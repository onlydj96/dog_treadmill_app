import 'package:dog_treadmill_app/core/theme/app_theme.dart';
import 'package:dog_treadmill_app/features/auth/data/auth_repository.dart';
import 'package:dog_treadmill_app/features/auth/presentation/login_screen.dart';
import 'package:dog_treadmill_app/features/booking/data/booking_models.dart';
import 'package:dog_treadmill_app/features/booking/presentation/widgets/booking_widgets.dart';
import 'package:dog_treadmill_app/features/consents/data/consent.dart';
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
    expect(find.text('마감'), findsOneWidget);
    expect(find.text('잔여 4'), findsOneWidget);

    await tester.tap(find.text('마감'));
    expect(selected, isNull);

    await tester.tap(find.text('3:00'));
    expect(selected?.start, base.add(const Duration(hours: 15)));
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
}
