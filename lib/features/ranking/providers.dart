import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/supabase/supabase_providers.dart';
import 'data/ranking_models.dart';
import 'data/ranking_repository.dart';

final rankingRepositoryProvider = Provider<RankingRepository>(
  (ref) => RankingRepository(ref.watch(supabaseClientProvider)),
);

/// 반려견 + 랭킹 월 (Provider family 키)
@immutable
class DogMonth {
  const DogMonth(this.dogId, this.month);

  final String dogId;
  final DateTime month;

  @override
  bool operator ==(Object other) => other is DogMonth && other.dogId == dogId && other.month == month;

  @override
  int get hashCode => Object.hash(dogId, month);
}

final leaderboardProvider = FutureProvider.autoDispose.family<List<LeaderboardEntry>, RankingQuery>(
  (ref, query) => ref.watch(rankingRepositoryProvider).fetchLeaderboard(query),
);

final myRankingProvider = FutureProvider.autoDispose.family<MyRanking, DogMonth>(
  (ref, key) => ref.watch(rankingRepositoryProvider).fetchMyRanking(key.dogId, key.month),
);

final branchBattleProvider = FutureProvider.autoDispose.family<List<BranchBattleEntry>, DateTime>(
  (ref, month) => ref.watch(rankingRepositoryProvider).fetchBranchBattle(month),
);

final hallOfFameProvider = FutureProvider.autoDispose<List<HallOfFameEntry>>(
  (ref) => ref.watch(rankingRepositoryProvider).fetchHallOfFame(),
);

/// 배지 카탈로그. 앱 실행 중에는 한 번만 불러온다.
final badgeCatalogProvider = FutureProvider<List<BadgeDef>>(
  (ref) => ref.watch(rankingRepositoryProvider).fetchBadgeCatalog(),
);

/// 내 반려견의 배지·진행률·수상 기록
final dogAchievementsProvider = FutureProvider.autoDispose.family<DogAchievements, String>(
  (ref, dogId) => ref.watch(rankingRepositoryProvider).fetchAchievements(dogId),
);

/// 랭킹에서 누른 반려견의 이번 달 공개 프로필
final rankingDogProfileProvider = FutureProvider.autoDispose.family<RankingDogProfile, String>(
  (ref, dogId) => ref.watch(rankingRepositoryProvider).fetchDogProfile(dogId, RankingMonth.current()),
);

/// 참여 설정·응원·동의 변경 뒤 랭킹 화면들을 다시 불러온다.
void refreshRankingProviders(WidgetRef ref) {
  ref
    ..invalidate(leaderboardProvider)
    ..invalidate(myRankingProvider)
    ..invalidate(branchBattleProvider)
    ..invalidate(hallOfFameProvider)
    ..invalidate(rankingDogProfileProvider)
    ..invalidate(dogAchievementsProvider);
}
