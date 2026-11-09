import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/signup_screen.dart';
import '../../features/booking/presentation/booking_detail_screen.dart';
import '../../features/booking/presentation/booking_list_screen.dart';
import '../../features/booking/presentation/booking_screen.dart';
import '../../features/consents/presentation/consent_screen.dart';
import '../../features/dogs/presentation/dog_list_screen.dart';
import '../../features/dogs/presentation/dog_profile_screen.dart';
import '../../features/dogs/presentation/dog_registration_screen.dart';
import '../../features/exercise/presentation/exercise_history_screen.dart';
import '../../features/exercise/presentation/exercise_screen.dart';
import '../../features/health/presentation/analysis_report_screen.dart';
import '../../features/health/presentation/health_dashboard_screen.dart';
import '../../features/health/presentation/video_player_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/membership/presentation/membership_screen.dart';
import '../../features/membership/presentation/payment_history_screen.dart';
import '../../features/mypage/presentation/my_page_screen.dart';
import '../../features/mypage/presentation/notification_settings_screen.dart';
import '../../features/mypage/presentation/profile_edit_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/support/presentation/support_screens.dart';
import '../supabase/supabase_providers.dart';
import 'app_routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(supabaseClientProvider).auth;
  final refresh = _StreamListenable(auth.onAuthStateChange);
  final router = buildRouter(isLoggedIn: () => auth.currentSession != null, refreshListenable: refresh);
  ref.onDispose(() {
    refresh.dispose();
    router.dispose();
  });
  return router;
});

/// 라우터 구성. 테스트에서 로그인 상태를 주입할 수 있도록 함수로 분리한다.
GoRouter buildRouter({
  required bool Function() isLoggedIn,
  Listenable? refreshListenable,
  String initialLocation = AppRoutes.home,
}) {
  NoTransitionPage<void> tab(Widget child) => NoTransitionPage<void>(child: child);

  return GoRouter(
    initialLocation: initialLocation,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final loggedIn = isLoggedIn();
      final location = state.matchedLocation;
      final onAuthPage = location == AppRoutes.login || location == AppRoutes.signup;
      if (!loggedIn && !onAuthPage) return AppRoutes.login;
      if (loggedIn && onAuthPage) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginScreen()),
      GoRoute(path: AppRoutes.signup, builder: (_, __) => const SignupScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.home, pageBuilder: (_, __) => tab(const HomeScreen())),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.booking, pageBuilder: (_, __) => tab(const BookingListScreen())),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.exercise, pageBuilder: (_, __) => tab(const ExerciseScreen())),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.health, pageBuilder: (_, __) => tab(const HealthDashboardScreen())),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: AppRoutes.my, pageBuilder: (_, __) => tab(const MyPageScreen())),
          ]),
        ],
      ),
      GoRoute(path: AppRoutes.notifications, builder: (_, __) => const NotificationsScreen()),
      GoRoute(path: AppRoutes.bookingNew, builder: (_, __) => const BookingScreen()),
      GoRoute(
        path: '/bookings/:id',
        builder: (_, state) => BookingDetailScreen(bookingId: state.pathParameters['id']!),
      ),
      GoRoute(path: AppRoutes.exerciseHistory, builder: (_, __) => const ExerciseHistoryScreen()),
      GoRoute(
        path: '/reports/:id',
        builder: (_, state) => AnalysisReportScreen(reportId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/video',
        builder: (_, state) => VideoPlayerScreen(
          path: state.uri.queryParameters['path'] ?? '',
          title: state.uri.queryParameters['title'] ?? '운동 영상',
        ),
      ),
      GoRoute(path: AppRoutes.dogs, builder: (_, __) => const DogListScreen()),
      GoRoute(path: AppRoutes.dogNew, builder: (_, __) => const DogRegistrationScreen()),
      GoRoute(
        path: '/dogs/:id',
        builder: (_, state) => DogProfileScreen(dogId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (_, state) => DogRegistrationScreen(dogId: state.pathParameters['id']),
          ),
        ],
      ),
      GoRoute(path: AppRoutes.membership, builder: (_, __) => const MembershipScreen()),
      GoRoute(path: AppRoutes.payments, builder: (_, __) => const PaymentHistoryScreen()),
      GoRoute(path: AppRoutes.profileEdit, builder: (_, __) => const ProfileEditScreen()),
      GoRoute(path: AppRoutes.notificationSettings, builder: (_, __) => const NotificationSettingsScreen()),
      GoRoute(path: AppRoutes.consents, builder: (_, __) => const ConsentScreen()),
      GoRoute(path: AppRoutes.notices, builder: (_, __) => const NoticesScreen()),
      GoRoute(path: AppRoutes.faq, builder: (_, __) => const FaqScreen()),
      GoRoute(path: AppRoutes.inquiries, builder: (_, __) => const InquiryListScreen()),
      GoRoute(path: AppRoutes.inquiryNew, builder: (_, __) => const InquiryFormScreen()),
    ],
  );
}

/// 인증 상태 스트림을 GoRouter.refreshListenable로 연결
class _StreamListenable extends ChangeNotifier {
  _StreamListenable(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
