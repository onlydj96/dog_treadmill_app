import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../data/notification_repository.dart';

/// 알림 (예약·운동·분석 알림, 실시간 반영)
class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  /// 스와이프로 지운 알림은 Realtime 반영 전까지 목록에서 즉시 숨긴다.
  final Set<String> _dismissed = {};

  Future<void> _open(AppNotification notification) async {
    if (!notification.isRead) {
      try {
        await ref.read(notificationRepositoryProvider).markRead(notification.id);
      } catch (_) {
        // 읽음 처리 실패는 이동을 막지 않는다
      }
    }
    if (!mounted) return;
    final bookingId = notification.bookingId;
    final reportId = notification.reportId;
    if (reportId != null) {
      unawaited(context.push(AppRoutes.report(reportId)));
    } else if (bookingId != null) {
      unawaited(context.push(AppRoutes.bookingDetail(bookingId)));
    } else if (notification.type == 'exercise') {
      context.go(AppRoutes.exercise);
    }
  }

  Future<void> _delete(AppNotification notification) async {
    setState(() => _dismissed.add(notification.id));
    try {
      await ref.read(notificationRepositoryProvider).delete(notification.id);
    } catch (error) {
      if (!mounted) return;
      setState(() => _dismissed.remove(notification.id));
      context.showMessage(friendlyError(error));
    }
  }

  Future<void> _markAllRead() async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    try {
      await ref.read(notificationRepositoryProvider).markAllRead(userId);
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationsProvider);
    final unread = ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('알림'),
        actions: [
          if (unread > 0) TextButton(onPressed: _markAllRead, child: const Text('모두 읽음')),
          const SizedBox(width: 8),
        ],
      ),
      body: AsyncValueView<List<AppNotification>>(
        value: notifications,
        onRetry: () => ref.invalidate(notificationsProvider),
        data: (all) {
          final items = all.where((n) => !_dismissed.contains(n.id)).toList();
          if (items.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none_rounded,
              title: '새 알림이 없어요',
              message: '예약 확정, 운동 시작·완료, AI 분석 결과를 알려 드려요.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(indent: 20, endIndent: 20),
            itemBuilder: (context, index) {
              final item = items[index];
              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 24),
                  color: AppColors.coral,
                  child: const Icon(Icons.delete_outline_rounded, color: Colors.white),
                ),
                onDismissed: (_) => _delete(item),
                child: _NotificationTile(notification: item, onTap: () => _open(item)),
              );
            },
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (icon, tone) = switch (notification.type) {
      'booking' => (Icons.event_available_rounded, scheme.activeTone),
      'exercise' => (Icons.directions_run_rounded, scheme.cautionTone),
      'analysis' => (Icons.auto_awesome_rounded, scheme.calmTone),
      _ => (Icons.campaign_rounded, scheme.neutralTone),
    };

    return Semantics(
      container: true,
      button: true,
      label: notification.isRead ? null : '읽지 않은 알림',
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: notification.isRead ? null : scheme.primaryContainer.withValues(alpha: 0.25),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: tone.background, shape: BoxShape.circle),
                child: Icon(icon, color: tone.foreground, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800),
                          ),
                        ),
                        Text(
                          Fmt.relative(notification.createdAt),
                          style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    if (notification.body.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(notification.body, style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45)),
                    ],
                  ],
                ),
              ),
              if (!notification.isRead) ...[
                const SizedBox(width: 8),
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.coral, shape: BoxShape.circle),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
