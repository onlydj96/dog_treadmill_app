import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/error_messages.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/brand_mark.dart';
import '../../../core/widgets/common.dart';
import '../../booking/presentation/widgets/booking_widgets.dart';
import '../../booking/providers.dart';
import '../../dogs/data/dog.dart';
import '../../dogs/providers.dart';
import '../../health/providers.dart';
import '../data/exercise_session.dart';
import '../providers.dart';
import 'widgets/exercise_widgets.dart';

/// 운동 탭 — 현재 운동 진행 현황 + 최근 기록 (문서 3.3)
class ExerciseScreen extends ConsumerWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dog = ref.watch(selectedDogProvider).valueOrNull;

    // 진행 중이던 운동이 끝나면 기록과 리포트 목록을 갱신한다.
    ref.listen(latestSessionProvider, (previous, next) {
      final before = previous?.valueOrNull;
      final after = next.valueOrNull;
      if (before != null &&
          after != null &&
          before.id == after.id &&
          before.status.isActive &&
          !after.status.isActive) {
        ref
          ..invalidate(sessionsProvider(after.dogId))
          ..invalidate(reportsProvider(after.dogId))
          ..invalidate(nextBookingProvider);
        context.showMessage(after.status == SessionStatus.completed ? '운동을 완료했어요!' : '운동이 중단되었어요.');
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(dog == null ? '운동' : '${dog.name}의 운동')),
      body: dog == null
          ? EmptyState(
              icon: Icons.pets_rounded,
              title: '등록된 반려견이 없어요',
              message: '반려견을 등록하면 운동 현황과 기록을 볼 수 있어요.',
              actionLabel: '반려견 등록',
              onAction: () => context.push(AppRoutes.dogNew),
            )
          : RefreshIndicator(
              onRefresh: () async {
                ref
                  ..invalidate(latestSessionProvider)
                  ..invalidate(sessionsProvider(dog.id))
                  ..invalidate(nextBookingProvider);
                await ref.read(sessionsProvider(dog.id).future);
              },
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  _LiveSection(dog: dog),
                  const SizedBox(height: 28),
                  _MonthlySummary(dogId: dog.id),
                  const SizedBox(height: 28),
                  _RecentRecords(dogId: dog.id),
                ],
              ),
            ),
    );
  }
}

class _LiveSection extends ConsumerWidget {
  const _LiveSection({required this.dog});

  final Dog dog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final live = ref.watch(liveSessionProvider);
    return live.when(
      skipLoadingOnRefresh: true,
      loading: () => const SizedBox(height: 220, child: LoadingView()),
      error: (error, _) => ErrorView(
        message: friendlyError(error),
        onRetry: () => ref.invalidate(latestSessionProvider),
      ),
      data: (session) => session == null ? const _NoLiveSession() : _LiveSessionCard(session: session, dog: dog),
    );
  }
}

class _LiveSessionCard extends ConsumerWidget {
  const _LiveSessionCard({required this.session, required this.dog});

  final ExerciseSession session;
  final Dog dog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treadmillId = session.treadmillId;
    final treadmillName =
        treadmillId == null ? null : ref.watch(treadmillProvider(treadmillId)).valueOrNull?.deviceName;

    return IntersectionBackdrop(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
        child: LiveTicker(
          builder: (context, now) {
            final elapsed = session.elapsedSeconds(now);
            final target = session.targetDurationSeconds;
            return Column(
              children: [
                Row(
                  children: [
                    if (session.status == SessionStatus.running) ...[
                      const PulsingDot(color: AppColors.mint),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      session.status.label,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const Spacer(),
                    Text(
                      '실시간',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12.5),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ProgressRing(
                  progress: session.progress(now),
                  size: 208,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('경과 시간', style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 13)),
                      const SizedBox(height: 4),
                      Text(Fmt.timer(elapsed), style: AppText.numeric(44, color: Colors.white)),
                      if (target != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '목표 ${Fmt.durationMinutes(target)}',
                          style: const TextStyle(color: AppColors.mintLight, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: HeroNumber(label: '현재 속도', value: session.currentSpeed.toStringAsFixed(1), unit: 'km/h'),
                    ),
                    Expanded(
                      child: HeroNumber(
                        label: '이동 거리',
                        value: session.distanceMeters >= 1000
                            ? (session.distanceMeters / 1000).toStringAsFixed(2)
                            : session.distanceMeters.round().toString(),
                        unit: session.distanceMeters >= 1000 ? 'km' : 'm',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: HeroNumber(
                        label: '시작 시간',
                        value: session.startedAt == null ? '-' : Fmt.time(session.startedAt!),
                      ),
                    ),
                    Expanded(child: HeroNumber(label: '트레드밀', value: treadmillName ?? '-')),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.shield_outlined, color: AppColors.mintLight, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '트레드밀 구동과 비상정지는 현장 운영자가 직접 관리해요.',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 12.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// 진행 중인 운동이 없을 때 — 건강 탭의 '리포트 없음' 카드와 같은 가운데 정렬 빈 상태.
/// 다음 예약이 있으면 홈과 같은 '다음 예약' 섹션으로 따로 보여준다.
class _NoLiveSession extends ConsumerWidget {
  const _NoLiveSession();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = ref.watch(nextBookingProvider).valueOrNull;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: EmptyState(
            compact: true,
            icon: Icons.directions_run_rounded,
            title: '진행 중인 운동이 없어요',
            message: '운동이 시작되면 이곳에서 실시간으로 확인할 수 있어요.',
            actionLabel: next == null ? '운동 예약하기' : null,
            onAction: next == null ? () => context.push(AppRoutes.bookingNew) : null,
          ),
        ),
        if (next != null) ...[
          const SizedBox(height: 28),
          SectionHeader(title: '다음 예약', actionLabel: '예약 내역', onAction: () => context.go(AppRoutes.booking)),
          BookingCard(booking: next, onTap: () => context.push(AppRoutes.bookingDetail(next.id))),
        ],
      ],
    );
  }
}

class _MonthlySummary extends ConsumerWidget {
  const _MonthlySummary({required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(finishedSessionsProvider(dogId)).valueOrNull ?? const [];
    final now = DateTime.now();
    final totals = ExerciseTotals.of(
      sessions.where((s) => s.date.toLocal().year == now.year && s.date.toLocal().month == now.month),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: '${now.month}월 운동 요약'),
        AppCard(
          child: Row(
            children: [
              Expanded(child: StatValue(label: '운동 횟수', value: '${totals.count}', unit: '회')),
              Expanded(child: StatValue(label: '총 운동 시간', value: '${(totals.seconds / 60).round()}', unit: '분')),
              Expanded(
                child: StatValue(label: '총 거리', value: (totals.meters / 1000).toStringAsFixed(1), unit: 'km'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RecentRecords extends ConsumerWidget {
  const _RecentRecords({required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(finishedSessionsProvider(dogId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: '최근 운동 기록',
          actionLabel: '전체 기록',
          onAction: () => context.push(AppRoutes.exerciseHistory),
        ),
        sessions.when(
          skipLoadingOnRefresh: true,
          loading: () => const LoadingView(),
          error: (error, _) => ErrorView(
            message: friendlyError(error),
            onRetry: () => ref.invalidate(sessionsProvider(dogId)),
          ),
          data: (list) {
            if (list.isEmpty) {
              return const AppCard(
                child: EmptyState(
                  compact: true,
                  icon: Icons.insights_rounded,
                  title: '아직 운동 기록이 없어요',
                  message: '운동을 마치면 시간, 거리, 속도가 기록돼요.',
                ),
              );
            }
            return Column(
              children: [
                for (final session in list.take(5))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ExerciseRecordTile(
                      session: session,
                      onReportTap: (reportId) => context.push(AppRoutes.report(reportId)),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
