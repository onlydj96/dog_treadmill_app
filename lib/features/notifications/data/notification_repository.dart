import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/json.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.data,
    required this.isRead,
    required this.createdAt,
  });

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
  final String title;
  final String body;
  final Json data;
  final bool isRead;
  final DateTime createdAt;

  String? get bookingId => data['booking_id'] as String?;
  String? get reportId => data['report_id'] as String?;
  String? get sessionId => data['session_id'] as String?;
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
    await _client.from('notifications').update({'is_read': true}).eq('id', notificationId);
  }

  Future<void> markAllRead(String userId) async {
    await _client.from('notifications').update({'is_read': true}).eq('user_id', userId).eq('is_read', false);
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
  final notifications = ref.watch(notificationsProvider).valueOrNull ?? const [];
  return notifications.where((n) => !n.isRead).length;
});
