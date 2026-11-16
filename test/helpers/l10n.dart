import 'package:dog_treadmill_app/core/theme/app_theme.dart';
import 'package:dog_treadmill_app/l10n/app_language.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// 두 언어의 날짜 기호를 읽어 둔다 (setUpAll에서 호출)
Future<void> initTestLocales() async {
  await initializeDateFormatting('ko_KR');
  await initializeDateFormatting('en_US');
}

/// 이 테스트 동안 앱 언어(L10n — 포맷터·모델 라벨·오류 문구)를 [language]로 바꾸고, 끝나면 한국어로 되돌린다.
void useLanguage(AppLanguage language) {
  L10n.use(language);
  addTearDown(() => L10n.use(AppLanguage.ko));
}

/// 앱과 같은 다국어 설정을 갖춘 MaterialApp (기본 한국어). English 화면을 확인하려면 language를 넘긴다.
Widget localizedApp(Widget home, {AppLanguage language = AppLanguage.ko, ThemeData? theme}) {
  if (language != L10n.language) useLanguage(language);
  return MaterialApp(
    theme: theme ?? AppTheme.light(),
    locale: language.locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: home,
  );
}

/// SharedPreferences 없이 언어 설정을 쓰는 위젯(로그인 화면의 언어 버튼, 마이페이지)을 테스트할 때 넣는 Provider override.
/// 언어를 고르면 저장하지 않고 상태와 L10n만 바꾼다.
Override languageOverride([AppLanguage language = AppLanguage.ko]) =>
    appLanguageProvider.overrideWith(() => _TestLanguageController(language));

class _TestLanguageController extends AppLanguageController {
  _TestLanguageController(this.initial);

  final AppLanguage initial;

  @override
  AppLanguage build() {
    L10n.use(initial);
    return initial;
  }

  @override
  Future<void> select(AppLanguage language) async {
    L10n.use(language);
    state = language;
  }
}
