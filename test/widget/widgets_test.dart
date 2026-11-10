import 'package:dog_treadmill_app/core/theme/app_theme.dart';
import 'package:dog_treadmill_app/core/widgets/common.dart';
import 'package:dog_treadmill_app/features/auth/data/auth_repository.dart';
import 'package:dog_treadmill_app/features/auth/presentation/login_screen.dart';
import 'package:dog_treadmill_app/features/booking/data/booking_models.dart';
import 'package:dog_treadmill_app/features/booking/presentation/widgets/booking_widgets.dart';
import 'package:dog_treadmill_app/features/consents/data/consent.dart';
import 'package:dog_treadmill_app/features/consents/data/consent_repository.dart';
import 'package:dog_treadmill_app/features/dogs/data/dog.dart';
import 'package:dog_treadmill_app/features/dogs/providers.dart';
import 'package:dog_treadmill_app/features/health/data/analysis_models.dart';
import 'package:dog_treadmill_app/features/health/presentation/health_dashboard_screen.dart';
import 'package:dog_treadmill_app/features/health/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

/// 로그인 요청만 기록하는 테스트용 저장소
class _RecordingAuthRepository implements AuthRepository {
  final List<(String, String)> signIns = [];

  @override
  String? get currentEmail => null;

  @override
  Future<void> signIn({required String email, required String password}) async {
    signIns.add((email, password));
  }

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required Map<ConsentType, bool> consents,
  }) async =>
      true;

  @override
  Future<void> signOut() async {}

  @override
  Future<void> updatePassword(String newPassword) async {}

  @override
  Future<void> deleteAccount() async {}
}

Widget _app(Widget child, {List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(theme: AppTheme.light(), home: child),
  );
}

void main() {
  setUpAll(() => initializeDateFormatting('ko_KR'));

  testWidgets('로그인: 빈 입력은 검증 오류, 올바른 입력은 로그인 요청', (tester) async {
    final auth = _RecordingAuthRepository();
    await tester.pumpWidget(_app(
      const LoginScreen(),
      overrides: [authRepositoryProvider.overrideWithValue(auth)],
    ));

    await tester.tap(find.widgetWithText(FilledButton, '로그인'));
    await tester.pump();
    expect(find.text('이메일을 입력해 주세요.'), findsOneWidget);
    expect(find.text('비밀번호를 입력해 주세요.'), findsOneWidget);
    expect(auth.signIns, isEmpty);

    await tester.enterText(find.widgetWithText(TextFormField, '이메일'), 'owner@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, '비밀번호'), 'abcd1234');
    await tester.tap(find.widgetWithText(FilledButton, '로그인'));
    await tester.pump();
    expect(auth.signIns, [('owner@example.com', 'abcd1234')]);
  });

  testWidgets('시간 슬롯: 오전/오후로 나누고 마감 슬롯은 선택할 수 없다', (tester) async {
    final base = DateTime(2026, 11, 10);
    TimeSlot slot(int hour, int available) => TimeSlot(
          start: base.add(Duration(hours: hour)),
          end: base.add(Duration(hours: hour, minutes: 30)),
          availableCount: available,
          totalCount: 4,
        );
    final slots = [slot(10, 4), slot(11, 0), slot(15, 1)];
    TimeSlot? selected;

    await tester.pumpWidget(_app(
      Scaffold(
        body: SlotGrid(slots: slots, selectedStart: null, onSelected: (value) => selected = value),
      ),
    ));

    expect(find.text('오전'), findsOneWidget);
    expect(find.text('오후'), findsOneWidget);
    expect(find.text('새벽'), findsNothing, reason: '슬롯이 없는 시간대는 숨긴다');
    expect(find.text('저녁'), findsNothing);
    expect(find.text('마감'), findsOneWidget);
    expect(find.text('잔여 4'), findsOneWidget);

    await tester.tap(find.text('마감'));
    expect(selected, isNull);

    await tester.tap(find.text('3:00'));
    expect(selected?.start, base.add(const Duration(hours: 15)));
  });

  testWidgets('시간 슬롯: 24시간 지점은 새벽·오전·오후·저녁으로 나눈다', (tester) async {
    final base = DateTime(2026, 11, 10);
    TimeSlot slot(int minutes) => TimeSlot(
          start: base.add(Duration(minutes: minutes)),
          end: base.add(Duration(minutes: minutes + 30)),
          availableCount: 2,
          totalCount: 2,
        );
    // 00:00~23:30, 30분 간격 48칸
    final slots = [for (var m = 0; m < 24 * 60; m += 30) slot(m)];

    await tester.pumpWidget(_app(
      Scaffold(
        body: SingleChildScrollView(
          child: SlotGrid(slots: slots, selectedStart: null, onSelected: (_) {}),
        ),
      ),
    ));

    final headers = ['새벽', '오전', '오후', '저녁'];
    for (final header in headers) {
      expect(find.text(header), findsOneWidget);
    }
    // 시간대 순서대로 위에서 아래로 놓인다.
    final tops = [for (final header in headers) tester.getTopLeft(find.text(header)).dy];
    expect(tops, orderedEquals([...tops]..sort()));
    // 각 시간대 12칸씩 (6시간 × 30분)
    expect(find.text('잔여 2'), findsNWidgets(48));
  });

  testWidgets('예약 상태 배지는 상태별 문구를 보여준다', (tester) async {
    await tester.pumpWidget(_app(
      const Scaffold(
        body: Column(
          children: [
            BookingStatusBadge(status: BookingStatus.pending),
            BookingStatusBadge(status: BookingStatus.noShow),
          ],
        ),
      ),
    ));
    expect(find.text('예약 대기'), findsOneWidget);
    expect(find.text('미방문'), findsOneWidget);
  });

  group('빈 상태·오류 정렬', () {
    // AppBar 아래 본문 영역의 중심
    Offset bodyCenter(WidgetTester tester) {
      final screen = tester.getSize(find.byType(Scaffold));
      final top = tester.getBottomLeft(find.byType(AppBar)).dy;
      return Offset(screen.width / 2, (top + screen.height) / 2);
    }

    Rect contentRect(WidgetTester tester, Type owner) =>
        tester.getRect(find.descendant(of: find.byType(owner), matching: find.byType(Column)).first);

    testWidgets('화면 본문에 놓인 EmptyState는 본문 정중앙에 배치된다', (tester) async {
      await tester.pumpWidget(_app(
        Scaffold(
          appBar: AppBar(title: const Text('공지사항')),
          body: const EmptyState(icon: Icons.campaign_outlined, title: '등록된 공지사항이 없어요'),
        ),
      ));
      final center = contentRect(tester, EmptyState).center;
      final expected = bodyCenter(tester);
      expect(center.dx, moreOrLessEquals(expected.dx, epsilon: 0.5));
      expect(center.dy, moreOrLessEquals(expected.dy, epsilon: 0.5));
    });

    testWidgets('화면 본문에 놓인 ErrorView도 본문 정중앙에 배치된다', (tester) async {
      await tester.pumpWidget(_app(
        Scaffold(
          appBar: AppBar(title: const Text('알림')),
          body: ErrorView(message: '네트워크 오류', onRetry: () {}),
        ),
      ));
      final center = contentRect(tester, ErrorView).center;
      final expected = bodyCenter(tester);
      expect(center.dx, moreOrLessEquals(expected.dx, epsilon: 0.5));
      expect(center.dy, moreOrLessEquals(expected.dy, epsilon: 0.5));
    });

    testWidgets('공간이 좁아도 넘치지 않고 스크롤되며 당겨서 새로고침이 동작한다', (tester) async {
      tester.view.physicalSize = const Size(320, 260);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var refreshed = 0;

      await tester.pumpWidget(_app(
        Scaffold(
          appBar: AppBar(title: const Text('운동 기록')),
          body: RefreshIndicator(
            onRefresh: () async => refreshed++,
            child: EmptyState(
              icon: Icons.insights_rounded,
              title: '아직 운동 기록이 없어요',
              message: '운동을 마치면 날짜별 기록이 쌓여요.',
              actionLabel: '운동 예약하기',
              onAction: () {},
            ),
          ),
        ),
      ));
      expect(tester.takeException(), isNull);

      await tester.fling(find.text('아직 운동 기록이 없어요'), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();
      expect(refreshed, 1);
    });

    testWidgets('목록 속 카드 안의 compact EmptyState는 가로 가운데 정렬된다', (tester) async {
      await tester.pumpWidget(_app(
        Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              AppCard(
                child: EmptyState(compact: true, icon: Icons.directions_run_rounded, title: '진행 중인 운동이 없어요'),
              ),
            ],
          ),
        ),
      ));
      final card = tester.getRect(find.byType(AppCard));
      final title = tester.getRect(find.text('진행 중인 운동이 없어요'));
      expect(title.center.dx, moreOrLessEquals(card.center.dx, epsilon: 0.5));
      expect(title.left, greaterThan(card.left + 20));
    });
  });

  group('건강 탭: 리포트가 없을 때 안내', () {
    const dog = Dog(id: 'd1', ownerId: 'u1', name: '초코');

    Map<ConsentType, DataConsent> videoConsent({required bool granted}) => {
          ConsentType.videoRecording: DataConsent(
            type: ConsentType.videoRecording,
            version: '1.0',
            granted: granted,
            respondedAt: DateTime(2026, 11, 1),
          ),
        };

    Future<void> pumpHealth(
      WidgetTester tester, {
      required Map<ConsentType, DataConsent> consents,
      List<AnalysisReport> reports = const [],
    }) async {
      await tester.pumpWidget(_app(
        const HealthDashboardScreen(),
        overrides: [
          selectedDogProvider.overrideWithValue(const AsyncData(dog)),
          reportsProvider('d1').overrideWith((ref) async => reports),
          activePlanProvider('d1').overrideWith((ref) async => null),
          consentsProvider.overrideWith((ref) async => consents),
        ],
      ));
      // 분석 중 표시의 무한 애니메이션 때문에 pumpAndSettle 대신 Future가 풀릴 만큼만 진행한다.
      await tester.pump();
      await tester.pump();
    }

    testWidgets('영상 촬영에 동의하지 않았으면 동의를 안내한다', (tester) async {
      await pumpHealth(tester, consents: const {});
      expect(find.text('운동 영상 촬영 동의가 필요해요'), findsOneWidget);
      expect(find.text('동의하러 가기'), findsOneWidget);
      expect(find.text('아직 분석 리포트가 없어요'), findsNothing);
    });

    testWidgets('이미 동의했으면 동의 안내 없이 리포트가 생기는 방법만 알려준다', (tester) async {
      await pumpHealth(tester, consents: videoConsent(granted: true));
      expect(find.text('아직 분석 리포트가 없어요'), findsOneWidget);
      expect(find.textContaining('동의'), findsNothing);
    });

    testWidgets('분석 중이면 동의 여부와 상관없이 준비 중이라고만 안내하고 배너는 겹쳐 띄우지 않는다', (tester) async {
      await pumpHealth(
        tester,
        consents: videoConsent(granted: false),
        reports: [
          AnalysisReport(
            id: 'r1',
            sessionId: 's1',
            dogId: 'd1',
            status: AnalysisStatus.processing,
            createdAt: DateTime(2026, 11, 9, 10),
          ),
        ],
      );
      expect(find.text('첫 분석 리포트를 준비하고 있어요'), findsOneWidget);
      expect(find.textContaining('동의'), findsNothing);
      expect(find.textContaining('건을 분석하고 있어요'), findsNothing);
    });
  });
}
