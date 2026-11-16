import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/json.dart';
import 'ranking_models.dart';

/// 랭킹·배지 조회와 응원. 다른 회원 데이터는 공개용 RPC로만 읽는다 (테이블 RLS는 본인 것만 허용).
class RankingRepository {
  RankingRepository(this._client);

  final SupabaseClient _client;

  Future<List<LeaderboardEntry>> fetchLeaderboard(RankingQuery query) async {
    final rows = await _client.rpc<List<dynamic>>('get_leaderboard', params: {
      'p_month': toDateString(query.month),
      'p_scope': query.scope.dbValue,
      'p_scope_key': query.scopeKey,
      'p_limit': query.limit,
    });
    return rows.cast<Json>().map(LeaderboardEntry.fromJson).toList();
  }

  Future<MyRanking> fetchMyRanking(String dogId, DateTime month) async {
    final json = await _client.rpc<Json>('get_my_ranking', params: {
      'p_dog_id': dogId,
      'p_month': toDateString(month),
    });
    return MyRanking.fromJson(json);
  }

  Future<List<BranchBattleEntry>> fetchBranchBattle(DateTime month) async {
    final rows = await _client.rpc<List<dynamic>>('get_branch_battle', params: {'p_month': toDateString(month)});
    return rows.cast<Json>().map(BranchBattleEntry.fromJson).toList();
  }

  Future<List<HallOfFameEntry>> fetchHallOfFame({int months = 6}) async {
    final rows = await _client.rpc<List<dynamic>>('get_hall_of_fame', params: {'p_months': months});
    return rows.cast<Json>().map(HallOfFameEntry.fromJson).toList();
  }

  Future<RankingDogProfile> fetchDogProfile(String dogId, DateTime month) async {
    final json = await _client.rpc<Json>('get_ranking_dog_profile', params: {
      'p_dog_id': dogId,
      'p_month': toDateString(month),
    });
    return RankingDogProfile.fromJson(json);
  }

  Future<DogAchievements> fetchAchievements(String dogId) async {
    final json = await _client.rpc<Json>('get_dog_achievements', params: {'p_dog_id': dogId});
    return DogAchievements.fromJson(json);
  }

  Future<List<BadgeDef>> fetchBadgeCatalog() async {
    // postgrest-dart의 order는 기본이 내림차순이다
    final rows = await _client.from('badges').select().eq('is_active', true).order('sort_order', ascending: true);
    return rows.map(BadgeDef.fromJson).toList();
  }

  /// 이번 달 응원 (같은 반려견은 한 달에 한 번). 응원 수를 돌려준다.
  Future<int> cheer(String dogId) async {
    return await _client.rpc<int>('cheer_dog', params: {'p_dog_id': dogId});
  }
}
