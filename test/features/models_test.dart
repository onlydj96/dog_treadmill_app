import 'package:dog_treadmill_app/features/booking/data/booking_models.dart';
import 'package:dog_treadmill_app/features/dogs/data/dog.dart';
import 'package:dog_treadmill_app/features/exercise/data/exercise_session.dart';
import 'package:dog_treadmill_app/features/health/data/analysis_models.dart';
import 'package:dog_treadmill_app/features/membership/data/membership_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ko_KR'));

  group('Dog', () {
    test('fromJson과 요약 문구', () {
      final dog = Dog.fromJson({
        'id': 'd1',
        'owner_id': 'u1',
        'name': '코코',
        'breed': '말티즈',
        'birth_date': '2023-01-15',
        'sex': 'female',
        'neutered': true,
        'weight_kg': 3.2,
        'profile_image_path': null,
      });
      expect(dog.sex, DogSex.female);
      expect(dog.sexLabel, '암컷(중성화)');
      expect(dog.summary, startsWith('말티즈 · '));
      expect(dog.summary, endsWith('3.2kg'));
    });

    test('DogDraft는 빈 견종을 null로 저장한다', () {
      const draft = DogDraft(name: '  보리 ', breed: '  ', weightKg: 5.1);
      final json = draft.toJson();
      expect(json['name'], '보리');
      expect(json['breed'], isNull);
      expect(json['birth_date'], isNull);
      expect(json['weight_kg'], 5.1);
    });

    test('건강 정보 JSON 왕복', () {
      final profile = DogHealthProfile.fromJson({
        'dog_id': 'd1',
        'diseases': [
          {'name': '슬개골 탈구', 'detail': '2기'},
        ],
        'surgeries': [
          {'name': '중성화', 'date': '2024-05-01'},
        ],
        'medications': <dynamic>[],
        'exercise_restrictions': [
          {'name': '경사 운동 금지'},
        ],
        'veterinary_notes': ' 저속 보행 권장 ',
      });
      expect(profile.diseases.single.detail, '2기');
      expect(profile.surgeries.single.date, DateTime(2024, 5, 1));
      expect(profile.isEmpty, isFalse);
      final json = profile.toJson();
      expect(json['veterinary_notes'], '저속 보행 권장');
      expect((json['surgeries'] as List<dynamic>).single, {'name': '중성화', 'date': '2024-05-01'});
    });
  });

  group('Booking', () {
    Map<String, dynamic> bookingJson({required DateTime start, String status = 'confirmed'}) => {
          'id': 'b1',
          'user_id': 'u1',
          'dog_id': 'd1',
          'branch_id': 'br1',
          'treadmill_id': 't1',
          'program_id': 'p1',
          'membership_id': 'm1',
          'start_at': start.toUtc().toIso8601String(),
          'end_at': start.add(const Duration(minutes: 30)).toUtc().toIso8601String(),
          'status': status,
          'note': null,
          'cancel_reason': null,
          'cancelled_at': null,
          'created_at': '2026-11-01T00:00:00+00:00',
          'branch': {
            'id': 'br1',
            'name': '강남점',
            'address': '서울',
            'opens_at': '10:00:00',
            'closes_at': '21:00:00',
            'slot_minutes': 30,
          },
          'treadmill': {'id': 't1', 'device_name': 'T-01', 'status': 'available'},
          'program': {
            'id': 'p1',
            'name': '표준 유산소',
            'duration_minutes': 30,
            'target_speed_kmh': 4.5,
            'intensity': 'medium',
          },
          'dog': {'id': 'd1', 'name': '코코', 'breed': '말티즈', 'profile_image_path': null},
          'session': [
            {'id': 's1'},
          ],
        };

    test('임베드된 지점·트레드밀·프로그램·반려견·세션을 파싱한다', () {
      final booking = Booking.fromJson(bookingJson(start: DateTime(2026, 11, 10, 10)));
      expect(booking.status, BookingStatus.confirmed);
      expect(booking.branch?.hoursLabel, '10:00 ~ 21:00');
      expect(booking.treadmill?.deviceName, 'T-01');
      expect(booking.program?.intensity, ProgramIntensity.medium);
      expect(booking.dog?.name, '코코');
      expect(booking.sessionId, 's1');
      expect(booking.usesMembership, isTrue);
    });

    test('시작 1시간 전까지만 변경·취소할 수 있다', () {
      final now = DateTime(2026, 11, 10, 9);
      expect(Booking.fromJson(bookingJson(start: DateTime(2026, 11, 10, 10, 30))).canModify(now), isTrue);
      expect(Booking.fromJson(bookingJson(start: DateTime(2026, 11, 10, 9, 45))).canModify(now), isFalse);
      expect(
        Booking.fromJson(bookingJson(start: DateTime(2026, 11, 10, 12), status: 'checked_in')).canModify(now),
        isFalse,
      );
    });

    test('예정/지난 예약 구분', () {
      final now = DateTime(2026, 11, 10, 9);
      expect(Booking.fromJson(bookingJson(start: DateTime(2026, 11, 10, 12))).isUpcoming(now), isTrue);
      expect(
        Booking.fromJson(bookingJson(start: DateTime(2026, 11, 10, 12), status: 'cancelled')).isUpcoming(now),
        isFalse,
      );
      expect(Booking.fromJson(bookingJson(start: DateTime(2026, 11, 9, 12))).isUpcoming(now), isFalse);
    });
  });

  group('Membership', () {
    final membership = Membership.fromJson({
      'id': 'm1',
      'plan_name': '10회 이용권',
      'total_sessions': 10,
      'remaining_sessions': 3,
      'starts_at': '2026-11-01T00:00:00+00:00',
      'expires_at': '2026-11-30T15:00:00+00:00',
      'status': 'active',
    });

    test('예약 시간이 유효기간 안이면 사용할 수 있다', () {
      final start = DateTime.utc(2026, 11, 20, 1);
      expect(membership.isUsableFor(start, start.add(const Duration(minutes: 30))), isTrue);
    });

    test('유효기간이 끝난 뒤의 예약에는 사용할 수 없다', () {
      final start = DateTime.utc(2026, 12, 2, 1);
      expect(membership.isUsableFor(start, start.add(const Duration(minutes: 30))), isFalse);
    });
  });

  group('ExerciseSession', () {
    test('운동 중이면 마지막 갱신 이후 시간을 더해 경과 시간을 계산한다', () {
      final updatedAt = DateTime.utc(2026, 11, 10, 1, 0, 0);
      final session = ExerciseSession.fromJson({
        'id': 's1',
        'dog_id': 'd1',
        'status': 'running',
        'started_at': '2026-11-10T00:58:00+00:00',
        'duration_seconds': 100,
        'distance_meters': '120.5',
        'current_speed': '4.5',
        'target_duration_seconds': 1800,
        'created_at': '2026-11-10T00:58:00+00:00',
        'updated_at': updatedAt.toIso8601String(),
      });
      expect(session.currentSpeed, 4.5);
      expect(session.distanceMeters, 120.5);
      expect(session.elapsedSeconds(updatedAt.add(const Duration(seconds: 10))), 110);
      expect(session.progress(updatedAt.add(const Duration(seconds: 10))), closeTo(110 / 1800, 1e-9));
    });

    test('종료된 세션은 저장된 시간을 그대로 쓴다', () {
      final session = ExerciseSession.fromJson({
        'id': 's1',
        'dog_id': 'd1',
        'status': 'completed',
        'duration_seconds': 1500,
        'distance_meters': 1800,
        'current_speed': 0,
        'created_at': '2026-11-10T00:58:00+00:00',
        'reports': [
          {'id': 'r1', 'analysis_status': 'completed'},
        ],
      });
      expect(session.status.isActive, isFalse);
      expect(session.elapsedSeconds(DateTime.now()), 1500);
      expect(session.latestReport?.isCompleted, isTrue);
    });
  });

  group('AnalysisReport', () {
    final report = AnalysisReport.fromJson({
      'id': 'r1',
      'session_id': 's1',
      'dog_id': 'd1',
      'analysis_status': 'completed',
      'joint_metrics': {
        'keypoint_count': 15,
        'joints': [
          {'key': 'right_stifle', 'rom_deg': 44.0, 'baseline_rom_deg': 50.0, 'confidence': 0.9},
        ],
      },
      'gait_metrics': {
        'cadence_spm': 142,
        'stride_time_s': 0.84,
        'stride_time_cv': 0.06,
        'symmetry_index': 0.91,
        'baseline': {'cadence_spm': 140, 'symmetry_index': 0.95},
      },
      'anomaly_metrics': {
        'anomaly_score': 0.32,
        'level': 'caution',
        'confidence': 0.86,
        'findings': [
          {'joint': 'right_stifle', 'description': '가동 범위 12% 감소', 'severity': 'caution'},
        ],
        'notes': ['측면 카메라 일부 가림'],
      },
      'care_notes': ['다음 운동은 저속 보행 위주로 진행해 주세요.'],
      'summary': '오른쪽 뒷다리 무릎의 가동 범위가 줄었어요.',
      'model_version': 'gait-v0.3',
      'created_at': '2026-11-10T02:00:00+00:00',
      'session': {
        'id': 's1',
        'status': 'completed',
        'started_at': '2026-11-10T01:00:00+00:00',
        'duration_seconds': 1800,
        'distance_meters': 2100,
        'current_speed': 0,
      },
    });

    test('지표 JSON을 파싱하고 관절 이름을 키포인트 정의에서 채운다', () {
      final joint = report.jointMetrics!.joints.single;
      expect(joint.label, '오른쪽 뒷다리 무릎');
      expect(joint.romChangeRatio, closeTo(-0.12, 1e-9));
      expect(report.gaitMetrics!.baseline!.symmetryIndex, 0.95);
      expect(report.anomalyMetrics!.level, AnomalyLevel.caution);
      expect(report.anomalyMetrics!.findings.single.label, '오른쪽 뒷다리 무릎');
      expect(report.careNotes, hasLength(1));
    });

    test('임베드된 세션의 시작 시각을 운동 일시로 사용한다', () {
      expect(report.exerciseDate, DateTime.utc(2026, 11, 10, 1));
      expect(report.session!.distanceMeters, 2100);
    });
  });
}
