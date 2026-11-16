import 'package:dog_treadmill_app/core/utils/error_messages.dart';
import 'package:dog_treadmill_app/core/utils/json.dart';
import 'package:dog_treadmill_app/demo/demo_auth.dart';
import 'package:dog_treadmill_app/demo/demo_repositories.dart';
import 'package:dog_treadmill_app/demo/mock_server/catalog.dart';
import 'package:dog_treadmill_app/demo/mock_server/mock_server.dart';
import 'package:dog_treadmill_app/features/booking/data/booking_models.dart';
import 'package:dog_treadmill_app/features/consents/data/consent.dart';
import 'package:dog_treadmill_app/features/ranking/data/ranking_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// 목업 서버가 실제 DB 함수(supabase/migrations)와 같은 규칙·같은 오류 코드로 동작하는지 확인한다.

const _choco = '5eedd000-0000-4000-8000-000000000006'; // 초코러버의 초코
const _chocoOwner = '5eed0000-0000-4000-8000-000000000005';
const _happy = '5eedd000-0000-4000-8000-000000000007'; // 랭킹에 참여하지 않은 산책왕의 해피

/// 지연·타이머 없이 데모 보호자로 로그인한 목업 서버
MockServer _server() {
  final server = MockServer(latency: Duration.zero, randomSeed: 7);
  server.treadmill
    ..autoTick = false
    ..autoStartAfterCheckIn = null;
  server.analysis.autoProcess = false;
  server.db.currentUserId = DemoAccount.userId;
  return server;
}

Matcher _rpcError(String message) => throwsA(isA<PostgrestException>().having((e) => e.message, 'message', message));

/// 오늘부터 [days]일 뒤 한국 시간 [hour]:[minute]
DateTime _at(int days, int hour, [int minute = 0]) =>
    Kst.at(Kst.date(DateTime.now()).add(Duration(days: days)), hour * 60 + minute);

List<Json> _notifications(MockServer server, String userId) =>
    server.db.where('notifications', (n) => n['user_id'] == userId).toList();

void main() {
  test('샘플 데이터: 두부는 운동 29회이고, 곧 시작하는 예약은 지금 체크인할 수 있다', () {
    final server = _server();
    final stats = server.ranking.achievements(DemoAccount.tofuId).objOrNull('stats')!;
    expect(stats['sessions'], DemoAccount.tofuSessionsBeforeDemo);

    final next = Booking.fromJson(server.booking.nextBooking(DemoAccount.tofuId)!);
    expect(next.canCheckIn(), isTrue);
    expect(next.status, BookingStatus.confirmed);
    expect(server.ranking.hallOfFame(), isNotEmpty);
  });

  test('예약: 이용권으로 예약하면 확정·1회 차감, 같은 시간 중복은 거절, 취소하면 복구', () {
    final server = _server();
    final membership = server.db.find(
      'memberships',
      (m) => m['user_id'] == DemoAccount.userId && m['status'] == 'active' && m.intOr('remaining_sessions') > 0,
    )!;
    final remaining = membership.intOr('remaining_sessions');

    Json book() => server.booking.createBooking(
          dogId: DemoAccount.tofuId,
          branchId: MockCatalog.yongsan,
          programId: MockCatalog.jointCare,
          startAt: _at(3, 11),
          membershipId: membership.str('id'),
        );
    final booking = book();
    expect(booking['status'], 'confirmed');
    expect(membership.intOr('remaining_sessions'), remaining - 1);
    expect(book, _rpcError('DOG_ALREADY_BOOKED'));

    server.booking.cancelBooking(booking.str('id'), reason: '일정 변경');
    expect(server.db.byId('bookings', booking.str('id'))!['status'], 'cancelled');
    expect(membership.intOr('remaining_sessions'), remaining);
  });

  test('예약: 지난 시간·정각/30분이 아닌 시간·영업시간 밖은 거절하고, 이용권이 없으면 예약 대기', () {
    final server = _server();
    Json book(DateTime startAt) => server.booking.createBooking(
          dogId: DemoAccount.mangoId,
          branchId: MockCatalog.yongsan,
          programId: MockCatalog.dailyWalk,
          startAt: startAt,
        );
    expect(() => book(DateTime.now().subtract(const Duration(hours: 1))), _rpcError('SLOT_IN_PAST'));
    expect(() => book(_at(4, 11, 10)), _rpcError('SLOT_NOT_AVAILABLE'));
    expect(() => book(_at(4, 20, 30)), _rpcError('SLOT_NOT_AVAILABLE'), reason: '용산은 20:30에 닫는다');
    expect(book(_at(4, 11))['status'], 'pending');
  });

  test('예약 가능 시간: 지난 슬롯은 빼고, 예약이 생기면 남은 대수가 줄어든다', () {
    final server = _server();
    final date = Kst.date(DateTime.now()).add(const Duration(days: 5));
    int available() => server.booking
        .availableSlots(branchId: MockCatalog.yongsan, date: date, programId: MockCatalog.gaitCheck)
        .firstWhere((s) => s['slot_start'] == iso(Kst.at(date, 11 * 60)))
        .intOr('available_count');

    final before = available();
    server.booking.createBooking(
      dogId: DemoAccount.mangoId,
      branchId: MockCatalog.yongsan,
      programId: MockCatalog.gaitCheck,
      startAt: Kst.at(date, 11 * 60),
    );
    expect(available(), before - 1);

    final today = server.booking.availableSlots(
      branchId: MockCatalog.yongsan,
      date: Kst.date(DateTime.now()),
      programId: MockCatalog.gaitCheck,
    );
    expect(today.every((s) => DateTime.parse(s.str('slot_start')).isAfter(DateTime.now())), isTrue);
  });

  test('셀프 체크인: 시작 15분 전부터 종료 전까지만', () {
    final server = _server();
    final later = server.booking
        .bookingsOf(DemoAccount.userId)
        .firstWhere((b) => b['status'] == 'confirmed' && b.dateTime('start_at').isAfter(_at(1, 0)));
    expect(() => server.booking.selfCheckIn(later.str('id')), _rpcError('CHECK_IN_TOO_EARLY'));

    final missed = server.db.insert('bookings', {
      'user_id': DemoAccount.userId,
      'dog_id': DemoAccount.mangoId,
      'branch_id': MockCatalog.yongsan,
      'treadmill_id': MockCatalog.treadmillId(MockCatalog.yongsan, 1),
      'start_at': iso(DateTime.now().subtract(const Duration(minutes: 40))),
      'end_at': iso(DateTime.now().subtract(const Duration(minutes: 15))),
      'status': 'confirmed',
    });
    expect(() => server.booking.selfCheckIn(missed.str('id')), _rpcError('CHECK_IN_CLOSED'));

    final soon = server.booking.nextBooking(DemoAccount.tofuId)!;
    server.booking.selfCheckIn(soon.str('id'));
    expect(server.db.byId('bookings', soon.str('id'))!['status'], 'checked_in');
    expect(() => server.booking.selfCheckIn(soon.str('id')), _rpcError('INVALID_BOOKING_STATUS'));
  });

  test('트레드밀 흐름: 체크인 → 실시간 지표 → 완료하면 점수·30회 배지·알림 → AI 리포트', () {
    final server = _server();
    server.treadmill.autoStartAfterCheckIn = Duration.zero;
    final soon = server.booking.nextBooking(DemoAccount.tofuId)!;
    server.booking.selfCheckIn(soon.str('id'));

    final session = server.db.find('exercise_sessions', (s) => s['booking_id'] == soon['id'])!;
    expect(session['status'], 'running');
    server.treadmill.tick(60);
    expect(session.intOr('duration_seconds'), 60);
    expect(session.dblOr('distance_meters'), greaterThan(0));
    expect(session.dblOr('current_speed'), greaterThan(0));

    server.treadmill.completeNow(session.str('id'));
    expect(session['status'], 'completed');
    expect(session.intOr('duration_seconds'), 15 * 60);
    expect(server.db.byId('bookings', soon.str('id'))!['status'], 'completed');

    final points = server.db.where('exercise_points', (p) => p['session_id'] == session['id']).toList();
    final main = points.singleWhere((p) => p['kind'] == 'session');
    expect(main.intOr('attendance_points'), 10);
    expect(main.intOr('achievement_points'), 10);
    expect(main.intOr('distance_points'), (session.dblOr('distance_meters') / 100).floor().clamp(0, 20));
    final total = points.fold<int>(0, (sum, p) => sum + p.intOr('points'));

    final badge =
        server.db.find('dog_badges', (b) => b['dog_id'] == DemoAccount.tofuId && b['badge_code'] == 'sessions_30');
    expect(badge, isNotNull, reason: '데모 전 29회 + 1회 = 30회 「단골 러너」');

    final bodies = _notifications(server, DemoAccount.userId).map((n) => '${n['title']}|${n['body']}').toList();
    expect(bodies, contains('운동을 시작했어요|두부의 트레드밀 운동이 시작되었습니다. 실시간 현황을 확인해 보세요.'));
    expect(bodies, contains('운동을 완료했어요|두부의 운동이 끝났어요. $total점을 받았어요! 운동 기록을 확인해 보세요.'));
    expect(bodies, contains('새 배지를 받았어요|두부의 「단골 러너」 배지가 도착했어요. 배지함에서 확인해 보세요.'));

    final report = server.db.find('analysis_reports', (r) => r['session_id'] == session['id'])!;
    expect(report['analysis_status'], 'queued', reason: '영상 촬영 동의자만 분석 대기열에 오른다');
    server.analysis.completeAllPending();
    expect(report['analysis_status'], 'completed');
    expect(report.objOrNull('gait_metrics'), isNotNull);
    final arrived = _notifications(server, DemoAccount.userId)
        .where((n) => n.objOrNull('data')?['report_id'] == report['id'])
        .toList();
    expect(arrived.single['title'], 'AI 보행 분석 리포트가 도착했어요');
  });

  test('비상정지: 중단해도 감점 없이 한 만큼 점수를 받고, 사유를 알린다', () {
    final server = _server();
    final session = server.treadmill.startForDog(DemoAccount.mangoId);
    server.treadmill.tick(400);
    server.treadmill.finish(session.str('id'), completed: false, stopReason: '비상정지 버튼으로 중단');

    expect(session['status'], 'stopped');
    final main = server.db.find('exercise_points', (p) => p['session_id'] == session['id'] && p['kind'] == 'session')!;
    expect(main.intOr('attendance_points'), 10, reason: '5분 이상이면 출석 점수');
    expect(main.intOr('achievement_points'), (10 * 400 / (15 * 60)).floor());
    expect(
      _notifications(server, DemoAccount.userId).map((n) => n['body']),
      contains('망고의 운동이 중단되었습니다. 사유: 비상정지 버튼으로 중단'),
    );
  });

  test('점수 규칙: 5분 미만 0점, 같은 날 두 번째 0점, 주 2회째에 보너스 20점, 상한', () {
    final server = _server();
    final dogId = server.db.insert('dogs', {
      'owner_id': DemoAccount.userId,
      'name': '시험견',
      'size_class': 'small',
      'deleted_at': null,
    }).str('id');
    Json run(DateTime startedAt, int seconds, double meters) {
      final session = server.db.insert('exercise_sessions', {
        'dog_id': dogId,
        'booking_id': null,
        'treadmill_id': MockCatalog.treadmillId(MockCatalog.yongsan, 1),
        'status': 'completed',
        'started_at': iso(startedAt),
        'ended_at': iso(startedAt.add(Duration(seconds: seconds))),
        'duration_seconds': seconds,
        'distance_meters': meters,
        'target_duration_seconds': 1200,
      });
      server.ranking.awardSessionPoints(session);
      return server.db.find('exercise_points', (p) => p['session_id'] == session['id'] && p['kind'] == 'session')!;
    }

    final monday = Kst.weekStart(Kst.date(DateTime.now())).subtract(const Duration(days: 21));
    final short = run(Kst.at(monday, 11 * 60), 200, 150);
    expect((short['note'], short.intOr('points')), ('too_short', 0));

    final first = run(Kst.at(monday, 15 * 60), 600, 650); // 목표 20분 중 10분, 650m
    expect((first.intOr('attendance_points'), first.intOr('achievement_points'), first.intOr('distance_points')),
        (10, 5, 6));

    final again = run(Kst.at(monday, 18 * 60), 1200, 1500);
    expect((again['note'], again.intOr('points')), ('daily_limit', 0));

    final wednesday = run(Kst.at(monday.add(const Duration(days: 2)), 11 * 60), 1500, 2600);
    expect(wednesday.intOr('points'), 10 + 10 + 20, reason: '달성 10점·거리 20점이 상한');
    final bonus = server.db.find('exercise_points', (p) => p['dog_id'] == dogId && p['kind'] == 'weekly_bonus')!;
    expect((bonus.intOr('points'), bonus['session_id']), (20, wednesday['session_id']));
  });

  test('랭킹: 동의하지 않은 보호자는 순위표에 없지만 지점 대항전 거리에는 들어간다', () {
    final server = _server();
    final month = server.ranking.currentMonth();
    double goyang() => server.ranking
        .branchBattle(month)
        .firstWhere((b) => b['branch_id'] == MockCatalog.goyang)
        .dblOr('distance_meters');
    final before = goyang();

    final booking = server.db.insert('bookings', {
      'user_id': '5eed0000-0000-4000-8000-000000000006',
      'dog_id': _happy,
      'branch_id': MockCatalog.goyang,
      'treadmill_id': MockCatalog.treadmillId(MockCatalog.goyang, 1),
      'program_id': MockCatalog.dailyWalk,
      'start_at': iso(DateTime.now()),
      'end_at': iso(DateTime.now().add(const Duration(minutes: 25))),
      'status': 'checked_in',
    });
    final session = server.treadmill.startSession(booking.str('id'));
    server.treadmill.completeNow(session.str('id'));

    expect(goyang(), closeTo(before + session.dblOr('distance_meters'), 0.01));
    final names = server.ranking
        .leaderboard(month: month, scope: 'all', scopeKey: 'all', limit: 100)
        .map((r) => r['dog_name'])
        .toList();
    expect(names, isNot(contains('해피')));
    expect(names, contains('두부'));
  });

  test('내 순위: 바로 위 순위를 앞지르는 데 필요한 점수와 상위 %', () {
    final server = _server();
    final month = server.ranking.currentMonth();
    final mine = MyRanking.fromJson(server.ranking.myRanking(DemoAccount.tofuId, month));
    final overall = mine.overall!;
    final board = server.ranking
        .leaderboard(month: month, scope: 'all', scopeKey: 'all', limit: 100)
        .map(LeaderboardEntry.fromJson)
        .toList();
    final index = board.indexWhere((e) => e.dogId == DemoAccount.tofuId);

    expect(overall.rank, board[index].rank);
    expect(overall.points, mine.points);
    expect(overall.pointsToNext, index == 0 ? null : board[index - 1].points - overall.points + 1);
    expect(overall.topPercent, (overall.rank * 100 / overall.participantCount).ceil());
    expect(mine.ranks.map((r) => r.scope), containsAllInOrder([RankingScope.all, RankingScope.branch]));
    expect(mine.ranks.last.scope, RankingScope.size);
  });

  test('응원: 내 반려견은 안 되고, 다른 반려견은 한 달에 한 번만 센다', () {
    final server = _server();
    expect(() => server.ranking.cheer(DemoAccount.tofuId), _rpcError('CANNOT_CHEER_OWN_DOG'));
    expect(() => server.ranking.cheer(_happy), _rpcError('DOG_NOT_FOUND'), reason: '랭킹 비참여 반려견');

    final first = server.ranking.cheer(_choco);
    expect(server.ranking.cheer(_choco), first);
    final received = _notifications(server, _chocoOwner).where((n) => n['title'] == '응원이 도착했어요').toList();
    expect(received.single['body'], '두부망고네님이 초코를 응원했어요.');
  });

  test('닉네임: 형식·금칙어·중복·30일 주기', () {
    final server = _server();
    expect(() => server.ranking.setNickname('a'), _rpcError('NICKNAME_INVALID'));
    expect(() => server.ranking.setNickname('관리자두부'), _rpcError('NICKNAME_FORBIDDEN'));
    expect(() => server.ranking.setNickname('콩이맘'), _rpcError('NICKNAME_TAKEN'));
    expect(server.ranking.setNickname('두부언니'), '두부언니');
    expect(() => server.ranking.setNickname('두부엄마'), _rpcError('NICKNAME_COOLDOWN'));
  });

  test('인증: 실제 서버와 같은 오류 코드라 같은 안내 문구가 나온다', () {
    final server = _server();
    final auth = DemoAuth(server)..signOut();
    Matcher message(String text) => throwsA(isA<AuthException>().having(friendlyError, 'friendlyError', text));

    expect(() => auth.signIn(DemoAccount.email, 'wrong-password'), message('이메일 또는 비밀번호가 올바르지 않아요.'));
    void signUp(String email) => auth.signUp(
          email: email,
          password: 'abcd1234',
          name: '새 보호자',
          phone: '010-1111-2222',
          consents: {ConsentType.terms: true, ConsentType.privacy: true, ConsentType.ranking: false},
        );
    expect(() => signUp(DemoAccount.email), message('이미 가입된 이메일이에요.'));

    signUp('new@pawfit.local');
    final user = server.db.byId('users', auth.userId)!;
    expect(user['nickname'], matches(RegExp(r'^[가-힣]+\d{4}$')));
    expect(server.db.hasConsent(auth.userId, 'ranking'), isFalse);
    expect(server.db.hasConsent(auth.userId, 'terms'), isTrue);
  });

  test('데모 저장소: 모든 조회 응답을 실제 모델로 읽는다', () async {
    final server = _server();
    const me = DemoAccount.userId;
    const tofu = DemoAccount.tofuId;
    final month = RankingMonth.current();

    final dogs = await DemoDogRepository(server).fetchDogs(me);
    expect(dogs.map((d) => (d.name, d.breedLabel)), [('두부', '비숑 프리제'), ('망고', '웰시코기')]);
    expect((await DemoDogRepository(server).fetchHealthProfile(tofu))?.conditionCodes, ['joint_disease']);
    expect(await DemoDogRepository(server).fetchBreeds(), hasLength(40));

    final bookings = DemoBookingRepository(server);
    expect(await bookings.fetchBranches(), hasLength(3));
    expect((await bookings.fetchBookings(me)).first.branch, isNotNull);

    final sessions = await DemoExerciseRepository(server).fetchSessions(tofu);
    expect(sessions.where((s) => s.pointsSummary != null), isNotEmpty);
    expect(sessions.where((s) => s.latestReport != null), isNotEmpty);
    expect(await DemoExerciseRepository(server).watchLatestSession(tofu).first, isNotNull);

    final reports = await DemoAnalysisRepository(server).fetchReports(tofu);
    expect(reports.where((r) => r.isCompleted).first.gaitMetrics?.symmetryIndex, isNotNull);
    expect(reports.first.session?.treadmillName, startsWith('T-'));
    expect(await DemoAnalysisRepository(server).fetchActivePlan(tofu), isNotNull);

    expect(await DemoMembershipRepository(server).fetchMemberships(me), hasLength(3));
    expect(await DemoMembershipRepository(server).fetchPayments(me), hasLength(3));
    expect(await DemoNotificationRepository(server).watchNotifications(me).first, isNotEmpty);
    expect((await DemoUserRepository(server).fetchUser(me)).nickname, '두부망고네');
    expect((await DemoConsentRepository(server).fetchLatest(me))[ConsentType.ranking]?.granted, isTrue);

    final ranking = DemoRankingRepository(server);
    expect(await ranking.fetchLeaderboard(RankingQuery(month: month)), isNotEmpty);
    expect(await ranking.fetchBranchBattle(month), hasLength(3));
    expect(await ranking.fetchHallOfFame(), isNotEmpty);
    expect((await ranking.fetchAchievements(tofu)).stats.sessions, DemoAccount.tofuSessionsBeforeDemo);
    expect((await ranking.fetchDogProfile(_choco, month)).isMine, isFalse);
    expect(await ranking.fetchBadgeCatalog(), hasLength(12));

    expect(await DemoSupportRepository(server).fetchFaqs(), hasLength(7));
    expect((await DemoSupportRepository(server).fetchInquiries(me)).single.isAnswered, isTrue);
  });
}
