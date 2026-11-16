import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState;

import '../app.dart';
import '../core/router/app_router.dart';
import '../core/supabase/supabase_providers.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/booking/providers.dart';
import '../features/consents/data/consent_repository.dart';
import '../features/dogs/providers.dart';
import '../features/exercise/providers.dart';
import '../features/health/providers.dart';
import '../features/membership/providers.dart';
import '../features/notifications/data/notification_repository.dart';
import '../features/profile/data/user_repository.dart';
import '../features/ranking/providers.dart';
import '../features/support/data/support_repository.dart';
import 'demo_auth.dart';
import 'demo_overlay.dart';
import 'demo_repositories.dart';
import 'mock_server/mock_server.dart';

/// 데모 앱의 목업 서버 (데모 컨트롤이 기기·AI 서버를 움직일 때 쓴다)
final mockServerProvider = Provider<MockServer>((ref) => throw UnimplementedError('DemoApp이 주입한다'));

final demoAuthProvider = Provider<DemoAuth>((ref) => throw UnimplementedError('DemoApp이 주입한다'));

/// 목업 서버를 처음 상태로 되돌리고 앱을 다시 그린다 (모든 Provider 캐시를 버린다)
final demoRestartProvider = Provider<VoidCallback>((ref) => throw UnimplementedError('DemoApp이 주입한다'));

/// 로그인한 사용자 ID. 데모 로그인 상태가 바뀔 때마다 다시 계산된다.
final _demoUserIdProvider = Provider<String?>((ref) {
  final auth = ref.watch(demoAuthProvider);
  void onChange() => ref.invalidateSelf();
  auth.addListener(onChange);
  ref.onDispose(() => auth.removeListener(onChange));
  return auth.userId;
});

/// 실제 앱과 같은 화면·Provider를 쓰고, 서버에 닿는 Provider(저장소·인증·라우터)만 목업 서버 구현으로 바꾼다.
List<Override> demoOverrides({
  required MockServer server,
  required DemoAuth auth,
  required SharedPreferences preferences,
}) {
  return [
    sharedPreferencesProvider.overrideWithValue(preferences),
    mockServerProvider.overrideWithValue(server),
    demoAuthProvider.overrideWithValue(auth),

    // 데모는 Supabase에 연결하지 않는다. 목업으로 바꾸지 않은 경로가 생기면 바로 드러나도록 오류를 낸다.
    supabaseClientProvider.overrideWith(
      (ref) => throw StateError('데모 앱은 Supabase에 연결하지 않아요. 이 Provider를 demoOverrides에서 목업 구현으로 바꿔 주세요.'),
    ),
    authStateChangesProvider.overrideWith((ref) => const Stream<AuthState>.empty()),
    currentUserIdProvider.overrideWith((ref) => ref.watch(_demoUserIdProvider)),
    routerProvider.overrideWith((ref) {
      final router = buildRouter(isLoggedIn: () => auth.isLoggedIn, refreshListenable: auth);
      ref.onDispose(router.dispose);
      return router;
    }),

    authRepositoryProvider.overrideWithValue(DemoAuthRepository(server, auth)),
    dogRepositoryProvider.overrideWithValue(DemoDogRepository(server)),
    bookingRepositoryProvider.overrideWithValue(DemoBookingRepository(server)),
    exerciseRepositoryProvider.overrideWithValue(DemoExerciseRepository(server)),
    analysisRepositoryProvider.overrideWithValue(DemoAnalysisRepository(server)),
    membershipRepositoryProvider.overrideWithValue(DemoMembershipRepository(server)),
    notificationRepositoryProvider.overrideWithValue(DemoNotificationRepository(server)),
    userRepositoryProvider.overrideWithValue(DemoUserRepository(server)),
    consentRepositoryProvider.overrideWithValue(DemoConsentRepository(server)),
    rankingRepositoryProvider.overrideWithValue(DemoRankingRepository(server)),
    supportRepositoryProvider.overrideWithValue(DemoSupportRepository(server)),
  ];
}

/// 데모 앱 루트: 목업 서버 + 실제 앱 화면(DogGymApp) + 데모 컨트롤
class DemoApp extends StatefulWidget {
  const DemoApp({super.key, required this.preferences, this.server, this.signedIn = false});

  final SharedPreferences preferences;

  /// 테스트에서 주입 (지연 없음·자동 진행 끔 등). 없으면 기본 설정으로 만든다.
  final MockServer? server;

  /// true면 데모 계정으로 로그인한 채 시작한다
  final bool signedIn;

  @override
  State<DemoApp> createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {
  late final MockServer _server = widget.server ?? MockServer();
  late final DemoAuth _auth = DemoAuth(_server);
  var _generation = 0;

  @override
  void initState() {
    super.initState();
    if (widget.signedIn) _auth.signInDemo();
  }

  void _restart() {
    _auth.resetServer();
    setState(() => _generation++);
  }

  @override
  void dispose() {
    _auth.dispose();
    _server.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      key: ValueKey(_generation),
      overrides: [
        ...demoOverrides(server: _server, auth: _auth, preferences: widget.preferences),
        demoRestartProvider.overrideWithValue(_restart),
      ],
      child: DogGymApp(builder: (context, child) => DemoOverlay(child: child ?? const SizedBox.shrink())),
    );
  }
}
