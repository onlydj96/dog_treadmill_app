import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../booking/providers.dart';
import '../../dogs/presentation/widgets/dog_avatar.dart';
import '../data/ranking_models.dart';
import '../providers.dart';
import 'widgets/ranking_widgets.dart';

/// 매장 태블릿·TV용 지점 랭킹 보드. 1분마다 새로 불러온다.
/// 매장 기기는 지점 관리자(기기) 계정으로 로그인해 두고, 화면 꺼짐을 기기 설정에서 끈다.
class StoreBoardScreen extends ConsumerStatefulWidget {
  const StoreBoardScreen({super.key, required this.branchId});

  final String branchId;

  @override
  ConsumerState<StoreBoardScreen> createState() => _StoreBoardScreenState();
}

class _StoreBoardScreenState extends ConsumerState<StoreBoardScreen> {
  /// 차콜 화면 위 카드 (시상대·순위 줄이 배경과 구분되게 한 톤 밝게)
  static const _cardColor = Color(0xFF30343F);

  late final Timer _timer;
  DateTime _month = RankingMonth.current();

  RankingQuery get _query =>
      RankingQuery(month: _month, scope: RankingScope.branch, scopeKey: widget.branchId, limit: 10);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (!mounted) return;
      // 자정을 넘기면 새 달 순위로 바꾼다
      setState(() => _month = RankingMonth.current());
      ref
        ..invalidate(leaderboardProvider(_query))
        ..invalidate(branchBattleProvider(_month));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branches = ref.watch(branchesProvider).valueOrNull ?? const [];
    final branchName = branches.where((b) => b.id == widget.branchId).firstOrNull?.name ?? 'PawFit';
    final entries = ref.watch(leaderboardProvider(_query)).valueOrNull;
    final battle = ref.watch(branchBattleProvider(_month)).valueOrNull;
    final myBattle = battle?.where((b) => b.branchId == widget.branchId).firstOrNull;

    return Theme(
      data: AppTheme.dark(),
      child: Scaffold(
        backgroundColor: AppColors.charcoal,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 20, 28, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    const BrandMark(size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$branchName 이번 달 랭킹',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            '${Fmt.yearMonth(_month)} · 운동이 끝나면 바로 반영돼요',
                            style: const TextStyle(color: AppColors.mintLight, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: '닫기',
                      color: Colors.white54,
                      onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.ranking),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: entries == null
                      ? const Center(child: CircularProgressIndicator())
                      : entries.isEmpty
                          ? const _EmptyBoard()
                          : LayoutBuilder(
                              builder: (context, constraints) {
                                // 휴대폰 기준(폭 420)으로 그린 시상대를 TV 화면 크기에 맞게 키운다
                                final podium = FittedBox(
                                  child: SizedBox(
                                    width: 420,
                                    child: RankingPodium(entries: entries.take(3).toList(), background: _cardColor),
                                  ),
                                );
                                final rest = entries.skip(3).toList();
                                if (rest.isEmpty) {
                                  return Center(
                                    child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 720), child: podium),
                                  );
                                }
                                if (constraints.maxWidth >= 840) {
                                  return Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 5, child: Align(alignment: Alignment.topCenter, child: podium)),
                                      const SizedBox(width: 24),
                                      Expanded(flex: 6, child: SingleChildScrollView(child: _BoardList(entries: rest))),
                                    ],
                                  );
                                }
                                return ListView(
                                  children: [podium, const SizedBox(height: 16), _BoardList(entries: rest)],
                                );
                              },
                            ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.phone_iphone_rounded, color: AppColors.honey),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'PawFit 앱에서 「랭킹 참여」를 켜면 우리 아이 이름이 여기에 올라와요!',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      if (myBattle != null)
                        Text(
                          '지점 대항전 ${myBattle.rank}위 · ${Fmt.km(myBattle.distanceMeters)}',
                          style: AppText.numeric(16, color: AppColors.honey),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BoardList extends StatelessWidget {
  const _BoardList({required this.entries});

  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final entry in entries)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 36,
                  child: Text('${entry.rank}', style: AppText.numeric(22, color: Colors.white70)),
                ),
                DogAvatar.path(path: entry.photoPath, size: 44),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.dogName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                      Text('@${entry.nickname}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.mintLight, fontSize: 13)),
                    ],
                  ),
                ),
                Text(Fmt.points(entry.points), style: AppText.numeric(20, color: Colors.white)),
              ],
            ),
          ),
      ],
    );
  }
}

class _EmptyBoard extends StatelessWidget {
  const _EmptyBoard();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events_rounded, color: AppColors.honey, size: 64),
          SizedBox(height: 16),
          Text(
            '이번 달 1등의 주인공이 되어 보세요!',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 6),
          Text(
            '이 지점에서 운동을 마치면 바로 순위에 올라요.',
            style: TextStyle(color: AppColors.mintLight, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
