import '../../../core/utils/json.dart';
import '../../exercise/data/exercise_session.dart';
import 'dog_keypoints.dart';

// 지표 JSON 구조는 docs/analysis-metrics.md 참고 (AI 서버와의 계약)

enum AnalysisStatus {
  queued('queued', '분석 대기'),
  processing('processing', '분석 중'),
  completed('completed', '분석 완료'),
  failed('failed', '분석 실패');

  const AnalysisStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static AnalysisStatus fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => AnalysisStatus.queued);

  bool get isPending => this == queued || this == processing;
}

class JointMetric {
  const JointMetric({
    required this.key,
    required this.label,
    this.romDeg,
    this.meanAngleDeg,
    this.minAngleDeg,
    this.maxAngleDeg,
    this.baselineRomDeg,
    this.confidence,
  });

  factory JointMetric.fromJson(Json json) {
    final key = json.strOrNull('key') ?? '';
    return JointMetric(
      key: key,
      label: json.strOrNull('label') ?? DogKeypoint.fromKey(key)?.label ?? key,
      romDeg: json.dblOrNull('rom_deg'),
      meanAngleDeg: json.dblOrNull('mean_angle_deg'),
      minAngleDeg: json.dblOrNull('min_angle_deg'),
      maxAngleDeg: json.dblOrNull('max_angle_deg'),
      baselineRomDeg: json.dblOrNull('baseline_rom_deg'),
      confidence: json.dblOrNull('confidence'),
    );
  }

  final String key;
  final String label;

  /// 관절 가동 범위(ROM, 도)
  final double? romDeg;
  final double? meanAngleDeg;
  final double? minAngleDeg;
  final double? maxAngleDeg;

  /// 개체별 정상 보행 기준선의 ROM
  final double? baselineRomDeg;
  final double? confidence;

  /// 기준선 대비 ROM 변화율 (예: -0.12 = 12% 감소)
  double? get romChangeRatio {
    if (romDeg == null || baselineRomDeg == null || baselineRomDeg == 0) return null;
    return (romDeg! - baselineRomDeg!) / baselineRomDeg!;
  }
}

class JointMetrics {
  const JointMetrics({required this.joints, this.keypointCount});

  factory JointMetrics.fromJson(Json json) => JointMetrics(
        keypointCount: json.intOrNull('keypoint_count'),
        joints: json.objList('joints').map(JointMetric.fromJson).toList(),
      );

  final int? keypointCount;
  final List<JointMetric> joints;
}

class GaitBaseline {
  const GaitBaseline({this.cadenceSpm, this.symmetryIndex, this.strideTimeCv});

  factory GaitBaseline.fromJson(Json json) => GaitBaseline(
        cadenceSpm: json.dblOrNull('cadence_spm'),
        symmetryIndex: json.dblOrNull('symmetry_index'),
        strideTimeCv: json.dblOrNull('stride_time_cv'),
      );

  final double? cadenceSpm;
  final double? symmetryIndex;
  final double? strideTimeCv;
}

class GaitMetrics {
  const GaitMetrics({
    this.cadenceSpm,
    this.strideTimeS,
    this.strideTimeCv,
    this.symmetryIndex,
    this.frontSymmetry,
    this.hindSymmetry,
    this.rhythmScore,
    this.baseline,
  });

  factory GaitMetrics.fromJson(Json json) {
    final baseline = json.objOrNull('baseline');
    return GaitMetrics(
      cadenceSpm: json.dblOrNull('cadence_spm'),
      strideTimeS: json.dblOrNull('stride_time_s'),
      strideTimeCv: json.dblOrNull('stride_time_cv'),
      symmetryIndex: json.dblOrNull('symmetry_index'),
      frontSymmetry: json.dblOrNull('front_symmetry'),
      hindSymmetry: json.dblOrNull('hind_symmetry'),
      rhythmScore: json.dblOrNull('rhythm_score'),
      baseline: baseline == null ? null : GaitBaseline.fromJson(baseline),
    );
  }

  /// 분당 걸음 수
  final double? cadenceSpm;

  /// 걸음걸이 주기(초)
  final double? strideTimeS;

  /// 보행 주기 변동성 (변동계수, 낮을수록 일정)
  final double? strideTimeCv;

  /// 좌우 대칭성 (0~1, 1이 완전 대칭)
  final double? symmetryIndex;
  final double? frontSymmetry;
  final double? hindSymmetry;

  /// 보행 리듬 점수 (0~1)
  final double? rhythmScore;
  final GaitBaseline? baseline;
}

enum AnomalyLevel {
  normal('normal', '특이사항 없음'),
  caution('caution', '관찰 필요'),
  warning('warning', '주의 필요');

  const AnomalyLevel(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static AnomalyLevel fromDb(String? value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => AnomalyLevel.normal);
}

class AnomalyFinding {
  const AnomalyFinding({
    required this.description,
    required this.severity,
    this.jointKey,
    this.label,
  });

  factory AnomalyFinding.fromJson(Json json) {
    final joint = json.strOrNull('joint');
    return AnomalyFinding(
      jointKey: joint,
      label: json.strOrNull('label') ?? (joint == null ? null : DogKeypoint.fromKey(joint)?.label),
      description: json.strOrNull('description') ?? '',
      severity: AnomalyLevel.fromDb(json.strOrNull('severity')),
    );
  }

  final String? jointKey;
  final String? label;
  final String description;
  final AnomalyLevel severity;
}

class AnomalyMetrics {
  const AnomalyMetrics({
    required this.level,
    this.anomalyScore,
    this.confidence,
    this.findings = const [],
    this.notes = const [],
  });

  factory AnomalyMetrics.fromJson(Json json) => AnomalyMetrics(
        level: AnomalyLevel.fromDb(json.strOrNull('level')),
        anomalyScore: json.dblOrNull('anomaly_score'),
        confidence: json.dblOrNull('confidence'),
        findings: json.objList('findings').map(AnomalyFinding.fromJson).toList(),
        notes: json.strList('notes'),
      );

  final AnomalyLevel level;

  /// 평소 패턴과의 차이 정도 (0~1)
  final double? anomalyScore;

  /// 분석 신뢰도 (0~1)
  final double? confidence;
  final List<AnomalyFinding> findings;

  /// 분석 주의사항 (카메라 각도, 가림 등)
  final List<String> notes;
}

class AnalysisReport {
  const AnalysisReport({
    required this.id,
    required this.sessionId,
    required this.dogId,
    required this.status,
    required this.createdAt,
    this.jointMetrics,
    this.gaitMetrics,
    this.anomalyMetrics,
    this.summary,
    this.careNotes = const [],
    this.skeletonVideoPath,
    this.reportPdfPath,
    this.modelVersion,
    this.completedAt,
    this.session,
  });

  factory AnalysisReport.fromJson(Json json) {
    final joint = json.objOrNull('joint_metrics');
    final gait = json.objOrNull('gait_metrics');
    final anomaly = json.objOrNull('anomaly_metrics');
    final session = json.objOrNull('session');
    return AnalysisReport(
      id: json.str('id'),
      sessionId: json.str('session_id'),
      dogId: json.str('dog_id'),
      status: AnalysisStatus.fromDb(json.str('analysis_status')),
      jointMetrics: joint == null ? null : JointMetrics.fromJson(joint),
      gaitMetrics: gait == null ? null : GaitMetrics.fromJson(gait),
      anomalyMetrics: anomaly == null ? null : AnomalyMetrics.fromJson(anomaly),
      summary: json.strOrNull('summary'),
      careNotes: json.strList('care_notes'),
      skeletonVideoPath: json.strOrNull('skeleton_video_path'),
      reportPdfPath: json.strOrNull('report_pdf_path'),
      modelVersion: json.strOrNull('model_version'),
      createdAt: json.dateTime('created_at'),
      completedAt: json.dateTimeOrNull('completed_at'),
      session: session == null ? null : _sessionFromEmbed(session, json),
    );
  }

  /// 리포트에 임베드된 세션은 일부 컬럼만 포함하므로 누락된 필드를 보완한다.
  static ExerciseSession _sessionFromEmbed(Json session, Json report) {
    return ExerciseSession.fromJson({
      'dog_id': report['dog_id'],
      'created_at': report['created_at'],
      ...session,
    });
  }

  final String id;
  final String sessionId;
  final String dogId;
  final AnalysisStatus status;
  final JointMetrics? jointMetrics;
  final GaitMetrics? gaitMetrics;
  final AnomalyMetrics? anomalyMetrics;
  final String? summary;
  final List<String> careNotes;
  final String? skeletonVideoPath;
  final String? reportPdfPath;
  final String? modelVersion;
  final DateTime createdAt;
  final DateTime? completedAt;
  final ExerciseSession? session;

  /// 운동 일시 (세션 시작 시각, 없으면 리포트 생성 시각)
  DateTime get exerciseDate => session?.startedAt ?? createdAt;

  bool get isCompleted => status == AnalysisStatus.completed;
}

class PoseRecord {
  const PoseRecord({required this.id, required this.cameraType, this.videoFilePath, this.fps, this.frameCount});

  factory PoseRecord.fromJson(Json json) => PoseRecord(
        id: json.str('id'),
        cameraType: json.str('camera_type'),
        videoFilePath: json.strOrNull('video_file_path'),
        fps: json.dblOrNull('fps'),
        frameCount: json.intOrNull('frame_count'),
      );

  final String id;
  final String cameraType;
  final String? videoFilePath;
  final double? fps;
  final int? frameCount;

  String get cameraLabel => cameraType == 'front' ? '정면 영상' : '측면 영상';
}

class ExercisePlan {
  const ExercisePlan({
    required this.id,
    required this.programName,
    this.targetDurationSeconds,
    this.targetSpeed,
    this.restrictions = const [],
    this.notes,
  });

  factory ExercisePlan.fromJson(Json json) => ExercisePlan(
        id: json.str('id'),
        programName: json.str('program_name'),
        targetDurationSeconds: json.intOrNull('target_duration_seconds'),
        targetSpeed: json.dblOrNull('target_speed'),
        restrictions:
            json.objList('restrictions').map((e) => e.strOrNull('name') ?? '').where((e) => e.isNotEmpty).toList(),
        notes: json.strOrNull('notes'),
      );

  final String id;
  final String programName;
  final int? targetDurationSeconds;
  final double? targetSpeed;
  final List<String> restrictions;
  final String? notes;
}
