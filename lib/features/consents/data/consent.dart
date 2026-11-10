import '../../../core/utils/json.dart';

/// 동의 항목. 영상 촬영 동의와 AI 학습 활용 동의는 분리한다(문서 8장).
enum ConsentType {
  terms(
    dbValue: 'terms',
    title: '서비스 이용약관',
    description: 'PawFit 서비스 이용에 관한 약관입니다.',
    isRequired: true,
  ),
  privacy(
    dbValue: 'privacy',
    title: '개인정보 수집·이용',
    description: '회원 식별, 예약·결제 처리, 고객 상담을 위해 이름·연락처·이메일과 반려견 정보를 수집합니다.',
    isRequired: true,
  ),
  videoRecording(
    dbValue: 'video_recording',
    title: '운동 영상 촬영 및 AI 분석',
    description: '트레드밀 운동 중 반려견의 정면·측면 영상을 촬영해 관절·보행 분석 리포트를 만듭니다. '
        '동의하지 않으면 AI 분석 리포트가 제공되지 않습니다.',
  ),
  aiTraining(
    dbValue: 'ai_training',
    title: 'AI 학습 데이터 활용',
    description: '촬영 영상과 관절 좌표를 비식별화해 AI 모델 개선에 활용합니다. '
        '동의하지 않아도 서비스 이용에는 제한이 없습니다.',
  ),
  marketing(
    dbValue: 'marketing',
    title: '마케팅 정보 수신',
    description: '이벤트와 혜택 소식을 알림으로 받습니다.',
  );

  const ConsentType({
    required this.dbValue,
    required this.title,
    required this.description,
    this.isRequired = false,
  });

  final String dbValue;
  final String title;
  final String description;
  final bool isRequired;

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
