import 'package:dog_treadmill_app/core/utils/formatters.dart';
import 'package:dog_treadmill_app/core/utils/validators.dart';
import 'package:dog_treadmill_app/features/dogs/data/dog.dart';
import 'package:dog_treadmill_app/features/exercise/data/exercise_session.dart';
import 'package:dog_treadmill_app/features/profile/data/app_user.dart';
import 'package:dog_treadmill_app/features/ranking/data/ranking_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ko_KR'));

  group('RankingMonth', () {
    test('한국 시간 기준으로 이번 달을 정한다 (UTC 15시 = 다음 날 0시)', () {
      expect(RankingMonth.current(now: DateTime.utc(2026, 10, 31, 14, 59)), DateTime(2026, 10));
      expect(RankingMonth.current(now: DateTime.utc(2026, 10, 31, 15)), DateTime(2026, 11));
    });

    test('이전·다음 달은 연도를 넘긴다', () {
      expect(RankingMonth.previous(DateTime(2026, 1)), DateTime(2025, 12));
      expect(RankingMonth.next(DateTime(2026, 12)), DateTime(2027, 1));
    });

    test('같은 조건의 순위표 조회는 같은 키다 (Provider 캐시)', () {
      final a = RankingQuery(month: DateTime(2026, 11), scope: RankingScope.size, scopeKey: 'small');
      final b = RankingQuery(month: DateTime(2026, 11), scope: RankingScope.size, scopeKey: 'small');
      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a == RankingQuery(month: DateTime(2026, 11)), isFalse);
    });
  });

  test('지점 이름은 좁은 곳에서 "용산점"처럼 줄인다', () {
    expect(shortBranchName('용산 아이파크몰점'), '용산점');
    expect(shortBranchName('영등포 타임스퀘어점'), '영등포점');
    expect(shortBranchName('테스트지점'), '테스트지점');
  });

  test('순위표 행: 닉네임·견종·지난달 칭호', () {
    final entry = LeaderboardEntry.fromJson({
      'rank': 2,
      'dog_id': 'd1',
      'dog_name': '콩이',
      'breed_label': '말티즈',
      'size_class': 'small',
      'photo_path': null,
      'nickname': '콩이맘',
      'main_branch_name': '용산 아이파크몰점',
      'points': '438',
      'session_count': 9,
      'distance_meters': '15230.5',
      'cheer_count': 3,
      'cheered_by_me': true,
      'is_mine': false,
      'title_period': '2026-10-01',
      'title_scope': 'branch',
      'title_label': '용산 아이파크몰점',
      'title_rank': 1,
      'participant_count': 87,
    });
    expect(entry.size, DogSize.small);
    expect(entry.points, 438);
    expect(entry.distanceMeters, 15230.5);
    expect(entry.title?.text, '10월 용산점 1위');

    final noTitle = LeaderboardEntry.fromJson({
      'rank': 1,
      'dog_id': 'd2',
      'dog_name': '보리',
      'nickname': '보리아빠',
      'points': 10,
      'session_count': 1,
      'distance_meters': 0,
      'participant_count': 1,
      'title_period': null,
    });
    expect(noTitle.title, isNull);
  });

  test('내 순위: 범위별 순위와 다음 순위까지 남은 점수', () {
    final ranking = MyRanking.fromJson({
      'dog_id': 'd1',
      'period_month': '2026-11-01',
      'participating': false,
      'nickname': '콩이맘',
      'points': 40,
      'session_count': 1,
      'distance_meters': 2500,
      'weekly_bonus_count': 0,
      'streak_weeks': 3,
      'ranks': [
        {'scope': 'all', 'scope_key': 'all', 'label': '전체', 'rank': 2, 'participant_count': 4, 'points': 40,
         'points_to_next': 1, 'top_percent': 50},
        {'scope': 'branch', 'scope_key': 'b1', 'label': '용산 아이파크몰점', 'rank': 1, 'participant_count': 2,
         'points': 40, 'points_to_next': null, 'top_percent': 50},
        {'scope': 'size', 'scope_key': 'small', 'label': '소형견', 'rank': 3, 'participant_count': 3,
         'points': 40, 'points_to_next': 5, 'top_percent': 100},
      ],
    });
    expect(ranking.periodMonth, DateTime(2026, 11));
    expect(ranking.participating, isFalse);
    expect(ranking.overall?.pointsToNext, 1);
    expect(ranking.mainBranch?.shortText, '용산점 1위');
    expect(ranking.mainBranch?.pointsToNext, isNull, reason: '1위면 앞지를 순위가 없다');
    expect(ranking.sizeRank?.shortText, '소형견 3위');
    expect(ranking.rankFor(RankingScope.branch, 'b2'), isNull);
  });

  group('배지 진행률', () {
    const stats = BadgeStats(sessions: 3, distanceMeters: 12430, streakWeeks: 1, bestStreakWeeks: 3, branches: 1);

    BadgeDef badge(String metric, num goal) =>
        BadgeDef.fromJson({'code': metric, 'name': metric, 'description': '', 'metric': metric, 'goal': goal});

    test('횟수·거리·연속 주', () {
      expect(badge('sessions', 10).progress(stats), closeTo(0.3, 1e-9));
      expect(badge('sessions', 10).progressLabel(stats), '3 / 10회');
      expect(badge('distance_meters', 42195).progressLabel(stats), '12.4 / 42.2km');
      expect(badge('streak_weeks', 4).progressLabel(stats), '3 / 4주', reason: '연속 출석은 최장 기록 기준');
      expect(badge('branches', 3).progressLabel(stats), '1 / 3곳');
    });

    test('목표를 넘으면 100%로 멈춘다', () {
      expect(badge('sessions', 2).progress(stats), 1.0);
      expect(badge('sessions', 2).progressLabel(stats), '2 / 2회');
    });

    test('월간 마감 때 주는 배지는 진행률이 없다', () {
      final podium = BadgeDef.fromJson({'code': 'podium', 'name': '시상대', 'description': '', 'tier': 'gold'});
      expect(podium.tier, BadgeTier.gold);
      expect(podium.progress(stats), isNull);
      expect(podium.progressLabel(stats), isNull);
    });
  });

  group('운동 점수', () {
    test('운동 기록에 붙은 점수와 주간 보너스를 합친다', () {
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
           'bonus_points': 0, 'points': 40, 'note': null, 'voided_at': null},
          {'kind': 'weekly_bonus', 'attendance_points': 0, 'achievement_points': 0, 'distance_points': 0,
           'bonus_points': 20, 'points': 20, 'note': null, 'voided_at': null},
        ],
      });
      final summary = session.pointsSummary!;
      expect(summary.total, 60);
      expect(summary.weeklyBonus, 20);
      expect(summary.note, isNull);
    });

    test('0점인 이유와 무효 처리', () {
      final limited = SessionPointsSummary.of([
        SessionPoints.fromJson(const {'kind': 'session', 'points': 0, 'note': 'daily_limit'}),
      ])!;
      expect(limited.total, 0);
      expect(limited.note, PointsNote.dailyLimit);

      final voided = SessionPointsSummary.of([
        SessionPoints.fromJson(const {
          'kind': 'session',
          'attendance_points': 10,
          'points': 10,
          'voided_at': '2026-11-04T00:00:00Z',
        }),
      ])!;
      expect(voided.voided, isTrue);
      expect(voided.total, 0);
    });

    test('점수 기록이 없는 운동(Realtime 행 등)은 null', () {
      expect(SessionPointsSummary.of(const []), isNull);
    });
  });

  group('닉네임·알림 설정', () {
    test('자동 닉네임은 바로 바꿀 수 있고, 바꾼 뒤에는 30일을 기다린다', () {
      final auto = AppUser.fromJson(const {
        'id': 'u1',
        'name': '김보호',
        'role': 'user',
        'nickname': '씩씩한발바닥0427',
        'nickname_updated_at': null,
      });
      expect(auto.nicknameChangeableAt(), isNull);
      expect(auto.rankingShowPhoto, isTrue);

      final changed = AppUser.fromJson(const {
        'id': 'u1',
        'name': '김보호',
        'role': 'user',
        'nickname': '콩이맘',
        'nickname_updated_at': '2026-11-01T00:00:00Z',
      });
      expect(changed.nicknameChangeableAt(now: DateTime.utc(2026, 11, 20)), DateTime.utc(2026, 12, 1));
      expect(changed.nicknameChangeableAt(now: DateTime.utc(2026, 12, 2)), isNull);
    });

    test('랭킹 알림 키가 없던 회원은 켜진 것으로 본다', () {
      final prefs = NotificationPrefs.fromJson(const {'booking': true, 'exercise': false, 'analysis': true});
      expect(prefs.ranking, isTrue);
      expect(prefs.copyWith(ranking: false).toJson()['ranking'], isFalse);
    });

    test('닉네임 검증은 DB 제약과 같다', () {
      expect(Validators.nickname('콩이맘'), isNull);
      expect(Validators.nickname('Coco_Mom1'), isNull);
      expect(Validators.nickname(' 단 '), isNotNull);
      expect(Validators.nickname('열세글자가넘는아주긴닉네임'), isNotNull);
      expect(Validators.nickname('hello world'), isNotNull);
      expect(Validators.nickname('ㅋㅋ'), isNotNull, reason: '자모만 있는 글자는 안 된다');
    });

    test('점수·월·거리 표시', () {
      expect(Fmt.points(1234), '1,234점');
      expect(Fmt.month(DateTime(2026, 11)), '11월');
      expect(Fmt.km(12430), '12.4km');
    });
  });
}
