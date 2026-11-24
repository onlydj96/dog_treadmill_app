import '../../../core/utils/json.dart';
import '../../../l10n/l10n.dart';
import '../../exercise/data/exercise_session.dart';
import 'dog_keypoints.dart';

// 지표 JSON 구조는 docs/app-interface.md 참고 (AI 서버와의 계약)

enum AnalysisStatus {
  queued('queued'),
  processing('processing'),
  completed('completed'),
  failed('failed');

  const AnalysisStatus(this.dbValue);

  final String dbValue;

  String get label => switch (this) {
        AnalysisStatus.queued => L10n.current.analysisStatusQueued,
        AnalysisStatus.processing => L10n.current.analysisStatusProcessing,
        AnalysisStatus.completed => L10n.current.analysisStatusCompleted,
        AnalysisStatus.failed => L10n.current.analysisStatusFailed,
      };

  static AnalysisStatus fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => AnalysisStatus.queued);

  bool get isPending => this == queued || this == processing;
}

class JointMetric {
  const JointMetric({
    required this.key,
    String? label,
    this.labelEn,
    this.romDeg,
    this.meanAngleDeg,
    this.minAngleDeg,
    this.maxAngleDeg,
    this.baselineRomDeg,
    this.confidence,
  }) : _label = label;

  factory JointMetric.fromJson(Json json) {
    final key = json.strOrNull('key') ?? '';
    return JointMetric(
      key: key,
      label: json.strOrNull('label'),
      labelEn: json.strOrNull('label_en'),
      romDeg: json.dblOrNull('rom_deg'),
      meanAngleDeg: json.dblOrNull('mean_angle_deg'),
      minAngleDeg: json.dblOrNull('min_angle_deg'),
      maxAngleDeg: json.dblOrNull('max_angle_deg'),
      baselineRomDeg: json.dblOrNull('baseline_rom_deg'),
      confidence: json.dblOrNull('confidence'),
    );
  }

  final String key;
  final String? _label;

  /// AI 결과의 영어 라벨 (`label_en`)
  final String? labelEn;

  /// 현재 언어의 관절 이름. 한국어: label → 앱 관절 이름 → key,
  /// 영어: label_en → 앱 관절 이름 → label → key.
  String get label {
    final keypoint = DogKeypoint.fromKey(key)?.label;
    if (L10n.isEnglish) return L10n.pickOrNull(null, labelEn) ?? keypoint ?? _label ?? key;
    return _label ?? keypoint ?? key;
  }

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
  normal('normal'),
  caution('caution'),
  warning('warning');

  const AnomalyLevel(this.dbValue);

  final String dbValue;

  String get label => switch (this) {
        AnomalyLevel.normal => L10n.current.analysisLevelNormal,
        AnomalyLevel.caution => L10n.current.analysisLevelCaution,
        AnomalyLevel.warning => L10n.current.analysisLevelWarning,
      };

  static AnomalyLevel fromDb(String? value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => AnomalyLevel.normal);
}

class AnomalyFinding {
  const AnomalyFinding({
    required String description,
    required this.severity,
    this.jointKey,
    String? label,
    this.labelEn,
    this.descriptionEn,
  })  : _description = description,
        _label = label;

  factory AnomalyFinding.fromJson(Json json) {
    final joint = json.strOrNull('joint');
    return AnomalyFinding(
      jointKey: joint,
      label: json.strOrNull('label'),
      labelEn: json.strOrNull('label_en'),
      description: json.strOrNull('description') ?? '',
      descriptionEn: json.strOrNull('description_en'),
      severity: AnomalyLevel.fromDb(json.strOrNull('severity')),
    );
  }

  final String? jointKey;
  final String? _label;
  final String? labelEn;
  final String _description;
  final String? descriptionEn;
  final AnomalyLevel severity;

  /// 현재 언어의 관절 이름. 한국어: label → 앱 관절 이름, 영어: label_en → 앱 관절 이름 → label.
  String? get label {
    final joint = jointKey;
    final keypoint = joint == null ? null : DogKeypoint.fromKey(joint)?.label;
    if (L10n.isEnglish) return L10n.pickOrNull(null, labelEn) ?? keypoint ?? _label;
    return _label ?? keypoint;
  }

  String get description => L10n.pick(_description, descriptionEn);
}

class AnomalyMetrics {
  const AnomalyMetrics({
    required this.level,
    this.anomalyScore,
    this.confidence,
    this.findings = const [],
    List<String> notes = const [],
    this.notesEn,
  }) : _notes = notes;

  factory AnomalyMetrics.fromJson(Json json) => AnomalyMetrics(
        level: AnomalyLevel.fromDb(json.strOrNull('level')),
        anomalyScore: json.dblOrNull('anomaly_score'),
        confidence: json.dblOrNull('confidence'),
        findings: json.objList('findings').map(AnomalyFinding.fromJson).toList(),
        notes: json.strList('notes'),
        notesEn: json['notes_en'] is List ? json.strList('notes_en') : null,
      );

  final AnomalyLevel level;

  /// 평소 패턴과의 차이 정도 (0~1)
  final double? anomalyScore;

  /// 분석 신뢰도 (0~1)
  final double? confidence;
  final List<AnomalyFinding> findings;

  final List<String> _notes;
  final List<String>? notesEn;

  /// 분석 주의사항 (카메라 각도, 가림 등)
  List<String> get notes => L10n.pickList(_notes, notesEn);
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
    String? summary,
    this.summaryEn,
    List<String> careNotes = const [],
    this.careNotesEn,
    this.skeletonVideoPath,
    this.reportPdfPath,
    this.modelVersion,
    this.completedAt,
    this.session,
  })  : _summary = summary,
        _careNotes = careNotes;

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
      summaryEn: json.strOrNull('summary_en'),
      careNotes: json.strList('care_notes'),
      careNotesEn: json['care_notes_en'] is List ? json.strList('care_notes_en') : null,
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
  final String? _summary;
  final String? summaryEn;
  final List<String> _careNotes;
  final List<String>? careNotesEn;
  final String? skeletonVideoPath;
  final String? reportPdfPath;
  final String? modelVersion;
  final DateTime createdAt;
  final DateTime? completedAt;
  final ExerciseSession? session;

  /// 현재 언어의 요약 (영어 화면에서 summary_en이 없으면 한국어 요약)
  String? get summary => L10n.pickOrNull(_summary, summaryEn);

  List<String> get careNotes => L10n.pickList(_careNotes, careNotesEn);

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

  String get cameraLabel => cameraType == 'front' ? L10n.current.analysisCameraFront : L10n.current.analysisCameraSide;
}

class ExercisePlan {
  const ExercisePlan({
    required this.id,
    required String programName,
    this.targetDurationSeconds,
    this.targetSpeed,
    List<String> restrictions = const [],
    String? notes,
    String? programNameEn,
    List<String>? restrictionsEn,
    String? notesEn,
  })  : _programName = programName,
        _programNameEn = programNameEn,
        _restrictions = restrictions,
        _restrictionsEn = restrictionsEn,
        _notes = notes,
        _notesEn = notesEn;

  /// 영어 값은 `program_name_en` · `notes_en` · restrictions 항목의 `name_en`. 없으면 기본(한국어) 값.
  factory ExercisePlan.fromJson(Json json) {
    final items = json.objList('restrictions');
    return ExercisePlan(
      id: json.str('id'),
      programName: json.str('program_name'),
      programNameEn: json.strOrNull('program_name_en'),
      targetDurationSeconds: json.intOrNull('target_duration_seconds'),
      targetSpeed: json.dblOrNull('target_speed'),
      restrictions: items.map((e) => e.strOrNull('name') ?? '').where((e) => e.isNotEmpty).toList(),
      restrictionsEn: items
          .where((e) => (e.strOrNull('name') ?? '').isNotEmpty)
          .map((e) => e.strOrNull('name_en') ?? '')
          .toList(),
      notes: json.strOrNull('notes'),
      notesEn: json.strOrNull('notes_en'),
    );
  }

  final String id;
  final String _programName;
  final String? _programNameEn;
  final int? targetDurationSeconds;
  final double? targetSpeed;
  final List<String> _restrictions;
  final List<String>? _restrictionsEn;
  final String? _notes;
  final String? _notesEn;

  String get programName => L10n.pick(_programName, _programNameEn);

  /// 항목마다 영어 값(restrictionsEn과 같은 순서, 빈 문자열이면 없음)이 없으면 그 항목만 한국어로 둔다.
  List<String> get restrictions {
    final en = _restrictionsEn;
    if (!L10n.isEnglish || en == null || en.length != _restrictions.length) return _restrictions;
    return [for (var i = 0; i < en.length; i++) L10n.pick(_restrictions[i], en[i])];
  }

  String? get notes => L10n.pickOrNull(_notes, _notesEn);
}
