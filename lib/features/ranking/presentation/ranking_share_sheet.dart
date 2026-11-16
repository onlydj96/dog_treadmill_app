import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/common.dart';
import '../../dogs/data/dog.dart';
import '../../dogs/presentation/widgets/dog_avatar.dart';
import '../data/ranking_models.dart';

/// 이번 달 기록을 이미지 카드로 만들어 SNS에 자랑하기
Future<void> showRankingShareSheet(BuildContext context, {required Dog dog, required MyRanking ranking}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _ShareSheet(dog: dog, ranking: ranking),
  );
}

class _ShareSheet extends StatefulWidget {
  const _ShareSheet({required this.dog, required this.ranking});

  final Dog dog;
  final MyRanking ranking;

  @override
  State<_ShareSheet> createState() => _ShareSheetState();
}

class _ShareSheetState extends State<_ShareSheet> {
  final _cardKey = GlobalKey();
  bool _sharing = false;

  Future<void> _share() async {
    setState(() => _sharing = true);
    try {
      final boundary = _cardKey.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      // 320x400 카드를 1080x1350(인스타그램 4:5)으로 저장
      final image = await boundary.toImage(pixelRatio: 1080 / RankingShareCard.width);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      image.dispose();
      if (data == null) throw StateError('카드 이미지를 만들지 못했어요');

      final month = Fmt.month(widget.ranking.periodMonth);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(data.buffer.asUint8List(), mimeType: 'image/png', name: 'pawfit_$month.png')],
          text: '${widget.dog.name}의 $month PawFit 운동 기록이에요! #PawFit #강아지트레드밀',
        ),
      );
    } catch (_) {
      if (mounted) context.showMessage('공유하지 못했어요. 잠시 후 다시 시도해 주세요.');
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('이번 달 기록 자랑하기', style: theme.textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              '이미지로 저장해 인스타그램·카카오톡에 올려 보세요.',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            Center(
              child: RepaintBoundary(
                key: _cardKey,
                child: RankingShareCard(dog: widget.dog, ranking: widget.ranking),
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _sharing ? null : _share,
              icon: _sharing
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                    )
                  : const Icon(Icons.ios_share_rounded),
              label: const Text('이미지로 공유하기'),
            ),
          ],
        ),
      ),
    );
  }
}

/// 공유용 월간 기록 카드 (4:5). 랭킹에 참여하지 않았으면 순위 대신 점수를 크게 보여준다.
class RankingShareCard extends StatelessWidget {
  const RankingShareCard({super.key, required this.dog, required this.ranking});

  static const width = 320.0;
  static const height = 400.0;

  final Dog dog;
  final MyRanking ranking;

  @override
  Widget build(BuildContext context) {
    final overall = ranking.participating ? ranking.overall : null;
    final otherRanks = ranking.participating
        ? ranking.ranks.where((r) => r.scope != RankingScope.all).take(2).toList()
        : const <ScopeRank>[];

    return SizedBox(
      width: width,
      height: height,
      child: IntersectionBackdrop(
        borderRadius: 24,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
          child: Column(
            children: [
              Row(
                children: [
                  const BrandWordmark(color: Colors.white),
                  const Spacer(),
                  Text(
                    Fmt.yearMonth(ranking.periodMonth),
                    style: const TextStyle(color: AppColors.mintLight, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ],
              ),
              const Spacer(),
              DogAvatar(
                dog: dog,
                size: 96,
                ringColor: overall != null && overall.rank <= 3 ? AppColors.medal(overall.rank) : AppColors.honey,
              ),
              const SizedBox(height: 10),
              Text(
                dog.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
              ),
              if (ranking.participating && ranking.nickname.isNotEmpty)
                Text('@${ranking.nickname}', style: const TextStyle(color: AppColors.mintLight, fontSize: 13)),
              const SizedBox(height: 12),
              if (overall != null) ...[
                Text(
                  '전체 ${overall.rank}위',
                  style: AppText.numeric(34, weight: FontWeight.w800, color: AppColors.medalGold),
                ),
                if (otherRanks.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final rank in otherRanks)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            rank.shortText,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                ],
              ] else
                Text(
                  Fmt.points(ranking.points),
                  style: AppText.numeric(34, weight: FontWeight.w800, color: AppColors.medalGold),
                ),
              const Spacer(),
              Row(
                children: [
                  _CardStat(label: '점수', value: Fmt.number(ranking.points), unit: '점'),
                  _CardStat(label: '운동', value: '${ranking.sessionCount}', unit: '회'),
                  _CardStat(label: '거리', value: (ranking.distanceMeters / 1000).toStringAsFixed(1), unit: 'km'),
                ],
              ),
              if (ranking.streakWeeks >= 2) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.local_fire_department_rounded, size: 16, color: AppColors.honey),
                    const SizedBox(width: 4),
                    Text(
                      '${ranking.streakWeeks}주 연속 운동 중',
                      style: const TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CardStat extends StatelessWidget {
  const _CardStat({required this.label, required this.value, required this.unit});

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: AppColors.mintLight, fontSize: 11.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: value, style: AppText.numeric(20, color: Colors.white)),
                TextSpan(text: ' $unit', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.75))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
