import '../../../core/utils/json.dart';
import '../../../l10n/l10n.dart';

class NotificationPrefs {
  const NotificationPrefs({
    this.booking = true,
    this.exercise = true,
    this.analysis = true,
    this.ranking = true,
    this.marketing = false,
  });

  factory NotificationPrefs.fromJson(Json? json) {
    if (json == null) return const NotificationPrefs();
    return NotificationPrefs(
      booking: json.boolOr('booking', true),
      exercise: json.boolOr('exercise', true),
      analysis: json.boolOr('analysis', true),
      // 랭킹 알림이 생기기 전에 가입한 회원은 키가 없다 → 서버(notify_user)처럼 켜진 것으로 본다
      ranking: json.boolOr('ranking', true),
      marketing: json.boolOr('marketing'),
    );
  }

  final bool booking;
  final bool exercise;
  final bool analysis;

  /// 배지 획득, 응원, 월간 순위 확정
  final bool ranking;
  final bool marketing;

  Json toJson() => {
        'booking': booking,
        'exercise': exercise,
        'analysis': analysis,
        'ranking': ranking,
        'marketing': marketing,
      };

  NotificationPrefs copyWith({bool? booking, bool? exercise, bool? analysis, bool? ranking, bool? marketing}) {
    return NotificationPrefs(
      booking: booking ?? this.booking,
      exercise: exercise ?? this.exercise,
      analysis: analysis ?? this.analysis,
      ranking: ranking ?? this.ranking,
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
    this.nickname = '',
    this.nicknameUpdatedAt,
    this.rankingShowPhoto = true,
    this.managedBranchId,
  });

  factory AppUser.fromJson(Json json) {
    return AppUser(
      id: json.str('id'),
      name: json.str('name'),
      phone: json.strOrNull('phone'),
      role: json.str('role'),
      notificationPrefs: NotificationPrefs.fromJson(json.objOrNull('notification_prefs')),
      nickname: json.strOrNull('nickname') ?? '',
      nicknameUpdatedAt: json.dateTimeOrNull('nickname_updated_at'),
      rankingShowPhoto: json.boolOr('ranking_show_photo', true),
      managedBranchId: json.strOrNull('managed_branch_id'),
    );
  }

  /// 닉네임은 30일에 한 번 바꿀 수 있다 (DB private.nickname_change_interval)
  static const nicknameChangeInterval = Duration(days: 30);

  final String id;
  final String name;
  final String? phone;
  final String role;
  final NotificationPrefs notificationPrefs;

  /// 랭킹·응원에 보이는 이름. 가입 시 자동으로 만들어진다.
  final String nickname;

  /// 보호자가 닉네임을 마지막으로 바꾼 시각. null이면 자동 닉네임이라 바로 바꿀 수 있다.
  final DateTime? nicknameUpdatedAt;

  /// 랭킹에 반려견 프로필 사진을 보여줄지
  final bool rankingShowPhoto;

  /// 관리자 담당 지점 (null이면 전 지점)
  final String? managedBranchId;

  bool get isAdmin => role == 'admin';

  String get displayName => name.isEmpty ? L10n.current.commonOwnerFallbackName : name;

  /// 다음에 닉네임을 바꿀 수 있는 시각. 지금 바꿀 수 있으면 null.
  DateTime? nicknameChangeableAt({DateTime? now}) {
    final updated = nicknameUpdatedAt;
    if (updated == null) return null;
    final next = updated.add(nicknameChangeInterval);
    return next.isAfter(now ?? DateTime.now()) ? next : null;
  }
}
