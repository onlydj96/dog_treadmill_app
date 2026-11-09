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

/// 운동 기록 — 날짜별 기록, 누적 통계, 중단 사유, AI 리포트 연결 (문서 3.3)
class ExerciseHistoryScreen extends ConsumerWidget {
  const ExerciseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dog = ref.watch(selectedDogProvider).valueOrNull;
    return Scaffold(
      appBar: AppBar(title: Text(dog == null ? '운동 기록' : '${dog.name}의 운동 기록')),
      body: dog == null
          ? const EmptyState(icon: Icons.pets_rounded, title: '등록된 반려견이 없어요')
          : AsyncValueView<List<ExerciseSession>>(
              value: ref.watch(finishedSessionsProvider(dog.id)),
              onRetry: () => ref.invalidate(sessionsProvider(dog.id)),
              data: (sessions) => RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(sessionsProvider(dog.id));
                  await ref.read(sessionsProvider(dog.id).future);
                },
                child: sessions.isEmpty
                    ? ListView(
                        children: const [
                          EmptyState(
                            icon: Icons.insights_rounded,
                            title: '아직 운동 기록이 없어요',
                            message: '운동을 마치면 날짜별 기록이 쌓여요.',
                          ),
                        ],
                      )
                    : _HistoryList(sessions: sessions),
              ),
            ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.sessions});

  final List<ExerciseSession> sessions;

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
          decoration: BoxDecoration(color: AppColors.peach, borderRadius: BorderRadius.circular(24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '누적 운동 기록',
                style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.burgundyDeep),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: StatValue(
                      label: '총 운동',
                      value: '${totals.count}',
                      unit: '회',
                      color: AppColors.burgundyDeep,
                      labelColor: AppColors.burgundy,
                    ),
                  ),
                  Expanded(
                    child: StatValue(
                      label: '총 시간',
                      value: '${(totals.seconds / 60).round()}',
                      unit: '분',
                      color: AppColors.burgundyDeep,
                      labelColor: AppColors.burgundy,
                    ),
                  ),
                  Expanded(
                    child: StatValue(
                      label: '총 거리',
                      value: (totals.meters / 1000).toStringAsFixed(1),
                      unit: 'km',
                      color: AppColors.burgundyDeep,
                      labelColor: AppColors.burgundy,
                    ),
                  ),
                  Expanded(
                    child: StatValue(
                      label: '최고 속도',
                      value: bestSpeed == 0 ? '-' : bestSpeed.toStringAsFixed(1),
                      unit: bestSpeed == 0 ? null : 'km/h',
                      color: AppColors.burgundyDeep,
                      labelColor: AppColors.burgundy,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        for (final entry in groups.entries) ...[
          const SizedBox(height: 24),
          SectionHeader(title: '${entry.key} · ${entry.value.length}회'),
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
