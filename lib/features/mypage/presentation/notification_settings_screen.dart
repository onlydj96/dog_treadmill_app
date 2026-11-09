import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/supabase/supabase_providers.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../profile/data/app_user.dart';
import '../../profile/data/user_repository.dart';

/// 알림 설정 — 끈 항목은 서버에서 알림을 만들지 않는다 (private.notify_user)
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('알림 설정')),
      body: AsyncValueView<AppUser?>(
        value: ref.watch(currentUserProfileProvider),
        onRetry: () => ref.invalidate(currentUserProfileProvider),
        data: (user) => user == null ? const SizedBox.shrink() : _PrefsForm(initial: user.notificationPrefs),
      ),
    );
  }
}

class _PrefsForm extends ConsumerStatefulWidget {
  const _PrefsForm({required this.initial});

  final NotificationPrefs initial;

  @override
  ConsumerState<_PrefsForm> createState() => _PrefsFormState();
}

class _PrefsFormState extends ConsumerState<_PrefsForm> {
  late NotificationPrefs _prefs = widget.initial;

  Future<void> _update(NotificationPrefs next) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    final previous = _prefs;
    setState(() => _prefs = next);
    try {
      await ref.read(userRepositoryProvider).updateNotificationPrefs(userId, next);
      ref.invalidate(currentUserProfileProvider);
    } catch (error) {
      if (!mounted) return;
      setState(() => _prefs = previous);
      context.showMessage(friendlyError(error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              SwitchListTile(
                secondary: const Icon(Icons.event_available_outlined),
                title: const Text('예약 알림', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('예약 확정·취소, 미방문 처리'),
                value: _prefs.booking,
                onChanged: (value) => _update(_prefs.copyWith(booking: value)),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.directions_run_rounded),
                title: const Text('운동 알림', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('운동 시작·완료·중단'),
                value: _prefs.exercise,
                onChanged: (value) => _update(_prefs.copyWith(exercise: value)),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.auto_awesome_outlined),
                title: const Text('AI 분석 알림', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('보행 분석 리포트 도착'),
                value: _prefs.analysis,
                onChanged: (value) => _update(_prefs.copyWith(analysis: value)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.campaign_outlined, color: scheme.onSurfaceVariant),
          title: const Text('이벤트·혜택 알림'),
          subtitle: const Text('마케팅 정보 수신 동의에서 설정할 수 있어요.'),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => context.push(AppRoutes.consents),
        ),
      ],
    );
  }
}
