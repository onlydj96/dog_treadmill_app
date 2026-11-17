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
import '../../ranking/data/ranking_models.dart';
import '../../ranking/presentation/widgets/ranking_widgets.dart';
import '../../../l10n/l10n.dart';
import '../../ranking/providers.dart';
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
      title: context.l10n.dogDeleteTitle(dog.name),
      message: context.l10n.dogDeleteMessage,
      confirmLabel: context.l10n.commonDelete,
      destructive: true,
    );
    if (!confirmed) return;
    try {
      await ref.read(dogRepositoryProvider).deleteDog(dog.id);
      ref.invalidate(dogsProvider);
      if (context.mounted) {
        context.showMessage(context.l10n.dogDeleted(dog.name));
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
        title: Text(context.l10n.dogProfileTitle),
        actions: [
          if (dog != null) ...[
            IconButton(
              tooltip: context.l10n.commonEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.push(AppRoutes.dogEdit(dog.id)),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') _delete(context, ref, dog);
              },
              itemBuilder: (context) => [PopupMenuItem(value: 'delete', child: Text(context.l10n.dogDeleteMenu))],
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
            _AchievementSection(dogId: dog.id),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () {
                ref.read(selectedDogIdProvider.notifier).select(dog.id);
                context.push(AppRoutes.bookingNew);
              },
              icon: const Icon(Icons.event_available_rounded),
              label: Text(context.l10n.dogBookWorkout(dog.name)),
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
                DogAvatar(dog: dog, size: 84, ringColor: AppColors.honey),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dog.name, style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        dog.summary.isEmpty ? context.l10n.dogProfileEmptySummary : dog.summary,
                        style: const TextStyle(color: AppColors.mintLight, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(child: HeroNumber(label: context.l10n.dogTotalWorkouts, value: '${totals.count}', unit: context.l10n.dogUnitTimes)),
                Expanded(child: HeroNumber(
                    label: context.l10n.dogTotalTime,
                    value: '${(totals.seconds / 60).round()}',
                    unit: context.l10n.dogUnitMinutes,
                  )),
                Expanded(
                  child: HeroNumber(label: context.l10n.dogTotalDistance, value: (totals.meters / 1000).toStringAsFixed(1), unit: 'km'),
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
        SectionHeader(title: context.l10n.dogSectionBasic),
        AppCard(
          child: Column(
            children: [
              InfoRow(label: context.l10n.dogBreed, value: dog.breedLabel ?? '-'),
              InfoRow(
                label: context.l10n.dogSize,
                value: dog.size == null
                    ? '-'
                    : [
                        context.l10n.dogSizeDog(dog.size!.label),
                        if (dog.isBrachycephalic == true) context.l10n.dogBrachycephalic,
                      ].join(' · '),
              ),
              if (dog.birthDateEstimated)
                InfoRow(label: context.l10n.dogAge, value: context.l10n.dogAgeEstimated(dog.ageLabel ?? '-'))
              else
                InfoRow(
                  label: context.l10n.dogBirthDate,
                  value: dog.birthDate == null ? '-' : '${Fmt.dateShort(dog.birthDate!)} (${dog.ageLabel})',
                ),
              InfoRow(label: context.l10n.dogSex, value: dog.sex?.label ?? '-'),
              InfoRow(
                label: context.l10n.dogNeutered,
                value: switch (dog.neutered) {
                  true => context.l10n.dogNeuteredYes,
                  false => context.l10n.dogNeuteredNo,
                  null => '-',
                },
              ),
              InfoRow(label: context.l10n.dogWeight, value: Fmt.weight(dog.weightKg)),
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
    final conditionNames = {
      for (final condition in ref.watch(healthConditionsProvider).valueOrNull ?? const <HealthCondition>[])
        condition.code: condition.name,
    };
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.dogSectionHealth),
        AsyncValueView<DogHealthProfile?>(
          value: profile,
          onRetry: () => ref.invalidate(dogHealthProfileProvider(dogId)),
          data: (profile) {
            if (profile == null || profile.isEmpty) {
              return InlineEmptyCard(
                icon: Icons.medical_services_outlined,
                message: context.l10n.dogNoHealthInfo,
              );
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
                        Icon(icon, size: 18, color: highlight ? AppColors.honeyDeep : scheme.onSurfaceVariant),
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
                  if (profile.conditionCodes case final codes?)
                    group(
                      context.l10n.dogConditionsTitle,
                      codes.isEmpty
                          ? [HealthItem(name: context.l10n.dogConditionNone)]
                          : [for (final code in codes) HealthItem(name: conditionNames[code] ?? code)],
                      Icons.health_and_safety_outlined,
                      highlight: codes.isNotEmpty,
                    ),
                  group(context.l10n.dogRestrictionsTitle, profile.exerciseRestrictions, Icons.block_rounded, highlight: true),
                  group(context.l10n.dogDiseasesTitle, profile.diseases, Icons.healing_rounded),
                  group(context.l10n.dogSurgeriesTitle, profile.surgeries, Icons.medical_services_outlined),
                  group(context.l10n.dogMedicationsTitle, profile.medications, Icons.medication_outlined),
                  if (profile.veterinaryNotes != null && profile.veterinaryNotes!.isNotEmpty) ...[
                    Row(
                      children: [
                        Icon(Icons.local_hospital_outlined, size: 18, color: scheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        Text(context.l10n.dogVetNotes, style: const TextStyle(fontWeight: FontWeight.w700)),
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

/// 받은 배지·수상 기록과 다음 배지까지의 진행률
class _AchievementSection extends ConsumerWidget {
  const _AchievementSection({required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final achievements = ref.watch(dogAchievementsProvider(dogId)).valueOrNull;
    final catalog = ref.watch(badgeCatalogProvider).valueOrNull;
    // 불러오는 동안·실패 시에는 섹션을 숨긴다 (배지함 화면에서 다시 시도할 수 있다)
    if (achievements == null || catalog == null) return const SizedBox.shrink();

    final earned = [
      for (final badge in catalog)
        if (achievements.earned(badge.code) != null) badge,
    ];
    BadgeDef? next;
    var nextProgress = -1.0;
    for (final badge in catalog) {
      if (achievements.earned(badge.code) != null) continue;
      final progress = badge.progress(achievements.stats);
      if (progress != null && progress > nextProgress) {
        next = badge;
        nextProgress = progress;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(
            title: context.l10n.dogBadgeSection(earned.length, catalog.length),
            actionLabel: context.l10n.dogBadgeCollection,
            onAction: () => context.push(AppRoutes.dogBadges(dogId)),
          ),
          AppCard(
            onTap: () => context.push(AppRoutes.dogBadges(dogId)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (achievements.awards.isNotEmpty) ...[
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final award in achievements.awards.take(4))
                        RankingTitleChip(text: award.text, rank: award.rank, dense: false),
                    ],
                  ),
                  const SizedBox(height: 14),
                ],
                if (earned.isEmpty)
                  Text(context.l10n.dogFirstBadgeHint, style: TextStyle(color: scheme.onSurfaceVariant))
                else
                  SizedBox(
                    height: 86,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: earned.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 6),
                      itemBuilder: (context, index) => SizedBox(
                        width: 76,
                        child: Column(
                          children: [
                            BadgeMedallion(badge: earned[index], earned: true, size: 50),
                            const SizedBox(height: 4),
                            Text(
                              earned[index].name,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, height: 1.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (next != null) ...[
                  const Divider(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          context.l10n.dogNextBadge(next.name),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                        ),
                      ),
                      Text(
                        next.progressLabel(achievements.stats) ?? '',
                        style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: nextProgress,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
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
          SectionHeader(title: context.l10n.dogPlanSection),
          AppCard(
            child: Column(
              children: [
                InfoRow(label: context.l10n.dogPlanProgram, value: plan.programName),
                if (plan.targetDurationSeconds != null)
                  InfoRow(label: context.l10n.dogPlanTargetTime, value: Fmt.durationMinutes(plan.targetDurationSeconds!)),
                if (plan.targetSpeed != null) InfoRow(label: context.l10n.dogPlanTargetSpeed, value: Fmt.speed(plan.targetSpeed)),
                if (plan.notes != null) InfoRow(label: context.l10n.dogPlanNotes, value: plan.notes!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
