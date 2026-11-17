import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import '../../dogs/presentation/widgets/dog_avatar.dart';
import '../data/ranking_models.dart';
import '../providers.dart';
import 'widgets/ranking_widgets.dart';

/// 랭킹에서 반려견을 눌렀을 때: 공개 프로필, 배지, 수상 기록, 응원하기
Future<void> showRankingDogSheet(BuildContext context, String dogId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _RankingDogSheet(dogId: dogId),
  );
}

class _RankingDogSheet extends ConsumerStatefulWidget {
  const _RankingDogSheet({required this.dogId});

  final String dogId;

  @override
  ConsumerState<_RankingDogSheet> createState() => _RankingDogSheetState();
}

class _RankingDogSheetState extends ConsumerState<_RankingDogSheet> {
  bool _cheering = false;

  Future<void> _cheer(RankingDogProfile profile) async {
    setState(() => _cheering = true);
    try {
      await ref.read(rankingRepositoryProvider).cheer(profile.dogId);
      ref
        ..invalidate(rankingDogProfileProvider(profile.dogId))
        ..invalidate(leaderboardProvider);
      if (mounted) context.showMessage(context.l10n.rankingCheerSent(profile.dogName));
    } catch (error) {
      if (mounted) context.showMessage(friendlyError(error));
    } finally {
      if (mounted) setState(() => _cheering = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(rankingDogProfileProvider(widget.dogId));
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
        child: profile.when(
          skipLoadingOnRefresh: true,
          loading: () => const SizedBox(height: 280, child: LoadingView()),
          error: (error, _) => ErrorView(
            message: friendlyError(error),
            onRetry: () => ref.invalidate(rankingDogProfileProvider(widget.dogId)),
          ),
          data: (profile) => _ProfileBody(profile: profile, cheering: _cheering, onCheer: () => _cheer(profile)),
        ),
      ),
    );
  }
}

/// 단위가 없는 언어(영어)에서는 단위를 붙이지 않는다
String? _unitOrNull(String unit) => unit.isEmpty ? null : unit;

class _ProfileBody extends ConsumerWidget {
  const _ProfileBody({required this.profile, required this.cheering, required this.onCheer});

  final RankingDogProfile profile;
  final bool cheering;
  final VoidCallback onCheer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final catalog = {
      for (final badge in ref.watch(badgeCatalogProvider).valueOrNull ?? const <BadgeDef>[]) badge.code: badge,
    };
    final l = context.l10n;
    final rank = profile.rank;
    final subtitle = [
      if (profile.breedLabel != null) profile.breedLabel!,
      if (profile.size != null) sizeScopeLabel(profile.size!),
    ].join(' · ');

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: DogAvatar.path(
              path: profile.photoPath,
              size: 92,
              ringColor: rank != null && rank <= 3 ? AppColors.medal(rank) : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(profile.dogName, textAlign: TextAlign.center, style: theme.textTheme.headlineSmall),
          if (subtitle.isNotEmpty)
            Text(subtitle, textAlign: TextAlign.center, style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 2),
          Text(
            '@${profile.nickname}',
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w700),
          ),
          if (profile.awards.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final award in profile.awards.take(6))
                  RankingTitleChip(text: award.text, rank: award.rank, dense: false),
              ],
            ),
          ],
          const SizedBox(height: 18),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: StatValue(
                    label: l.rankingStatRank(Fmt.month(profile.periodMonth)),
                    value: rank == null ? '-' : l.rankingRankValue(rank),
                    unit: rank == null ? null : _unitOrNull(l.rankingRankUnit),
                    valueSize: 22,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                Expanded(
                  child: StatValue(
                    label: l.rankingStatPoints,
                    value: Fmt.number(profile.points),
                    unit: _unitOrNull(l.rankingUnitPoints),
                    valueSize: 22,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                Expanded(
                  child: StatValue(
                    label: l.rankingStatSessions,
                    value: '${profile.sessionCount}',
                    unit: _unitOrNull(l.rankingUnitSessions),
                    valueSize: 22,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                Expanded(
                  child: StatValue(
                    label: l.rankingStatCheers,
                    value: '${profile.cheerCount}',
                    valueSize: 22,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(l.rankingBadgesEarned(profile.badges.length), style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          if (profile.badges.isEmpty)
            Text(l.rankingNoBadgesYet, style: TextStyle(color: scheme.onSurfaceVariant))
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final earned in profile.badges)
                  if (catalog[earned.code] case final badge?)
                    SizedBox(
                      width: 76,
                      child: Column(
                        children: [
                          BadgeMedallion(badge: badge, earned: true, size: 48),
                          const SizedBox(height: 4),
                          Text(
                            badge.name,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, height: 1.25),
                          ),
                        ],
                      ),
                    ),
              ],
            ),
          const SizedBox(height: 22),
          if (profile.isMine)
            Text(
              profile.participating ? l.rankingMyDogJoined : l.rankingMyDogNotJoined,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            )
          else
            FilledButton.icon(
              onPressed: profile.cheeredByMe || cheering ? null : onCheer,
              icon: Icon(profile.cheeredByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded),
              label: Text(profile.cheeredByMe ? l.rankingCheeredThisMonth : l.rankingCheerDog(profile.dogName)),
              style: FilledButton.styleFrom(backgroundColor: AppColors.coral, foregroundColor: Colors.white),
            ),
        ],
      ),
    );
  }
}
