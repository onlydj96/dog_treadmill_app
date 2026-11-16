// 로컬 Supabase에 대해 랭킹·배지 흐름을 앱 저장소 계층으로 검증하는 통합 테스트.
//
// 실행 (supabase_flow_test.dart와 같은 키):
//   flutter test test/integration/ranking_flow_test.dart --dart-define-from-file=<로컬 키 파일>
//
// 안전장치: URL이 localhost/127.0.0.1이 아니면 실행하지 않는다.
import 'dart:typed_data';

import 'package:dog_treadmill_app/core/utils/error_messages.dart';
import 'package:dog_treadmill_app/features/auth/data/auth_repository.dart';
import 'package:dog_treadmill_app/features/consents/data/consent.dart';
import 'package:dog_treadmill_app/features/consents/data/consent_repository.dart';
import 'package:dog_treadmill_app/features/dogs/data/dog.dart';
import 'package:dog_treadmill_app/features/dogs/data/dog_repository.dart';
import 'package:dog_treadmill_app/features/exercise/data/exercise_repository.dart';
import 'package:dog_treadmill_app/features/profile/data/user_repository.dart';
import 'package:dog_treadmill_app/features/ranking/data/ranking_models.dart';
import 'package:dog_treadmill_app/features/ranking/data/ranking_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _url = String.fromEnvironment('SUPABASE_URL');
const _publicKey = String.fromEnvironment('SUPABASE_PUBLISHABLE_KEY');
const _serviceKey = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY');

/// 지점 (마이그레이션 20261110000200의 운영 기준 데이터)
const _yongsanBranchId = 'b1000000-0000-4000-8000-000000000001';

String? _skipReason() {
  if (_url.isEmpty || _publicKey.isEmpty || _serviceKey.isEmpty) {
    return 'SUPABASE_URL / SUPABASE_PUBLISHABLE_KEY / SUPABASE_SERVICE_ROLE_KEY가 필요합니다.';
  }
  final host = Uri.parse(_url).host;
  if (host != '127.0.0.1' && host != 'localhost') return '통합 테스트는 로컬 Supabase에서만 실행합니다.';
  return null;
}

SupabaseClient _client(String key) => SupabaseClient(
      _url,
      key,
      authOptions: const AuthClientOptions(autoRefreshToken: false, authFlowType: AuthFlowType.implicit),
    );

/// 1x1 투명 PNG
final _pngBytes = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52,
  0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4,
  0x89, 0x00, 0x00, 0x00, 0x0D, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
  0x42, 0x60, 0x82,
]);

void main() {
  final skip = _skipReason();

  group('랭킹 통합 흐름', skip: skip, () {
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final suffix = (stamp % 10000).toString().padLeft(4, '0');
    final month = RankingMonth.current();
    late SupabaseClient service;
    late SupabaseClient ownerClient; // 랭킹 참여
    late SupabaseClient otherClient; // 랭킹 참여
    late SupabaseClient shyClient; // 랭킹 미참여
    final userIds = <String>[];
    late Dog ownerDog;
    late Dog otherDog;
    late Dog shyDog;

    Future<String> signUp(SupabaseClient client, String prefix, {required bool ranking}) async {
      final signedIn = await AuthRepository(client).signUp(
        email: 'rank-$prefix-$stamp@example.com',
        password: 'test1234pw',
        name: '랭킹테스트 $prefix',
        phone: '010-1234-5678',
        consents: {ConsentType.terms: true, ConsentType.privacy: true, ConsentType.ranking: ranking},
      );
      expect(signedIn, isTrue, reason: '로컬 환경은 이메일 인증 없이 바로 로그인되어야 한다');
      final id = client.auth.currentUser!.id;
      userIds.add(id);
      return id;
    }

    /// 트레드밀 기기가 운동을 끝낸 것처럼 기록한다 (트리거가 점수·배지를 쌓는다)
    Future<void> finishWorkout(String dogId, {required int minutes, required int meters}) async {
      final treadmill =
          await service.from('treadmills').select('id').eq('branch_id', _yongsanBranchId).limit(1).single();
      final startedAt = DateTime.now().toUtc().subtract(Duration(minutes: minutes + 5));
      await service.from('exercise_sessions').insert({
        'dog_id': dogId,
        'treadmill_id': treadmill['id'],
        'status': 'completed',
        'started_at': startedAt.toIso8601String(),
        'ended_at': startedAt.add(Duration(minutes: minutes)).toIso8601String(),
        'duration_seconds': minutes * 60,
        'distance_meters': meters,
        'target_duration_seconds': 1800,
      });
    }

    setUpAll(() async {
      service = _client(_serviceKey);
      ownerClient = _client(_publicKey);
      otherClient = _client(_publicKey);
      shyClient = _client(_publicKey);
      final ownerId = await signUp(ownerClient, 'owner', ranking: true);
      final otherId = await signUp(otherClient, 'other', ranking: true);
      final shyId = await signUp(shyClient, 'shy', ranking: false);

      ownerDog = await DogRepository(ownerClient).createDog(ownerId, const DogDraft(name: '콩이', breedId: 'maltese'));
      otherDog = await DogRepository(otherClient).createDog(otherId, const DogDraft(name: '단풍', breedId: 'toy_poodle'));
      shyDog = await DogRepository(shyClient).createDog(shyId, const DogDraft(name: '초코', breedId: 'maltese'));

      await DogRepository(ownerClient).uploadProfileImage(dog: ownerDog, bytes: _pngBytes, extension: 'png');
      await DogRepository(shyClient).uploadProfileImage(dog: shyDog, bytes: _pngBytes, extension: 'png');
      ownerDog = await DogRepository(ownerClient).fetchDog(ownerDog.id);
      shyDog = await DogRepository(shyClient).fetchDog(shyDog.id);

      await finishWorkout(ownerDog.id, minutes: 30, meters: 2500);
      await finishWorkout(otherDog.id, minutes: 30, meters: 1500);
      await finishWorkout(shyDog.id, minutes: 30, meters: 3000);
    });

    tearDownAll(() async {
      for (final id in userIds) {
        await service.auth.admin.deleteUser(id);
      }
      for (final client in [service, ownerClient, otherClient, shyClient]) {
        await client.dispose();
      }
    });

    test('가입하면 기본 닉네임이 생기고, 30일에 한 번 바꿀 수 있다', () async {
      final users = UserRepository(ownerClient);
      final ownerId = ownerClient.auth.currentUser!.id;
      final user = await users.fetchUser(ownerId);
      expect(user.nickname, matches(RegExp(r'^[가-힣A-Za-z0-9_]{2,12}$')));
      expect(user.nicknameChangeableAt(), isNull, reason: '자동 닉네임은 바로 바꿀 수 있다');
      expect(user.notificationPrefs.ranking, isTrue);

      expect(await users.setNickname('콩이맘$suffix'), '콩이맘$suffix');
      final updated = await users.fetchUser(ownerId);
      expect(updated.nickname, '콩이맘$suffix');
      expect(updated.nicknameChangeableAt(), isNotNull);

      await expectLater(
        users.setNickname('콩이아빠$suffix'),
        throwsA(isA<PostgrestException>().having(friendlyError, 'message', '닉네임은 30일에 한 번 바꿀 수 있어요.')),
      );
    });

    test('운동 기록에 받은 점수가 붙는다', () async {
      final sessions = await ExerciseRepository(ownerClient).fetchSessions(ownerDog.id);
      final points = sessions.single.pointsSummary;
      expect(points?.total, 40);
      expect([points?.attendance, points?.achievement, points?.distance], [10, 10, 20]);
    });

    test('순위표에는 참여한 보호자의 반려견만 닉네임과 함께 나온다', () async {
      final entries = await RankingRepository(otherClient).fetchLeaderboard(RankingQuery(month: month, limit: 100));
      final mine = entries.firstWhere((e) => e.dogId == otherDog.id);
      final owners = entries.firstWhere((e) => e.dogId == ownerDog.id);
      expect(mine.isMine, isTrue);
      expect(owners.nickname, '콩이맘$suffix');
      expect(owners.points, 40);
      expect(owners.breedLabel, '말티즈');
      expect(owners.photoPath, ownerDog.profileImagePath);
      expect(entries.any((e) => e.dogId == shyDog.id), isFalse, reason: '랭킹에 참여하지 않은 보호자의 반려견');

      final small = await RankingRepository(otherClient)
          .fetchLeaderboard(RankingQuery(month: month, scope: RankingScope.size, scopeKey: 'small', limit: 100));
      expect(small.map((e) => e.dogId), containsAll([ownerDog.id, otherDog.id]));
    });

    test('참여하지 않아도 내 순위(참여하면 몇 위인지)를 볼 수 있다', () async {
      final ranking = await RankingRepository(shyClient).fetchMyRanking(shyDog.id, month);
      expect(ranking.participating, isFalse);
      expect(ranking.points, 40);
      expect(ranking.overall, isNotNull);
      expect(ranking.mainBranch?.scopeKey, _yongsanBranchId);
      expect(ranking.sizeRank?.label, '소형견');
    });

    test('랭킹 참여 + 사진 공개인 반려견 사진만 다른 회원이 볼 수 있다', () async {
      final otherDogs = DogRepository(otherClient);
      expect(await otherDogs.createSignedImageUrl(ownerDog.profileImagePath!), contains('token='));
      await expectLater(
        otherDogs.createSignedImageUrl(shyDog.profileImagePath!),
        throwsA(isA<StorageException>()),
        reason: '랭킹에 참여하지 않은 보호자의 사진',
      );

      final ownerId = ownerClient.auth.currentUser!.id;
      await UserRepository(ownerClient).updateRankingShowPhoto(ownerId, show: false);
      await expectLater(otherDogs.createSignedImageUrl(ownerDog.profileImagePath!), throwsA(isA<StorageException>()));
      final hidden = await RankingRepository(otherClient).fetchLeaderboard(RankingQuery(month: month, limit: 100));
      expect(hidden.firstWhere((e) => e.dogId == ownerDog.id).photoPath, isNull);
      await UserRepository(ownerClient).updateRankingShowPhoto(ownerId, show: true);
    });

    test('응원하기: 한 달에 한 번, 내 반려견은 안 되고, 받은 보호자에게 알림이 간다', () async {
      final ranking = RankingRepository(otherClient);
      expect(await ranking.cheer(ownerDog.id), 1);
      expect(await ranking.cheer(ownerDog.id), 1);
      await expectLater(
        ranking.cheer(otherDog.id),
        throwsA(isA<PostgrestException>().having(friendlyError, 'message', '내 반려견은 응원할 수 없어요.')),
      );

      final profile = await ranking.fetchDogProfile(ownerDog.id, month);
      expect(profile.cheerCount, 1);
      expect(profile.cheeredByMe, isTrue);

      final notifications = await ownerClient
          .from('notifications')
          .select('title, type')
          .eq('user_id', ownerClient.auth.currentUser!.id)
          .eq('type', 'ranking');
      expect(notifications.map((n) => n['title']), contains('응원이 도착했어요'));
    });

    test('첫 운동 배지와 진행률', () async {
      final repo = RankingRepository(ownerClient);
      final catalog = await repo.fetchBadgeCatalog();
      final achievements = await repo.fetchAchievements(ownerDog.id);
      expect(catalog, hasLength(12));
      expect(achievements.earned('first_run'), isNotNull);
      expect(achievements.stats.sessions, 1);
      final tenSessions = catalog.firstWhere((b) => b.code == 'sessions_10');
      expect(tenSessions.progressLabel(achievements.stats), '1 / 10회');
    });

    test('지점 대항전과 명예의 전당을 불러온다', () async {
      final repo = RankingRepository(otherClient);
      final battle = await repo.fetchBranchBattle(month);
      expect(battle.map((b) => b.branchId), contains(_yongsanBranchId));
      expect(battle.firstWhere((b) => b.branchId == _yongsanBranchId).distanceMeters, greaterThanOrEqualTo(7000));
      await repo.fetchHallOfFame();
    });

    test('랭킹 참여를 철회하면 순위표에서 바로 빠진다', () async {
      await ConsentRepository(ownerClient)
          .record(ownerClient.auth.currentUser!.id, ConsentType.ranking, granted: false);
      final entries = await RankingRepository(otherClient).fetchLeaderboard(RankingQuery(month: month, limit: 100));
      expect(entries.any((e) => e.dogId == ownerDog.id), isFalse);
      await expectLater(
        RankingRepository(otherClient).fetchDogProfile(ownerDog.id, month),
        throwsA(isA<PostgrestException>()),
      );
    });
  });
}
