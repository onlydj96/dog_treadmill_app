import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../consents/data/consent_repository.dart';
import '../../dogs/providers.dart';
import '../data/analysis_models.dart';
import '../providers.dart';
import 'widgets/health_widgets.dart';
import '../../../l10n/l10n.dart';

/// 건강 탭 — AI 보행 분석 요약과 변화 추이 (문서 3.4, 화면 10 HealthDashboardScreen)
class HealthDashboardScreen extends ConsumerWidget {
  const HealthDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dog = ref.watch(selectedDogProvider).valueOrNull;
    // 리포트와 함께 동의 상태를 미리 불러와, 리포트 없음 안내 문구가 뒤늦게 바뀌어 보이지 않게 한다.
    ref.listen(videoConsentGrantedProvider, (_, __) {});

    return Scaffold(
      appBar: AppBar(title: Text(dog == null ? context.l10n.healthTitle : context.l10n.healthTitleDog(dog.name))),
      body: dog == null
          ? EmptyState(
              icon: Icons.pets_rounded,
              title: context.l10n.exerciseNoDogTitle,
              message: context.l10n.healthNoDogMessage,
              actionLabel: context.l10n.exerciseRegisterDog,
              onAction: () => context.push(AppRoutes.dogNew),
            )
          : AsyncValueView<List<AnalysisReport>>(
              value: ref.watch(reportsProvider(dog.id)),
              onRetry: () => ref.invalidate(reportsProvider(dog.id)),
              data: (reports) => RefreshIndicator(
                onRefresh: () async {
                  ref
                    ..invalidate(reportsProvider(dog.id))
                    ..invalidate(activePlanProvider(dog.id))
                    ..invalidate(consentsProvider);
                  await ref.read(reportsProvider(dog.id).future);
                },
                child: _Dashboard(dogId: dog.id, reports: reports),
              ),
            ),
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.dogId, required this.reports});

  final String dogId;
  final List<AnalysisReport> reports;

  @override
  Widget build(BuildContext context) {
    final completed = reports.where((r) => r.isCompleted).toList();
    final pending = reports.where((r) => r.status.isPending).toList();
    final latest = completed.firstOrNull;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      children: [
        // 완료된 리포트가 없으면 아래 카드가 분석 중임을 알리므로 배너는 생략한다.
        if (pending.isNotEmpty && latest != null) ...[
          _PendingBanner(count: pending.length),
          const SizedBox(height: 16),
        ],
        if (latest == null)
          _NoReportCard(analyzing: pending.isNotEmpty)
        else ...[
          _LatestSummaryCard(report: latest),
          const SizedBox(height: 28),
          if (completed.length >= 2) ...[
            _TrendSection(reports: completed.take(10).toList().reversed.toList()),
            const SizedBox(height: 28),
          ],
          _JointHighlights(report: latest),
          const SizedBox(height: 28),
        ],
        _PlanSection(dogId: dogId),
        if (reports.isNotEmpty) ...[
          const SizedBox(height: 28),
          SectionHeader(title: context.l10n.healthReports),
          for (final report in reports)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _ReportTile(report: report),
            ),
        ],
        const SizedBox(height: 16),
        const AiDisclaimer(),
      ],
    );
  }
}

class _PendingBanner extends StatelessWidget {
  const _PendingBanner({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: scheme.calmTone.background, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2.2, color: scheme.calmTone.foreground),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              context.l10n.healthPendingBanner(count),
              style: TextStyle(color: scheme.calmTone.foreground, fontWeight: FontWeight.w600, fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// 완료된 리포트가 없을 때. 분석 진행 여부와 영상 촬영 동의 상태에 맞는 안내 하나만 보여준다.
class _NoReportCard extends ConsumerWidget {
  const _NoReportCard({required this.analyzing});

  /// 분석 중인 운동 영상이 있는지
  final bool analyzing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (analyzing) {
      return AppCard(
        child: EmptyState(
          compact: true,
          icon: Icons.auto_awesome_rounded,
          title: context.l10n.healthPreparingTitle,
          message: context.l10n.healthPreparingMessage,
        ),
      );
    }

    // 동의 상태를 아직 모르면(로딩·오류) 동의 여부와 무관한 안내만 보여준다.
    if (ref.watch(videoConsentGrantedProvider) == false) {
      return AppCard(
        child: EmptyState(
          compact: true,
          icon: Icons.videocam_outlined,
          title: context.l10n.healthConsentTitle,
          message: context.l10n.healthConsentMessage,
          actionLabel: context.l10n.healthConsentAction,
          onAction: () => context.push(AppRoutes.consents),
        ),
      );
    }

    return AppCard(
      child: EmptyState(
        compact: true,
        icon: Icons.auto_awesome_rounded,
        title: context.l10n.healthNoReportTitle,
        message: context.l10n.healthNoReportMessage,
      ),
    );
  }
}

class _LatestSummaryCard extends StatelessWidget {
  const _LatestSummaryCard({required this.report});

  final AnalysisReport report;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gait = report.gaitMetrics;
    final anomaly = report.anomalyMetrics;
    final onColor = scheme.onTertiaryContainer;

    return Semantics(
      container: true,
      button: true,
      child: Material(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: () => context.push(AppRoutes.report(report.id)),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: onColor, size: 20),
                    const SizedBox(width: 6),
                    Text(context.l10n.healthLatestAnalysis, style: TextStyle(color: onColor, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    Text(Fmt.date(report.exerciseDate), style: TextStyle(color: onColor.withValues(alpha: 0.75))),
                  ],
                ),
                const SizedBox(height: 18),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 좁은 화면·큰 글자에서는 「좌우 대칭성」이 단어 중간에서 끊기지 않고 숫자 아래 줄로 통째로 내려간다
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        spacing: 12,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                gait?.symmetryIndex == null ? '-' : (gait!.symmetryIndex! * 100).toStringAsFixed(0),
                                style: AppText.numeric(56, color: onColor, height: 1),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4, bottom: 8),
                                child: Text('%', style: AppText.numeric(22, color: onColor)),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(context.l10n.healthSymmetry, style: TextStyle(color: onColor, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    if (anomaly != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: AnomalyLevelBadge(level: anomaly.level),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: StatValue(
                        label: context.l10n.healthCadence,
                        value: gait?.cadenceSpm?.toStringAsFixed(0) ?? '-',
                        valueSize: 20,
                        color: onColor,
                        labelColor: onColor.withValues(alpha: 0.75),
                      ),
                    ),
                    Expanded(
                      child: StatValue(
                        label: context.l10n.healthRhythm,
                        value: gait?.rhythmScore == null ? '-' : (gait!.rhythmScore! * 100).toStringAsFixed(0),
                        unit: gait?.rhythmScore == null ? null : context.l10n.healthUnitPoints,
                        valueSize: 20,
                        color: onColor,
                        labelColor: onColor.withValues(alpha: 0.75),
                      ),
                    ),
                    Expanded(
                      child: StatValue(
                        label: context.l10n.healthConfidence,
                        value: anomaly?.confidence == null ? '-' : (anomaly!.confidence! * 100).toStringAsFixed(0),
                        unit: anomaly?.confidence == null ? null : '%',
                        valueSize: 20,
                        color: onColor,
                        labelColor: onColor.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
                if (report.summary != null) ...[
                  const SizedBox(height: 16),
                  Text(report.summary!, style: TextStyle(color: onColor, height: 1.55)),
                ],
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    context.l10n.healthViewReport,
                    style: TextStyle(color: onColor, fontWeight: FontWeight.w800, fontSize: 13),
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

enum _TrendMetric { symmetry, cadence, variability }

class _TrendSection extends StatefulWidget {
  const _TrendSection({required this.reports});

  /// 오래된 순
  final List<AnalysisReport> reports;

  @override
  State<_TrendSection> createState() => _TrendSectionState();
}

class _TrendSectionState extends State<_TrendSection> {
  _TrendMetric _metric = _TrendMetric.symmetry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final points = <TrendPoint>[];
    double? baseline;
    for (final report in widget.reports) {
      final gait = report.gaitMetrics;
      final value = switch (_metric) {
        _TrendMetric.symmetry => gait?.symmetryIndex == null ? null : gait!.symmetryIndex! * 100,
        _TrendMetric.cadence => gait?.cadenceSpm,
        _TrendMetric.variability => gait?.strideTimeCv == null ? null : gait!.strideTimeCv! * 100,
      };
      if (value != null) points.add(TrendPoint(label: Fmt.monthDay(report.exerciseDate), value: value));
    }
    final latestBaseline = widget.reports.last.gaitMetrics?.baseline;
    baseline = switch (_metric) {
      _TrendMetric.symmetry => latestBaseline?.symmetryIndex == null ? null : latestBaseline!.symmetryIndex! * 100,
      _TrendMetric.cadence => latestBaseline?.cadenceSpm,
      _TrendMetric.variability => latestBaseline?.strideTimeCv == null ? null : latestBaseline!.strideTimeCv! * 100,
    };

    final (description, formatter, color) = switch (_metric) {
      _TrendMetric.symmetry => (
          context.l10n.healthTrendSymmetryDesc,
          (double v) => '${v.toStringAsFixed(0)}%',
          AppColors.mintDeep,
        ),
      _TrendMetric.cadence => (
          context.l10n.healthTrendCadenceDesc,
          (double v) => v.toStringAsFixed(0),
          AppColors.tealDeep,
        ),
      _TrendMetric.variability => (
          context.l10n.healthTrendVariabilityDesc,
          (double v) => '${v.toStringAsFixed(1)}%',
          AppColors.honeyDeep,
        ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.healthTrendTitle),
        AppCard(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<_TrendMetric>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(value: _TrendMetric.symmetry, label: Text(context.l10n.healthTrendSegSymmetry)),
                  ButtonSegment(value: _TrendMetric.cadence, label: Text(context.l10n.healthTrendSegCadence)),
                  ButtonSegment(value: _TrendMetric.variability, label: Text(context.l10n.healthTrendSegVariability)),
                ],
                selected: {_metric},
                onSelectionChanged: (value) => setState(() => _metric = value.first),
              ),
              const SizedBox(height: 12),
              Text(description, style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant, height: 1.45)),
              const SizedBox(height: 16),
              if (points.length >= 2)
                TrendChart(points: points, baseline: baseline, valueFormatter: formatter, color: color)
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: Text(context.l10n.healthTrendNeedMore)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 최신 리포트에서 기준선 대비 가동 범위 변화가 큰 관절
class _JointHighlights extends StatelessWidget {
  const _JointHighlights({required this.report});

  final AnalysisReport report;

  @override
  Widget build(BuildContext context) {
    final joints = (report.jointMetrics?.joints ?? const <JointMetric>[])
        .where((j) => j.romChangeRatio != null)
        .toList()
      ..sort((a, b) => b.romChangeRatio!.abs().compareTo(a.romChangeRatio!.abs()));
    if (joints.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(
          title: context.l10n.healthJointRomTitle,
          actionLabel: context.l10n.healthAllJoints,
          onAction: () => context.push(AppRoutes.report(report.id)),
        ),
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            children: [
              for (final joint in joints.take(4))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(child: Text(joint.label, style: const TextStyle(fontWeight: FontWeight.w600))),
                      Text(
                        '${joint.romDeg!.toStringAsFixed(0)}°',
                        style: AppText.numeric(16, color: scheme.onSurface),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 78,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: DeltaText(
                            delta: joint.romChangeRatio! * 100,
                            neutralThreshold: 2,
                            format: (v) => '${v.toStringAsFixed(0)}%',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlanSection extends ConsumerWidget {
  const _PlanSection({required this.dogId});

  final String dogId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(activePlanProvider(dogId)).valueOrNull;
    if (plan == null) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.healthPlanTitle),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.assignment_turned_in_rounded, color: scheme.secondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(plan.programName, style: Theme.of(context).textTheme.titleMedium)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (plan.targetDurationSeconds != null)
                    Expanded(
                      child: StatValue(
                        label: context.l10n.healthPlanTargetTime,
                        value: '${(plan.targetDurationSeconds! / 60).round()}',
                        unit: context.l10n.exerciseUnitMinutes,
                        valueSize: 20,
                      ),
                    ),
                  if (plan.targetSpeed != null)
                    Expanded(
                      child: StatValue(
                        label: context.l10n.healthPlanTargetSpeed,
                        value: plan.targetSpeed!.toStringAsFixed(1),
                        unit: 'km/h',
                        valueSize: 20,
                      ),
                    ),
                ],
              ),
              if (plan.restrictions.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final restriction in plan.restrictions)
                      StatusBadge(label: restriction, tone: scheme.cautionTone, icon: Icons.block_rounded, dense: true),
                  ],
                ),
              ],
              if (plan.notes != null) ...[
                const SizedBox(height: 12),
                Text(plan.notes!, style: TextStyle(color: scheme.onSurfaceVariant, height: 1.5)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.report});

  final AnalysisReport report;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final symmetry = report.gaitMetrics?.symmetryIndex;
    return AppCard(
      padding: const EdgeInsets.all(16),
      onTap: () => context.push(AppRoutes.report(report.id)),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: scheme.tertiaryContainer, borderRadius: BorderRadius.circular(14)),
            child: Icon(Icons.auto_awesome_rounded, color: scheme.onTertiaryContainer),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${Fmt.date(report.exerciseDate)} ${Fmt.time(report.exerciseDate)}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (report.isCompleted && report.anomalyMetrics != null)
                      AnomalyLevelBadge(level: report.anomalyMetrics!.level, dense: true)
                    else
                      AnalysisStatusBadge(status: report.status, dense: true),
                  ],
                ),
              ],
            ),
          ),
          if (symmetry != null)
            Text('${(symmetry * 100).toStringAsFixed(0)}%', style: AppText.numeric(18, color: scheme.onSurface)),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}
