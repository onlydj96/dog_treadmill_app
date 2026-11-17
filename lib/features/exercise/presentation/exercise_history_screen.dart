import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../dogs/providers.dart';
import '../data/exercise_session.dart';
import '../providers.dart';
import 'widgets/exercise_widgets.dart';
import '../../../l10n/l10n.dart';

/// 운동 기록 — 날짜별 기록, 누적 통계, 중단 사유, AI 리포트 연결 (문서 3.3)
class ExerciseHistoryScreen extends ConsumerWidget {
  const ExerciseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dog = ref.watch(selectedDogProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(dog == null ? context.l10n.exerciseHistoryTitle : context.l10n.exerciseHistoryTitleDog(dog.name))),
      body: dog == null
          ? EmptyState(
              icon: Icons.pets_rounded,
              title: context.l10n.exerciseNoDogTitle,
              message: context.l10n.exerciseNoDogHistoryMessage,
              actionLabel: context.l10n.exerciseRegisterDog,
              onAction: () => context.push(AppRoutes.dogNew),
            )
          : AsyncValueView<List<ExerciseSession>>(
              value: ref.watch(finishedSessionsProvider(dog.id)),
              onRetry: () => ref.invalidate(sessionsProvider(dog.id)),
              data: (sessions) => RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(sessionsProvider(dog.id));
                  await ref.read(sessionsProvider(dog.id).future);
                },
                child: sessions.isEmpty
                    ? EmptyState(
                        icon: Icons.insights_rounded,
                        title: context.l10n.exerciseNoRecordsTitle,
                        message: context.l10n.exerciseNoRecordsHistoryMessage,
                      )
                    : _HistoryList(sessions: sessions),
              ),
            ),
    );
  }
}

/// 단위가 없는 언어(영어의 '회')는 비워 둔다.
String? _unit(String unit) => unit.isEmpty ? null : unit;

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.sessions});

  final List<ExerciseSession> sessions;

  /// "2026년 11월 · 3회 · 120점" (점수 기록이 있는 달만 점수를 붙인다)
  static String _monthTitle(BuildContext context, String month, List<ExerciseSession> sessions) {
    final scored = sessions.map((s) => s.pointsSummary).nonNulls.toList();
    return [
      month,
      context.l10n.exerciseSessionCount(sessions.length),
      if (scored.isNotEmpty) Fmt.points(scored.fold<int>(0, (sum, p) => sum + p.total)),
    ].join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final totals = ExerciseTotals.of(sessions);
    final bestSpeed = sessions.map((s) => s.maxSpeed ?? 0).fold<double>(0, (max, value) => value > max ? value : max);

    // 월별 그룹 (최신순)
    final groups = <String, List<ExerciseSession>>{};
    for (final session in sessions) {
      groups.putIfAbsent(Fmt.yearMonth(session.date), () => []).add(session);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppColors.mintMist, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.exerciseTotalsTitle,
                style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.mintInk),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: StatValue(
                      label: context.l10n.exerciseStatTotalWorkouts,
                      value: '${totals.count}',
                      unit: _unit(context.l10n.exerciseUnitTimes),
                      color: AppColors.mintInk,
                      labelColor: AppColors.mintDeep,
                    ),
                  ),
                  Expanded(
                    child: StatValue(
                      label: context.l10n.exerciseStatTotalTime,
                      value: '${(totals.seconds / 60).round()}',
                      unit: context.l10n.exerciseUnitMinutes,
                      color: AppColors.mintInk,
                      labelColor: AppColors.mintDeep,
                    ),
                  ),
                  Expanded(
                    child: StatValue(
                      label: context.l10n.exerciseStatTotalDistance,
                      value: (totals.meters / 1000).toStringAsFixed(1),
                      unit: 'km',
                      color: AppColors.mintInk,
                      labelColor: AppColors.mintDeep,
                    ),
                  ),
                  Expanded(
                    child: StatValue(
                      label: context.l10n.exerciseStatBestSpeed,
                      value: bestSpeed == 0 ? '-' : bestSpeed.toStringAsFixed(1),
                      unit: bestSpeed == 0 ? null : 'km/h',
                      color: AppColors.mintInk,
                      labelColor: AppColors.mintDeep,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        for (final entry in groups.entries) ...[
          const SizedBox(height: 24),
          SectionHeader(title: _monthTitle(context, entry.key, entry.value)),
          for (final session in entry.value)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ExerciseRecordTile(
                session: session,
                onReportTap: (reportId) => context.push(AppRoutes.report(reportId)),
              ),
            ),
        ],
      ],
    );
  }
}
