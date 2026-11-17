import 'package:dog_treadmill_app/core/utils/formatters.dart';
import 'package:dog_treadmill_app/features/auth/presentation/login_screen.dart';
import 'package:dog_treadmill_app/features/auth/presentation/signup_screen.dart';
import 'package:dog_treadmill_app/features/consents/data/consent.dart';
import 'package:dog_treadmill_app/features/notifications/data/notification_repository.dart';
import 'package:dog_treadmill_app/features/profile/data/app_user.dart';
import 'package:dog_treadmill_app/features/support/data/support_repository.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n.dart';

AppNotification _n(String msg, Map<String, dynamic> args, {String title = '원본 제목', String body = '원본 본문'}) =>
    AppNotification(
      id: 'n1',
      type: 'general',
      title: title,
      body: body,
      data: {'msg': msg, 'args': args},
      isRead: false,
      createdAt: DateTime(2026, 11, 17),
    );

const _startAt = '2026-11-20T05:30:00Z';

const _awards = [
  {'scope': 'overall', 'label': '전체', 'label_en': 'Overall', 'rank': 1},
  {'scope': 'branch', 'label': '용산 아이파크몰점', 'label_en': "Yongsan I'Park Mall", 'rank': 2},
];

void main() {
  setUpAll(initTestLocales);

  String when() => Fmt.dateTime(DateTime.parse(_startAt));

  group('알림 문구 (ko)', () {
    test('예약 3종', () {
      final args = {'dog_name': '콩이', 'start_at': _startAt};
      expect(_n('booking_confirmed', args).title, '예약이 확정되었어요');
      expect(_n('booking_confirmed', args).body, '콩이 · ${when()} 예약이 확정되었습니다.');
      expect(_n('booking_cancelled', args).title, '예약이 취소되었어요');
      expect(_n('booking_cancelled', args).body, '콩이 · ${when()} 예약이 헬스장 사정으로 취소되었습니다.');
      expect(_n('booking_no_show', args).title, '미방문 처리되었어요');
      expect(_n('booking_no_show', args).body, '콩이 · ${when()} 예약이 미방문으로 처리되었습니다.');
    });

    test('운동·분석', () {
      expect(_n('exercise_started', {'dog_name': '콩이'}).title, '운동을 시작했어요');
      expect(_n('exercise_started', {'dog_name': '콩이'}).body, '콩이의 트레드밀 운동이 시작되었습니다. 실시간 현황을 확인해 보세요.');
      expect(_n('exercise_completed', {'dog_name': '콩이', 'points': 0}).body, '콩이의 운동이 끝났어요. 운동 기록을 확인해 보세요.');
      expect(_n('exercise_completed', {'dog_name': '콩이', 'points': 120}).body,
          '콩이의 운동이 끝났어요. 120점을 받았어요! 운동 기록을 확인해 보세요.');
      expect(_n('exercise_stopped', {'dog_name': '콩이', 'reason': null}).body, '콩이의 운동이 중단되었습니다. 사유: -');
      expect(_n('exercise_stopped', {'dog_name': '콩이', 'reason': '운영자 판단에 의한 중단'}).body,
          '콩이의 운동이 중단되었습니다. 사유: 운영자 판단에 의한 중단');
      expect(_n('analysis_completed', {'dog_name': '콩이'}).title, 'AI 보행 분석 리포트가 도착했어요');
      expect(_n('analysis_completed', {'dog_name': '콩이'}).body, '콩이의 운동 분석 결과를 확인해 보세요.');
      expect(_n('analysis_failed', {'dog_name': '콩이'}).title, 'AI 분석을 완료하지 못했어요');
      expect(_n('analysis_failed', {'dog_name': '콩이'}).body, '콩이의 영상 분석 중 문제가 발생했습니다. 헬스장에서 확인 후 다시 분석합니다.');
    });

    test('배지·응원·월간 시상', () {
      expect(_n('badge_earned', {'dog_name': '콩이', 'badge_name': '첫 걸음', 'badge_name_en': 'First Steps'}).body,
          '콩이의 「첫 걸음」 배지가 도착했어요. 배지함에서 확인해 보세요.');
      expect(_n('cheer_received', {'dog_name': '콩이', 'nickname': '민수'}).body, '민수님이 콩이를 응원했어요.');
      expect(_n('cheer_received', {'dog_name': '봄', 'nickname': null}).body, '다른 보호자가 봄을 응원했어요.');
      final award = _n('monthly_award', {'dog_name': '콩이', 'month': 11, 'awards': _awards});
      expect(award.title, '11월 랭킹 시상대에 올랐어요');
      expect(award.body, '콩이가 11월 랭킹 전체 1위 · 용산 아이파크몰점 2위에 올랐어요. 명예의 전당에서 확인해 보세요.');
    });

    test('모르는 msg, args 없음, args 불완전은 원본 문구', () {
      expect(_n('unknown_kind', {'dog_name': '콩이'}).title, '원본 제목');
      expect(_n('unknown_kind', {'dog_name': '콩이'}).body, '원본 본문');
      expect(_n('booking_confirmed', {'dog_name': '콩이'}).body, '원본 본문');
      final legacy = AppNotification.fromJson({
        'id': 'x',
        'title': '예전 알림',
        'body': '예전 본문',
        'data': <String, dynamic>{},
        'is_read': false,
        'created_at': '2026-11-01T00:00:00Z',
      });
      expect(legacy.title, '예전 알림');
      expect(legacy.body, '예전 본문');
    });
  });

  group('알림 문구 (en)', () {
    setUp(() => useLanguage(AppLanguage.en));

    test('예약 3종', () {
      final args = {'dog_name': 'Kongi', 'start_at': _startAt};
      expect(_n('booking_confirmed', args).title, 'Booking confirmed');
      expect(_n('booking_confirmed', args).body, 'Your booking for Kongi on ${when()} is confirmed.');
      expect(_n('booking_cancelled', args).title, 'Booking cancelled');
      expect(_n('booking_cancelled', args).body, 'Your booking for Kongi on ${when()} was cancelled by the gym.');
      expect(_n('booking_no_show', args).title, 'Marked as no-show');
      expect(_n('booking_no_show', args).body, 'Your booking for Kongi on ${when()} was marked as a no-show.');
    });

    test('운동·분석', () {
      expect(_n('exercise_started', {'dog_name': 'Kongi'}).title, 'Workout started');
      expect(_n('exercise_started', {'dog_name': 'Kongi'}).body,
          'Kongi has started a treadmill workout. Check the live status.');
      expect(_n('exercise_completed', {'dog_name': 'Kongi', 'points': 0}).body,
          "Kongi's workout is done. Check your workout history.");
      expect(_n('exercise_completed', {'dog_name': 'Kongi', 'points': 1200}).body,
          "Kongi's workout is done. You earned 1,200 pts! Check your workout history.");
      expect(_n('exercise_stopped', {'dog_name': 'Kongi', 'reason': null}).body, "Kongi's workout was stopped. Reason: -");
      expect(_n('exercise_stopped', {'dog_name': 'Kongi', 'reason': '운영자 판단에 의한 중단'}).body,
          "Kongi's workout was stopped. Reason: Stopped by staff");
      expect(_n('exercise_stopped', {'dog_name': 'Kongi', 'reason': 'Dog was tired'}).body,
          "Kongi's workout was stopped. Reason: Dog was tired");
      expect(_n('analysis_completed', {'dog_name': 'Kongi'}).title, 'Your AI gait analysis report is ready');
      expect(_n('analysis_completed', {'dog_name': 'Kongi'}).body, 'Check the workout analysis results for Kongi.');
      expect(_n('analysis_failed', {'dog_name': 'Kongi'}).title, "AI analysis couldn't be completed");
      expect(_n('analysis_failed', {'dog_name': 'Kongi'}).body,
          "There was a problem analyzing Kongi's video. We'll check at the gym and run the analysis again.");
    });

    test('배지·응원·월간 시상', () {
      expect(_n('badge_earned', {'dog_name': 'Kongi', 'badge_name': '첫 걸음', 'badge_name_en': 'First Steps'}).body,
          'Kongi earned the "First Steps" badge. Check it in your badge collection.');
      // _en이 없으면 한국어 이름
      expect(_n('badge_earned', {'dog_name': 'Kongi', 'badge_name': '첫 걸음'}).body, contains('"첫 걸음"'));
      expect(_n('cheer_received', {'dog_name': 'Kongi', 'nickname': 'Minsu'}).body, 'Minsu cheered for Kongi.');
      expect(_n('cheer_received', {'dog_name': 'Kongi', 'nickname': null}).body, 'Another owner cheered for Kongi.');
      final award = _n('monthly_award', {'dog_name': 'Kongi', 'month': 11, 'awards': _awards});
      expect(award.title, 'Podium finish in Nov rankings');
      expect(award.body,
          "Kongi placed in the Nov rankings: #1 Overall · #2 Yongsan I'Park Mall. Check the Hall of Fame to see it.");
    });

    test('모르는 msg는 원본 문구', () {
      expect(_n('unknown_kind', {'dog_name': 'Kongi'}).title, '원본 제목');
    });
  });

  group('모델 라벨', () {
    const emptyNameUser = AppUser(id: 'u', name: '', role: 'user', notificationPrefs: NotificationPrefs());

    test('한국어 기본', () {
      expect(ConsentType.privacy.title, '개인정보 수집·이용');
      expect(InquiryCategory.payment.label, '결제·이용권');
      expect(emptyNameUser.displayName, '보호자');
    });

    test('영어', () {
      useLanguage(AppLanguage.en);
      expect(ConsentType.terms.title, 'Terms of service');
      expect(ConsentType.ranking.description, contains('Hall of Fame'));
      expect(InquiryCategory.analysis.label, 'AI analysis');
      expect(emptyNameUser.displayName, 'PawFit member');
      final inquiry = Inquiry.fromJson({
        'id': 'i',
        'category': 'booking',
        'title': 't',
        'body': 'b',
        'status': 'answered',
        'created_at': '2026-11-01T00:00:00Z',
      });
      expect(inquiry.statusLabel, 'Answered');
    });

    test('공지·FAQ는 _en 값을 쓰고 없으면 한국어', () {
      final notice = Notice.fromJson({
        'id': 'n',
        'title': '점검 안내',
        'body': '본문',
        'title_en': 'Maintenance',
        'is_pinned': false,
        'published_at': '2026-11-01T00:00:00Z',
      });
      final faq = Faq.fromJson({
        'id': 'f',
        'category': '예약',
        'question': '질문',
        'answer': '답변',
        'category_en': 'Booking',
        'question_en': 'Question',
        'answer_en': 'Answer',
      });
      expect(notice.title, '점검 안내');
      expect(faq.question, '질문');
      useLanguage(AppLanguage.en);
      expect(notice.title, 'Maintenance');
      expect(notice.body, '본문');
      expect((faq.category, faq.question, faq.answer), ('Booking', 'Question', 'Answer'));
    });
  });

  group('화면 (en)', () {
    testWidgets('로그인', (tester) async {
      await tester.pumpWidget(ProviderScope(
        overrides: [languageOverride(AppLanguage.en)],
        child: localizedApp(const LoginScreen(), language: AppLanguage.en),
      ));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Sign up'), findsOneWidget);
      await tester.tap(find.text('Log in'));
      await tester.pump();
      expect(find.text('Please enter your email.'), findsOneWidget);
    });

    testWidgets('회원가입', (tester) async {
      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [languageOverride(AppLanguage.en)],
        child: localizedApp(const SignupScreen(), language: AppLanguage.en),
      ));
      expect(find.text('Your info'), findsOneWidget);
      expect(find.text('Agree to all'), findsOneWidget);
      expect(find.text('Create account'), findsOneWidget);
      expect(find.textContaining('[Required] Terms of service', findRichText: true), findsOneWidget);
    });
  });
}
