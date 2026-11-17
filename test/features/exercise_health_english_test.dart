import 'package:dog_treadmill_app/features/exercise/data/exercise_session.dart';
import 'package:dog_treadmill_app/features/exercise/presentation/widgets/exercise_widgets.dart';
import 'package:dog_treadmill_app/features/health/data/analysis_models.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n.dart';

/// 운동·건강 영역의 영어 화면: 라벨, 서버 `_en` 선택과 한국어 대체값, 위젯 문구
void main() {
  setUpAll(initTestLocales);

  group('영어 라벨', () {
    test('SessionStatus · AnalysisStatus · AnomalyLevel', () {
      useLanguage(AppLanguage.en);
      expect(SessionStatus.ready.label, 'Getting ready');
      expect(SessionStatus.running.label, 'Working out');
      expect(SessionStatus.paused.label, 'Paused');
      expect(SessionStatus.completed.label, 'Workout complete');
      expect(SessionStatus.stopped.label, 'Workout stopped');
      expect(AnalysisStatus.queued.label, 'Queued');
      expect(AnalysisStatus.completed.label, 'Analysis complete');
      expect(AnomalyLevel.normal.label, 'No concerns');
      expect(AnomalyLevel.caution.label, 'Monitor');
      expect(AnomalyLevel.warning.label, 'Needs attention');
      expect(const PoseRecord(id: 'p', cameraType: 'front').cameraLabel, 'Front view');
      expect(const PoseRecord(id: 'p', cameraType: 'side').cameraLabel, 'Side view');
    });

    test('한국어는 그대로', () {
      expect(SessionStatus.running.label, '운동 중');
      expect(AnomalyLevel.caution.label, '관찰 필요');
    });
  });

  group('AI 결과의 _en 선택', () {
    final json = <String, dynamic>{
      'id': 'r1',
      'session_id': 's1',
      'dog_id': 'd1',
      'analysis_status': 'completed',
      'created_at': '2026-11-09T10:00:00Z',
      'summary': '좌우 대칭이 좋아요.',
      'summary_en': 'Your dog moves evenly on both sides.',
      'care_notes': ['충분히 쉬게 해 주세요.'],
      'care_notes_en': ['Let your dog rest well.'],
      'joint_metrics': {
        'joints': [
          {'key': 'left_knee', 'label': '왼쪽 무릎', 'label_en': 'Left knee', 'rom_deg': 40},
          {'key': 'unknown_joint', 'label': '알 수 없는 관절', 'rom_deg': 10},
        ],
      },
      'anomaly_metrics': {
        'level': 'caution',
        'notes': ['측면 각도가 가려졌어요.'],
        'notes_en': ['The side angle was partly blocked.'],
        'findings': [
          {
            'joint': 'left_knee',
            'label': '왼쪽 무릎',
            'label_en': 'Left knee',
            'description': '가동 범위가 줄었어요.',
            'description_en': 'Range of motion has decreased.',
            'severity': 'caution',
          },
        ],
      },
    };

    test('영어: _en 값을 쓴다', () {
      useLanguage(AppLanguage.en);
      final report = AnalysisReport.fromJson(json);
      expect(report.summary, 'Your dog moves evenly on both sides.');
      expect(report.careNotes, ['Let your dog rest well.']);
      expect(report.jointMetrics!.joints[0].label, 'Left knee');
      expect(report.anomalyMetrics!.notes, ['The side angle was partly blocked.']);
      final finding = report.anomalyMetrics!.findings.single;
      expect(finding.label, 'Left knee');
      expect(finding.description, 'Range of motion has decreased.');
      expect(finding.severity.label, 'Monitor');
    });

    test('영어: _en이 없으면 한국어 값으로 대체', () {
      useLanguage(AppLanguage.en);
      final report = AnalysisReport.fromJson({
        ...json,
        'summary_en': null,
        'care_notes_en': null,
        'joint_metrics': {
          'joints': [
            {'key': 'unknown_joint', 'label': '알 수 없는 관절'},
          ],
        },
        'anomaly_metrics': {
          'level': 'normal',
          'notes': ['측면 각도가 가려졌어요.'],
          'findings': [
            {'label': '허리', 'description': '문제 없음', 'severity': 'normal'},
          ],
        },
      });
      expect(report.summary, '좌우 대칭이 좋아요.');
      expect(report.careNotes, ['충분히 쉬게 해 주세요.']);
      expect(report.jointMetrics!.joints.single.label, '알 수 없는 관절');
      expect(report.anomalyMetrics!.notes, ['측면 각도가 가려졌어요.']);
      expect(report.anomalyMetrics!.findings.single.description, '문제 없음');
      expect(report.anomalyMetrics!.findings.single.label, '허리');
    });

    test('한국어: _en이 있어도 한국어 값, 언어를 바꾸면 같은 객체가 따라 바뀐다', () {
      final report = AnalysisReport.fromJson(json);
      expect(report.summary, '좌우 대칭이 좋아요.');
      expect(report.careNotes, ['충분히 쉬게 해 주세요.']);
      expect(report.jointMetrics!.joints[0].label, '왼쪽 무릎');
      expect(report.anomalyMetrics!.findings.single.description, '가동 범위가 줄었어요.');
      useLanguage(AppLanguage.en);
      expect(report.summary, 'Your dog moves evenly on both sides.');
    });
  });

  group('위젯 (English)', () {
    testWidgets('운동 기록 타일: 중단 사유와 단위가 영어로 나온다', (tester) async {
      final session = ExerciseSession(
        id: 's1',
        dogId: 'd1',
        status: SessionStatus.stopped,
        durationSeconds: 600,
        distanceMeters: 800,
        currentSpeed: 0,
        createdAt: DateTime(2026, 11, 16, 15, 5),
        treadmillName: 'T-3',
        averageSpeed: 2.5,
        maxSpeed: 3.1,
        stopReason: '운영자 판단에 의한 중단',
        reports: const [SessionReportRef(id: 'r1', status: 'completed')],
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [languageOverride(AppLanguage.en)],
          child: localizedApp(
            Scaffold(body: ExerciseRecordTile(session: session)),
            language: AppLanguage.en,
          ),
        ),
      );
      expect(find.text('Treadmill T-3'), findsNothing, reason: '시각과 함께 한 줄로 묶인다');
      expect(find.textContaining('Treadmill T-3'), findsOneWidget);
      expect(find.text('Workout time'), findsOneWidget);
      expect(find.text('Avg / max'), findsOneWidget);
      expect(find.text('AI report'), findsOneWidget);
      expect(find.text('Workout stopped'), findsOneWidget);
      expect(find.text('Stopped: Stopped by staff'), findsOneWidget);
      expect(find.textContaining(RegExp('[가-힣]')), findsNothing);
    });
  });
}
