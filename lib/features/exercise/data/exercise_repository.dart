import 'package:supabase_flutter/supabase_flutter.dart';

import '../../booking/data/booking_models.dart';
import 'exercise_session.dart';

class ExerciseRepository {
  ExerciseRepository(this._client);

  final SupabaseClient _client;

  static const _sessionColumns = '*, '
      'treadmill:treadmills(id, device_name), '
      'reports:analysis_reports(id, analysis_status, created_at)';

  /// 반려견의 최신 운동 세션을 Realtime으로 구독한다 (운동 진행 화면).
  /// 영상은 전송하지 않고 상태·속도·거리 등 지표만 받는다.
  Stream<ExerciseSession?> watchLatestSession(String dogId) {
    return _client
        .from('exercise_sessions')
        .stream(primaryKey: ['id'])
        .eq('dog_id', dogId)
        .order('created_at')
        .limit(1)
        .map((rows) => rows.isEmpty ? null : ExerciseSession.fromJson(rows.first));
  }

  Future<List<ExerciseSession>> fetchSessions(String dogId, {int limit = 100}) async {
    final rows = await _client
        .from('exercise_sessions')
        .select(_sessionColumns)
        .eq('dog_id', dogId)
        .order('created_at', ascending: false)
        .order('created_at', ascending: false, referencedTable: 'reports')
        .limit(limit);
    return rows.map(ExerciseSession.fromJson).toList();
  }

  Future<Treadmill> fetchTreadmill(String treadmillId) async {
    final row = await _client.from('treadmills').select('id, device_name, status').eq('id', treadmillId).single();
    return Treadmill.fromJson(row);
  }
}
