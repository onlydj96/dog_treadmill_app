import '../../../core/utils/json.dart';

class NotificationPrefs {
  const NotificationPrefs({
    this.booking = true,
    this.exercise = true,
    this.analysis = true,
    this.marketing = false,
  });

  factory NotificationPrefs.fromJson(Json? json) {
    if (json == null) return const NotificationPrefs();
    return NotificationPrefs(
      booking: json.boolOr('booking', true),
      exercise: json.boolOr('exercise', true),
      analysis: json.boolOr('analysis', true),
      marketing: json.boolOr('marketing'),
    );
  }

  final bool booking;
  final bool exercise;
  final bool analysis;
  final bool marketing;

  Json toJson() => {
        'booking': booking,
        'exercise': exercise,
        'analysis': analysis,
        'marketing': marketing,
      };

  NotificationPrefs copyWith({bool? booking, bool? exercise, bool? analysis, bool? marketing}) {
    return NotificationPrefs(
      booking: booking ?? this.booking,
      exercise: exercise ?? this.exercise,
      analysis: analysis ?? this.analysis,
      marketing: marketing ?? this.marketing,
    );
  }
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.role,
    required this.notificationPrefs,
    this.phone,
  });

  factory AppUser.fromJson(Json json) {
    return AppUser(
      id: json.str('id'),
      name: json.str('name'),
      phone: json.strOrNull('phone'),
      role: json.str('role'),
      notificationPrefs: NotificationPrefs.fromJson(json.objOrNull('notification_prefs')),
    );
  }

  final String id;
  final String name;
  final String? phone;
  final String role;
  final NotificationPrefs notificationPrefs;

  bool get isAdmin => role == 'admin';

  String get displayName => name.isEmpty ? '보호자' : name;
}
