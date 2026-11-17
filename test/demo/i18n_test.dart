import 'package:dog_treadmill_app/core/utils/json.dart';
import 'package:dog_treadmill_app/demo/demo_app.dart';
import 'package:dog_treadmill_app/demo/demo_repositories.dart';
import 'package:dog_treadmill_app/demo/mock_server/catalog.dart';
import 'package:dog_treadmill_app/demo/mock_server/mock_server.dart';
import 'package:dog_treadmill_app/l10n/app_language.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/l10n.dart';

// 데모 앱의 이중 언어: 목업 서버가 실제 서버 계약(`_en` 컬럼·RPC 필드·알림 msg/args)을 따르고,
// 데모 전용 샘플 값(`__en`)이 현재 언어로 바뀌며, 언어를 바꾸면 화면이 다시 불러오는지 확인한다.

MockServer _server() {
  final server = MockServer(latency: Duration.zero, randomSeed: 7);
  server.treadmill
    ..autoTick = false
    ..autoStartAfterCheckIn = null;
  server.analysis.autoProcess = false;
  server.db.currentUserId = DemoAccount.userId;
  return server;
}

Future<void> _settle(WidgetTester tester, [int frames = 12]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Json _args(Json notification) => (notification['data'] as Json)['args'] as Json;

String _msg(Json notification) => (notification['data'] as Json)['msg'] as String;

void main() {
  setUpAll(initTestLocales);

  group('localizeJson', () {
    final row = <String, dynamic>{
      'name': '두부',
      'name__en': 'Tofu',
      'memo': '그대로',
      'dog': {'name': '망고', 'name__en': 'Mango', 'age': 3},
      'items': [
        {'title': '가', 'title__en': 'A'},
        {'title': '나', 'title__en': null},
      ],
      'data': {
        'args': {'dog_name': '두부', 'dog_name__en': 'Tofu', 'reason': null},
      },
    };

    test('한국어: 값은 그대로 두고 __en 키만 모두 지운다', () {
      final out = localizeRow(row);
      expect(out['name'], '두부');
      expect((out['dog'] as Json)['name'], '망고');
      expect(((out['items'] as List)[0] as Json)['title'], '가');
      expect((((out['data'] as Json)['args']) as Json)['dog_name'], '두부');
      expect(out.toString().contains('__en'), isFalse);
      expect(row['name__en'], 'Tofu', reason: '원본은 바꾸지 않는다');
    });

    test('영어: 임베드·목록·알림 args까지 __en 값으로 바꾸고, 영어 값이 비면 기본값', () {
      useLanguage(AppLanguage.en);
      final out = localizeRow(row);
      expect(out['name'], 'Tofu');
      expect(out['memo'], '그대로');
      expect((out['dog'] as Json)['name'], 'Mango');
      expect((out['dog'] as Json)['age'], 3);
      expect(((out['items'] as List)[0] as Json)['title'], 'A');
      expect(((out['items'] as List)[1] as Json)['title'], '나');
      expect((((out['data'] as Json)['args']) as Json)['dog_name'], 'Tofu');
      expect(out.toString().contains('__en'), isFalse);
    });
  });

  group('목업 서버: 실제 서버 계약', () {
    test('카탈로그 행에 _en 컬럼이 있고 catalog_en.json과 같다', () {
      final db = _server().db;
      final yongsan = db.byId('branches', MockCatalog.yongsan)!;
      expect(yongsan['name'], '용산 아이파크몰점');
      expect(yongsan['name_en'], "Yongsan I'Park Mall");
      expect(yongsan['address_en'], '55 Hangang-daero 23-gil, Yongsan-gu, Seoul (Yongsan I\'Park Mall)');
      expect(db.byId('exercise_programs', MockCatalog.jointCare)!['name_en'], 'Joint Care Walk');
      expect(db.byId('exercise_programs', MockCatalog.jointCare)!['description_en'], isNotEmpty);
      expect(db.byId('membership_plans', MockCatalog.planTen)!['name_en'], '10-session pass');
      expect(db.find('breeds', (b) => b['id'] == 'bichon_frise')!['name_en'], 'Bichon Frise');
      expect(db.find('health_conditions', (c) => c['code'] == 'obesity')!['name_en'], 'Obesity');
      expect(db.find('badges', (b) => b['code'] == 'podium')!['name_en'], 'Podium');
      expect(
          db.table('faqs').every((f) => f['question_en'] != null && f['answer_en'] != null && f['category_en'] != null),
          isTrue);
      expect(db.table('notices').every((n) => n['title_en'] != null && n['body_en'] != null), isTrue);
      // 한국어 값은 그대로
      expect(db.table('notices').first['title'], isNotEmpty);
    });

    test('AI 리포트는 두 언어 문구를 함께 만든다', () {
      final server = _server();
      final reports = server.db.where('analysis_reports', (r) => r['analysis_status'] == 'completed').toList();
      expect(reports, isNotEmpty);
      for (final report in reports) {
        expect(report['summary_en'], isA<String>());
        expect(report['care_notes_en'], isA<List<dynamic>>());
        expect((report['care_notes_en'] as List).length, (report['care_notes'] as List).length);
        final anomaly = report['anomaly_metrics'] as Json;
        expect((anomaly['notes_en'] as List).length, (anomaly['notes'] as List).length);
        for (final finding in anomaly['findings'] as List) {
          expect((finding as Json)['description_en'], isA<String>());
        }
      }
    });

    test('순위·수상 RPC는 _en 필드를 돌려준다', () {
      final ranking = _server().ranking;
      final month = ranking.currentMonth();
      final board = ranking.leaderboard(month: month, scope: 'all', scopeKey: 'all');
      expect(board, isNotEmpty);
      final first = board.first;
      expect(first['breed_label_en'], isA<String>());
      expect(first['main_branch_name_en'], isA<String>());
      expect(first['dog_name__en'], isA<String>());
      expect(first['nickname__en'], isA<String>());

      final mine = ranking.myRanking(DemoAccount.tofuId, month);
      final labels = [for (final r in mine['ranks'] as List) (r as Json)['label_en']];
      expect(labels, contains('Overall'));
      expect(labels, contains('Small dogs'));

      final battle = ranking.branchBattle(month);
      expect({for (final b in battle) b['branch_name_en']},
          {"Yongsan I'Park Mall", 'Goyang Starfield', 'Yeongdeungpo Times Square'});

      final hall = ranking.hallOfFame();
      expect(hall.every((h) => h['scope_label_en'] != null), isTrue);
      final profile = ranking.dogProfile(DemoAccount.tofuId, month);
      expect(profile['breed_label_en'], 'Bichon Frise');
      expect((profile['badges'] as List).every((b) => (b as Json)['name_en'] != null), isTrue);
      expect(ranking.breedLabelEn({'breed': '말티푸', 'is_mixed': true}), 'Mixed (말티푸)');
      expect(ranking.breedLabelEn({'is_mixed': true}), 'Mixed breed');
    });

    test('시드 알림은 한국어 title/body와 함께 msg·args를 가진다', () {
      final notifications = _server().db.where('notifications', (n) => n['user_id'] == DemoAccount.userId).toList();
      final byMsg = {for (final n in notifications) _msg(n): n};
      expect(byMsg.keys, containsAll(['analysis_completed', 'badge_earned', 'cheer_received', 'exercise_completed']));
      expect(byMsg['analysis_completed']!['title'], 'AI 보행 분석 리포트가 도착했어요');
      expect(_args(byMsg['analysis_completed']!)['dog_name'], '두부');
      expect(_args(byMsg['analysis_completed']!)['dog_name__en'], 'Tofu');
      expect(_args(byMsg['cheer_received']!)['nickname'], '콩이맘');
      expect(_args(byMsg['cheer_received']!)['nickname__en'], 'BeanMom');
      final badge = _args(byMsg['badge_earned']!);
      expect(badge['badge_code'], isA<String>());
      expect(badge['badge_name'], isA<String>());
      expect(badge['badge_name_en'], isA<String>());
      expect(_args(byMsg['exercise_completed']!)['points'], isA<int>());
      final award = notifications.where((n) => _msg(n) == 'monthly_award');
      for (final n in award) {
        final args = _args(n);
        expect(args['month'], isA<int>());
        final awards = args['awards'] as List;
        expect(awards, isNotEmpty);
        expect((awards.first as Json).keys, containsAll(['scope', 'label', 'label_en', 'rank']));
        expect((n['data'] as Json)['period_month'], isA<String>());
      }
      // 기존 data 키는 그대로
      expect((byMsg['analysis_completed']!['data'] as Json)['report_id'], isA<String>());
      expect((byMsg['badge_earned']!['data'] as Json)['dog_id'], isA<String>());
    });

    test('운동 시작·완료·중단, 분석 완료, 응원 알림도 msg·args를 가진다', () {
      final server = _server();
      final db = server.db;
      Json latest(String msg) =>
          (db.where('notifications', (n) => n['user_id'] == DemoAccount.userId && _msg(n) == msg).toList()
                ..sort((a, b) => b.str('created_at').compareTo(a.str('created_at'))))
              .first;

      final started = server.treadmill.startForDog(DemoAccount.tofuId);
      expect(_args(latest('exercise_started')), {'dog_name': '두부', 'dog_name__en': 'Tofu'});
      server.treadmill.finish(started.str('id'),
          completed: false, stopReason: '비상정지 버튼으로 중단', stopReasonEn: 'Stopped with the emergency stop button');
      final stopped = _args(latest('exercise_stopped'));
      expect(stopped['reason'], '비상정지 버튼으로 중단');
      expect(stopped['reason__en'], 'Stopped with the emergency stop button');

      final second = server.treadmill.startForDog(DemoAccount.mangoId);
      server.treadmill.completeNow(second.str('id'));
      expect(_args(latest('exercise_completed')).keys, containsAll(['dog_name', 'points']));
      server.analysis.completeAllPending();
      expect(_args(latest('analysis_completed'))['dog_name'], isNotNull);

      // 다른 보호자의 응원
      final nickname = server.cheerFromAnotherUser(DemoAccount.mangoId);
      expect(nickname, isNotNull);
      final cheer = _args(latest('cheer_received'));
      expect(cheer['nickname'], nickname);
      expect(cheer['nickname__en'], isA<String>());
      expect(cheer['dog_name'], '망고');
    });

    test('저장소 JSON: 반려견·예약의 breed_catalog, 영어 화면의 __en 처리', () async {
      final server = _server();
      final dogs = DemoDogRepository(server);
      final list = await dogs.fetchDogs(DemoAccount.userId);
      expect(list.map((d) => d.name), ['두부', '망고']);

      final dog = server.db.dogWithBreedCatalog(server.db.byId('dogs', DemoAccount.tofuId)!);
      expect(dog['breed_catalog'], {'name_en': 'Bichon Frise'});
      expect(server.db.dogWithBreedCatalog({'breed_id': null})['breed_catalog'], isNull);
      final booking = server.booking.bookingsOf(DemoAccount.userId).first;
      final embedded = booking['dog'] as Json;
      expect(embedded['breed_catalog'], isA<Map<String, dynamic>>());
      expect(booking['branch'], containsPair('name_en', isA<String>()));
      expect(booking['program'], containsPair('name_en', isA<String>()));

      useLanguage(AppLanguage.en);
      expect((await dogs.fetchDogs(DemoAccount.userId)).map((d) => d.name), ['Tofu', 'Mango']);
      final notices = await DemoSupportRepository(server).fetchInquiries(DemoAccount.userId);
      expect(notices.first.title, 'Could I move my booking 30 minutes later?');

      // 이름을 바꾸면 샘플 영어 이름 대신 입력한 값
      final tofu = await dogs.fetchDog(DemoAccount.tofuId);
      expect(tofu.name, 'Tofu');
    });

    test('영어 화면에서 가입하면 영어 닉네임, 한국어면 한국어 닉네임', () {
      final server = _server();
      useLanguage(AppLanguage.en);
      for (var i = 0; i < 20; i++) {
        final nickname = server.ranking.generateNickname();
        expect(RegExp(r'^[A-Za-z0-9_]{1,12}$').hasMatch(nickname), isTrue, reason: nickname);
        expect(RegExp(r'^[A-Z][a-z]+[A-Z][a-z]+\d{3}$').hasMatch(nickname), isTrue, reason: nickname);
      }
      L10n.use(AppLanguage.ko);
      expect(RegExp(r'^[가-힣]+\d{4}$').hasMatch(server.ranking.generateNickname()), isTrue);
    });
  });

  testWidgets('언어를 바꾸면 데모 화면이 다시 불러온다: 반려견 이름과 데모 컨트롤이 영어로', (tester) async {
    tester.view
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final server = MockServer(latency: Duration.zero, randomSeed: 5);
    server.treadmill.autoTick = false;
    server.analysis.autoProcess = false;

    await tester.pumpWidget(DemoApp(preferences: preferences, server: server, signedIn: true));
    await _settle(tester);
    expect(find.text('두부'), findsWidgets);
    expect(find.text('Tofu'), findsNothing);

    // 데모 컨트롤의 언어 줄 → 언어 선택 시트에서 English
    await tester.tap(find.text('DEMO'));
    await _settle(tester);
    expect(find.text('데모 컨트롤'), findsOneWidget);
    await tester.tap(find.text('언어 (Language)'));
    await _settle(tester);
    await tester.tap(find.text('English'));
    await _settle(tester, 20);

    expect(L10n.language, AppLanguage.en);
    expect(find.text('Demo controls'), findsOneWidget);
    expect(find.text('Start workout'), findsOneWidget);
    expect(preferences.getString(AppLanguageController.prefsKey), 'en');

    // 컨트롤을 닫으면 화면 뒤의 반려견 이름이 영어 샘플 이름으로 다시 불러와진다
    await tester.tapAt(const Offset(10, 10));
    await _settle(tester, 20);
    expect(find.text('Tofu'), findsWidgets);
    expect(find.text('두부'), findsNothing);
    expect(find.byType(ProviderScope), findsOneWidget);
    expect(tester.takeException(), isNull);
    addTearDown(() => L10n.use(AppLanguage.ko));
  });
}
