import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/brand_mark.dart';
import '../../../../core/widgets/common.dart';
import '../../../dogs/presentation/widgets/dog_avatar.dart';
import '../../data/ranking_models.dart';

/// 1~3위 메달 (숫자). 4위부터는 숫자만.
class RankMedal extends StatelessWidget {
  const RankMedal({super.key, required this.rank, this.size = 28});

  final int rank;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (rank > 3) {
      return SizedBox(
        width: size,
        child: Text(
          '$rank',
          textAlign: TextAlign.center,
          style: AppText.numeric(size * 0.6, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: AppColors.medal(rank), shape: BoxShape.circle),
      child: Text('$rank', style: AppText.numeric(size * 0.5, weight: FontWeight.w800, color: AppColors.charcoal)),
    );
  }
}

/// 지난달 수상 칭호 ("10월 전체 1위")
class RankingTitleChip extends StatelessWidget {
  const RankingTitleChip({super.key, required this.text, this.rank = 1, this.dense = true});

  final String text;
  final int rank;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: dense ? 7 : 10, vertical: dense ? 2 : 4),
      decoration: BoxDecoration(color: AppColors.medal(rank), borderRadius: BorderRadius.circular(999)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events_rounded, size: dense ? 12 : 15, color: AppColors.charcoal),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: dense ? 11 : 12.5,
                fontWeight: FontWeight.w800,
                color: AppColors.charcoal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 순위표 상위 3마리 시상대 (차콜 히어로 위)
class RankingPodium extends StatelessWidget {
  const RankingPodium({super.key, required this.entries, this.onTap, this.background = AppColors.charcoal});

  /// 1~3위 (최대 3개)
  final List<LeaderboardEntry> entries;
  final ValueChanged<LeaderboardEntry>? onTap;

  /// 카드 배경. 차콜 화면(매장 보드) 위에서는 한 톤 밝게 준다.
  final Color background;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return const SizedBox.shrink();
    final first = entries.isNotEmpty ? entries[0] : null;
    final second = entries.length > 1 ? entries[1] : null;
    final third = entries.length > 2 ? entries[2] : null;

    return IntersectionBackdrop(
      background: background,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 22, 12, 0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: _PodiumColumn(entry: second, place: 2, onTap: onTap)),
            Expanded(child: _PodiumColumn(entry: first, place: 1, onTap: onTap)),
            Expanded(child: _PodiumColumn(entry: third, place: 3, onTap: onTap)),
          ],
        ),
      ),
    );
  }
}

class _PodiumColumn extends StatelessWidget {
  const _PodiumColumn({required this.entry, required this.place, this.onTap});

  final LeaderboardEntry? entry;
  final int place;
  final ValueChanged<LeaderboardEntry>? onTap;

  @override
  Widget build(BuildContext context) {
    final entry = this.entry;
    final avatarSize = place == 1 ? 76.0 : 58.0;
    final pedestalHeight = switch (place) { 1 => 56.0, 2 => 40.0, _ => 30.0 };
    final medal = AppColors.medal(entry?.rank ?? place);

    final pedestal = Container(
      height: pedestalHeight,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: place == 1 ? 0.16 : 0.1),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Text('${entry?.rank ?? place}', style: AppText.numeric(22, weight: FontWeight.w800, color: medal)),
    );

    if (entry == null) {
      return Column(mainAxisSize: MainAxisSize.min, children: [const SizedBox(height: 8), pedestal]);
    }

    return Semantics(
      button: onTap != null,
      label: '${entry.rank}위 ${entry.dogName}, ${Fmt.points(entry.points)}',
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap == null ? null : () => onTap!(entry),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (place == 1) const Icon(Icons.workspace_premium_rounded, color: AppColors.medalGold, size: 26),
            DogAvatar.path(path: entry.photoPath, size: avatarSize, ringColor: medal),
            const SizedBox(height: 8),
            Text(
              entry.dogName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: place == 1 ? 16 : 14,
              ),
            ),
            Text(
              '@${entry.nickname}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.mintLight, fontSize: 11.5, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(Fmt.points(entry.points), style: AppText.numeric(14, color: Colors.white)),
            const SizedBox(height: 8),
            pedestal,
          ],
        ),
      ),
    );
  }
}

/// 순위표 한 줄 (4위부터)
class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({super.key, required this.entry, this.onTap});

  final LeaderboardEntry entry;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final subtitle = [
      '@${entry.nickname}',
      if (entry.breedLabel != null) entry.breedLabel!,
      if (entry.mainBranchName != null) shortBranchName(entry.mainBranchName!),
    ].join(' · ');

    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
      color: entry.isMine ? scheme.primaryContainer : null,
      borderColor: entry.isMine ? Colors.transparent : null,
      child: Row(
        children: [
          RankMedal(rank: entry.rank, size: 30),
          const SizedBox(width: 10),
          DogAvatar.path(path: entry.photoPath, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        entry.dogName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                      ),
                    ),
                    if (entry.isMine) ...[
                      const SizedBox(width: 6),
                      StatusBadge(label: '내 반려견', tone: scheme.activeTone, dense: true),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                ),
                // 지난달 칭호는 이름 줄이 좁아지지 않게 따로 한 줄에 둔다
                if (entry.title != null) ...[
                  const SizedBox(height: 5),
                  RankingTitleChip(text: entry.title!.text, rank: entry.title!.rank),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(Fmt.points(entry.points), style: AppText.numeric(16)),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    entry.cheeredByMe ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    size: 13,
                    color: entry.cheeredByMe ? AppColors.coral : scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 3),
                  Text('${entry.cheerCount}', style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 배지 아이콘 키 → Material 아이콘 (DB badges.icon)
IconData badgeIcon(String key) => switch (key) {
      'flag' => Icons.flag_rounded,
      'run' => Icons.directions_run_rounded,
      'route' => Icons.route_rounded,
      'fire' => Icons.local_fire_department_rounded,
      'stamp' => Icons.approval_rounded,
      'sunrise' => Icons.wb_twilight_rounded,
      'trophy' => Icons.emoji_events_rounded,
      _ => Icons.pets_rounded,
    };

Color badgeTierColor(BadgeTier tier) => switch (tier) {
      BadgeTier.gold => AppColors.medalGold,
      BadgeTier.silver => AppColors.medalSilver,
      BadgeTier.bronze => AppColors.medalBronze,
    };

/// 배지 메달. 받지 않은 배지는 회색으로 잠가 둔다.
class BadgeMedallion extends StatelessWidget {
  const BadgeMedallion({super.key, required this.badge, required this.earned, this.size = 56});

  final BadgeDef badge;
  final bool earned;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tierColor = badgeTierColor(badge.tier);
    return Semantics(
      label: '${badge.name} 배지${earned ? '' : ' (아직 받지 않음)'}',
      excludeSemantics: true,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: earned ? tierColor : scheme.surfaceContainerHigh,
          border: Border.all(
            color: earned ? AppColors.charcoal.withValues(alpha: 0.12) : scheme.outlineVariant,
            width: 2,
          ),
        ),
        child: Icon(
          earned ? badgeIcon(badge.icon) : Icons.lock_outline_rounded,
          size: size * 0.46,
          color: earned ? AppColors.charcoal : scheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

/// 운동 기록에 붙는 점수 칩 ("+40점"). 0점이면 회색.
class PointsChip extends StatelessWidget {
  const PointsChip({super.key, required this.summary, this.onTap});

  final SessionPointsSummary summary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final earned = summary.total > 0;
    final tone = earned ? scheme.activeTone : scheme.neutralTone;
    final label = summary.voided ? '점수 무효' : (earned ? '+${Fmt.points(summary.total)}' : '0점');
    return Semantics(
      button: onTap != null,
      label: '랭킹 점수 $label',
      excludeSemantics: true,
      child: Material(
        color: tone.background,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_outlined, size: 14, color: tone.foreground),
                const SizedBox(width: 3),
                Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: tone.foreground)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 운동 1회 점수 내역
Future<void> showPointsBreakdownSheet(BuildContext context, SessionPointsSummary summary) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final theme = Theme.of(context);
      final scheme = theme.colorScheme;
      Widget row(String label, int points, {String? caption}) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
                      if (caption != null)
                        Text(caption, style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                Text('+$points', style: AppText.numeric(17)),
              ],
            ),
          );
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('이번 운동 점수', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text(
                summary.voided
                    ? '운영자 확인 결과 이 운동의 점수는 무효 처리되었어요.'
                    : summary.note?.message ?? '꾸준히 운동할수록 점수가 쌓여요.',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              row('출석', summary.attendance, caption: '5분 이상 운동 (하루 1회)'),
              row('달성', summary.achievement, caption: '프로그램 목표 시간 대비 (최대 10)'),
              row('거리', summary.distance, caption: '100m당 1점 (최대 20)'),
              if (summary.weeklyBonus > 0) row('주간 보너스', summary.weeklyBonus, caption: '이번 주 두 번째 운동'),
              const Divider(height: 24),
              Row(
                children: [
                  const Expanded(child: Text('합계', style: TextStyle(fontWeight: FontWeight.w800))),
                  Text(Fmt.points(summary.total), style: AppText.numeric(22, color: scheme.primary)),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// 점수 규칙 안내 (docs/ranking.md와 같은 내용)
Future<void> showScoreRulesSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final theme = Theme.of(context);
      final scheme = theme.colorScheme;
      Widget rule(IconData icon, String title, String body) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: scheme.primaryContainer, shape: BoxShape.circle),
                  child: Icon(icon, size: 19, color: scheme.onPrimaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text(body, style: TextStyle(color: scheme.onSurfaceVariant, height: 1.45)),
                    ],
                  ),
                ),
              ],
            ),
          );
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('점수는 이렇게 쌓여요', style: theme.textTheme.titleLarge),
              const SizedBox(height: 4),
              Text('많이보다 꾸준히! 무리한 운동은 점수에 도움이 되지 않아요.',
                  style: TextStyle(color: scheme.onSurfaceVariant)),
              const SizedBox(height: 18),
              rule(Icons.how_to_reg_rounded, '출석 10점', '5분 이상 운동하면 받아요. 반려견마다 하루 한 번만 점수를 받아요.'),
              rule(Icons.flag_rounded, '달성 최대 10점', '프로그램 목표 시간을 채운 만큼 받아요. 중간에 멈춰도 감점은 없어요.'),
              rule(Icons.route_rounded, '거리 최대 20점', '100m마다 1점이에요. 2km를 넘게 걸어도 20점까지만 받아요.'),
              rule(Icons.local_fire_department_rounded, '주간 보너스 20점', '한 주(월~일)에 두 번 이상 운동하면 받아요.'),
              rule(Icons.leaderboard_rounded, '월간 랭킹',
                  '매달 1일에 새로 시작해요. 전체·지점·체급별로 순위를 매기고, 동점이면 먼저 도달한 반려견이 앞서요.'),
              rule(Icons.emoji_events_rounded, '명예의 전당',
                  '달이 끝나면 부문별 1~3위가 명예의 전당에 오르고 「시상대」 배지를 받아요.'),
              const SizedBox(height: 4),
              Text(
                '반려견 컨디션이 좋지 않으면 운동을 쉬어 주세요. 이상이 보이면 트레드밀의 비상정지 버튼을 눌러 주세요.',
                style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant, height: 1.5),
              ),
            ],
          ),
        ),
      );
    },
  );
}
