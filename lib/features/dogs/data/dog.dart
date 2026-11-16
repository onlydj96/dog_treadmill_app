import '../../../core/utils/formatters.dart';
import '../../../core/utils/json.dart';

enum DogSex {
  male('male', '수컷'),
  female('female', '암컷');

  const DogSex(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static DogSex? fromDb(String? value) {
    for (final sex in values) {
      if (sex.dbValue == value) return sex;
    }
    return null;
  }
}

/// 체구. 성견 평균 체중 기준 참고값 (DB breeds.size_class와 같은 값)
enum DogSize {
  small('small', '소형', '10kg 미만'),
  medium('medium', '중형', '10~25kg'),
  large('large', '대형', '25kg 이상');

  const DogSize(this.dbValue, this.label, this.weightHint);

  final String dbValue;
  final String label;
  final String weightHint;

  static DogSize? fromDb(String? value) {
    for (final size in values) {
      if (size.dbValue == value) return size;
    }
    return null;
  }
}

/// 견종 카탈로그 (breeds)
class Breed {
  const Breed({required this.id, required this.name, required this.size, required this.isBrachycephalic});

  factory Breed.fromJson(Json json) => Breed(
        id: json.str('id'),
        name: json.str('name'),
        size: DogSize.fromDb(json.str('size_class'))!,
        isBrachycephalic: json.boolOr('is_brachycephalic'),
      );

  final String id;
  final String name;
  final DogSize size;
  final bool isBrachycephalic;
}

/// 질병·주의사항 카탈로그 (health_conditions). code는 운동 금기/제한 규칙의 키.
class HealthCondition {
  const HealthCondition({required this.code, required this.name, this.description});

  factory HealthCondition.fromJson(Json json) => HealthCondition(
        code: json.str('code'),
        name: json.str('name'),
        description: json.strOrNull('description'),
      );

  final String code;
  final String name;
  final String? description;
}

class Dog {
  const Dog({
    required this.id,
    required this.ownerId,
    required this.name,
    this.breed,
    this.breedId,
    this.isMixed = false,
    this.size,
    this.isBrachycephalic,
    this.birthDate,
    this.birthDateEstimated = false,
    this.sex,
    this.neutered,
    this.weightKg,
    this.profileImagePath,
  });

  factory Dog.fromJson(Json json) {
    final birth = json.strOrNull('birth_date');
    return Dog(
      id: json.str('id'),
      ownerId: json.strOrNull('owner_id') ?? '',
      name: json.str('name'),
      breed: json.strOrNull('breed'),
      breedId: json.strOrNull('breed_id'),
      isMixed: json.boolOr('is_mixed'),
      size: DogSize.fromDb(json.strOrNull('size_class')),
      isBrachycephalic: json['is_brachycephalic'] as bool?,
      birthDate: birth == null ? null : DateTime.parse(birth),
      birthDateEstimated: json.boolOr('birth_date_estimated'),
      sex: DogSex.fromDb(json.strOrNull('sex')),
      neutered: json['neutered'] as bool?,
      weightKg: json.dblOrNull('weight_kg'),
      profileImagePath: json.strOrNull('profile_image_path'),
    );
  }

  final String id;
  final String ownerId;
  final String name;

  /// 표시용 견종명. 카탈로그 견종이면 카탈로그 이름, 믹스견이면 섞인 견종(없을 수 있음)
  final String? breed;

  /// 견종 카탈로그 ID. 믹스견·목록 밖 견종은 null
  final String? breedId;
  final bool isMixed;
  final DogSize? size;
  final bool? isBrachycephalic;
  final DateTime? birthDate;

  /// true면 birthDate는 추정 나이로 계산한 날짜
  final bool birthDateEstimated;
  final DogSex? sex;

  /// null = 미응답
  final bool? neutered;
  final double? weightKg;
  final String? profileImagePath;

  String? get ageLabel {
    if (birthDate == null) return null;
    final age = Fmt.dogAge(birthDate!);
    return birthDateEstimated ? '약 $age' : age;
  }

  /// "시츄", "믹스견(말티푸)", "믹스견"
  String? get breedLabel {
    final name = breed?.trim();
    final hasName = name != null && name.isNotEmpty;
    if (isMixed) return hasName ? '믹스견($name)' : '믹스견';
    return hasName ? name : null;
  }

  /// "말티즈 · 3살 · 3.2kg"
  String get summary {
    return [
      if (breedLabel != null) breedLabel!,
      if (ageLabel != null) ageLabel!,
      if (weightKg != null) Fmt.weight(weightKg),
    ].join(' · ');
  }
}

/// 반려견 등록·수정 입력값.
/// breedId가 있으면 DB 트리거가 견종명·체구·단두종을 카탈로그 값으로 맞춘다.
class DogDraft {
  const DogDraft({
    required this.name,
    this.breed,
    this.breedId,
    this.isMixed = false,
    this.size,
    this.isBrachycephalic,
    this.birthDate,
    this.birthDateEstimated = false,
    this.sex,
    this.neutered,
    this.weightKg,
  });

  final String name;
  final String? breed;
  final String? breedId;
  final bool isMixed;
  final DogSize? size;
  final bool? isBrachycephalic;
  final DateTime? birthDate;
  final bool birthDateEstimated;
  final DogSex? sex;
  final bool? neutered;
  final double? weightKg;

  Json toJson() => {
        'name': name.trim(),
        'breed': (breed == null || breed!.trim().isEmpty) ? null : breed!.trim(),
        'breed_id': breedId,
        'is_mixed': isMixed,
        'size_class': size?.dbValue,
        'is_brachycephalic': isBrachycephalic,
        'birth_date': birthDate == null ? null : toDateString(birthDate!),
        'birth_date_estimated': birthDate != null && birthDateEstimated,
        'sex': sex?.dbValue,
        'neutered': neutered,
        'weight_kg': weightKg,
      };
}

/// 건강 정보 항목 (질환/수술/약물/운동 제한 공통)
class HealthItem {
  const HealthItem({required this.name, this.detail, this.date});

  factory HealthItem.fromJson(Json json) {
    final date = json.strOrNull('date');
    return HealthItem(
      name: json.strOrNull('name') ?? '',
      detail: json.strOrNull('detail'),
      date: date == null ? null : DateTime.tryParse(date),
    );
  }

  final String name;
  final String? detail;
  final DateTime? date;

  Json toJson() => {
        'name': name,
        if (detail != null && detail!.isNotEmpty) 'detail': detail,
        if (date != null) 'date': toDateString(date!),
      };
}

class DogHealthProfile {
  const DogHealthProfile({
    required this.dogId,
    this.conditionCodes,
    this.diseases = const [],
    this.surgeries = const [],
    this.medications = const [],
    this.exerciseRestrictions = const [],
    this.veterinaryNotes,
    this.updatedAt,
  });

  factory DogHealthProfile.fromJson(Json json) {
    List<HealthItem> items(String key) => json.objList(key).map(HealthItem.fromJson).toList();
    return DogHealthProfile(
      dogId: json.str('dog_id'),
      conditionCodes: json['condition_codes'] == null ? null : json.strList('condition_codes'),
      diseases: items('diseases'),
      surgeries: items('surgeries'),
      medications: items('medications'),
      exerciseRestrictions: items('exercise_restrictions'),
      veterinaryNotes: json.strOrNull('veterinary_notes'),
      updatedAt: json.dateTimeOrNull('updated_at'),
    );
  }

  final String dogId;

  /// 질병·주의사항 코드 (health_conditions.code). null = 미응답, 빈 목록 = 해당 없음
  final List<String>? conditionCodes;
  final List<HealthItem> diseases;
  final List<HealthItem> surgeries;
  final List<HealthItem> medications;
  final List<HealthItem> exerciseRestrictions;
  final String? veterinaryNotes;
  final DateTime? updatedAt;

  bool get isEmpty =>
      conditionCodes == null &&
      diseases.isEmpty &&
      surgeries.isEmpty &&
      medications.isEmpty &&
      exerciseRestrictions.isEmpty &&
      (veterinaryNotes == null || veterinaryNotes!.trim().isEmpty);

  Json toJson() => {
        'dog_id': dogId,
        'condition_codes': conditionCodes,
        'diseases': diseases.map((e) => e.toJson()).toList(),
        'surgeries': surgeries.map((e) => e.toJson()).toList(),
        'medications': medications.map((e) => e.toJson()).toList(),
        'exercise_restrictions': exerciseRestrictions.map((e) => e.toJson()).toList(),
        'veterinary_notes':
            (veterinaryNotes == null || veterinaryNotes!.trim().isEmpty) ? null : veterinaryNotes!.trim(),
      };
}
