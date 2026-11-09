import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/common.dart';
import '../../exercise/presentation/widgets/exercise_widgets.dart';
import '../../exercise/providers.dart';
import '../../health/providers.dart';
import '../data/dog.dart';
import '../providers.dart';
import 'widgets/dog_avatar.dart';

/// 반려견 상세 정보 (화면 4 DogProfileScreen)
class DogProfileScreen extends ConsumerWidget {
  const DogProfileScreen({super.key, required this.dogId});

  final String dogId;

  Future<void> _delete(BuildContext context, WidgetRef ref, Dog dog) async {
    final confirmed = await confirmDialog(
      context,
      title: '${dog.name} 정보를 삭제할까요?',
      message: '목록에서 사라지며 새 예약을 할 수 없어요. 지금까지의 운동·분석 기록은 헬스장에 보관됩니다.',
      confirmLabel: '삭제',
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(dogRepositoryProvider).deleteDog(dog.id);
      ref.invalidate(dogsProvider);
      if (context.mounted) {
        context.showMessage('${dog.name} 정보를 삭제했어요.');
        context.pop();
      }
    } catch (error) {
      if (context.mounted) context.showMessage(friendlyError(error));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dogAsync = ref.watch(dogDetailProvider(dogId));
    final dog = dogAsync.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('반려견 정보'),
        actions: [
          if (dog != null) ...[
            IconButton(
              tooltip: '수정',
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(AppRoutes.dogEdit(dog.id)),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') _delete(context, ref, dog);
              },
              itemBuilder: (context) => const [PopupMenuItem(value: 'delete', child: Text('반려견 삭제'))],
            ),
          ],
        ],
      ),
      body: AsyncValueView<Dog>(
        value: dogAsync,
        onRetry: () => ref.invalidate(dogDetailProvider(dogId)),
        data: (dog) => ListView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
          children: [
            _ProfileHeader(dog: dog),
            const SizedBox(height: 20),
            _BasicInfo(dog: dog),
            const SizedBox(height: 20),
            _HealthInfo(dogId: dog.id),
            _PlanInfo(dogId: dog.id),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                ref.read(selectedDogIdProvider.notifier).select(dog.id);
                context.push(AppRoutes.bookingNew);
              },
              icon: const Icon(Icons.event_available_rounded),
              label: Text('${dog.name} 운동 예약하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends ConsumerWidget {
  const _ProfileHeader({required this.dog});

  final Dog dog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final sessions = ref.watch(finishedSessionsProvider(dog.id)).valueOrNull ?? const [];
    final totals = ExerciseTotals.of(sessions);

    return IntersectionBackdrop(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Row(
              children: [
                DogAvatar(dog: dog, size: 84, ringColor: AppColors.peach),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dog.name, style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        dog.summary.isEmpty ? '프로필 정보를 입력해 주세요' : dog.summary,
                        style: const TextStyle(color: AppColors.peach, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: HeroNumber(label: '누적 운동', value: '${totals.count}', unit: '회')),
                Expanded(child: HeroNumber(label: '누적 시간', value: '${(totals.seconds / 60).round()}', unit: '분')),
                Expanded(
                  child: HeroNumber(label: '누적 거리', value: (totals.meters / 1000).toStringAsFixed(1), unit: 'km'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BasicInfo extends StatelessWidget {
  const _BasicInfo({required this.dog});

  final Dog dog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: '기본 정보'),
        AppCard(
          child: Column(
            children: [
              InfoRow(label: '견종', value: dog.breed ?? '-'),
              InfoRow(
                label: '생년월일',
                value: dog.birthDate == null ? '-' : '${Fmt.dateShort(dog.birthDate!)} (${dog.ageLabel})',
              ),
              InfoRow(label: '성별', value: dog.sexLabel ?? '-'),
              InfoRow(label: '체중', value: Fmt.weight(dog.weightKg)),
            ],
          ),
        ),
      ],
    );
  }
}

class _HealthInfo extends ConsumerWidget {
  const _HealthInfo({required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(dogHealthProfileProvider(dogId));
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeader(title: '건강 정보'),
        AsyncValueView<DogHealthProfile?>(
          value: profile,
          onRetry: () => ref.invalidate(dogHealthProfileProvider(dogId)),
          data: (profile) {
            if (profile == null || profile.isEmpty) {
              return const AppCard(child: Text('등록된 건강 정보가 없어요. 수정 화면에서 입력할 수 있어요.'));
            }
            Widget group(String title, List<HealthItem> items, IconData icon, {bool highlight = false}) {
              if (items.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(icon, size: 18, color: highlight ? AppColors.vermilion : scheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final item in items)
                          StatusBadge(
                            label: [
                              item.name,
                              if (item.detail != null && item.detail!.isNotEmpty) item.detail!,
                              if (item.date != null) Fmt.dateShort(item.date!),
                            ].join(' · '),
                            tone: highlight ? scheme.cautionTone : scheme.neutralTone,
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  group('운동 제한 사항', profile.exerciseRestrictions, Icons.block_rounded, highlight: true),
                  group('기저질환', profile.diseases, Icons.healing_rounded),
                  group('수술 및 치료 이력', profile.surgeries, Icons.medical_services_outlined),
                  group('복용 중인 약물', profile.medications, Icons.medication_outlined),
                  if (profile.veterinaryNotes != null && profile.veterinaryNotes!.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.local_hospital_outlined, size: 18, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        const Text('수의사 권고사항', style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(profile.veterinaryNotes!, style: const TextStyle(height: 1.5)),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PlanInfo extends ConsumerWidget {
  const _PlanInfo({required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(activePlanProvider(dogId)).valueOrNull;
    if (plan == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SectionHeader(title: '맞춤 운동 계획'),
          AppCard(
            child: Column(
              children: [
                InfoRow(label: '프로그램', value: plan.programName),
                if (plan.targetDurationSeconds != null)
                  InfoRow(label: '목표 시간', value: Fmt.durationMinutes(plan.targetDurationSeconds!)),
                if (plan.targetSpeed != null) InfoRow(label: '목표 속도', value: Fmt.speed(plan.targetSpeed)),
                if (plan.notes != null) InfoRow(label: '메모', value: plan.notes!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
