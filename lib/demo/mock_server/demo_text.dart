import '../../core/utils/json.dart';
import '../../l10n/l10n.dart';

/// 데모 전용 영어 값 키 접미사. 실제로는 사용자가 입력하는 샘플 데이터(반려견 이름·닉네임·문의 내용 등)의
/// 영어 값을 `<키>__en`으로 함께 둔다. 서버가 주는 `_en` 컬럼·필드(`name_en` 등)와는 다른 규칙이다.
const demoEnglishSuffix = '__en';

/// 행(또는 목록·중첩 JSON)을 현재 언어로 바꾼다: 영어 화면이면 `<키>__en` 값을 `<키>`에 넣고,
/// `__en` 키는 모두 지운다(임베드된 맵·목록·알림 args 포함). 원본은 바꾸지 않는다.
/// 데모 저장소가 모델의 fromJson에 넘기기 전에 거치므로 모델은 `__en`을 알 필요가 없다.
dynamic localizeJson(dynamic value) {
  if (value is Map) {
    final out = <String, dynamic>{};
    for (final entry in value.entries) {
      final key = entry.key as String;
      if (key.endsWith(demoEnglishSuffix)) continue;
      final english = value['$key$demoEnglishSuffix'];
      final useEnglish = L10n.isEnglish && english != null && !(english is String && english.trim().isEmpty);
      out[key] = localizeJson(useEnglish ? english : entry.value);
    }
    return out;
  }
  if (value is List) return [for (final item in value) localizeJson(item)];
  return value;
}

/// [localizeJson]의 행 버전
Json localizeRow(Json row) => localizeJson(row) as Json;

/// 한 값만 현재 언어로 고른다 (읽는 순간 계산하는 목업 출력용). 영어 값이 없으면 기본(한국어) 값.
String? demoText(Json? row, String key) {
  if (row == null) return null;
  final english = row['$key$demoEnglishSuffix'];
  if (L10n.isEnglish && english is String && english.trim().isNotEmpty) return english;
  return row[key] as String?;
}
