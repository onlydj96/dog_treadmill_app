import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/common.dart';
import '../../dogs/providers.dart';
import '../data/ranking_models.dart';
import '../providers.dart';
import 'widgets/ranking_widgets.dart';

/// 반려견 배지함: 받은 배지와 다음 배지까지의 진행률, 수상 기록
class BadgeCollectionScreen extends ConsumerWidget {
  const BadgeCollectionScreen({super.key, required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dogName = ref.watch(dogDetailProvider(dogId)).valueOrNull?.name;
    final achievements = ref.watch(dogAchievementsProvider(dogId));
    final catalog = ref.watch(badgeCatalogProvider);

    Future<void> refresh() async {
      ref.invalidate(dogAchievementsProvider(dogId));
      await ref.read(dogAchievementsProvider(dogId).future);
    }

    // 새로고침 중에는 이전 값을 그대로 보여준다
    final data = achievements.valueOrNull;
    final badges = catalog.valueOrNull;
    final error = achievements.error ?? catalog.error;

    return Scaffold(
      appBar: AppBar(title: Text(dogName == null ? '배지함' : '$dogName의 배지함')),
      body: data != null && badges != null
          ? RefreshIndicator(onRefresh: refresh, child: _Collection(achievements: data, catalog: badges))
          : error != null
              ? ErrorView(
                  message: friendlyError(error),
                  onRetry: () {
                    ref
                      ..invalidate(dogAchievementsProvider(dogId))
                      ..invalidate(badgeCatalogProvider);
                  },
                )
              : const LoadingView(),
    );
  }
}

class _Collection extends StatelessWidget {
  const _Collection({required this.achievements, required this.catalog});

  final DogAchievements achievements;
  final List<BadgeDef> catalog;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = achievements.stats;
    final earnedCount = catalog.where((b) => achievements.earned(b.code) != null).length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.mintMist, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: '받은 배지 '),
                    TextSpan(text: '$earnedCount', style: const TextStyle(color: AppColors.mintDeep)),
                    TextSpan(text: ' / ${catalog.length}'),
                  ],
                ),
                style: theme.textTheme.titleMedium?.copyWith(color: AppColors.mintInk),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: StatValue(
                      label: '운동',
                      value: '${stats.sessions}',
                      unit: '회',
                      valueSize: 20,
                      color: AppColors.mintInk,
                      labelColor: AppColors.mintDeep,
                    ),
                  ),
                  Expanded(
                    child: StatValue(
                      label: '누적 거리',
                      value: (stats.distanceMeters / 1000).toStringAsFixed(1),
                      unit: 'km',
                      valueSize: 20,
                      color: AppColors.mintInk,
                      labelColor: AppColors.mintDeep,
                    ),
                  ),
                  Expanded(
                    child: StatValue(
                      label: '연속 운동',
                      value: '${stats.streakWeeks}',
                      unit: '주',
                      valueSize: 20,
                      color: AppColors.mintInk,
                      labelColor: AppColors.mintDeep,
                    ),
                  ),
                  Expanded(
                    child: StatValue(
                      label: '방문 지점',
                      value: '${stats.branches}',
                      unit: '곳',
                      valueSize: 20,
                      color: AppColors.mintInk,
                      labelColor: AppColors.mintDeep,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (achievements.awards.isNotEmpty) ...[
          const SizedBox(height: 24),
          const SectionHeader(title: '수상 기록'),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final award in achievements.awards)
                RankingTitleChip(text: '${award.text} · ${Fmt.points(award.points)}', rank: award.rank, dense: false),
            ],
          ),
        ],
        const SizedBox(height: 24),
        const SectionHeader(title: '배지'),
        for (final badge in catalog)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _BadgeCard(badge: badge, earned: achievements.earned(badge.code), stats: stats),
          ),
      ],
    );
  }
}

class _BadgeCard extends StatelessWidget {
  const _BadgeCard({required this.badge, required this.earned, required this.stats});

  final BadgeDef badge;
  final EarnedBadge? earned;
  final BadgeStats stats;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final progress = earned == null ? badge.progress(stats) : null;
    final progressLabel = earned == null ? badge.progressLabel(stats) : null;

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          BadgeMedallion(badge: badge, earned: earned != null, size: 52),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  badge.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: earned == null ? scheme.onSurfaceVariant : null,
                  ),
                ),
                const SizedBox(height: 2),
                Text(badge.description, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.4)),
                if (earned != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${Fmt.dateShort(earned!.earnedAt)} 획득',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: scheme.primary),
                  ),
                ] else if (progress != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(progressLabel ?? '', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ] else ...[
                  const SizedBox(height: 4),
                  Text('월간 랭킹 마감 때 받아요',
                      style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
