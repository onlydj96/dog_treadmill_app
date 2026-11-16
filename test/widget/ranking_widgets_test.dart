import 'package:dog_treadmill_app/features/booking/data/booking_models.dart';
import 'package:dog_treadmill_app/features/booking/providers.dart';
import 'package:dog_treadmill_app/features/consents/data/consent_repository.dart';
import 'package:dog_treadmill_app/features/dogs/data/dog.dart';
import 'package:dog_treadmill_app/features/dogs/providers.dart';
import 'package:dog_treadmill_app/features/exercise/data/exercise_session.dart';
import 'package:dog_treadmill_app/features/exercise/presentation/widgets/exercise_widgets.dart';
import 'package:dog_treadmill_app/features/profile/data/app_user.dart';
import 'package:dog_treadmill_app/features/profile/data/user_repository.dart';
import 'package:dog_treadmill_app/features/ranking/data/ranking_models.dart';
import 'package:dog_treadmill_app/features/ranking/presentation/badge_collection_screen.dart';
import 'package:dog_treadmill_app/features/ranking/presentation/ranking_screen.dart';
import 'package:dog_treadmill_app/features/ranking/presentation/widgets/ranking_widgets.dart';
import 'package:dog_treadmill_app/features/ranking/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n.dart';

Widget _app(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: [languageOverride(), ...overrides],
    child: localizedApp(child),
  );
}

LeaderboardEntry _entry(int rank, String name, String nickname, int points, {bool mine = false}) => LeaderboardEntry(
      rank: rank,
      dogId: 'dog-$rank',
      dogName: name,
      nickname: nickname,
      points: points,
      sessionCount: 3,
      distanceMeters: 4200,
      participantCount: 4,
      breedLabel: '말티즈',
      isMine: mine,
    );

const _dog = Dog(id: 'my-dog', ownerId: 'me', name: '콩이', size: DogSize.small);

MyRanking _myRanking({required bool participating, int? rank}) => MyRanking(
      dogId: _dog.id,
      periodMonth: RankingMonth.current(),
      participating: participating,
      nickname: '콩이맘',
      points: rank == null ? 0 : 40,
      sessionCount: rank == null ? 0 : 1,
      distanceMeters: rank == null ? 0 : 2500,
      weeklyBonusCount: 0,
      streakWeeks: 0,
      ranks: [
        if (rank != null)
          ScopeRank(
            scope: RankingScope.all,
            scopeKey: 'all',
            label: '전체',
            rank: rank,
            participantCount: 4,
            points: 40,
            topPercent: 50,
            pointsToNext: 7,
          ),
      ],
    );

List<Override> _rankingOverrides({
  required List<LeaderboardEntry> entries,
  required MyRanking mine,
  required bool participating,
}) =>
    [
      selectedDogProvider.overrideWithValue(const AsyncData(_dog)),
      branchesProvider.overrideWith((ref) async => const <Branch>[]),
      currentUserProfileProvider.overrideWith(
        (ref) async => const AppUser(id: 'me', name: '김보호', role: 'user', notificationPrefs: NotificationPrefs()),
      ),
      rankingConsentGrantedProvider.overrideWith((ref) => participating),
      leaderboardProvider.overrideWith((ref, query) async => entries),
      myRankingProvider.overrideWith((ref, key) async => mine),
      branchBattleProvider.overrideWith((ref, month) async => const []),
      hallOfFameProvider.overrideWith((ref) async => const []),
    ];

void main() {
  setUpAll(initTestLocales);

  testWidgets('시상대: 1~3위 이름·닉네임·점수, 누르면 그 반려견', (tester) async {
    LeaderboardEntry? tapped;
    await tester.pumpWidget(_app(Scaffold(
      body: RankingPodium(
        entries: [_entry(1, '보리', '보리아빠', 726), _entry(2, '호두', '모카집사', 649), _entry(3, '콩이', '콩이맘', 466)],
        onTap: (entry) => tapped = entry,
      ),
    )));

    expect(find.text('보리'), findsOneWidget);
    expect(find.text('@모카집사'), findsOneWidget);
    expect(find.text('466점'), findsOneWidget);

    await tester.tap(find.text('호두'));
    expect(tapped?.dogName, '호두');
  });

  testWidgets('순위표 행: 내 반려견 표시와 지난달 칭호', (tester) async {
    final entry = LeaderboardEntry(
      rank: 5,
      dogId: 'd5',
      dogName: '단풍',
      nickname: '단풍언니',
      points: 241,
      sessionCount: 4,
      distanceMeters: 3000,
      participantCount: 9,
      isMine: true,
      cheerCount: 2,
      title: RankingTitle(periodMonth: DateTime(2026, 10), scope: RankingScope.size, label: '소형견', rank: 1),
    );
    await tester.pumpWidget(_app(Scaffold(body: LeaderboardTile(entry: entry))));

    expect(find.text('내 반려견'), findsOneWidget);
    expect(find.text('10월 소형견 1위'), findsOneWidget);
    expect(find.text('241점'), findsOneWidget);
    expect(find.text('2'), findsOneWidget, reason: '응원 수');
  });

  testWidgets('랭킹 화면: 참여하지 않았으면 "참여하면 n위"로 참여를 권한다', (tester) async {
    await tester.pumpWidget(_app(
      const RankingScreen(),
      overrides: _rankingOverrides(
        entries: [_entry(1, '보리', '보리아빠', 726), _entry(2, '호두', '모카집사', 649), _entry(3, '모카', '모카집사', 385),
          _entry(4, '단풍', '단풍언니', 241)],
        mine: _myRanking(participating: false, rank: 2),
        participating: false,
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('참여하면 콩이 전체 2위예요'), findsOneWidget);
    expect(find.text('참여하기'), findsOneWidget);
    expect(find.text('보리'), findsOneWidget, reason: '시상대');
    expect(find.text('단풍'), findsOneWidget, reason: '4위부터 목록');
    expect(find.text('콩이 · 참여하면 2위'), findsOneWidget, reason: '아래 고정된 내 순위');
    expect(find.text('40점 · 7점 더 받으면 순위가 올라요'), findsOneWidget);
  });

  testWidgets('랭킹 화면: 순위표가 비면 첫 운동을 권한다', (tester) async {
    await tester.pumpWidget(_app(
      const RankingScreen(),
      overrides: _rankingOverrides(entries: const [], mine: _myRanking(participating: true), participating: true),
    ));
    await tester.pumpAndSettle();

    expect(find.text('아직 순위에 오른 반려견이 없어요'), findsOneWidget);
    expect(find.text('이번 달 첫 운동을 마치면 바로 랭킹에 올라요.'), findsOneWidget);
    expect(find.textContaining('참여하면'), findsNothing);
    expect(find.text('콩이 · 이 랭킹에서는 아직 점수가 없어요'), findsOneWidget);
  });

  testWidgets('운동 기록의 점수 칩을 누르면 점수 내역을 보여준다', (tester) async {
    final session = ExerciseSession.fromJson({
      'id': 's1',
      'dog_id': 'd1',
      'status': 'completed',
      'duration_seconds': 1800,
      'distance_meters': 2500,
      'current_speed': 0,
      'created_at': '2026-11-03T01:00:00Z',
      'points': [
        {'kind': 'session', 'attendance_points': 10, 'achievement_points': 10, 'distance_points': 20,
         'bonus_points': 0, 'points': 40},
        {'kind': 'weekly_bonus', 'bonus_points': 20, 'points': 20},
      ],
    });
    await tester.pumpWidget(_app(Scaffold(body: ExerciseRecordTile(session: session))));

    expect(find.text('+60점'), findsOneWidget);
    expect(find.text('주간 보너스 20점 포함'), findsOneWidget);

    await tester.tap(find.text('+60점'));
    await tester.pumpAndSettle();
    expect(find.text('이번 운동 점수'), findsOneWidget);
    expect(find.text('주간 보너스'), findsOneWidget);
    expect(find.text('60점'), findsOneWidget);
  });

  testWidgets('배지함: 받은 배지는 획득일, 받지 않은 배지는 진행률', (tester) async {
    const catalog = [
      BadgeDef(code: 'first_run', name: '첫 발걸음', description: '처음으로 운동을 마쳤어요.', icon: 'flag',
          tier: BadgeTier.bronze, metric: BadgeMetric.sessions, goal: 1),
      BadgeDef(code: 'sessions_10', name: '열 번째 운동', description: '운동을 10번 마쳤어요.', icon: 'run',
          tier: BadgeTier.bronze, metric: BadgeMetric.sessions, goal: 10),
      BadgeDef(code: 'podium', name: '시상대', description: '월간 랭킹에서 3위 안에 들었어요.', icon: 'trophy',
          tier: BadgeTier.gold),
    ];
    final achievements = DogAchievements(
      stats: const BadgeStats(sessions: 3, distanceMeters: 4200, streakWeeks: 2, bestStreakWeeks: 2, branches: 1),
      badges: [EarnedBadge(code: 'first_run', earnedAt: DateTime(2026, 11, 2))],
      awards: const [],
    );

    await tester.pumpWidget(_app(
      const BadgeCollectionScreen(dogId: 'd1'),
      overrides: [
        dogDetailProvider.overrideWith((ref, id) async => const Dog(id: 'd1', ownerId: 'me', name: '콩이')),
        dogAchievementsProvider.overrideWith((ref, id) async => achievements),
        badgeCatalogProvider.overrideWith((ref) async => catalog),
      ],
    ));
    await tester.pumpAndSettle();

    expect(find.text('콩이의 배지함'), findsOneWidget);
    expect(find.text('2026.11.02 획득'), findsOneWidget);
    expect(find.text('3 / 10회'), findsOneWidget);
    expect(find.text('월간 랭킹 마감 때 받아요'), findsOneWidget);
  });
}
