import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/common.dart';
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
      if (mounted) context.showMessage('${profile.dogName}에게 응원을 보냈어요!');
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
    final rank = profile.rank;
    final subtitle = [
      if (profile.breedLabel != null) profile.breedLabel!,
      if (profile.size != null) '${profile.size!.label}견',
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
                    label: '${Fmt.month(profile.periodMonth)} 순위',
                    value: rank == null ? '-' : '$rank',
                    unit: rank == null ? null : '위',
                    valueSize: 22,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                Expanded(
                  child: StatValue(
                    label: '점수',
                    value: Fmt.number(profile.points),
                    unit: '점',
                    valueSize: 22,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                Expanded(
                  child: StatValue(
                    label: '운동',
                    value: '${profile.sessionCount}',
                    unit: '회',
                    valueSize: 22,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
                Expanded(
                  child: StatValue(
                    label: '응원',
                    value: '${profile.cheerCount}',
                    valueSize: 22,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text('받은 배지 ${profile.badges.length}개', style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          if (profile.badges.isEmpty)
            Text('아직 받은 배지가 없어요.', style: TextStyle(color: scheme.onSurfaceVariant))
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
              profile.participating ? '내 반려견이에요. 꾸준히 운동해서 순위를 올려 보세요!' : '랭킹에 참여하면 다른 회원도 볼 수 있어요.',
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            )
          else
            FilledButton.icon(
              onPressed: profile.cheeredByMe || cheering ? null : onCheer,
              icon: Icon(profile.cheeredByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded),
              label: Text(profile.cheeredByMe ? '이번 달 응원했어요' : '${profile.dogName} 응원하기'),
              style: FilledButton.styleFrom(backgroundColor: AppColors.coral, foregroundColor: Colors.white),
            ),
        ],
      ),
    );
  }
}
