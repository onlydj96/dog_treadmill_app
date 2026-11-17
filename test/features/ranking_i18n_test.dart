import 'package:dog_treadmill_app/features/booking/data/booking_models.dart';
import 'package:dog_treadmill_app/features/booking/providers.dart';
import 'package:dog_treadmill_app/features/dogs/data/dog.dart';
import 'package:dog_treadmill_app/features/dogs/providers.dart';
import 'package:dog_treadmill_app/features/profile/data/app_user.dart';
import 'package:dog_treadmill_app/features/profile/data/user_repository.dart';
import 'package:dog_treadmill_app/features/ranking/data/ranking_models.dart';
import 'package:dog_treadmill_app/features/ranking/presentation/badge_collection_screen.dart';
import 'package:dog_treadmill_app/features/ranking/presentation/ranking_screen.dart';
import 'package:dog_treadmill_app/features/ranking/presentation/widgets/ranking_widgets.dart';
import 'package:dog_treadmill_app/features/ranking/providers.dart';
import 'package:dog_treadmill_app/features/consents/data/consent_repository.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n.dart';

Widget _enApp(Widget child, {List<Override> overrides = const []}) => ProviderScope(
      overrides: [languageOverride(AppLanguage.en), ...overrides],
      child: localizedApp(child, language: AppLanguage.en),
    );

void main() {
  setUpAll(initTestLocales);

  group('models in English', () {
    test('scope labels and size labels', () {
      useLanguage(AppLanguage.en);
      expect(RankingScope.all.label, 'Overall');
      expect(RankingScope.branch.label, 'Location');
      expect(RankingScope.size.label, 'Size class');
      expect(sizeScopeLabel(DogSize.small), 'Small dogs');
      expect(sizeScopeLabel(DogSize.large), 'Large dogs');
    });

    test('shortBranchName: Korean rule unchanged, English uses the first word', () {
      useLanguage(AppLanguage.en);
      expect(shortBranchName('용산 아이파크몰점'), '용산점');
      expect(shortBranchName("Yongsan I'Park Mall"), 'Yongsan');
      expect(shortBranchName('Goyang Starfield'), 'Goyang');
      expect(shortBranchName('Flagship'), 'Flagship');
    });

    test('RankingTitle.text uses _en label with Korean fallback', () {
      useLanguage(AppLanguage.en);
      final month = DateTime(2026, 10);
      expect(RankingTitle(periodMonth: month, scope: RankingScope.all, label: '전체', labelEn: 'Overall', rank: 1).text,
          'Oct #1 Overall');
      expect(
          RankingTitle(
                  periodMonth: month,
                  scope: RankingScope.branch,
                  label: '용산 아이파크몰점',
                  labelEn: "Yongsan I'Park Mall",
                  rank: 2)
              .text,
          'Oct #2 Yongsan');
      expect(RankingTitle(periodMonth: month, scope: RankingScope.size, label: '소형견', rank: 3).text, 'Oct #3 소형견',
          reason: '_en이 없으면 한국어 라벨');
    });

    test('server labels follow the language through the existing getters', () {
      final json = {
        'rank': 4,
        'dog_id': 'd1',
        'dog_name': 'Kongi',
        'breed_label': '말티즈',
        'breed_label_en': 'Maltese',
        'main_branch_name': '고양 스타필드점',
        'main_branch_name_en': 'Goyang Starfield',
        'participant_count': 9,
        'title_period': '2026-10-01',
        'title_scope': 'branch',
        'title_label': '용산 아이파크몰점',
        'title_label_en': "Yongsan I'Park Mall",
        'title_rank': 1,
      };
      final entry = LeaderboardEntry.fromJson(json);
      expect(entry.breedLabel, '말티즈');
      expect(entry.mainBranchName, '고양 스타필드점');
      expect(entry.title!.text, '10월 용산점 1위');

      useLanguage(AppLanguage.en);
      expect(entry.breedLabel, 'Maltese');
      expect(entry.mainBranchName, 'Goyang Starfield');
      expect(entry.title!.text, 'Oct #1 Yongsan');

      final old = LeaderboardEntry.fromJson({...json}..remove('breed_label_en'));
      expect(old.breedLabel, '말티즈', reason: '_en이 없는 옛 행은 한국어');
    });

    test('ScopeRank, battle, hall of fame, awards and badge defs read _en siblings', () {
      useLanguage(AppLanguage.en);
      final rank = ScopeRank.fromJson({
        'scope': 'branch',
        'scope_key': 'b1',
        'label': '용산 아이파크몰점',
        'label_en': "Yongsan I'Park Mall",
        'rank': 1,
        'participant_count': 3,
        'points': 40,
      });
      expect(rank.label, "Yongsan I'Park Mall");
      expect(rank.shortText, '#1 Yongsan');

      final battle = BranchBattleEntry.fromJson({'rank': 1, 'branch_id': 'b1', 'branch_name': '고양 스타필드점',
        'branch_name_en': 'Goyang Starfield'});
      expect(battle.branchName, 'Goyang Starfield');

      final hall = HallOfFameEntry.fromJson({'period_month': '2026-10-01', 'scope': 'size', 'scope_key': 'small',
        'scope_label': '소형견', 'scope_label_en': 'Small dogs', 'breed_label': '말티즈', 'breed_label_en': 'Maltese',
        'rank': 1});
      expect(hall.scopeLabel, 'Small dogs');
      expect(hall.breedLabel, 'Maltese');

      final award = AwardRecord.fromJson({'period_month': '2026-10-01', 'scope': 'all', 'scope_key': 'all',
        'scope_label': '전체', 'scope_label_en': 'Overall', 'rank': 1, 'points': 100});
      expect(award.text, 'Oct #1 Overall');

      final badge = BadgeDef.fromJson({'code': 'first_run', 'name': '첫 발걸음', 'name_en': 'First Steps',
        'description': '처음으로 운동을 마쳤어요.', 'description_en': 'Finished a treadmill workout for the first time.'});
      expect(badge.name, 'First Steps');
      expect(badge.description, 'Finished a treadmill workout for the first time.');
      final noEn = BadgeDef.fromJson({'code': 'x', 'name': '이름', 'description': '설명'});
      expect(noEn.name, '이름');
    });

    test('badge progress text uses plurals instead of unit concatenation', () {
      useLanguage(AppLanguage.en);
      BadgeDef def(BadgeMetric metric, double goal) =>
          BadgeDef(code: 'c', name: 'n', description: 'd', icon: 'flag', tier: BadgeTier.bronze, metric: metric, goal: goal);
      const stats = BadgeStats(sessions: 3, distanceMeters: 12400, branches: 1, bestStreakWeeks: 2, openRuns: 0);
      expect(def(BadgeMetric.sessions, 10).progressLabel(stats), '3 / 10 workouts');
      expect(def(BadgeMetric.sessions, 1).progressLabel(stats), '1 / 1 workout');
      expect(def(BadgeMetric.distanceMeters, 42195).progressLabel(stats), '12.4 / 42.2km');
      expect(def(BadgeMetric.streakWeeks, 4).progressLabel(stats), '2 / 4 weeks');
      expect(def(BadgeMetric.branches, 3).progressLabel(stats), '1 / 3 locations');
      expect(def(BadgeMetric.openRuns, 3).progressLabel(stats), '0 / 3 open runs');
    });

    test('points notes', () {
      useLanguage(AppLanguage.en);
      expect(PointsNote.tooShort.message, "Workouts under 5 minutes don't count toward points.");
      expect(PointsNote.dailyLimit.message, 'You can earn points once a day.');
    });
  });

  group('widgets in English', () {
    testWidgets('podium semantics, leaderboard tile and points sheet', (tester) async {
      final entry = LeaderboardEntry(
        rank: 5,
        dogId: 'd5',
        dogName: 'Maple',
        nickname: 'MapleMom',
        points: 241,
        sessionCount: 4,
        distanceMeters: 3000,
        participantCount: 9,
        isMine: true,
        cheerCount: 2,
        breedLabel: '말티즈',
        breedLabelEn: 'Maltese',
        title: RankingTitle(
            periodMonth: DateTime(2026, 10), scope: RankingScope.size, label: '소형견', labelEn: 'Small dogs', rank: 1),
      );
      await tester.pumpWidget(_enApp(Scaffold(body: LeaderboardTile(entry: entry))));

      expect(find.text('Your dog'), findsOneWidget);
      expect(find.text('Oct #1 Small dogs'), findsOneWidget);
      expect(find.text('241 pts'), findsOneWidget);
      expect(find.text('@MapleMom · Maltese'), findsOneWidget);

      await tester.pumpWidget(_enApp(const Scaffold(
        body: PointsChip(
          summary: SessionPointsSummary(
              total: 60, attendance: 10, achievement: 10, distance: 20, weeklyBonus: 20),
        ),
      )));
      expect(find.text('+60 pts'), findsOneWidget);
    });

    testWidgets('score rules sheet and breakdown sheet', (tester) async {
      await tester.pumpWidget(_enApp(Builder(
        builder: (context) => Scaffold(
          body: Column(children: [
            TextButton(onPressed: () => showScoreRulesSheet(context), child: const Text('rules')),
            TextButton(
              onPressed: () => showPointsBreakdownSheet(
                  context,
                  const SessionPointsSummary(
                      total: 60, attendance: 10, achievement: 10, distance: 20, weeklyBonus: 20)),
              child: const Text('breakdown'),
            ),
          ]),
        ),
      )));

      await tester.tap(find.text('rules'));
      await tester.pumpAndSettle();
      expect(find.text('How points add up'), findsOneWidget);
      expect(find.text('Weekly bonus: 20 pts'), findsOneWidget);
      expect(find.text('Hall of Fame'), findsOneWidget);
      Navigator.of(tester.element(find.text('How points add up'))).pop();
      await tester.pumpAndSettle();

      await tester.tap(find.text('breakdown'));
      await tester.pumpAndSettle();
      expect(find.text('Points for this workout'), findsOneWidget);
      expect(find.text('Attendance'), findsOneWidget);
      expect(find.text('Your 2nd workout this week'), findsOneWidget);
      expect(find.text('Total'), findsOneWidget);
    });

    testWidgets('badge collection screen', (tester) async {
      const catalog = [
        BadgeDef(
            code: 'first_run', name: '첫 발걸음', nameEn: 'First Steps', description: '처음으로 운동을 마쳤어요.',
            descriptionEn: 'Finished a treadmill workout for the first time.', icon: 'flag',
            tier: BadgeTier.bronze, metric: BadgeMetric.sessions, goal: 1),
        BadgeDef(
            code: 'sessions_10', name: '열 번째 운동', nameEn: 'Tenth Workout', description: '운동을 10번 마쳤어요.',
            descriptionEn: 'Finished 10 workouts.', icon: 'run',
            tier: BadgeTier.bronze, metric: BadgeMetric.sessions, goal: 10),
        BadgeDef(
            code: 'podium', name: '시상대', nameEn: 'Podium', description: '월간 랭킹에서 3위 안에 들었어요.',
            descriptionEn: 'Placed in the top 3 of a monthly ranking.', icon: 'trophy', tier: BadgeTier.gold),
      ];
      final achievements = DogAchievements(
        stats: const BadgeStats(sessions: 3, distanceMeters: 4200, streakWeeks: 2, bestStreakWeeks: 2, branches: 1),
        badges: [EarnedBadge(code: 'first_run', earnedAt: DateTime(2026, 11, 2))],
        awards: [
          AwardRecord(
              periodMonth: DateTime(2026, 10),
              scope: RankingScope.all,
              scopeKey: 'all',
              scopeLabel: '전체',
              scopeLabelEn: 'Overall',
              rank: 1,
              points: 100),
        ],
      );

      await tester.pumpWidget(_enApp(
        const BadgeCollectionScreen(dogId: 'd1'),
        overrides: [
          dogDetailProvider.overrideWith((ref, id) async => const Dog(id: 'd1', ownerId: 'me', name: 'Kongi')),
          dogAchievementsProvider.overrideWith((ref, id) async => achievements),
          badgeCatalogProvider.overrideWith((ref) async => catalog),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text("Kongi's badge collection"), findsOneWidget);
      expect(find.text('Earned Nov 2, 2026'), findsOneWidget);
      expect(find.text('3 / 10 workouts'), findsOneWidget);
      expect(find.text('First Steps'), findsOneWidget);
      expect(find.text('Awarded when the monthly ranking closes'), findsOneWidget);
      expect(find.text('Oct #1 Overall · 100 pts'), findsOneWidget);
      expect(find.text('Awards'), findsOneWidget);
      expect(find.text('Total distance'), findsOneWidget);
    });

    testWidgets('ranking screen: join prompt and sticky bar', (tester) async {
      const dog = Dog(id: 'my-dog', ownerId: 'me', name: 'Kongi', size: DogSize.small);
      final mine = MyRanking(
        dogId: dog.id,
        periodMonth: RankingMonth.current(),
        participating: false,
        nickname: 'KongiMom',
        points: 40,
        sessionCount: 1,
        distanceMeters: 2500,
        weeklyBonusCount: 0,
        streakWeeks: 0,
        ranks: const [
          ScopeRank(
              scope: RankingScope.all,
              scopeKey: 'all',
              label: '전체',
              labelEn: 'Overall',
              rank: 2,
              participantCount: 4,
              points: 40,
              topPercent: 50,
              pointsToNext: 7),
        ],
      );
      LeaderboardEntry entry(int rank, String name) => LeaderboardEntry(
            rank: rank,
            dogId: 'dog-$rank',
            dogName: name,
            nickname: '$name-owner',
            points: 800 - rank * 100,
            sessionCount: 3,
            distanceMeters: 4200,
            participantCount: 4,
          );

      await tester.pumpWidget(_enApp(
        const RankingScreen(),
        overrides: [
          selectedDogProvider.overrideWithValue(const AsyncData(dog)),
          branchesProvider.overrideWith((ref) async => const <Branch>[]),
          currentUserProfileProvider.overrideWith(
            (ref) async => const AppUser(id: 'me', name: 'Kim', role: 'user', notificationPrefs: NotificationPrefs()),
          ),
          rankingConsentGrantedProvider.overrideWith((ref) => false),
          leaderboardProvider.overrideWith((ref, query) async => [entry(1, 'Bori'), entry(2, 'Hodu'), entry(3, 'Moca'), entry(4, 'Maple')]),
          myRankingProvider.overrideWith((ref, key) async => mine),
          branchBattleProvider.overrideWith((ref, month) async => const []),
          hallOfFameProvider.overrideWith((ref) async => const []),
        ],
      ));
      await tester.pumpAndSettle();

      expect(find.text('Rankings'), findsOneWidget);
      expect(find.text('Dog rankings'), findsOneWidget);
      expect(find.text('Location battle'), findsOneWidget);
      expect(find.text('Join and Kongi will be #2 overall'), findsOneWidget);
      expect(find.text('Join'), findsOneWidget);
      expect(find.text('Kongi · #2 if you join'), findsOneWidget);
      expect(find.text('40 pts · 7 more pts to move up'), findsOneWidget);
      expect(find.text('4 dogs competing'), findsOneWidget);
      expect(find.text('Overall'), findsOneWidget, reason: 'scope segment');
    });
  });
}
