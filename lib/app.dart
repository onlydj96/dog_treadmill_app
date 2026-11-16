import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/brand_mark.dart';

const _locale = Locale('ko', 'KR');

class DogGymApp extends ConsumerWidget {
  const DogGymApp({super.key, this.builder});

  /// 모든 화면 위에 덧씌울 위젯 (데모 앱의 DEMO 표시·컨트롤 패널). 실제 앱은 쓰지 않는다.
  final TransitionBuilder? builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'PawFit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: _locale,
      supportedLocales: const [_locale],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
      builder: builder,
    );
  }
}

/// `.env`가 주입되지 않은 채 실행했을 때 안내 화면
class ConfigMissingApp extends StatelessWidget {
  const ConfigMissingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BrandMark(size: 56),
                const SizedBox(height: 24),
                Text('Supabase 설정이 필요해요', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 12),
                const Text(
                  '프로젝트 루트의 .env에 SUPABASE_URL과 SUPABASE_PUBLISHABLE_KEY를 넣고 '
                  '아래와 같이 실행해 주세요.',
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const SelectableText(
                    'flutter run --dart-define-from-file=.env',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
