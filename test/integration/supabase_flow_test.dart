// 로컬 Supabase(supabase start)에 대해 앱의 저장소 계층 전체를 검증하는 통합 테스트.
//
// 실행:
//   npx supabase start
//   npx supabase status -o env   # 아래 키 확인
//   flutter test test/integration --dart-define-from-file=<로컬 키 파일>
//     SUPABASE_URL=http://127.0.0.1:54321
//     SUPABASE_PUBLISHABLE_KEY=...      (앱과 같은 공개 키)
//     SUPABASE_SERVICE_ROLE_KEY=...     (테스트 준비용 관리자 키)
//
// 안전장치: URL이 localhost/127.0.0.1이 아니면 실행하지 않는다.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:dog_treadmill_app/core/utils/json.dart';
import 'package:dog_treadmill_app/features/auth/data/auth_repository.dart';
import 'package:dog_treadmill_app/features/booking/data/booking_models.dart';
import 'package:dog_treadmill_app/features/booking/data/booking_repository.dart';
import 'package:dog_treadmill_app/features/consents/data/consent.dart';
import 'package:dog_treadmill_app/features/consents/data/consent_repository.dart';
import 'package:dog_treadmill_app/features/dogs/data/dog.dart';
import 'package:dog_treadmill_app/features/dogs/data/dog_repository.dart';
import 'package:dog_treadmill_app/features/exercise/data/exercise_repository.dart';
import 'package:dog_treadmill_app/features/exercise/data/exercise_session.dart';
import 'package:dog_treadmill_app/features/health/data/analysis_models.dart';
import 'package:dog_treadmill_app/features/health/data/analysis_repository.dart';
import 'package:dog_treadmill_app/features/membership/data/membership_repository.dart';
import 'package:dog_treadmill_app/features/notifications/data/notification_repository.dart';
import 'package:dog_treadmill_app/features/profile/data/app_user.dart';
import 'package:dog_treadmill_app/features/profile/data/user_repository.dart';
import 'package:dog_treadmill_app/features/support/data/support_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _url = String.fromEnvironment('SUPABASE_URL');
const _publicKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
const _serviceKey = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY');

String? _skipReason() {
  if (_url.isEmpty || _publicKey.isEmpty || _serviceKey.isEmpty) {
    return 'SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY / SUPABASE_SERVICE_ROLE_KEY가 필요합니다.';
  }
  final host = Uri.parse(_url).host;
  if (host != '127.0.0.1' && host != 'localhost') return '통합 테스트는 로컬 Supabase에서만 실행합니다.';
  return null;
}

// 앱(supabase_flutter)은 PKCE용 저장소를 제공하지만 순수 Dart 클라이언트는 없으므로 implicit 흐름을 쓴다.
SupabaseClient _client(String key) => SupabaseClient(
      _url,
      key,
      authOptions: const AuthClientOptions(autoRefreshToken: false, authFlowType: AuthFlowType.implicit),
    );

/// 조건이 만족될 때까지 기다린다 (Realtime 반영 대기용)
Future<void> _waitFor(bool Function() condition, {Duration timeout = const Duration(seconds: 20)}) async {
  final deadline = DateTime.now().add(timeout);
  while (!condition()) {
    if (DateTime.now().isAfter(deadline)) throw TimeoutException('조건을 만족하지 못했습니다', timeout);
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

/// 1x1 투명 PNG
final _pngBytes = Uint8List.fromList([
  0x89,
  0x50,
  0x4E,
  0x47,
  0x0D,
  0x0A,
  0x1A,
  0x0A,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x48,
  0x44,
  0x52,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x00,
  0x00,
  0x01,
  0x08,
  0x06,
  0x00,
  0x00,
  0x00,
  0x1F,
  0x15,
  0xC4,
  0x89,
  0x00,
  0x00,
  0x00,
  0x0D,
  0x49,
  0x44,
  0x41,
  0x54,
  0x78,
  0x9C,
  0x63,
  0x00,
  0x01,
  0x00,
  0x00,
  0x05,
  0x00,
  0x01,
  0x0D,
  0x0A,
  0x2D,
  0xB4,
  0x00,
  0x00,
  0x00,
  0x00,
  0x49,
  0x45,
  0x4E,
  0x44,
  0xAE,
  0x42,
  0x60,
  0x82,
]);

void main() {
  final skip = _skipReason();

  group('Supabase 통합 흐름', skip: skip, () {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    late SupabaseClient service;
    late SupabaseClient ownerClient;
    late SupabaseClient otherClient;
    late SupabaseClient adminClient;
    late String ownerId;
    String? otherId;
    String? adminId;
    late Dog dog;
    late String bookingId;
    late String sessionId;
    late String reportId;

    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);

    Future<String> signUp(SupabaseClient client, String prefix, Map<ConsentType, bool> consents) async {
      final signedIn = await AuthRepository(client).signUp(
        email: '$prefix-$stamp@example.com',
        password: 'test1234pw',
        name: '통합테스트 $prefix',
        phone: '010-1234-5678',
        consents: consents,
      );
      expect(signedIn, isTrue, reason: '로컬 환경은 이메일 인증 없이 바로 로그인되어야 한다');
      return client.auth.currentUser!.id;
    }

    setUpAll(() async {
      service = _client(_serviceKey);
      ownerClient = _client(_publicKey);
      otherClient = _client(_publicKey);
      adminClient = _client(_publicKey);
      ownerId = await signUp(ownerClient, 'owner', {
        ConsentType.terms: true,
        ConsentType.privacy: true,
        ConsentType.videoRecording: true,
        ConsentType.aiTraining: false,
        ConsentType.marketing: false,
      });
      otherId = await signUp(otherClient, 'other', {ConsentType.terms: true, ConsentType.privacy: true});
      adminId = await signUp(adminClient, 'admin', {ConsentType.terms: true, ConsentType.privacy: true});
      await service.from('users').update({'role': 'admin'}).eq('id', adminId!);
    });

    tearDownAll(() async {
      for (final id in [otherId, adminId].whereType<String>()) {
        await service.auth.admin.deleteUser(id);
      }
      for (final client in [service, ownerClient, otherClient, adminClient]) {
        await client.dispose();
      }
    });

    test('회원가입 시 프로필과 동의 이력이 생성된다', () async {
      final user = await UserRepository(ownerClient).fetchUser(ownerId);
      expect(user.name, '통합테스트 owner');
      expect(user.phone, '010-1234-5678');
      expect(user.isAdmin, isFalse);

      final consents = await ConsentRepository(ownerClient).fetchLatest(ownerId);
      expect(consents[ConsentType.videoRecording]?.granted, isTrue);
      expect(consents[ConsentType.aiTraining]?.granted, isFalse);

      await ConsentRepository(ownerClient).record(ownerId, ConsentType.marketing, granted: true);
      final updated = await ConsentRepository(ownerClient).fetchLatest(ownerId);
      expect(updated[ConsentType.marketing]?.granted, isTrue);

      await UserRepository(ownerClient).updateNotificationPrefs(ownerId, const NotificationPrefs(marketing: true));
      expect((await UserRepository(ownerClient).fetchUser(ownerId)).notificationPrefs.marketing, isTrue);
    });

    test('반려견 등록·건강 정보·프로필 사진', () async {
      final repo = DogRepository(ownerClient);
      dog = await repo.createDog(
        ownerId,
        DogDraft(name: '코코', breed: '말티즈', birthDate: DateTime(2023, 1, 15), sex: DogSex.female, weightKg: 3.2),
      );
      await repo.saveHealthProfile(DogHealthProfile(
        dogId: dog.id,
        diseases: const [HealthItem(name: '슬개골 탈구', detail: '2기')],
        exerciseRestrictions: const [HealthItem(name: '경사 운동 금지')],
        veterinaryNotes: '저속 보행 권장',
      ));
      // 같은 dog_id로 다시 저장하면 갱신(upsert)된다
      await repo.saveHealthProfile(DogHealthProfile(
        dogId: dog.id,
        diseases: const [HealthItem(name: '슬개골 탈구', detail: '2기')],
        medications: const [HealthItem(name: '관절 영양제')],
        exerciseRestrictions: const [HealthItem(name: '경사 운동 금지')],
      ));

      final profile = await repo.fetchHealthProfile(dog.id);
      expect(profile?.medications.single.name, '관절 영양제');
      expect(profile?.exerciseRestrictions.single.name, '경사 운동 금지');

      final path = await repo.uploadProfileImage(dog: dog, bytes: _pngBytes, extension: 'png');
      expect(path, startsWith('$ownerId/${dog.id}/'));
      dog = await repo.fetchDog(dog.id);
      expect(dog.profileImagePath, path);

      final signedUrl = await repo.createSignedImageUrl(path);
      final response = await (await HttpClient().getUrl(Uri.parse(signedUrl))).close();
      expect(response.statusCode, 200);
      await response.drain<void>();

      expect((await repo.fetchDogs(ownerId)).map((d) => d.id), [dog.id]);
    });

    test('다른 보호자는 반려견·건강 정보·사진에 접근할 수 없다', () async {
      expect(await DogRepository(otherClient).fetchDogs(ownerId), isEmpty);
      expect(await DogRepository(otherClient).fetchHealthProfile(dog.id), isNull);
      await expectLater(
        DogRepository(otherClient).createSignedImageUrl(dog.profileImagePath!),
        throwsA(isA<StorageException>()),
      );
    });

    test('예약 가능 시간 조회와 이용권 예약', () async {
      final bookingRepo = BookingRepository(ownerClient);
      final branches = await bookingRepo.fetchBranches();
      final programs = await bookingRepo.fetchPrograms();
      expect(branches, hasLength(3));
      expect(programs, hasLength(6));

      final branch = branches.firstWhere((b) => b.name == '용산 아이파크몰점');
      expect(branch.hoursLabel, '10:30 ~ 20:30');
      final program = programs.firstWhere((p) => p.name == '데일리 산책');
      final slots = await bookingRepo.fetchAvailableSlots(
        (branchId: branch.id, programId: program.id, date: tomorrowDate),
      );
      // 10:30~20:30, 25분 프로그램 → 10:30부터 20:00까지 30분 간격 20칸
      expect(slots, hasLength(20));
      expect(slots.first.totalCount, 3);

      await service.from('memberships').insert({
        'user_id': ownerId,
        'plan_name': '10회 이용권',
        'total_sessions': 10,
        'remaining_sessions': 10,
        'expires_at': DateTime.now().add(const Duration(days: 90)).toUtc().toIso8601String(),
      });
      final membership = (await MembershipRepository(ownerClient).fetchMemberships(ownerId)).single;
      expect(membership.isUsableFor(slots.first.start, slots.first.end), isTrue);

      bookingId = await bookingRepo.createBooking(
        dogId: dog.id,
        branchId: branch.id,
        programId: program.id,
        startAt: slots.first.start,
        membershipId: membership.id,
        note: '낯선 소리에 예민해요',
      );

      final booking = await bookingRepo.fetchBooking(bookingId);
      expect(booking.status, BookingStatus.confirmed);
      expect(booking.branch?.name, '용산 아이파크몰점');
      expect(booking.treadmill?.deviceName, isNotEmpty);
      expect(booking.program?.id, program.id);
      expect(booking.dog?.name, '코코');
      expect(booking.note, '낯선 소리에 예민해요');
      expect((await bookingRepo.fetchNextBooking(dog.id))?.id, bookingId);
      expect((await MembershipRepository(ownerClient).fetchMemberships(ownerId)).single.remainingSessions, 9);

      final after = await bookingRepo.fetchAvailableSlots(
        (branchId: branch.id, programId: program.id, date: tomorrowDate),
      );
      expect(after.first.availableCount, slots.first.availableCount - 1);
    });

    test('예약 시간 변경과 취소(이용권 복구)', () async {
      final bookingRepo = BookingRepository(ownerClient);
      final original = await bookingRepo.fetchBooking(bookingId);
      final newStart = original.startAt.add(const Duration(hours: 1));
      await bookingRepo.rescheduleBooking(bookingId, newStart);
      expect((await bookingRepo.fetchBooking(bookingId)).startAt.isAtSameMomentAs(newStart), isTrue);

      await bookingRepo.cancelBooking(bookingId, reason: '일정이 변경되었어요');
      final cancelled = await bookingRepo.fetchBooking(bookingId);
      expect(cancelled.status, BookingStatus.cancelled);
      expect(cancelled.cancelReason, '일정이 변경되었어요');
      expect((await MembershipRepository(ownerClient).fetchMemberships(ownerId)).single.remainingSessions, 10);

      // 현장 결제 예약 (이용권 미적용 → 예약 대기)
      bookingId = await bookingRepo.createBooking(
        dogId: dog.id,
        branchId: original.branchId,
        programId: original.programId!,
        startAt: original.startAt,
      );
      expect((await bookingRepo.fetchBooking(bookingId)).status, BookingStatus.pending);
    });

    test('다른 보호자는 예약을 조회·취소할 수 없다', () async {
      await expectLater(BookingRepository(otherClient).fetchBooking(bookingId), throwsA(isA<PostgrestException>()));
      await expectLater(
        BookingRepository(otherClient).cancelBooking(bookingId),
        throwsA(isA<PostgrestException>().having((e) => e.message, 'message', 'BOOKING_NOT_FOUND')),
      );
    });

    test('운동 세션이 Realtime으로 보호자 앱에 전달된다', () async {
      final events = <ExerciseSession?>[];
      final subscription = ExerciseRepository(ownerClient).watchLatestSession(dog.id).listen(events.add);
      final otherEvents = <ExerciseSession?>[];
      final otherSubscription = ExerciseRepository(otherClient).watchLatestSession(dog.id).listen(otherEvents.add);
      addTearDown(subscription.cancel);
      addTearDown(otherSubscription.cancel);

      await _waitFor(() => events.isNotEmpty && otherEvents.isNotEmpty);
      expect(events.last, isNull);
      // Realtime 채널 구독이 완료될 시간을 준다
      await Future<void>.delayed(const Duration(seconds: 2));

      final started = await adminClient.rpc<Json>('start_exercise_session', params: {'p_booking_id': bookingId});
      sessionId = started.str('id');
      await _waitFor(() => events.any((e) => e?.id == sessionId && e!.status == SessionStatus.running));

      await adminClient.rpc<Json>('update_exercise_session_metrics', params: {
        'p_session_id': sessionId,
        'p_current_speed': 4.5,
        'p_distance_meters': 150,
        'p_duration_seconds': 120,
      });
      await _waitFor(() => events.any((e) => e?.id == sessionId && e!.currentSpeed == 4.5));
      final live = events.lastWhere((e) => e?.id == sessionId)!;
      expect(live.distanceMeters, 150);
      expect(live.durationSeconds, 120);

      await adminClient.rpc<Json>('finish_exercise_session', params: {'p_session_id': sessionId});
      await _waitFor(() => events.any((e) => e?.id == sessionId && e!.status == SessionStatus.completed));
      expect(events.lastWhere((e) => e?.id == sessionId)!.averageSpeed, 4.5);

      // 다른 보호자에게는 전달되지 않는다
      expect(otherEvents.whereType<ExerciseSession>(), isEmpty);
    });

    test('운동 기록과 AI 분석 리포트 조회', () async {
      final sessions = await ExerciseRepository(ownerClient).fetchSessions(dog.id);
      expect(sessions.single.id, sessionId);
      expect(sessions.single.treadmillName, isNotEmpty);
      expect(sessions.single.latestReport?.status, 'queued', reason: '영상 촬영 동의 시 분석 대기열에 등록');

      final analysisRepo = AnalysisRepository(ownerClient);
      final queued = (await analysisRepo.fetchReports(dog.id)).single;
      reportId = queued.id;
      expect(queued.status, AnalysisStatus.queued);
      expect(queued.session?.id, sessionId);

      // AI 서버(service_role)가 결과를 저장했다고 가정
      await service.from('pose_records').insert({
        'session_id': sessionId,
        'camera_type': 'side',
        'video_file_path': '${dog.id}/$sessionId/side.mp4',
        'fps': 30,
        'frame_count': 3600,
      });
      await service.from('analysis_reports').update({
        'analysis_status': 'completed',
        'model_version': 'gait-test',
        'summary': '좌우 대칭성이 양호합니다.',
        'gait_metrics': {
          'cadence_spm': 140,
          'symmetry_index': 0.94,
          'baseline': {'symmetry_index': 0.95}
        },
        'joint_metrics': {
          'keypoint_count': 15,
          'joints': [
            {'key': 'left_elbow', 'rom_deg': 62, 'baseline_rom_deg': 64},
          ],
        },
        'anomaly_metrics': {'level': 'normal', 'anomaly_score': 0.1, 'confidence': 0.9, 'findings': <Object>[]},
        'care_notes': ['현재 운동 강도를 유지해 주세요.'],
      }).eq('id', reportId);

      final report = await analysisRepo.fetchReport(reportId);
      expect(report.isCompleted, isTrue);
      expect(report.completedAt, isNotNull);
      expect(report.gaitMetrics?.symmetryIndex, 0.94);
      expect(report.jointMetrics?.joints.single.label, '왼쪽 앞다리 팔꿈치');
      expect(report.anomalyMetrics?.level, AnomalyLevel.normal);
      expect(report.careNotes, hasLength(1));
      expect(await analysisRepo.fetchPreviousCompleted(dogId: dog.id, before: report.createdAt), isNull);
      expect((await analysisRepo.fetchPoseRecords(sessionId)).single.cameraType, 'side');

      expect(await AnalysisRepository(otherClient).fetchReports(dog.id), isEmpty);
    });

    test('예약·운동·분석 알림이 생성되고 읽음 처리할 수 있다', () async {
      final repo = NotificationRepository(ownerClient);
      final notifications = await repo.watchNotifications(ownerId).firstWhere((list) => list.length >= 3);
      final types = notifications.map((n) => n.type).toSet();
      expect(types, containsAll(<String>['exercise', 'analysis']));
      expect(notifications.firstWhere((n) => n.type == 'analysis').reportId, reportId);

      await repo.markAllRead(ownerId);
      final after = await repo.watchNotifications(ownerId).first;
      expect(after.every((n) => n.isRead), isTrue);
    });

    test('공지·FAQ·1:1 문의', () async {
      final repo = SupportRepository(ownerClient);
      expect((await repo.fetchNotices()).first.isPinned, isTrue);
      expect(await repo.fetchFaqs(), hasLength(greaterThanOrEqualTo(6)));

      await repo.createInquiry(
        userId: ownerId,
        category: InquiryCategory.analysis,
        title: '리포트 문의',
        body: '대칭성 지표의 의미가 궁금해요.',
      );
      final inquiries = await repo.fetchInquiries(ownerId);
      expect(inquiries.single.statusLabel, '답변 대기');
      expect(await SupportRepository(otherClient).fetchInquiries(ownerId), isEmpty);
    });

    test('반려견 소프트 삭제', () async {
      await DogRepository(ownerClient).deleteDog(dog.id);
      expect(await DogRepository(ownerClient).fetchDogs(ownerId), isEmpty);
      // 이력은 남아 있다
      expect(await ExerciseRepository(ownerClient).fetchSessions(dog.id), hasLength(1));
    });

    test('회원 탈퇴 시 계정·데이터·사진이 삭제된다 (Edge Function)', () async {
      await AuthRepository(ownerClient).deleteAccount();
      expect(ownerClient.auth.currentSession, isNull);

      final users = await service.from('users').select('id').eq('id', ownerId);
      expect(users, isEmpty);
      final dogs = await service.from('dogs').select('id').eq('owner_id', ownerId);
      expect(dogs, isEmpty);
      final files = await service.storage.from('dog-profiles').list(path: '$ownerId/${dog.id}');
      expect(files, isEmpty);
    });
  });
}
