import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../../l10n/l10n.dart';
import '../../booking/data/booking_models.dart';
import '../../booking/providers.dart';
import '../../consents/data/consent_repository.dart';
import '../../dogs/data/dog.dart';
import '../../dogs/presentation/widgets/dog_avatar.dart';
import '../../dogs/providers.dart';
import '../../profile/data/user_repository.dart';
import '../data/ranking_models.dart';
import '../providers.dart';
import 'ranking_dog_sheet.dart';
import 'ranking_settings_sheet.dart';
import 'ranking_share_sheet.dart';
import 'widgets/ranking_widgets.dart';

enum RankingTab {
  leaderboard,
  battle,
  hall;

  /// 라우트 쿼리 (?tab=battle | hall)
  static RankingTab fromQuery(String? value) => switch (value) {
        'battle' => battle,
        'hall' => hall,
        _ => leaderboard,
      };
}

enum _MenuAction { settings, rules, board }

/// 랭킹 — 반려견 월간 랭킹, 지점 대항전, 명예의 전당
class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key, this.initialTab = RankingTab.leaderboard});

  final RankingTab initialTab;

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this, initialIndex: widget.initialTab.index);
  DateTime _month = RankingMonth.current();
  RankingScope _scope = RankingScope.all;
  String? _branchId;
  DogSize? _size;

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  /// 지점·체급을 고르지 않았으면 내 반려견이 이번 달 가장 많이 운동한 지점·체구를 먼저 보여준다.
  String? _scopeKey({required Dog? dog, required MyRanking? mine, required List<Branch> branches}) {
    return switch (_scope) {
      RankingScope.all => 'all',
      RankingScope.branch => _branchId ?? mine?.mainBranch?.scopeKey ?? branches.firstOrNull?.id,
      RankingScope.size => (_size ?? dog?.size ?? DogSize.small).dbValue,
    };
  }

  Future<void> _openMenu(_MenuAction action) async {
    switch (action) {
      case _MenuAction.settings:
        await showRankingSettingsSheet(context);
      case _MenuAction.rules:
        await showScoreRulesSheet(context);
      case _MenuAction.board:
        await _pickBoardBranch();
    }
  }

  /// 관리자: 매장 랭킹 보드를 띄울 지점 선택
  Future<void> _pickBoardBranch() async {
    final branches = ref.read(branchesProvider).valueOrNull ?? const <Branch>[];
    final managed = ref.read(currentUserProfileProvider).valueOrNull?.managedBranchId;
    final candidates = managed == null ? branches : branches.where((b) => b.id == managed).toList();
    final branchId = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(context.l10n.boardTitle, style: Theme.of(context).textTheme.titleLarge),
            ),
            for (final branch in candidates)
              ListTile(
                leading: const Icon(Icons.tv_rounded),
                title: Text(branch.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                onTap: () => Navigator.of(context).pop(branch.id),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
    if (branchId != null && mounted) await context.push(AppRoutes.storeBoard(branchId));
  }

  @override
  Widget build(BuildContext context) {
    final dog = ref.watch(selectedDogProvider).valueOrNull;
    final mine = dog == null ? null : ref.watch(myRankingProvider(DogMonth(dog.id, _month))).valueOrNull;
    final isAdmin = ref.watch(currentUserProfileProvider).valueOrNull?.isAdmin ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.rankingTitle),
        actions: [
          if (dog != null && mine != null && mine.points > 0)
            IconButton(
              tooltip: context.l10n.rankingShareTooltip,
              icon: const Icon(Icons.ios_share_rounded),
              onPressed: () => showRankingShareSheet(context, dog: dog, ranking: mine),
            ),
          PopupMenuButton<_MenuAction>(
            tooltip: context.l10n.rankingMenuTooltip,
            onSelected: _openMenu,
            itemBuilder: (context) => [
              PopupMenuItem(value: _MenuAction.settings, child: Text(context.l10n.rankingMenuSettings)),
              PopupMenuItem(value: _MenuAction.rules, child: Text(context.l10n.rankingMenuRules)),
              if (isAdmin) PopupMenuItem(value: _MenuAction.board, child: Text(context.l10n.boardTitle)),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          tabs: [
            Tab(text: context.l10n.rankingTabDogs),
            Tab(text: context.l10n.rankingTabBattle),
            Tab(text: context.l10n.rankingTabHall),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _buildLeaderboardTab(dog, mine),
          _BattleTab(
            month: _month,
            myBranchId: mine?.mainBranch?.scopeKey,
            onMonthChanged: (month) => setState(() => _month = month),
          ),
          const _HallOfFameTab(),
        ],
      ),
    );
  }

  Widget _buildLeaderboardTab(Dog? dog, MyRanking? mine) {
    final scheme = Theme.of(context).colorScheme;
    final branches = ref.watch(branchesProvider).valueOrNull ?? const <Branch>[];
    final participating = ref.watch(rankingConsentGrantedProvider);
    final scopeKey = _scopeKey(dog: dog, mine: mine, branches: branches);
    final query = scopeKey == null ? null : RankingQuery(month: _month, scope: _scope, scopeKey: scopeKey);
    final board = query == null ? const AsyncLoading<List<LeaderboardEntry>>() : ref.watch(leaderboardProvider(query));

    Future<void> refresh() async {
      if (query == null) return;
      ref.invalidate(leaderboardProvider(query));
      if (dog != null) ref.invalidate(myRankingProvider(DogMonth(dog.id, _month)));
      await ref.read(leaderboardProvider(query).future);
    }

    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _MonthBar(month: _month, onChanged: (month) => setState(() => _month = month)),
                const SizedBox(height: 10),
                SegmentedButton<RankingScope>(
                  showSelectedIcon: false,
                  segments: [
                    for (final scope in RankingScope.values) ButtonSegment(value: scope, label: Text(scope.label)),
                  ],
                  selected: {_scope},
                  onSelectionChanged: (selected) => setState(() => _scope = selected.first),
                ),
                if (_scope == RankingScope.branch && branches.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _ChipRow(
                    children: [
                      for (final branch in branches)
                        ChoiceChip(
                          label: Text(shortBranchName(branch.name)),
                          selected: scopeKey == branch.id,
                          onSelected: (_) => setState(() => _branchId = branch.id),
                        ),
                    ],
                  ),
                ],
                if (_scope == RankingScope.size) ...[
                  const SizedBox(height: 10),
                  _ChipRow(
                    children: [
                      for (final size in DogSize.values)
                        ChoiceChip(
                          label: Text(sizeScopeLabel(size)),
                          selected: scopeKey == size.dbValue,
                          onSelected: (_) => setState(() => _size = size),
                        ),
                    ],
                  ),
                ],
                if (participating == false && dog != null) ...[
                  const SizedBox(height: 14),
                  _JoinBanner(dog: dog, mine: mine),
                ],
                const SizedBox(height: 16),
                board.when(
                  skipLoadingOnRefresh: true,
                  loading: () => const LoadingView(),
                  error: (error, _) => ErrorView(
                    message: friendlyError(error),
                    onRetry: query == null ? null : () => ref.invalidate(leaderboardProvider(query)),
                  ),
                  data: (entries) {
                    if (entries.isEmpty) {
                      return AppCard(
                        child: EmptyState(
                          compact: true,
                          icon: Icons.leaderboard_rounded,
                          title: context.l10n.rankingEmptyTitle,
                          message: RankingMonth.isCurrent(_month)
                              ? context.l10n.rankingEmptyCurrent
                              : context.l10n.rankingEmptyPast,
                        ),
                      );
                    }
                    void open(LeaderboardEntry entry) => showRankingDogSheet(context, entry.dogId);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RankingPodium(entries: entries.take(3).toList(), onTap: open),
                        const SizedBox(height: 12),
                        for (final entry in entries.skip(3))
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: LeaderboardTile(entry: entry, onTap: () => open(entry)),
                          ),
                        const SizedBox(height: 4),
                        Text(
                          entries.first.participantCount > entries.length
                              ? context.l10n.rankingParticipantsTop(entries.first.participantCount, entries.length)
                              : context.l10n.rankingParticipants(entries.first.participantCount),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        if (dog != null && scopeKey != null)
          _MyRankBar(
            dog: dog,
            rank: mine?.rankFor(_scope, scopeKey),
            participating: participating ?? false,
          ),
      ],
    );
  }
}

class _ChipRow extends StatelessWidget {
  const _ChipRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final child in children) Padding(padding: const EdgeInsets.only(right: 8), child: child),
        ],
      ),
    );
  }
}

/// 랭킹 월 이동 (최근 12개월까지)
class _MonthBar extends StatelessWidget {
  const _MonthBar({required this.month, required this.onChanged});

  final DateTime month;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final current = RankingMonth.current();
    final isCurrent = RankingMonth.isCurrent(month);
    final earliest = DateTime(current.year, current.month - 12);
    return Row(
      children: [
        IconButton(
          tooltip: context.l10n.rankingPrevMonth,
          onPressed: month.isAfter(earliest) ? () => onChanged(RankingMonth.previous(month)) : null,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Column(
            children: [
              Text(Fmt.yearMonth(month), style: Theme.of(context).textTheme.titleMedium),
              Text(
                isCurrent ? context.l10n.rankingMonthInProgress : context.l10n.rankingMonthPast,
                style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: context.l10n.rankingNextMonth,
          onPressed: isCurrent ? null : () => onChanged(RankingMonth.next(month)),
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    );
  }
}

/// 랭킹에 참여하지 않은 보호자에게 참여를 권한다 ("참여하면 n위예요")
class _JoinBanner extends StatelessWidget {
  const _JoinBanner({required this.dog, required this.mine});

  final Dog dog;
  final MyRanking? mine;

  @override
  Widget build(BuildContext context) {
    final overall = mine?.overall;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 14),
      decoration: BoxDecoration(color: AppColors.honey, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          const Icon(Icons.emoji_events_rounded, color: AppColors.honeyInk, size: 30),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  overall == null
                      ? context.l10n.rankingJoinPrompt(dog.name)
                      : context.l10n.rankingJoinPromptRank(dog.name, overall.rank),
                  style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.charcoal),
                ),
                Text(
                  context.l10n.rankingJoinPublicInfo,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.honeyInk),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: () => showRankingSettingsSheet(context),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.charcoal,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
            ),
            child: Text(context.l10n.rankingJoinButton),
          ),
        ],
      ),
    );
  }
}

/// 화면 아래에 고정되는 내 반려견 순위
class _MyRankBar extends StatelessWidget {
  const _MyRankBar({required this.dog, required this.rank, required this.participating});

  final Dog dog;
  final ScopeRank? rank;
  final bool participating;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final rank = this.rank;
    final l = context.l10n;
    final pointsToNext = rank?.pointsToNext;
    final title = rank == null
        ? l.rankingMyBarNoScore(dog.name)
        : participating
            ? l.rankingMyBarRank(dog.name, rank.rank)
            : l.rankingMyBarRankIfJoined(dog.name, rank.rank);
    final caption = rank == null
        ? l.rankingMyBarNoPoints
        : pointsToNext == null
            ? l.rankingMyBarKeepFirst(Fmt.points(rank.points))
            : l.rankingMyBarPointsToNext(Fmt.points(rank.points), pointsToNext);

    return Material(
      color: scheme.surfaceContainerLowest,
      child: InkWell(
        onTap: () => showRankingDogSheet(context, dog.id),
        child: Container(
          decoration: BoxDecoration(border: Border(top: BorderSide(color: scheme.outlineVariant))),
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                if (rank != null) ...[RankMedal(rank: rank.rank, size: 30), const SizedBox(width: 10)],
                DogAvatar(dog: dog, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      Text(caption, maxLines: 1, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 지점 대항전: 지점별 이번 달 총 운동 거리
class _BattleTab extends ConsumerWidget {
  const _BattleTab({required this.month, required this.myBranchId, required this.onMonthChanged});

  final DateTime month;
  final String? myBranchId;
  final ValueChanged<DateTime> onMonthChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final battle = ref.watch(branchBattleProvider(month));

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(branchBattleProvider(month));
        await ref.read(branchBattleProvider(month).future);
      },
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _MonthBar(month: month, onChanged: onMonthChanged),
          const SizedBox(height: 6),
          Text(
            context.l10n.rankingBattleIntro,
            style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5),
          ),
          const SizedBox(height: 16),
          AsyncValueView<List<BranchBattleEntry>>(
            value: battle,
            onRetry: () => ref.invalidate(branchBattleProvider(month)),
            data: (entries) {
              final top = entries.isEmpty ? 0.0 : entries.first.distanceMeters;
              return Column(
                children: [
                  for (final entry in entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _BattleCard(entry: entry, topDistance: top, isMine: entry.branchId == myBranchId),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BattleCard extends StatelessWidget {
  const _BattleCard({required this.entry, required this.topDistance, required this.isMine});

  final BranchBattleEntry entry;
  final double topDistance;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ratio = topDistance <= 0 ? 0.0 : (entry.distanceMeters / topDistance).clamp(0.0, 1.0);
    return AppCard(
      padding: const EdgeInsets.all(16),
      borderColor: isMine ? scheme.primary : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              RankMedal(rank: entry.rank, size: 30),
              const SizedBox(width: 10),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(entry.branchName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                    ),
                    if (isMine) ...[
                      const SizedBox(width: 6),
                      StatusBadge(label: context.l10n.rankingBattleMine, tone: scheme.activeTone, dense: true),
                    ],
                  ],
                ),
              ),
              Text(Fmt.km(entry.distanceMeters), style: AppText.numeric(20)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: ratio,
            minHeight: 8,
            borderRadius: BorderRadius.circular(8),
            color: entry.rank == 1 ? AppColors.honeyDeep : scheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.rankingBattleStats(entry.sessionCount, entry.dogCount),
            style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

/// 명예의 전당: 마감한 달의 부문별 1~3위
class _HallOfFameTab extends ConsumerWidget {
  const _HallOfFameTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueView<List<HallOfFameEntry>>(
      value: ref.watch(hallOfFameProvider),
      onRetry: () => ref.invalidate(hallOfFameProvider),
      data: (entries) {
        if (entries.isEmpty) {
          return EmptyState(
            icon: Icons.emoji_events_outlined,
            title: context.l10n.rankingHallEmptyTitle,
            message: context.l10n.rankingHallEmptyMessage,
          );
        }
        final months = <DateTime, List<HallOfFameEntry>>{};
        for (final entry in entries) {
          months.putIfAbsent(entry.periodMonth, () => []).add(entry);
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(hallOfFameProvider);
            await ref.read(hallOfFameProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              for (final month in months.entries) ...[
                SectionHeader(title: context.l10n.rankingHallMonthTitle(Fmt.yearMonth(month.key))),
                _HallMonthCard(entries: month.value),
                const SizedBox(height: 24),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _HallMonthCard extends StatelessWidget {
  const _HallMonthCard({required this.entries});

  final List<HallOfFameEntry> entries;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final overall = entries.where((e) => e.scope == RankingScope.all).toList();
    final champions = entries.where((e) => e.scope != RankingScope.all && e.rank == 1).toList();

    void open(HallOfFameEntry entry) {
      if (!entry.isHidden && entry.dogId != null) showRankingDogSheet(context, entry.dogId!);
    }

    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (overall.isNotEmpty)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final entry in overall.take(3))
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => open(entry),
                      child: Column(
                        children: [
                          RankMedal(rank: entry.rank, size: 26),
                          const SizedBox(height: 6),
                          DogAvatar.path(path: entry.photoPath, size: 56, ringColor: AppColors.medal(entry.rank)),
                          const SizedBox(height: 6),
                          Text(
                            entry.dogName ?? context.l10n.rankingPrivateDog,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          if (entry.nickname != null)
                            Text('@${entry.nickname}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant)),
                          Text(Fmt.points(entry.points), style: AppText.numeric(13)),
                          const SizedBox(height: 6),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          if (champions.isNotEmpty) ...[
            const Divider(height: 24),
            Text(context.l10n.rankingHallChampions, style: TextStyle(fontWeight: FontWeight.w800, color: scheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            for (final entry in champions)
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                onTap: () => open(entry),
                leading: DogAvatar.path(path: entry.photoPath, size: 36),
                title: Text(entry.dogName ?? context.l10n.rankingPrivateDog, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(
                  entry.scope == RankingScope.branch ? shortBranchName(entry.scopeLabel) : entry.scopeLabel,
                ),
                trailing: Text(Fmt.points(entry.points), style: AppText.numeric(14)),
              ),
          ],
        ],
      ),
    );
  }
}
