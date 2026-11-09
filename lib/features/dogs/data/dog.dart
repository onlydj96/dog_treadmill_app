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

class Dog {
  const Dog({
    required this.id,
    required this.ownerId,
    required this.name,
    this.breed,
    this.birthDate,
    this.sex,
    this.neutered = false,
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
      birthDate: birth == null ? null : DateTime.parse(birth),
      sex: DogSex.fromDb(json.strOrNull('sex')),
      neutered: json.boolOr('neutered'),
      weightKg: json.dblOrNull('weight_kg'),
      profileImagePath: json.strOrNull('profile_image_path'),
    );
  }

  final String id;
  final String ownerId;
  final String name;
  final String? breed;
  final DateTime? birthDate;
  final DogSex? sex;
  final bool neutered;
  final double? weightKg;
  final String? profileImagePath;

  String? get ageLabel => birthDate == null ? null : Fmt.dogAge(birthDate!);

  String? get sexLabel {
    if (sex == null) return null;
    return neutered ? '${sex!.label}(중성화)' : sex!.label;
  }

  /// "말티즈 · 3살 · 3.2kg"
  String get summary {
    return [
      if (breed != null && breed!.isNotEmpty) breed!,
      if (ageLabel != null) ageLabel!,
      if (weightKg != null) Fmt.weight(weightKg),
    ].join(' · ');
  }
}

/// 반려견 등록·수정 입력값
class DogDraft {
  const DogDraft({
    required this.name,
    this.breed,
    this.birthDate,
    this.sex,
    this.neutered = false,
    this.weightKg,
  });

  final String name;
  final String? breed;
  final DateTime? birthDate;
  final DogSex? sex;
  final bool neutered;
  final double? weightKg;

  Json toJson() => {
        'name': name.trim(),
        'breed': (breed == null || breed!.trim().isEmpty) ? null : breed!.trim(),
        'birth_date': birthDate == null ? null : toDateString(birthDate!),
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
      diseases: items('diseases'),
      surgeries: items('surgeries'),
      medications: items('medications'),
      exerciseRestrictions: items('exercise_restrictions'),
      veterinaryNotes: json.strOrNull('veterinary_notes'),
      updatedAt: json.dateTimeOrNull('updated_at'),
    );
  }

  final String dogId;
  final List<HealthItem> diseases;
  final List<HealthItem> surgeries;
  final List<HealthItem> medications;
  final List<HealthItem> exerciseRestrictions;
  final String? veterinaryNotes;
  final DateTime? updatedAt;

  bool get isEmpty =>
      diseases.isEmpty &&
      surgeries.isEmpty &&
      medications.isEmpty &&
      exerciseRestrictions.isEmpty &&
      (veterinaryNotes == null || veterinaryNotes!.trim().isEmpty);

  Json toJson() => {
        'dog_id': dogId,
        'diseases': diseases.map((e) => e.toJson()).toList(),
        'surgeries': surgeries.map((e) => e.toJson()).toList(),
        'medications': medications.map((e) => e.toJson()).toList(),
        'exercise_restrictions': exerciseRestrictions.map((e) => e.toJson()).toList(),
        'veterinary_notes':
            (veterinaryNotes == null || veterinaryNotes!.trim().isEmpty) ? null : veterinaryNotes!.trim(),
      };
}
