import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/formatters.dart';
import '../../../l10n/l10n.dart';
import '../../../core/widgets/async_value_view.dart';
import '../../../core/widgets/common.dart';
import '../../dogs/providers.dart';
import '../data/analysis_models.dart';
import '../data/dog_keypoints.dart';
import '../providers.dart';
import 'widgets/health_widgets.dart';

/// AI 분석 리포트 (문서 3.4-E, 화면 9 AnalysisReportScreen)
class AnalysisReportScreen extends ConsumerWidget {
  const AnalysisReportScreen({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.analysisReportTitle)),
      body: AsyncValueView<AnalysisReport>(
        value: ref.watch(reportDetailProvider(reportId)),
        onRetry: () => ref.invalidate(reportDetailProvider(reportId)),
        data: (report) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(reportDetailProvider(reportId));
            await ref.read(reportDetailProvider(reportId).future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
            children: [
              _ReportHeader(report: report),
              const SizedBox(height: 16),
              if (!report.isCompleted)
                _PendingState(report: report)
              else ...[
                if (report.summary != null) ...[
                  _SummaryCard(summary: report.summary!),
                  const SizedBox(height: 24),
                ],
                if (report.anomalyMetrics != null) ...[
                  _AnomalySection(anomaly: report.anomalyMetrics!),
                  const SizedBox(height: 24),
                ],
                if (report.gaitMetrics != null) ...[
                  _GaitSection(gait: report.gaitMetrics!),
                  const SizedBox(height: 24),
                ],
                if (report.jointMetrics != null) ...[
                  _JointSection(joints: report.jointMetrics!, anomaly: report.anomalyMetrics),
                  const SizedBox(height: 24),
                ],
                _ComparisonSection(report: report),
                _VideoSection(report: report),
                if (report.careNotes.isNotEmpty) ...[
                  _CareNotes(notes: report.careNotes),
                  const SizedBox(height: 24),
                ],
              ],
              const AiDisclaimer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportHeader extends ConsumerWidget {
  const _ReportHeader({required this.report});

  final AnalysisReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final dogs = ref.watch(dogsProvider).valueOrNull ?? const [];
    final dog = dogs.where((d) => d.id == report.dogId).firstOrNull;
    final session = report.session;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // model_version은 AI 서버 내부 기록용이라 보호자 화면에는 보여 주지 않는다 (docs/app-interface.md)
          Align(
            alignment: Alignment.centerLeft,
            child: AnalysisStatusBadge(status: report.status, dense: true),
          ),
          const SizedBox(height: 12),
          Text(
            '${Fmt.dateFull(report.exerciseDate)} ${Fmt.time(report.exerciseDate)}',
            style: theme.textTheme.titleMedium,
          ),
          if (dog != null) ...[
            const SizedBox(height: 4),
            Text('${dog.name} · ${dog.summary}', style: TextStyle(color: scheme.onSurfaceVariant)),
          ],
          if (session != null) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: StatValue(label: context.l10n.analysisStatDuration, value: Fmt.timer(session.durationSeconds), valueSize: 18)),
                Expanded(
                  child: StatValue(
                    label: context.l10n.analysisStatDistance,
                    value: (session.distanceMeters / 1000).toStringAsFixed(2),
                    unit: 'km',
                    valueSize: 18,
                  ),
                ),
                Expanded(
                  child: StatValue(
                    label: context.l10n.analysisStatAvgSpeed,
                    value: session.averageSpeed?.toStringAsFixed(1) ?? '-',
                    unit: 'km/h',
                    valueSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _PendingState extends StatelessWidget {
  const _PendingState({required this.report});

  final AnalysisReport report;

  @override
  Widget build(BuildContext context) {
    final failed = report.status == AnalysisStatus.failed;
    return AppCard(
      child: EmptyState(
        compact: true,
        icon: failed ? Icons.error_outline_rounded : Icons.auto_awesome_rounded,
        title: failed ? context.l10n.analysisPendingFailedTitle : context.l10n.analysisPendingTitle,
        message: failed
            ? context.l10n.analysisPendingFailedMessage
            : context.l10n.analysisPendingMessage,
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: scheme.tertiaryContainer, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 18, color: scheme.onTertiaryContainer),
              const SizedBox(width: 6),
              Text(context.l10n.analysisSummaryTitle, style: TextStyle(fontWeight: FontWeight.w800, color: scheme.onTertiaryContainer)),
            ],
          ),
          const SizedBox(height: 10),
          Text(summary, style: TextStyle(color: scheme.onTertiaryContainer, height: 1.6, fontSize: 15)),
        ],
      ),
    );
  }
}

class _AnomalySection extends StatelessWidget {
  const _AnomalySection({required this.anomaly});

  final AnomalyMetrics anomaly;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final score = anomaly.anomalyScore;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.analysisAnomalySection),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  AnomalyLevelBadge(level: anomaly.level),
                  const Spacer(),
                  if (anomaly.confidence != null)
                    Text(
                      context.l10n.analysisConfidenceValue((anomaly.confidence! * 100).toStringAsFixed(0)),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant),
                    ),
                ],
              ),
              if (score != null) ...[
                const SizedBox(height: 16),
                Text(context.l10n.analysisPatternDiffCaption, style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: score.clamp(0.0, 1.0),
                    minHeight: 10,
                    color: switch (anomaly.level) {
                      AnomalyLevel.normal => AppColors.tealDeep,
                      AnomalyLevel.caution => AppColors.honeyDeep,
                      AnomalyLevel.warning => AppColors.coral,
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(context.l10n.analysisScaleSimilar, style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant)),
                    const Spacer(),
                    Text(context.l10n.analysisScaleDifferent, style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant)),
                  ],
                ),
              ],
              if (anomaly.findings.isNotEmpty) ...[
                const SizedBox(height: 16),
                for (final finding in anomaly.findings)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Icon(
                            finding.severity == AnomalyLevel.warning
                                ? Icons.warning_amber_rounded
                                : Icons.visibility_rounded,
                            size: 18,
                            color: finding.severity == AnomalyLevel.warning ? AppColors.coral : AppColors.honeyDeep,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                if (finding.label != null)
                                  TextSpan(
                                    text: '${finding.label}  ',
                                    style: const TextStyle(fontWeight: FontWeight.w800),
                                  ),
                                TextSpan(text: finding.description),
                              ],
                            ),
                            style: const TextStyle(height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
              ] else ...[
                const SizedBox(height: 12),
                Text(context.l10n.analysisNoAnomaly),
              ],
              if (anomaly.notes.isNotEmpty) ...[
                const Divider(height: 24),
                for (final note in anomaly.notes)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('· $note', style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant, height: 1.5)),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _GaitSection extends StatelessWidget {
  const _GaitSection({required this.gait});

  final GaitMetrics gait;

  @override
  Widget build(BuildContext context) {
    final baseline = gait.baseline;

    Widget? baselineDelta(
      double? value,
      double? base, {
      bool higherIsBetter = true,
      bool neutral = false,
      double scale = 1,
      String suffix = '',
      bool stepsSuffix = false,
    }) {
      if (value == null || base == null) return null;
      return DeltaText(
        delta: (value - base) * scale,
        higherIsBetter: higherIsBetter,
        neutral: neutral,
        neutralThreshold: 0.5,
        format: (v) => context.l10n.analysisVsBaseline(
          stepsSuffix ? context.l10n.analysisStepsCount(v.round()) : '${v.toStringAsFixed(scale == 1 ? 0 : 1)}$suffix',
        ),
        fontSize: 11.5,
      );
    }

    final tiles = <Widget>[
      MetricTile(
        label: context.l10n.healthSymmetry,
        value: gait.symmetryIndex == null ? '-' : (gait.symmetryIndex! * 100).toStringAsFixed(0),
        unit: '%',
        delta: baselineDelta(gait.symmetryIndex, baseline?.symmetryIndex, scale: 100, suffix: '%p'),
      ),
      MetricTile(
        label: context.l10n.healthCadence,
        value: gait.cadenceSpm?.toStringAsFixed(0) ?? '-',
        unit: context.l10n.homeUnitSteps,
        delta: baselineDelta(gait.cadenceSpm, baseline?.cadenceSpm, neutral: true, stepsSuffix: true),
      ),
      MetricTile(
        label: context.l10n.analysisStrideTime,
        value: gait.strideTimeS?.toStringAsFixed(2) ?? '-',
        unit: context.l10n.analysisUnitSeconds,
      ),
      MetricTile(
        label: context.l10n.analysisGaitVariability,
        value: gait.strideTimeCv == null ? '-' : (gait.strideTimeCv! * 100).toStringAsFixed(1),
        unit: '%',
        delta:
            baselineDelta(gait.strideTimeCv, baseline?.strideTimeCv, higherIsBetter: false, scale: 100, suffix: '%p'),
      ),
      MetricTile(
        label: context.l10n.analysisFrontSymmetry,
        value: gait.frontSymmetry == null ? '-' : (gait.frontSymmetry! * 100).toStringAsFixed(0),
        unit: '%',
      ),
      MetricTile(
        label: context.l10n.analysisHindSymmetry,
        value: gait.hindSymmetry == null ? '-' : (gait.hindSymmetry! * 100).toStringAsFixed(0),
        unit: '%',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.analysisGaitSection),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = (constraints.maxWidth - 10) / 2;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [for (final tile in tiles) SizedBox(width: width, child: tile)],
            );
          },
        ),
        if (gait.rhythmScore != null) ...[
          const SizedBox(height: 10),
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(child: Text(context.l10n.analysisRhythmScore, style: const TextStyle(fontWeight: FontWeight.w700))),
                Text(
                  (gait.rhythmScore! * 100).toStringAsFixed(0),
                  style: AppText.numeric(22, color: Theme.of(context).colorScheme.onSurface),
                ),
                const Text(' / 100'),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _JointSection extends StatelessWidget {
  const _JointSection({required this.joints, this.anomaly});

  final JointMetrics joints;
  final AnomalyMetrics? anomaly;

  /// 소견이 있는 관절을 소견 순서대로 모은다. 한 관절에 소견이 여럿이면 가장 높은 수준을 쓴다.
  Map<String, AnomalyLevel> get _markers {
    final markers = <String, AnomalyLevel>{};
    for (final finding in anomaly?.findings ?? const <AnomalyFinding>[]) {
      final key = finding.jointKey;
      if (key == null || finding.severity == AnomalyLevel.normal || DogKeypoint.fromKey(key) == null) continue;
      final current = markers[key];
      if (current == null || finding.severity.index > current.index) markers[key] = finding.severity;
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final markers = _markers;
    final markerNumbers = {for (final (index, key) in markers.keys.indexed) key: index + 1};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.analysisJointSection(joints.keypointCount ?? DogKeypoint.values.length)),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SkeletonDiagram(markers: markers),
              const SizedBox(height: 12),
              Wrap(
                spacing: 16,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: [
                  _Legend(label: context.l10n.analysisLegendNear),
                  _Legend(label: context.l10n.analysisLegendFar, faded: true),
                ],
              ),
              if (markers.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      for (final MapEntry(:key, :value) in markers.entries)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              JointMarkerBadge(number: markerNumbers[key]!, level: value),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  DogKeypoint.fromKey(key)!.label,
                                  style: const TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              AnomalyLevelBadge(level: value, dense: true),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
              if (joints.joints.isNotEmpty) ...[
                const Divider(height: 28),
                Row(
                  children: [
                    Expanded(child: Text(context.l10n.analysisColJoint, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant))),
                    SizedBox(
                      width: 64,
                      child: Text(context.l10n.analysisColRom,
                          textAlign: TextAlign.end, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                    ),
                    SizedBox(
                      width: 84,
                      child: Text(context.l10n.analysisColVsBaseline,
                          textAlign: TextAlign.end, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                for (final joint in joints.joints)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        if (markerNumbers[joint.key] case final number?) ...[
                          JointMarkerBadge(number: number, level: markers[joint.key]!, size: 18),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(joint.label, style: const TextStyle(fontWeight: FontWeight.w600)),
                              if (joint.minAngleDeg != null && joint.maxAngleDeg != null)
                                Text(
                                  context.l10n.analysisAngleRange(joint.minAngleDeg!.toStringAsFixed(0), joint.maxAngleDeg!.toStringAsFixed(0)),
                                  style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 64,
                          child: Text(
                            joint.romDeg == null ? '-' : '${joint.romDeg!.toStringAsFixed(0)}°',
                            textAlign: TextAlign.end,
                            style: AppText.numeric(16, color: scheme.onSurface),
                          ),
                        ),
                        SizedBox(
                          width: 84,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: joint.romChangeRatio == null
                                ? Text('-', style: TextStyle(color: scheme.onSurfaceVariant))
                                : DeltaText(
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
            ],
          ),
        ),
      ],
    );
  }
}

/// 도식의 관절 점 모양 그대로 보여 주는 범례. [faded]는 카메라 반대편 다리.
class _Legend extends StatelessWidget {
  const _Legend({required this.label, this.faded = false});

  final String label;
  final bool faded;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dot = faded
        ? Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: AppColors.teal.withValues(alpha: 0.6), shape: BoxShape.circle),
          )
        : Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
              color: AppColors.teal,
              shape: BoxShape.circle,
              border: Border.all(color: scheme.brightness == Brightness.dark ? scheme.surfaceContainerLow : Colors.white, width: 2),
              boxShadow: [BoxShadow(color: scheme.outlineVariant, spreadRadius: 0.5)],
            ),
          );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 12, child: Center(child: dot)),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
      ],
    );
  }
}

/// 이전 운동 대비 변화
class _ComparisonSection extends ConsumerWidget {
  const _ComparisonSection({required this.report});

  final AnalysisReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final previous = ref.watch(previousReportProvider((dogId: report.dogId, before: report.createdAt))).valueOrNull;
    if (previous == null) return const SizedBox.shrink();

    final now = report.gaitMetrics;
    final before = previous.gaitMetrics;
    String percent(double v) => '${(v * 100).toStringAsFixed(0)}%';
    String percentPoint(double v) => '${(v * 100).toStringAsFixed(1)}%p';
    final rows = <_ComparisonRow>[
      _ComparisonRow(context.l10n.healthSymmetry, now?.symmetryIndex, before?.symmetryIndex,
          higherIsBetter: true, value: percent, delta: percentPoint, threshold: 0.005),
      _ComparisonRow(context.l10n.healthCadence, now?.cadenceSpm, before?.cadenceSpm,
          value: (v) => v.toStringAsFixed(0), delta: (v) => context.l10n.analysisStepsCount(v.round()), threshold: 0.5),
      _ComparisonRow(context.l10n.analysisGaitVariability, now?.strideTimeCv, before?.strideTimeCv,
          higherIsBetter: false,
          value: (v) => '${(v * 100).toStringAsFixed(1)}%',
          delta: percentPoint,
          threshold: 0.0005),
      _ComparisonRow(context.l10n.analysisPatternDiff, report.anomalyMetrics?.anomalyScore, previous.anomalyMetrics?.anomalyScore,
          higherIsBetter: false,
          value: (v) => (v * 100).toStringAsFixed(0),
          delta: (v) => (v * 100).toStringAsFixed(0),
          threshold: 0.005),
    ].where((row) => row.current != null && row.prior != null).toList();
    if (rows.isEmpty) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: context.l10n.analysisCompareTitle(Fmt.monthDay(previous.exerciseDate))),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Column(
              children: [
                for (final row in rows)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(child: Text(row.label, style: const TextStyle(fontWeight: FontWeight.w600))),
                        Text(row.value(row.prior!), style: TextStyle(color: scheme.onSurfaceVariant)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Icon(Icons.arrow_forward_rounded, size: 16, color: scheme.onSurfaceVariant),
                        ),
                        Text(row.value(row.current!), style: AppText.numeric(16, color: scheme.onSurface)),
                        SizedBox(
                          width: 72,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: DeltaText(
                              delta: row.current! - row.prior!,
                              higherIsBetter: row.higherIsBetter ?? true,
                              neutral: row.higherIsBetter == null,
                              neutralThreshold: row.threshold,
                              format: row.delta,
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
      ),
    );
  }
}

class _ComparisonRow {
  const _ComparisonRow(
    this.label,
    this.current,
    this.prior, {
    required this.value,
    required this.delta,
    required this.threshold,
    this.higherIsBetter,
  });

  final String label;
  final double? current;
  final double? prior;

  /// null이면 방향에 좋고 나쁨이 없는 지표 (중립 표시)
  final bool? higherIsBetter;
  final String Function(double value) value;
  final String Function(double absDelta) delta;
  final double threshold;
}

class _VideoSection extends ConsumerWidget {
  const _VideoSection({required this.report});

  final AnalysisReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(poseRecordsProvider(report.sessionId)).valueOrNull ?? const <PoseRecord>[];
    final videos = <(String, String, IconData)>[
      for (final record in records)
        if (record.videoFilePath != null) (record.cameraLabel, record.videoFilePath!, Icons.videocam_rounded),
      if (report.skeletonVideoPath != null) (context.l10n.analysisVideoSkeleton, report.skeletonVideoPath!, Icons.accessibility_new_rounded),
    ];
    if (videos.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: context.l10n.analysisVideoSection),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (final (title, path, icon) in videos)
                  ListTile(
                    leading: Icon(icon, color: AppColors.mintDeep),
                    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.play_circle_fill_rounded, color: AppColors.mintDeep, size: 30),
                    onTap: () => context.push(AppRoutes.video(path: path, title: title)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CareNotes extends StatelessWidget {
  const _CareNotes({required this.notes});

  final List<String> notes;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeader(title: context.l10n.analysisCareNotes),
        AppCard(
          color: scheme.primaryContainer,
          borderColor: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final note in notes)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Icon(Icons.check_circle_rounded, size: 16, color: scheme.onPrimaryContainer),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(note, style: TextStyle(color: scheme.onPrimaryContainer, height: 1.5))),
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
