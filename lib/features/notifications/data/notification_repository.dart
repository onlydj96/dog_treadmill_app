import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/json.dart';
import '../../../l10n/l10n.dart';
import '../../../l10n/server_text.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required String title,
    required String body,
    required this.data,
    required this.isRead,
    required this.createdAt,
  })  : _title = title,
        _body = body;

  factory AppNotification.fromJson(Json json) => AppNotification(
        id: json.str('id'),
        type: json.strOrNull('type') ?? 'general',
        title: json.str('title'),
        body: json.strOrNull('body') ?? '',
        data: json.objOrNull('data') ?? const {},
        isRead: json.boolOr('is_read'),
        createdAt: json.dateTime('created_at'),
      );

  final String id;
  final String type;
  final String _title;
  final String _body;
  final Json data;
  final bool isRead;
  final DateTime createdAt;

  /// 현재 언어의 제목. 아는 `data.msg`면 ARB 문구로 만들고, 아니면 DB에 저장된 제목을 그대로 쓴다.
  String get title => _message?.title ?? _title;

  /// 현재 언어의 본문 (제목과 같은 규칙)
  String get body => _message?.body ?? _body;

  ({String title, String body})? get _message {
    final kind = data['msg'];
    final raw = data['args'];
    if (kind is! String || raw is! Map) return null;
    try {
      return _renderMessage(kind, raw.cast<String, dynamic>());
    } catch (_) {
      // args가 기대와 다르면 DB에 저장된 문구를 보여 준다
      return null;
    }
  }

  String? get bookingId => data['booking_id'] as String?;
  String? get reportId => data['report_id'] as String?;
  String? get sessionId => data['session_id'] as String?;

  /// 랭킹 알림: 배지(dog_id + badge_code), 월간 수상(period_month + dog_id), 응원(dog_id)
  String? get dogId => data['dog_id'] as String?;
  String? get badgeCode => data['badge_code'] as String?;
  String? get periodMonth => data['period_month'] as String?;
}

String _dogName(Map<String, dynamic> args) => args['dog_name'] as String;

String _when(Map<String, dynamic> args) =>
    Fmt.dateTime(DateTime.parse(args['start_at'] as String));

({String title, String body})? _renderMessage(
    String kind, Map<String, dynamic> args) {
  final l = L10n.current;
  switch (kind) {
    case 'booking_confirmed':
      return (
        title: l.notificationBookingConfirmedTitle,
        body: l.notificationBookingConfirmedBody(_dogName(args), _when(args))
      );
    case 'booking_cancelled':
      return (
        title: l.notificationBookingCancelledTitle,
        body: l.notificationBookingCancelledBody(_dogName(args), _when(args))
      );
    case 'booking_no_show':
      return (
        title: l.notificationBookingNoShowTitle,
        body: l.notificationBookingNoShowBody(_dogName(args), _when(args))
      );
    case 'exercise_started':
      return (
        title: l.notificationExerciseStartedTitle,
        body: l.notificationExerciseStartedBody(_dogName(args))
      );
    case 'exercise_completed':
      final points = (args['points'] as num?) ?? 0;
      return (
        title: l.notificationExerciseCompletedTitle,
        body: points > 0
            ? l.notificationExerciseCompletedPointsBody(
                _dogName(args), Fmt.points(points))
            : l.notificationExerciseCompletedBody(_dogName(args)),
      );
    case 'exercise_stopped':
      final reason = args['reason'] as String?;
      return (
        title: l.notificationExerciseStoppedTitle,
        body: l.notificationExerciseStoppedBody(
            _dogName(args), reason == null ? '-' : localizedStopReason(reason)),
      );
    case 'analysis_completed':
      return (
        title: l.notificationAnalysisCompletedTitle,
        body: l.notificationAnalysisCompletedBody(_dogName(args))
      );
    case 'analysis_failed':
      return (
        title: l.notificationAnalysisFailedTitle,
        body: l.notificationAnalysisFailedBody(_dogName(args))
      );
    case 'badge_earned':
      final badge = L10n.pick(
          args['badge_name'] as String, args['badge_name_en'] as String?);
      return (
        title: l.notificationBadgeEarnedTitle,
        body: l.notificationBadgeEarnedBody(_dogName(args), badge)
      );
    case 'cheer_received':
      final dog = particle(_dogName(args), '를', '을');
      final nickname = args['nickname'] as String?;
      return (
        title: l.notificationCheerReceivedTitle,
        body: nickname == null || nickname.isEmpty
            ? l.notificationCheerReceivedAnonymousBody(dog)
            : l.notificationCheerReceivedBody(nickname, dog),
      );
    case 'monthly_award':
      final month = Fmt.month(DateTime(2000, (args['month'] as num).toInt()));
      final summary = [
        for (final award
            in (args['awards'] as List).cast<Map<String, dynamic>>())
          l.notificationMonthlyAwardItem(
            L10n.pick(award['label'] as String, award['label_en'] as String?),
            (award['rank'] as num).toInt(),
          ),
      ].join(' · ');
      return (
        title: l.notificationMonthlyAwardTitle(month),
        body: l.notificationMonthlyAwardBody(
            particle(_dogName(args), '가', '이'), month, summary),
      );
    default:
      return null;
  }
}

class NotificationRepository {
  NotificationRepository(this._client);

  final SupabaseClient _client;

  Stream<List<AppNotification>> watchNotifications(String userId) {
    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .limit(50)
        .map((rows) => rows.map(AppNotification.fromJson).toList());
  }

  Future<void> markRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true}).eq('id', notificationId);
  }

  Future<void> markAllRead(String userId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  Future<void> delete(String notificationId) async {
    await _client.from('notifications').delete().eq('id', notificationId);
  }
}

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepository(ref.watch(supabaseClientProvider)),
);

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const []);
  return ref.watch(notificationRepositoryProvider).watchNotifications(userId);
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications =
      ref.watch(notificationsProvider).valueOrNull ?? const [];
  return notifications.where((n) => !n.isRead).length;
});
