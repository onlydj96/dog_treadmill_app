import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/env.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/brand_mark.dart';
import 'l10n/app_language.dart';
import 'l10n/l10n.dart';

class DogGymApp extends ConsumerWidget {
  const DogGymApp({super.key, this.builder});

  /// 모든 화면 위에 덧씌울 위젯 (데모 앱의 DEMO 표시·컨트롤 패널). 실제 앱은 쓰지 않는다.
  final TransitionBuilder? builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      locale: language.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        return RebuildOnLocaleChange(child: builder?.call(context, content) ?? content);
      },
    );
  }
}

/// 언어가 바뀌면 아래 위젯을 모두 다시 그린다.
///
/// 화면 문구는 대부분 `context.l10n`으로 읽어 자동으로 바뀌지만, 모델 라벨·포맷터처럼 BuildContext 없이
/// `L10n.current`를 읽는 문구도 있어 한 번 전체를 다시 그려 남는 문구가 없게 한다 (언어를 바꿀 때만 일어난다).
class RebuildOnLocaleChange extends StatefulWidget {
  const RebuildOnLocaleChange({super.key, required this.child});

  final Widget child;

  @override
  State<RebuildOnLocaleChange> createState() => _RebuildOnLocaleChangeState();
}

class _RebuildOnLocaleChangeState extends State<RebuildOnLocaleChange> {
  Locale? _locale;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = Localizations.localeOf(context);
    if (_locale != null && _locale != locale) {
      void markForRebuild(Element element) {
        element.markNeedsBuild();
        element.visitChildren(markForRebuild);
      }

      (context as Element).visitChildren(markForRebuild);
    }
    _locale = locale;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// `.env`가 주입되지 않은 채 실행했을 때 안내 화면 (개발용, 기기 언어를 따른다)
class ConfigMissingApp extends StatelessWidget {
  const ConfigMissingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandMark(size: 56),
                  const SizedBox(height: 24),
                  Text(context.l10n.configMissingTitle, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  Text(context.l10n.configMissingBody),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const SelectableText(
                      '# ${Env.fileAsset}\n'
                      'SUPABASE_URL=https://<project-ref>.supabase.co\n'
                      'SUPABASE_PUBLISHABLE_KEY=sb_publishable_...',
                      style: TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
