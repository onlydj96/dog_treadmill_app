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
import '../../dogs/presentation/dog_switcher_sheet.dart';
import '../../dogs/presentation/widgets/dog_avatar.dart';
import '../../dogs/providers.dart';
import '../../exercise/data/exercise_session.dart';
import '../../exercise/presentation/widgets/exercise_widgets.dart';
import '../../exercise/providers.dart';
import '../../health/presentation/widgets/health_widgets.dart';
import '../../health/providers.dart';
import '../../notifications/data/notification_repository.dart';
import '../../profile/data/user_repository.dart';
import '../../support/data/support_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _refresh(WidgetRef ref) async {
    final dogId = ref.read(activeDogIdProvider);
    ref
      ..invalidate(currentUserProfileProvider)
      ..invalidate(dogsProvider)
      ..invalidate(nextBookingProvider)
      ..invalidate(noticesProvider);
    if (dogId != null) {
      ref
        ..invalidate(sessionsProvider(dogId))
        ..invalidate(reportsProvider(dogId));
    }
    await ref.read(dogsProvider.future);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDog = ref.watch(selectedDogProvider);
    final dog = selectedDog.valueOrNull;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _refresh(ref),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              const _HomeHeader(),
              const SizedBox(height: 12),
              _Greeting(dog: dog),
              const SizedBox(height: 18),
              selectedDog.when(
                skipLoadingOnRefresh: true,
                data: (dog) => dog == null ? const _NoDogCard() : _DogHeroCard(dog: dog),
                loading: () => const SizedBox(height: 180, child: LoadingView()),
                error: (error, _) => ErrorView(
                  message: friendlyError(error),
                  onRetry: () => ref.invalidate(dogsProvider),
                ),
              ),
              if (dog != null) ...[
                const _LiveSessionBanner(),
                const SizedBox(height: 20),
                const _QuickActions(),
                const SizedBox(height: 28),
                const _NextBookingSection(),
                const SizedBox(height: 28),
                _RecentExerciseSection(dogId: dog.id),
                const SizedBox(height: 28),
                _AnalysisSummarySection(dogId: dog.id),
              ],
              const SizedBox(height: 28),
              const _NoticesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeHeader extends ConsumerWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unread = ref.watch(unreadNotificationCountProvider);
    return Row(
      children: [
        const BrandWordmark(),
        const Spacer(),
        IconButton(
          tooltip: '알림',
          onPressed: () => context.push(AppRoutes.notifications),
          icon: Badge(
            isLabelVisible: unread > 0,
            label: Text(unread > 99 ? '99+' : '$unread'),
            backgroundColor: AppColors.vermilion,
            child: const Icon(Icons.notifications_none_rounded, size: 26),
          ),
        ),
      ],
    );
  }
}

class _Greeting extends ConsumerWidget {
  const _Greeting({required this.dog});

  final Dog? dog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final profile = ref.watch(currentUserProfileProvider).valueOrNull;
    final name = profile?.displayName ?? '보호자';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$name님, 안녕하세요', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 2),
        Text(
          dog == null ? '반려견을 등록하고 시작해 볼까요?' : '오늘도 ${josa(dog!.name, '와', '과')} 건강하게 걸어요',
          style: theme.textTheme.headlineSmall,
        ),
      ],
    );
  }
}

class _DogHeroCard extends ConsumerWidget {
  const _DogHeroCard({required this.dog});

  final Dog dog;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dogCount = ref.watch(dogsProvider).valueOrNull?.length ?? 0;
    final sessions = ref.watch(finishedSessionsProvider(dog.id)).valueOrNull ?? const [];
    final latestReport = ref.watch(completedReportsProvider(dog.id)).valueOrNull?.firstOrNull;
    final now = DateTime.now();
    final monthTotals = ExerciseTotals.of(
      sessions.where((s) => s.date.toLocal().year == now.year && s.date.toLocal().month == now.month),
    );
    final symmetry = latestReport?.gaitMetrics?.symmetryIndex;

    return Semantics(
      container: true,
      button: true,
      onTapHint: '${dog.name} 정보 보기',
      child: IntersectionBackdrop(
        child: InkWell(
          onTap: () => context.push(AppRoutes.dogDetail(dog.id)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DogAvatar(dog: dog, size: 64, ringColor: AppColors.peach),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dog.name,
                              style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 22)),
                          const SizedBox(height: 2),
                          Text(
                            dog.summary.isEmpty ? '프로필을 완성해 주세요' : dog.summary,
                            style: const TextStyle(color: AppColors.peach, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    if (dogCount > 1)
                      TextButton.icon(
                        onPressed: () => showDogSwitcherSheet(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          iconColor: Colors.white,
                          backgroundColor: Colors.white.withValues(alpha: 0.14),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          minimumSize: const Size(0, 36),
                        ),
                        icon: const Icon(Icons.swap_horiz_rounded, size: 18),
                        label: const Text('전환'),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(height: 1, color: Colors.white.withValues(alpha: 0.16)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: HeroNumber(label: '이번 달 운동', value: '${monthTotals.count}', unit: '회')),
                    Expanded(
                      child: HeroNumber(
                        label: '이번 달 거리',
                        value: (monthTotals.meters / 1000).toStringAsFixed(1),
                        unit: 'km',
                      ),
                    ),
                    Expanded(
                      child: HeroNumber(
                        label: '최근 좌우 대칭',
                        value: symmetry == null ? '-' : (symmetry * 100).toStringAsFixed(0),
                        unit: symmetry == null ? null : '%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NoDogCard extends StatelessWidget {
  const _NoDogCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntersectionBackdrop(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DogAvatar(dog: null, size: 56),
            const SizedBox(height: 16),
            Text('반려견을 등록해 주세요', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
            const SizedBox(height: 6),
            const Text(
              '건강 정보와 운동 제한 사항을 함께 등록하면\n현장 운영자가 안전하게 운동을 진행할 수 있어요.',
              style: TextStyle(color: AppColors.peach, height: 1.5),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: () => context.push(AppRoutes.dogNew),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.peach,
                foregroundColor: AppColors.burgundyDeep,
                minimumSize: const Size(0, 48),
              ),
              icon: const Icon(Icons.add_rounded),
              label: const Text('반려견 등록하기'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiveSessionBanner extends ConsumerWidget {
  const _LiveSessionBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(liveSessionProvider).valueOrNull;
    if (session == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Semantics(
        container: true,
        button: true,
        onTapHint: '실시간 운동 현황 보기',
        child: Material(
          color: AppColors.vermilion,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => context.go(AppRoutes.exercise),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  const PulsingDot(color: Colors.white),
                  const SizedBox(width: 10),
                  Text(
                    session.status.label,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(width: 10),
                  LiveTicker(
                    builder: (context, now) => Text(
                      Fmt.timer(session.elapsedSeconds(now)),
                      style: AppText.numeric(18, color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Fmt.speed(session.currentSpeed),
                    style: AppText.numeric(14, weight: FontWeight.w600, color: Colors.white.withValues(alpha: 0.9)),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: _ActionTile(
            label: '운동 예약',
            caption: '빈 시간 확인',
            icon: Icons.add_circle_rounded,
            background: AppColors.vermilion,
            foreground: Colors.white,
            onTap: () => context.push(AppRoutes.bookingNew),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: _ActionTile(
            label: 'AI 리포트',
            caption: '보행 분석',
            icon: Icons.auto_awesome_rounded,
            background: scheme.tertiaryContainer,
            foreground: scheme.onTertiaryContainer,
            onTap: () => context.go(AppRoutes.health),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: _ActionTile(
            label: '운동 기록',
            caption: '전체 이력',
            icon: Icons.insights_rounded,
            background: scheme.primaryContainer,
            foreground: scheme.onPrimaryContainer,
            onTap: () => context.push(AppRoutes.exerciseHistory),
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    required this.caption,
    required this.icon,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final String caption;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: foreground, size: 26),
                const SizedBox(height: 18),
                Text(label, style: TextStyle(color: foreground, fontWeight: FontWeight.w800, fontSize: 15)),
                Text(caption, style: TextStyle(color: foreground.withValues(alpha: 0.75), fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NextBookingSection extends ConsumerWidget {
  const _NextBookingSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = ref.watch(nextBookingProvider);
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: '다음 예약', actionLabel: '예약 내역', onAction: () => context.go(AppRoutes.booking)),
        next.when(
          skipLoadingOnRefresh: true,
          loading: () => const LoadingView(padding: EdgeInsets.all(16)),
          error: (error, _) =>
              ErrorView(message: friendlyError(error), onRetry: () => ref.invalidate(nextBookingProvider)),
          data: (booking) {
            if (booking == null) {
              return AppCard(
                child: Row(
                  children: [
                    Icon(Icons.event_busy_rounded, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 12),
                    const Expanded(child: Text('예정된 예약이 없어요.')),
                    TextButton(onPressed: () => context.push(AppRoutes.bookingNew), child: const Text('예약하기')),
                  ],
                ),
              );
            }
            return BookingCard(
              booking: booking,
              onTap: () => context.push(AppRoutes.bookingDetail(booking.id)),
            );
          },
        ),
      ],
    );
  }
}

class _RecentExerciseSection extends ConsumerWidget {
  const _RecentExerciseSection({required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(finishedSessionsProvider(dogId));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: '최근 운동', actionLabel: '전체 기록', onAction: () => context.push(AppRoutes.exerciseHistory)),
        sessions.when(
          skipLoadingOnRefresh: true,
          loading: () => const LoadingView(padding: EdgeInsets.all(16)),
          error: (error, _) =>
              ErrorView(message: friendlyError(error), onRetry: () => ref.invalidate(sessionsProvider(dogId))),
          data: (list) {
            final ExerciseSession? latest = list.firstOrNull;
            if (latest == null) {
              return const AppCard(child: Text('아직 운동 기록이 없어요. 첫 운동을 예약해 보세요!'));
            }
            return ExerciseRecordTile(
              session: latest,
              onReportTap: (reportId) => context.push(AppRoutes.report(reportId)),
            );
          },
        ),
      ],
    );
  }
}

class _AnalysisSummarySection extends ConsumerWidget {
  const _AnalysisSummarySection({required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final reports = ref.watch(reportsProvider(dogId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: 'AI 보행 분석', actionLabel: '건강 리포트', onAction: () => context.go(AppRoutes.health)),
        reports.when(
          skipLoadingOnRefresh: true,
          loading: () => const LoadingView(padding: EdgeInsets.all(16)),
          error: (error, _) =>
              ErrorView(message: friendlyError(error), onRetry: () => ref.invalidate(reportsProvider(dogId))),
          data: (list) {
            final pending = list.where((r) => r.status.isPending).firstOrNull;
            final latest = list.where((r) => r.isCompleted).firstOrNull;
            if (latest == null) {
              return AppCard(
                color: scheme.tertiaryContainer,
                borderColor: Colors.transparent,
                child: Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: scheme.onTertiaryContainer),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        pending != null ? '최근 운동 영상을 분석하고 있어요. 완료되면 알려 드릴게요.' : '운동을 마치면 AI 보행 분석 리포트가 여기에 표시돼요.',
                        style: TextStyle(color: scheme.onTertiaryContainer),
                      ),
                    ),
                  ],
                ),
              );
            }

            final gait = latest.gaitMetrics;
            final anomaly = latest.anomalyMetrics;
            return AppCard(
              color: scheme.tertiaryContainer,
              borderColor: Colors.transparent,
              onTap: () => context.push(AppRoutes.report(latest.id)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (anomaly != null) AnomalyLevelBadge(level: anomaly.level, dense: true),
                      const Spacer(),
                      Text(
                        Fmt.date(latest.exerciseDate),
                        style: TextStyle(color: scheme.onTertiaryContainer.withValues(alpha: 0.75), fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: StatValue(
                          label: '좌우 대칭성',
                          value: gait?.symmetryIndex == null ? '-' : (gait!.symmetryIndex! * 100).toStringAsFixed(0),
                          unit: gait?.symmetryIndex == null ? null : '%',
                          valueSize: 30,
                          color: scheme.onTertiaryContainer,
                          labelColor: scheme.onTertiaryContainer.withValues(alpha: 0.75),
                        ),
                      ),
                      Expanded(
                        child: StatValue(
                          label: '분당 걸음 수',
                          value: gait?.cadenceSpm?.toStringAsFixed(0) ?? '-',
                          unit: gait?.cadenceSpm == null ? null : '보',
                          valueSize: 30,
                          color: scheme.onTertiaryContainer,
                          labelColor: scheme.onTertiaryContainer.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                  if (latest.summary != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      latest.summary!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: scheme.onTertiaryContainer, height: 1.5),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _NoticesSection extends ConsumerWidget {
  const _NoticesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notices = ref.watch(noticesProvider).valueOrNull ?? const [];
    if (notices.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: '공지사항', actionLabel: '전체보기', onAction: () => context.push(AppRoutes.notices)),
        AppCard(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              for (final notice in notices.take(3))
                ListTile(
                  onTap: () => context.push(AppRoutes.notices),
                  dense: true,
                  leading: Icon(
                    notice.isPinned ? Icons.push_pin_rounded : Icons.campaign_outlined,
                    color: notice.isPinned ? AppColors.vermilion : scheme.onSurfaceVariant,
                    size: 20,
                  ),
                  title: Text(notice.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  trailing: Text(Fmt.monthDay(notice.publishedAt),
                      style: TextStyle(color: scheme.onSurfaceVariant, fontSize: 12.5)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
