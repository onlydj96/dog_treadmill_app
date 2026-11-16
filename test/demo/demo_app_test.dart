import 'package:dog_treadmill_app/demo/demo_app.dart';
import 'package:dog_treadmill_app/demo/mock_server/mock_server.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/l10n.dart';

// 데모 앱을 실제 화면 그대로 띄워, 목업 서버만으로 로그인 → 체크인 → 실시간 운동 → 완료 알림까지 흘러가는지 본다.

/// 무한 애니메이션(실시간 표시 점)이 있어 pumpAndSettle 대신 시간을 조금씩 흘린다.
Future<void> _settle(WidgetTester tester, [int frames = 12]) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  setUpAll(initTestLocales);

  testWidgets('데모 앱: 데모 계정으로 시작해 체크인하면 운동이 실시간으로 보이고, 끝나면 점수 알림이 온다', (tester) async {
    // 390dp 폰 화면. 탭을 모두 돌며 레이아웃 넘침이 없는지도 본다.
    tester.view
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final server = MockServer(latency: Duration.zero, randomSeed: 3);
    server.treadmill
      ..autoTick = false
      ..autoStartAfterCheckIn = Duration.zero;
    server.analysis.autoProcess = false;

    await tester.pumpWidget(DemoApp(preferences: preferences, server: server));
    await _settle(tester);

    // 로그인 화면 위의 DEMO 버튼으로 데모 계정 로그인
    await tester.tap(find.text('DEMO · 데모 계정으로 시작'));
    await _settle(tester);
    expect(find.text('이서연님, 안녕하세요'), findsOneWidget);
    expect(find.text('DEMO'), findsOneWidget);

    // 홈: 곧 시작하는 예약을 셀프 체크인 → 트레드밀 기기가 운동을 시작한다
    final checkIn = find.text('체크인');
    await tester.ensureVisible(checkIn); // 하단 탭 바에 가리지 않게 위로 올린다
    await _settle(tester);
    await tester.tap(checkIn);
    await _settle(tester);
    await tester.tap(find.text('체크인').last); // 확인 다이얼로그
    await _settle(tester);

    final session = server.db.find(
      'exercise_sessions',
      (s) => s['dog_id'] == DemoAccount.tofuId && s['status'] == 'running',
    );
    expect(session, isNotNull);

    // 운동 탭: Realtime 흉내로 실시간 카드가 갱신된다
    await tester.tap(find.text('운동').last);
    await _settle(tester);
    expect(find.text('운동 중'), findsWidgets);

    server.treadmill.tick(120);
    await _settle(tester);
    expect(find.text('운동 중'), findsWidgets);

    // 기기가 운동을 마치면 실시간 카드가 사라지고, 점수 알림이 쌓인다
    server.treadmill.completeNow(session!['id'] as String);
    await _settle(tester);
    expect(find.text('운동 중'), findsNothing);
    final completed = server.db.where(
      'notifications',
      (n) => n['user_id'] == DemoAccount.userId && n['title'] == '운동을 완료했어요' && n['is_read'] == false,
    );
    expect(completed.map((n) => n['body'] as String), anyElement(contains('점을 받았어요')));

    // 다른 화면으로 가도 Supabase에 닿는 경로가 없어야 한다 (닿으면 StateError)
    for (final tab in ['건강', '예약', '마이페이지', '홈']) {
      await tester.tap(find.text(tab).last);
      await _settle(tester);
      expect(tester.takeException(), isNull, reason: tab);
    }
  });

  testWidgets('데모 컨트롤: 운동 시작 → 운동 탭으로 이동, 바로 완료 → AI 분석 → 처음 상태로', (tester) async {
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

    Future<void> openControls() async {
      await tester.tap(find.text('DEMO'));
      await _settle(tester);
      expect(find.text('데모 컨트롤'), findsOneWidget);
    }

    // 운동 시작: 곧 시작하는 두부 예약으로 기기가 운동을 시작하고 운동 탭으로 간다
    await openControls();
    await tester.tap(find.text('운동 시작'));
    await _settle(tester);
    expect(find.text('데모 컨트롤'), findsNothing);
    expect(find.text('운동 중'), findsWidgets);
    final session = server.db.find('exercise_sessions', (s) => s['status'] == 'running')!;
    expect(session['dog_id'], DemoAccount.tofuId);

    // 바로 완료: 목표 시간을 채우고 끝나며, AI 분석이 대기열에 오른다
    await openControls();
    await tester.tap(find.text('바로 완료'));
    await _settle(tester);
    expect(session['status'], 'completed');
    expect(server.analysis.hasPending, isTrue);

    await openControls();
    await tester.tap(find.text('대기 중인 분석 바로 끝내기'));
    await _settle(tester);
    expect(server.analysis.hasPending, isFalse);

    // 처음 상태로 되돌리면 방금 만든 운동 기록이 사라지고 데모 계정으로 다시 시작한다
    await openControls();
    await tester.ensureVisible(find.text('처음 상태로 되돌리기'));
    await tester.tap(find.text('처음 상태로 되돌리기'));
    await _settle(tester);
    await tester.tap(find.text('되돌리기'));
    await _settle(tester, 20);
    expect(server.db.byId('exercise_sessions', session['id'] as String?), isNull);
    expect(server.db.currentUserId, DemoAccount.userId);
    expect(find.text('이서연님, 안녕하세요'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
