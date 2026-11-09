import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../profile/data/user_repository.dart';
import '../data/consent.dart';
import '../data/consent_repository.dart';

/// 개인정보 및 영상 이용 동의 관리 (문서 3.5, 8장: 영상 촬영 동의와 AI 학습 동의 분리)
class ConsentScreen extends ConsumerStatefulWidget {
  const ConsentScreen({super.key});

  @override
  ConsumerState<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends ConsumerState<ConsentScreen> {
  final Set<ConsentType> _saving = {};

  Future<void> _toggle(ConsentType type, bool granted) async {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;

    if (!granted && type == ConsentType.videoRecording) {
      final confirmed = await confirmDialog(
        context,
        title: '영상 촬영 동의를 철회할까요?',
        message: '철회하면 다음 운동부터 AI 보행 분석 리포트가 제공되지 않아요. 이미 받은 리포트는 그대로 볼 수 있어요.',
        confirmLabel: '철회',
        destructive: true,
      );
      if (!confirmed) return;
    }

    setState(() => _saving.add(type));
    try {
      await ref.read(consentRepositoryProvider).record(userId, type, granted: granted);
      // 마케팅 동의는 이벤트·혜택 알림 설정과 함께 맞춘다.
      if (type == ConsentType.marketing) {
        final profile = ref.read(currentUserProfileProvider).valueOrNull;
        if (profile != null) {
          await ref
              .read(userRepositoryProvider)
              .updateNotificationPrefs(userId, profile.notificationPrefs.copyWith(marketing: granted));
          ref.invalidate(currentUserProfileProvider);
        }
      }
      ref.invalidate(consentsProvider);
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    } finally {
      if (mounted) setState(() => _saving.remove(type));
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('개인정보 및 영상 이용 동의')),
      body: AsyncValueView<Map<ConsentType, DataConsent>>(
        value: ref.watch(consentsProvider),
        onRetry: () => ref.invalidate(consentsProvider),
        data: (consents) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              '동의 항목은 언제든 변경할 수 있으며, 변경 이력은 안전하게 보관됩니다.',
              style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5),
            ),
            const SizedBox(height: 16),
            for (final type in ConsentType.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _ConsentCard(
                  type: type,
                  consent: consents[type],
                  saving: _saving.contains(type),
                  onChanged: type.isRequired ? null : (value) => _toggle(type, value),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              '필수 항목은 서비스 제공에 꼭 필요해 철회할 수 없어요. 철회를 원하면 회원 탈퇴를 진행해 주세요.',
              style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConsentCard extends StatelessWidget {
  const _ConsentCard({
    required this.type,
    required this.consent,
    required this.saving,
    required this.onChanged,
  });

  final ConsentType type;
  final DataConsent? consent;
  final bool saving;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final granted = consent?.granted ?? false;
    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 14, 10, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              StatusBadge(
                label: type.isRequired ? '필수' : '선택',
                tone: type.isRequired
                    ? const StatusTone(foreground: Colors.white, background: AppColors.vermilion)
                    : scheme.neutralTone,
                dense: true,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(type.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15))),
              if (saving)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2.2)),
                )
              else
                Switch(value: granted, onChanged: onChanged),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(type.description, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.5)),
          ),
          if (consent != null) ...[
            const SizedBox(height: 8),
            Text(
              '${granted ? '동의' : '미동의'} · ${Fmt.dateShort(consent!.respondedAt)} · v${consent!.version}',
              style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}
