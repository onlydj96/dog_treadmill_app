import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'generated/app_localizations.dart';

export 'generated/app_localizations.dart';

/// 앱이 지원하는 언어. 기본은 한국어이고, 마이페이지·로그인 화면에서 English로 바꿀 수 있다.
enum AppLanguage {
  ko(Locale('ko'), 'ko_KR'),
  en(Locale('en'), 'en_US');

  const AppLanguage(this.locale, this.intlLocale);

  final Locale locale;

  /// intl(DateFormat·NumberFormat)에 넘기는 로케일 이름
  final String intlLocale;

  /// 언어 선택 목록에 보여 줄 이름. 어느 언어 화면에서든 그 언어 자체의 표기로 보여 준다.
  String get nativeName => switch (this) {
        AppLanguage.ko => '한국어',
        AppLanguage.en => 'English',
      };

  static AppLanguage fromCode(String? code) =>
      values.firstWhere((language) => language.name == code, orElse: () => AppLanguage.ko);
}

extension L10nContext on BuildContext {
  /// 현재 언어의 문구. 위젯에서는 이것을 쓴다 (언어가 바뀌면 다시 그려진다).
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// BuildContext 없이 쓰는 현재 언어의 문구 — 포맷터(Fmt), 오류 문구(friendlyError), 입력 검증,
/// 모델의 라벨 getter(예: BookingStatus.label), 목업 서버처럼 위젯 밖에서 문구를 만들 때 쓴다.
///
/// 언어 설정([appLanguageProvider])이 바뀔 때 [use]로 갱신되고, 앱은 언어가 바뀌면 화면 전체를 다시 그린다.
abstract final class L10n {
  static AppLanguage _language = AppLanguage.ko;
  static AppLocalizations _strings = lookupAppLocalizations(AppLanguage.ko.locale);

  static AppLanguage get language => _language;

  static AppLocalizations get current => _strings;

  static bool get isEnglish => _language == AppLanguage.en;

  static bool get isKorean => _language == AppLanguage.ko;

  /// intl 포맷용 로케일 이름 ('ko_KR' / 'en_US')
  static String get intlLocale => _language.intlLocale;

  static void use(AppLanguage language) {
    _language = language;
    _strings = lookupAppLocalizations(language.locale);
    Intl.defaultLocale = language.intlLocale;
  }

  /// 서버 텍스트의 영어 값(`*_en` 컬럼·키)이 있으면 영어 화면에서 그것을, 아니면 기본(한국어) 값을 쓴다.
  static String pick(String ko, String? en) => isEnglish && en != null && en.trim().isNotEmpty ? en : ko;

  /// [pick]의 null 허용 버전
  static String? pickOrNull(String? ko, String? en) =>
      isEnglish && en != null && en.trim().isNotEmpty ? en : ko;

  /// 문자열 목록 버전 (예: AI 리포트의 care_notes / care_notes_en). 영어 목록이 비어 있으면 기본 목록.
  static List<String> pickList(List<String> ko, List<String>? en) =>
      isEnglish && en != null && en.isNotEmpty ? en : ko;
}
