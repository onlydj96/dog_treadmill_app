import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/supabase/supabase_providers.dart';
import 'l10n.dart';

/// 선택한 앱 언어. 기기에 저장하고(로그인과 무관), 처음 실행하면 한국어로 시작한다.
final appLanguageProvider = NotifierProvider<AppLanguageController, AppLanguage>(AppLanguageController.new);

class AppLanguageController extends Notifier<AppLanguage> {
  static const prefsKey = 'app_language';

  @override
  AppLanguage build() {
    final saved = AppLanguage.fromCode(ref.watch(sharedPreferencesProvider).getString(prefsKey));
    L10n.use(saved);
    return saved;
  }

  Future<void> select(AppLanguage language) async {
    if (language == state) return;
    // 위젯 밖 문구(L10n.current)를 먼저 바꾼 뒤 상태를 알린다. 다시 그려지는 화면이 모두 새 언어를 읽는다.
    L10n.use(language);
    state = language;
    await ref.read(sharedPreferencesProvider).setString(prefsKey, language.name);
  }
}

/// 언어 선택 시트 (마이페이지 · 로그인 화면 · 데모 컨트롤)
Future<void> showLanguagePicker(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => const _LanguagePickerSheet(),
  );
}

class _LanguagePickerSheet extends ConsumerWidget {
  const _LanguagePickerSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(appLanguageProvider);
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Text(context.l10n.languagePickerTitle, style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final language in AppLanguage.values)
              ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                leading: Icon(
                  language == current ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
                  color: language == current ? scheme.primary : scheme.onSurfaceVariant,
                ),
                title: Text(language.nativeName, style: const TextStyle(fontWeight: FontWeight.w600)),
                selected: language == current,
                onTap: () async {
                  Navigator.of(context).pop();
                  await ref.read(appLanguageProvider.notifier).select(language);
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// 현재 언어 이름과 지구본 아이콘이 있는 작은 버튼. 로그인 전 화면처럼 언어를 바로 바꿀 곳에 둔다.
class LanguageButton extends ConsumerWidget {
  const LanguageButton({super.key, this.foregroundColor});

  final Color? foregroundColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(appLanguageProvider);
    return TextButton.icon(
      onPressed: () => showLanguagePicker(context),
      style: TextButton.styleFrom(foregroundColor: foregroundColor, minimumSize: const Size(48, 40)),
      icon: const Icon(Icons.language_rounded, size: 18),
      label: Text(language.nativeName),
    );
  }
}
