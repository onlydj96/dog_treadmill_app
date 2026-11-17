import 'package:dog_treadmill_app/features/dogs/providers.dart';
import 'package:dog_treadmill_app/features/health/data/analysis_models.dart';
import 'package:dog_treadmill_app/features/health/data/dog_keypoints.dart';
import 'package:dog_treadmill_app/features/health/presentation/analysis_report_screen.dart';
import 'package:dog_treadmill_app/features/health/providers.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n.dart';

/// 건강 리포트 영역의 영어 화면: 관절 이름과 AI 분석 리포트 화면
void main() {
  setUpAll(initTestLocales);

  final hangul = RegExp(r'[ㄱ-ㆎ가-힣]');

  Map<String, dynamic> reportJson(String id, String createdAt, {double symmetry = 0.9, double cadence = 140}) => {
        'id': id,
        'session_id': 's-$id',
        'dog_id': 'd1',
        'analysis_status': 'completed',
        'created_at': createdAt,
        'summary': '좌우 대칭이 좋아요.',
        'summary_en': 'Your dog moves evenly on both sides.',
        'care_notes': ['충분히 쉬게 해 주세요.'],
        'care_notes_en': ['Let your dog rest well.'],
        'skeleton_video_path': 'skeleton.mp4',
        'joint_metrics': {
          'keypoint_count': 15,
          'joints': [
            {
              'key': 'left_hock',
              'rom_deg': 40,
              'min_angle_deg': 100,
              'max_angle_deg': 140,
              'baseline_rom_deg': 44,
            },
          ],
        },
        'gait_metrics': {
          'cadence_spm': cadence,
          'stride_time_s': 0.62,
          'stride_time_cv': 0.04,
          'symmetry_index': symmetry,
          'front_symmetry': 0.92,
          'hind_symmetry': 0.88,
          'rhythm_score': 0.8,
          'baseline': {'cadence_spm': cadence - 5, 'symmetry_index': 0.85, 'stride_time_cv': 0.05},
        },
        'anomaly_metrics': {
          'level': 'caution',
          'confidence': 0.85,
          'anomaly_score': 0.3,
          'notes': ['측면 각도가 가려졌어요.'],
          'notes_en': ['The side angle was partly blocked.'],
          'findings': [],
        },
      };

  group('DogKeypoint 라벨', () {
    test('영어', () {
      useLanguage(AppLanguage.en);
      expect(DogKeypoint.nose.label, 'Nose');
      expect(DogKeypoint.withers.label, 'Withers (top of shoulders)');
      expect(DogKeypoint.leftCarpus.label, 'Left front wrist (carpus)');
      expect(DogKeypoint.leftStifle.label, 'Left hind knee (stifle)');
      expect(DogKeypoint.rightHock.label, 'Right hind ankle (hock)');
      expect(DogKeypoint.rightHindPaw.label, 'Right hind paw');
      for (final point in DogKeypoint.values) {
        expect(point.label, isNot(matches(hangul)), reason: point.key);
      }
      expect(DogKeypoint.fromKey('left_hock'), DogKeypoint.leftHock);
      expect(DogKeypoint.rightElbow.isFarSide, isTrue);
    });

    test('한국어는 그대로', () {
      expect(DogKeypoint.nose.label, '코');
      expect(DogKeypoint.withers.label, '기갑(어깨 위)');
      expect(DogKeypoint.leftHock.label, '왼쪽 뒷발목(비절)');
      expect(DogKeypoint.rightFrontPaw.label, '오른쪽 앞발');
    });
  });

  group('AI 분석 리포트 화면', () {
    Future<void> pumpReport(WidgetTester tester, AppLanguage language) async {
      tester.view.physicalSize = const Size(800, 6000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final report = AnalysisReport.fromJson(reportJson('r2', '2026-11-10T10:00:00Z'));
      final previous = AnalysisReport.fromJson(
        reportJson('r1', '2026-11-03T10:00:00Z', symmetry: 0.85, cadence: 135),
      );
      await tester.pumpWidget(ProviderScope(
        overrides: [
          languageOverride(language),
          reportDetailProvider('r2').overrideWith((ref) async => report),
          previousReportProvider.overrideWith((ref, query) async => previous),
          poseRecordsProvider.overrideWith((ref, id) async => const <PoseRecord>[]),
          dogsProvider.overrideWith((ref) async => const []),
        ],
        child: localizedApp(const AnalysisReportScreen(reportId: 'r2'), language: language),
      ));
      await tester.pump();
      await tester.pump();
      // 테스트 기본 글꼴(Ahem)은 실제보다 넓어 이전 대비 칸이 넘칠 수 있다. 문구 검증이 목적이라 레이아웃 오버플로는 무시한다.
      while (tester.takeException() != null) {}
    }

    List<String> renderedTexts(WidgetTester tester) => [
          for (final w in tester.widgetList<Text>(find.byType(Text)))
            if (w.data != null) w.data! else w.textSpan?.toPlainText() ?? '',
        ];

    testWidgets('영어 화면에 영어 문구만 보인다', (tester) async {
      await pumpReport(tester, AppLanguage.en);
      for (final text in [
        'AI analysis report',
        'Analysis summary',
        'Unusual movement check',
        'Confidence 85%',
        'Difference from the usual gait pattern',
        'Gait pattern analysis',
        'Left-right symmetry',
        'Steps per minute',
        'Gait variability',
        'Gait rhythm score',
        'Joint movement analysis · 15 joints',
        'Left legs (camera side)',
        'Right legs',
        'Left hind ankle (hock)',
        'Change since your last workout (11/3)',
        'Pattern difference',
        'Skeleton video',
        'Workout care notes',
        'Your dog moves evenly on both sides.',
        'The side angle was partly blocked.',
      ]) {
        expect(find.textContaining(text), findsWidgets, reason: text);
      }
      expect(find.textContaining('5 steps vs baseline'), findsOneWidget);
      expect(find.textContaining('5 steps'), findsWidgets);
      final hits = renderedTexts(tester).where(hangul.hasMatch).toList();
      expect(hits, isEmpty);
    });

    testWidgets('한국어 화면은 그대로', (tester) async {
      await pumpReport(tester, AppLanguage.ko);
      for (final text in ['AI 분석 리포트', '이상 움직임 탐지', '분석 신뢰도 85%', '보행 패턴 분석', '관절 움직임 분석 · 15개 관절', '스켈레톤 영상', '운동 관리 참고사항']) {
        expect(find.textContaining(text), findsWidgets, reason: text);
      }
      expect(find.textContaining('기준선 대비 5보'), findsOneWidget);
    });
  });
}
