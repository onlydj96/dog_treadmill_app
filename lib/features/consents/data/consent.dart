import '../../../core/utils/json.dart';
import '../../../l10n/l10n.dart';

/// 동의 항목. 영상 촬영 동의와 AI 학습 활용 동의는 분리한다(문서 8장).
enum ConsentType {
  terms(dbValue: 'terms', isRequired: true),
  privacy(dbValue: 'privacy', isRequired: true),
  videoRecording(dbValue: 'video_recording'),
  aiTraining(dbValue: 'ai_training'),
  ranking(dbValue: 'ranking'),
  marketing(dbValue: 'marketing');

  const ConsentType({required this.dbValue, this.isRequired = false});

  final String dbValue;
  final bool isRequired;

  String get title => switch (this) {
        ConsentType.terms => L10n.current.consentTermsTitle,
        ConsentType.privacy => L10n.current.consentPrivacyTitle,
        ConsentType.videoRecording => L10n.current.consentVideoTitle,
        ConsentType.aiTraining => L10n.current.consentAiTrainingTitle,
        ConsentType.ranking => L10n.current.consentRankingTitle,
        ConsentType.marketing => L10n.current.consentMarketingTitle,
      };

  String get description => switch (this) {
        ConsentType.terms => L10n.current.consentTermsDesc,
        ConsentType.privacy => L10n.current.consentPrivacyDesc,
        ConsentType.videoRecording => L10n.current.consentVideoDesc,
        ConsentType.aiTraining => L10n.current.consentAiTrainingDesc,
        ConsentType.ranking => L10n.current.consentRankingDesc,
        ConsentType.marketing => L10n.current.consentMarketingDesc,
      };

  /// 약관 문서가 바뀌면 버전을 올려 재동의를 받는다.
  String get currentVersion => '1.0';

  static ConsentType? fromDb(String value) {
    for (final type in values) {
      if (type.dbValue == value) return type;
    }
    return null;
  }
}

class DataConsent {
  const DataConsent({
    required this.type,
    required this.version,
    required this.granted,
    required this.respondedAt,
  });

  final ConsentType type;
  final String version;
  final bool granted;
  final DateTime respondedAt;

  static DataConsent? fromJson(Json json) {
    final type = ConsentType.fromDb(json.str('consent_type'));
    if (type == null) return null;
    return DataConsent(
      type: type,
      version: json.str('consent_version'),
      granted: json.boolOr('granted'),
      respondedAt: json.dateTime('responded_at'),
    );
  }
}
