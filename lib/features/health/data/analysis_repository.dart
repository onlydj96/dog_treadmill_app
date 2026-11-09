import 'package:supabase_flutter/supabase_flutter.dart';

import 'analysis_models.dart';

class AnalysisRepository {
  AnalysisRepository(this._client);

  final SupabaseClient _client;

  static const videoBucket = 'exercise-videos';

  static const _reportColumns = '*, '
      'session:exercise_sessions(id, status, started_at, ended_at, duration_seconds, distance_meters, '
      'current_speed, average_speed, max_speed, treadmill:treadmills(id, device_name))';

  Future<List<AnalysisReport>> fetchReports(String dogId, {int limit = 30}) async {
    final rows = await _client
        .from('analysis_reports')
        .select(_reportColumns)
        .eq('dog_id', dogId)
        .order('created_at', ascending: false)
        .limit(limit);
    return rows.map(AnalysisReport.fromJson).toList();
  }

  Future<AnalysisReport> fetchReport(String reportId) async {
    final row = await _client.from('analysis_reports').select(_reportColumns).eq('id', reportId).single();
    return AnalysisReport.fromJson(row);
  }

  /// 이전 운동 대비 변화를 위한 직전 완료 리포트
  Future<AnalysisReport?> fetchPreviousCompleted({
    required String dogId,
    required DateTime before,
  }) async {
    final row = await _client
        .from('analysis_reports')
        .select(_reportColumns)
        .eq('dog_id', dogId)
        .eq('analysis_status', 'completed')
        .lt('created_at', before.toUtc().toIso8601String())
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return row == null ? null : AnalysisReport.fromJson(row);
  }

  Future<List<PoseRecord>> fetchPoseRecords(String sessionId) async {
    final rows = await _client
        .from('pose_records')
        .select('id, camera_type, video_file_path, fps, frame_count')
        .eq('session_id', sessionId)
        .order('camera_type', ascending: true);
    return rows.map(PoseRecord.fromJson).toList();
  }

  Future<String> createVideoUrl(String path) {
    return _client.storage.from(videoBucket).createSignedUrl(path, 60 * 60);
  }

  Future<ExercisePlan?> fetchActivePlan(String dogId) async {
    final row = await _client
        .from('exercise_plans')
        .select()
        .eq('dog_id', dogId)
        .eq('is_active', true)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();
    return row == null ? null : ExercisePlan.fromJson(row);
  }
}
