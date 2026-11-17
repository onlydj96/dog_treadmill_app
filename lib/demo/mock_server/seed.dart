import 'dart:math';

import '../../core/utils/json.dart';
import '../../features/profile/data/app_user.dart';
import 'booking_api.dart';
import 'catalog.dart';
import 'gait_report.dart';
import 'mock_db.dart';
import 'ranking_api.dart';

/// 데모 계정. 로그인 화면이나 데모 컨트롤에서 바로 로그인할 수 있다.
abstract final class DemoAccount {
  static const email = 'demo@pawfit.local';
  static const password = 'pawfit1234';
  static const userId = 'de300000-0000-4000-8000-000000000001';

  /// 두부 (비숑 프리제, 슬개골 관리 중)
  static const tofuId = 'de3d0000-0000-4000-8000-000000000001';

  /// 망고 (웰시코기)
  static const mangoId = 'de3d0000-0000-4000-8000-000000000002';

  /// 시작할 때 두부가 운동을 마친 횟수. 데모에서 한 번 더 운동하면 「단골 러너」(30회) 배지를 받는다.
  static const tofuSessionsBeforeDemo = 29;
}

class _OwnerSeed {
  const _OwnerSeed(
    this.id,
    this.name,
    this.nickname,
    this.dogs, {
    required this.nameEn,
    required this.nicknameEn,
    this.ranking = true,
    this.email,
  });

  final String id;
  final String name;
  final String nickname;

  /// 데모 전용 영어 값 (`name__en`, `nickname__en`)
  final String nameEn;
  final String nicknameEn;
  final List<_DogSeed> dogs;
  final bool ranking;
  final String? email;
}

class _DogSeed {
  const _DogSeed(
    this.id,
    this.name,
    this.breedId,
    this.sex,
    this.birthDate,
    this.weightKg, {
    required this.nameEn,
    required this.home,
    required this.perWeek,
    required this.programs,
    this.sinceDays = 120,
    this.steady = false,
  });

  final String id;
  final String name;

  /// 데모 전용 영어 이름 (`name__en`)
  final String nameEn;
  final String breedId;
  final String sex;
  final String birthDate;
  final double weightKg;

  /// 주로 가는 지점
  final String home;

  /// 주당 평균 운동 횟수
  final double perWeek;
  final List<String> programs;

  /// 며칠 전부터 운동했는지
  final int sinceDays;

  /// true면 쉬는 주 없이 꾸준히 운동한다 (연속 출석 기록용)
  final bool steady;
}

/// 데모용 샘플 데이터. 지금 시각을 기준으로 지난 기록과 다가오는 예약을 만든다.
///
/// supabase/seed.sql의 랭킹 샘플 보호자(콩이맘·보리아빠…)를 그대로 쓰고, 데모 보호자와 몇 명을 더했다.
/// 지난 운동은 실제 서버처럼 점수 적립·배지·월간 마감 규칙(RankingApi)을 거쳐 쌓는다.
class MockSeed {
  MockSeed(this.db, {required this.booking, required this.ranking, int seed = 20261116}) : _rnd = Random(seed);

  final MockDb db;
  final BookingApi booking;
  final RankingApi ranking;
  final Random _rnd;

  late final DateTime _now = db.now();
  late final DateTime _today = Kst.date(_now);

  static const _demo = _OwnerSeed(
    DemoAccount.userId,
    '이서연',
    '두부망고네',
    nameEn: 'Seoyeon Lee',
    nicknameEn: 'TofuMango',
    email: DemoAccount.email,
    [
      _DogSeed(DemoAccount.tofuId, '두부', 'bichon_frise', 'female', '2021-03-14', 6.2,
          nameEn: 'Tofu',
          home: MockCatalog.yongsan,
          perWeek: 2.8,
          sinceDays: 98,
          steady: true,
          programs: [MockCatalog.jointCare, MockCatalog.jointCare, MockCatalog.gaitCheck, MockCatalog.dailyWalk]),
      _DogSeed(DemoAccount.mangoId, '망고', 'welsh_corgi', 'male', '2022-06-02', 12.8,
          nameEn: 'Mango',
          home: MockCatalog.yongsan,
          perWeek: 1.8,
          sinceDays: 90,
          programs: [MockCatalog.dailyWalk, MockCatalog.interval, MockCatalog.dailyWalk]),
    ],
  );

  static const _others = <_OwnerSeed>[
    _OwnerSeed('5eed0000-0000-4000-8000-000000000001', '김샘플', '콩이맘', nameEn: 'Sample Kim', nicknameEn: 'BeanMom', [
      _DogSeed('5eedd000-0000-4000-8000-000000000001', '콩이', 'maltese', 'female', '2021-04-02', 3.4,
          nameEn: 'Bean',
          home: MockCatalog.yongsan,
          perWeek: 3.0,
          programs: [MockCatalog.dailyWalk, MockCatalog.jointCare, MockCatalog.gaitCheck]),
    ]),
    _OwnerSeed('5eed0000-0000-4000-8000-000000000002', '이샘플', '보리아빠', nameEn: 'Sample Lee', nicknameEn: 'BarleyDad', [
      _DogSeed('5eedd000-0000-4000-8000-000000000002', '보리', 'golden_retriever', 'male', '2020-08-15', 29.5,
          nameEn: 'Barley',
          home: MockCatalog.goyang,
          perWeek: 2.6,
          programs: [MockCatalog.dailyWalk, MockCatalog.interval, MockCatalog.weightCare]),
    ]),
    _OwnerSeed('5eed0000-0000-4000-8000-000000000003', '박샘플', '단풍언니', nameEn: 'Sample Park', nicknameEn: 'MapleSis', [
      _DogSeed('5eedd000-0000-4000-8000-000000000003', '단풍', 'toy_poodle', 'female', '2022-10-01', 3.1,
          nameEn: 'Maple',
          home: MockCatalog.yeongdeungpo,
          perWeek: 2.2,
          programs: [MockCatalog.dailyWalk, MockCatalog.firstStep, MockCatalog.gaitCheck]),
    ]),
    _OwnerSeed('5eed0000-0000-4000-8000-000000000004', '최샘플', '모카집사', nameEn: 'Sample Choi', nicknameEn: 'MochaPal', [
      _DogSeed('5eedd000-0000-4000-8000-000000000004', '모카', 'pomeranian', 'male', '2019-03-20', 2.8,
          nameEn: 'Mocha',
          home: MockCatalog.yeongdeungpo,
          perWeek: 1.4,
          programs: [MockCatalog.jointCare, MockCatalog.dailyWalk]),
      _DogSeed('5eedd000-0000-4000-8000-000000000005', '호두', 'welsh_corgi', 'male', '2021-12-11', 12.4,
          nameEn: 'Walnut',
          home: MockCatalog.yeongdeungpo,
          perWeek: 1.6,
          programs: [MockCatalog.interval, MockCatalog.dailyWalk]),
    ]),
    _OwnerSeed('5eed0000-0000-4000-8000-000000000005', '정샘플', '초코러버', nameEn: 'Sample Jung', nicknameEn: 'ChocoLover', [
      _DogSeed('5eedd000-0000-4000-8000-000000000006', '초코', 'shiba_inu', 'female', '2020-05-05', 9.8,
          nameEn: 'Choco',
          home: MockCatalog.goyang,
          perWeek: 2.8,
          programs: [MockCatalog.interval, MockCatalog.dailyWalk, MockCatalog.weightCare]),
    ]),
    // 랭킹에 참여하지 않은 보호자: 순위표·명예의 전당에는 나오지 않지만 지점 대항전 거리에는 들어간다
    _OwnerSeed(
        '5eed0000-0000-4000-8000-000000000006',
        '강샘플',
        '산책왕',
        nameEn: 'Sample Kang',
        nicknameEn: 'WalkKing',
        ranking: false,
        [
          _DogSeed('5eedd000-0000-4000-8000-000000000007', '해피', 'jindo', 'male', '2018-01-30', 18.0,
              nameEn: 'Happy',
              home: MockCatalog.goyang,
              perWeek: 2.0,
              programs: [MockCatalog.dailyWalk, MockCatalog.weightCare]),
          _DogSeed('5eedd000-0000-4000-8000-000000000008', '구름', 'samoyed', 'female', '2022-02-14', 22.5,
              nameEn: 'Cloud', home: MockCatalog.goyang, perWeek: 1.5, programs: [MockCatalog.dailyWalk]),
        ]),
    _OwnerSeed('5eed0000-0000-4000-8000-000000000007', '윤샘플', '라떼언니', nameEn: 'Sample Yoon', nicknameEn: 'LatteSis', [
      _DogSeed('5eedd000-0000-4000-8000-000000000009', '라떼', 'miniature_poodle', 'female', '2020-09-09', 5.1,
          nameEn: 'Latte',
          home: MockCatalog.yongsan,
          perWeek: 2.0,
          programs: [MockCatalog.dailyWalk, MockCatalog.gaitCheck]),
    ]),
    _OwnerSeed('5eed0000-0000-4000-8000-000000000008', '장샘플', '뭉치네', nameEn: 'Sample Jang', nicknameEn: 'BiscuitCrew', [
      _DogSeed('5eedd000-0000-4000-8000-00000000000a', '뭉치', 'beagle', 'male', '2019-11-23', 13.2,
          nameEn: 'Biscuit',
          home: MockCatalog.yeongdeungpo,
          perWeek: 2.4,
          programs: [MockCatalog.interval, MockCatalog.weightCare]),
    ]),
    _OwnerSeed('5eed0000-0000-4000-8000-000000000009', '임샘플', '하루아빠', nameEn: 'Sample Im', nicknameEn: 'HaruDad', [
      _DogSeed('5eedd000-0000-4000-8000-00000000000b', '하루', 'labrador_retriever', 'female', '2021-01-17', 27.0,
          nameEn: 'Haru',
          home: MockCatalog.goyang,
          perWeek: 2.0,
          programs: [MockCatalog.weightCare, MockCatalog.dailyWalk]),
    ]),
    _OwnerSeed('5eed0000-0000-4000-8000-00000000000a', '한샘플', '쿠키맘', nameEn: 'Sample Han', nicknameEn: 'CookieMom', [
      _DogSeed('5eedd000-0000-4000-8000-00000000000c', '쿠키', 'dachshund', 'male', '2020-02-29', 6.0,
          nameEn: 'Cookie',
          home: MockCatalog.yongsan,
          perWeek: 1.2,
          programs: [MockCatalog.jointCare, MockCatalog.dailyWalk]),
    ]),
  ];

  static const _stopReasons = ['반려견이 지쳐 보여 보호자가 중단', '비상정지 버튼으로 중단', '반려견이 불안해해 일찍 마침'];
  static const _stopReasonsEn = [
    'Stopped by the owner because the dog looked tired',
    'Stopped with the emergency stop button',
    'Finished early because the dog was anxious',
  ];

  late String _membershipSingle;
  late String _membershipFirstTen;
  late String _membershipCurrentTen;

  void run() {
    db.muteNotifications = true;
    _catalog();
    for (final (i, owner) in [_demo, ..._others].indexed) {
      _owner(owner, joinedDaysAgo: owner == _demo ? 100 : 130 - i, sampleNo: i);
    }
    _healthProfiles();
    _memberships();

    final sessions = <Json>[
      for (final owner in [_demo, ..._others])
        for (final dog in owner.dogs) ..._dogHistory(owner, dog),
    ];
    _shapeDemoHistory(sessions);
    sessions.sort((a, b) => a.str('started_at').compareTo(b.str('started_at')));
    for (final session in sessions) {
      ranking.awardSessionPoints(session);
    }
    _analysisReports(sessions);
    _assignMemberships();
    ranking.closeDueMonths();

    _cheers();
    _othersUpcomingBookings();
    _demoBookings();
    _support();
    db.muteNotifications = false;
    _notifications();
  }

  // ---------------------------------------------------------------------
  // 기준 데이터 · 회원
  // ---------------------------------------------------------------------

  void _catalog() {
    MockCatalog.branches().forEach((r) => db.insert('branches', r));
    MockCatalog.treadmills().forEach((r) => db.insert('treadmills', r));
    MockCatalog.programs().forEach((r) => db.insert('exercise_programs', r));
    MockCatalog.membershipPlans().forEach((r) => db.insert('membership_plans', r));
    MockCatalog.breeds().forEach((r) => db.insert('breeds', r));
    MockCatalog.healthConditions().forEach((r) => db.insert('health_conditions', r));
    MockCatalog.badges().forEach((r) => db.insert('badges', r));
    MockCatalog.faqs().forEach((r) => db.insert('faqs', r));
  }

  DateTime _daysAgo(int days, {int hour = 10, int minute = 0}) =>
      Kst.at(_today.subtract(Duration(days: days)), hour * 60 + minute);

  void _owner(_OwnerSeed owner, {required int joinedDaysAgo, required int sampleNo}) {
    final joinedAt = iso(_daysAgo(joinedDaysAgo, hour: 20));
    final email = owner.email ?? 'sample$sampleNo@pawfit.local';
    db
      ..insert('auth_users', {'id': owner.id, 'email': email, 'password': DemoAccount.password})
      ..insert('users', {
        'id': owner.id,
        'name': owner.name,
        'name__en': owner.nameEn,
        'phone': owner == _demo ? '010-2468-1357' : '010-1000-${sampleNo.toString().padLeft(4, '0')}',
        'role': 'user',
        'notification_prefs': const NotificationPrefs().toJson(),
        'nickname': owner.nickname,
        'nickname__en': owner.nicknameEn,
        'nickname_updated_at': owner == _demo ? iso(_daysAgo(45)) : null,
        'ranking_show_photo': true,
        'managed_branch_id': null,
        'created_at': joinedAt,
      });

    final video = owner == _demo || _rnd.nextBool();
    for (final (type, granted) in [
      ('terms', true),
      ('privacy', true),
      ('video_recording', video),
      ('ai_training', false),
      ('ranking', owner.ranking),
      ('marketing', false),
    ]) {
      db.insert('data_consents', {
        'user_id': owner.id,
        'consent_type': type,
        'consent_version': '1.0',
        'granted': granted,
        'responded_at': joinedAt,
      });
    }

    for (final dog in owner.dogs) {
      final breed = db.byId('breeds', dog.breedId)!;
      db.insert('dogs', {
        'id': dog.id,
        'owner_id': owner.id,
        'name': dog.name,
        'name__en': dog.nameEn,
        'breed': breed['name'],
        'breed_id': dog.breedId,
        'is_mixed': false,
        'size_class': breed['size_class'],
        'is_brachycephalic': breed['is_brachycephalic'],
        'birth_date': dog.birthDate,
        'birth_date_estimated': false,
        'sex': dog.sex,
        'neutered': true,
        'weight_kg': dog.weightKg,
        'profile_image_path': null,
        'deleted_at': null,
        'created_at': iso(_daysAgo(joinedDaysAgo, hour: 20, minute: 10)),
      });
    }
  }

  void _healthProfiles() {
    db
      ..insert('dog_health_profiles', {
        'id': db.newId(),
        'dog_id': DemoAccount.tofuId,
        'condition_codes': ['joint_disease'],
        'diseases': [
          {'name': '슬개골 탈구 1기', 'detail': '왼쪽 뒷다리', 'date': toDateString(_today.subtract(const Duration(days: 120)))},
        ],
        'diseases__en': [
          {
            'name': 'Patellar luxation, grade 1',
            'detail': 'Left hind leg',
            'date': toDateString(_today.subtract(const Duration(days: 120))),
          },
        ],
        'surgeries': <Json>[],
        'medications': [
          {'name': '관절 영양제', 'detail': '하루 1회'},
        ],
        'medications__en': [
          {'name': 'Joint supplement', 'detail': 'Once a day'},
        ],
        'exercise_restrictions': [
          {'name': '점프·급회전 피하기'},
        ],
        'exercise_restrictions__en': [
          {'name': 'Avoid jumping and sharp turns'},
        ],
        'veterinary_notes': '체중을 유지하면서 낮은 강도로 꾸준히 걷는 운동을 권장받았어요.',
        'veterinary_notes__en': 'The vet recommended steady, low-intensity walking while keeping weight stable.',
        'updated_at': iso(_daysAgo(97)),
      })
      ..insert('dog_health_profiles', {
        'id': db.newId(),
        'dog_id': DemoAccount.mangoId,
        'condition_codes': <String>[],
        'diseases': <Json>[],
        'surgeries': <Json>[],
        'medications': <Json>[],
        'exercise_restrictions': <Json>[],
        'veterinary_notes': null,
        'updated_at': iso(_daysAgo(89)),
      })
      ..insert('exercise_plans', {
        'dog_id': DemoAccount.tofuId,
        'program_name': '관절 케어 걷기',
        'program_name__en': 'Joint Care Walk',
        'target_duration_seconds': 20 * 60,
        'target_speed': 2.6,
        'restrictions': [
          {'name': '경사 없이 평지로'},
          {'name': '점프 금지'},
        ],
        'restrictions__en': [
          {'name': 'Flat surface, no incline'},
          {'name': 'No jumping'},
        ],
        'notes': '주 2~3회, 처음 3분과 마지막 3분은 더 천천히 걸어요.',
        'notes__en': 'Two to three times a week. Walk more slowly for the first and last 3 minutes.',
        'is_active': true,
        'created_at': iso(_daysAgo(60)),
      });
  }

  /// 1회권(만료) → 10회권(소진) → 10회권(사용 중)
  void _memberships() {
    String add(
        String planName, String planNameEn, int total, int startDaysAgo, int validityDays, int price, String method) {
      final startsAt = _daysAgo(startDaysAgo, hour: 9);
      final membership = db.insert('memberships', {
        'user_id': DemoAccount.userId,
        'plan_name': planName,
        'total_sessions': total,
        'remaining_sessions': total,
        'starts_at': iso(startsAt),
        'expires_at': iso(startsAt.add(Duration(days: validityDays))),
        'status': startDaysAgo > validityDays ? 'expired' : 'active',
        'created_at': iso(startsAt),
      });
      db.insert('payments', {
        'user_id': DemoAccount.userId,
        'amount': price,
        'status': 'paid',
        'order_name': planName,
        'order_name__en': planNameEn,
        'method': method,
        'refunded_amount': 0,
        'paid_at': iso(startsAt),
        'refunded_at': null,
        'created_at': iso(startsAt),
      });
      return membership.str('id');
    }

    _membershipSingle = add('1회 이용권', 'Single-session pass', 1, 99, 30, 25000, '카드');
    _membershipFirstTen = add('10회 이용권', '10-session pass', 10, 84, 90, 220000, '카드');
    _membershipCurrentTen = add('10회 이용권', '10-session pass', 10, 26, 90, 220000, '카카오페이');
  }

  // ---------------------------------------------------------------------
  // 지난 운동 기록
  // ---------------------------------------------------------------------

  List<Json> _dogHistory(_OwnerSeed owner, _DogSeed dog) {
    final first = _today.subtract(Duration(days: dog.sinceDays));
    final last = _today.subtract(const Duration(days: 1));
    final sessions = <Json>[];
    for (var week = Kst.weekStart(first); !week.isAfter(last); week = week.add(const Duration(days: 7))) {
      var count = dog.perWeek.floor() + (_rnd.nextDouble() < dog.perWeek % 1 ? 1 : 0);
      if (!dog.steady && _rnd.nextDouble() < 0.08) count = 0; // 쉬는 주
      final days = ([0, 1, 2, 3, 4, 5, 6]..shuffle(_rnd)).take(max(count, dog.steady ? 1 : 0)).toList()..sort();
      for (final offset in days) {
        final date = week.add(Duration(days: offset));
        if (date.isBefore(first) || date.isAfter(last)) continue;
        sessions.add(_pastSession(owner, dog, date));
      }
    }
    return sessions;
  }

  Json _pastSession(
    _OwnerSeed owner,
    _DogSeed dog,
    DateTime date, {
    String? programId,
    String? branchId,
    int? slotIndex,
    int? durationSeconds,
    String? stopReason,
    String? stopReasonEn,
  }) {
    final branch = branchId ?? (_rnd.nextDouble() < 0.85 ? dog.home : _otherBranch(dog.home));
    final branchRow = db.byId('branches', branch)!;
    final program = db.byId('exercise_programs', programId ?? dog.programs[_rnd.nextInt(dog.programs.length)])!;
    final minutes = program.intOr('duration_minutes');
    final opens = Kst.minutesOf(branchRow.str('opens_at'));
    final closes = Kst.minutesOf(branchRow.str('closes_at'));
    final slots = (closes - minutes - opens) ~/ 30 + 1;
    // 12%는 개점 직후(오픈런)
    final slot = slotIndex ?? (_rnd.nextDouble() < 0.12 ? 0 : _rnd.nextInt(slots));
    final startAt = Kst.at(date, opens + slot * 30);
    final treadmillId = MockCatalog.treadmillId(branch, 1 + _rnd.nextInt(MockCatalog.treadmillCounts[branch]!));

    final target = minutes * 60;
    final stopped = durationSeconds != null ? durationSeconds < target : _rnd.nextDouble() < 0.07;
    final duration = durationSeconds ?? (stopped ? (target * (0.35 + _rnd.nextDouble() * 0.45)).round() : target);
    final dogRow = db.byId('dogs', dog.id)!;
    final intensity = program.str('intensity');
    final average = _cruise(dogRow, intensity) * (0.95 + _rnd.nextDouble() * 0.05);
    final distance = average / 3.6 * duration;
    final startedAt = startAt.add(Duration(minutes: 1 + _rnd.nextInt(4)));
    final endedAt = startedAt.add(Duration(seconds: duration));

    final bookingRow = db.insert('bookings', {
      'user_id': owner.id,
      'dog_id': dog.id,
      'branch_id': branch,
      'treadmill_id': treadmillId,
      'program_id': program['id'],
      'membership_id': null,
      'start_at': iso(startAt),
      'end_at': iso(startAt.add(Duration(minutes: minutes))),
      'status': 'completed',
      'note': null,
      'cancel_reason': null,
      'cancelled_at': null,
      'created_at': iso(startAt.subtract(Duration(days: 1 + _rnd.nextInt(4), hours: _rnd.nextInt(8)))),
    });
    return db.insert('exercise_sessions', {
      'dog_id': dog.id,
      'booking_id': bookingRow['id'],
      'treadmill_id': treadmillId,
      'status': stopped ? 'stopped' : 'completed',
      'started_at': iso(startedAt),
      'ended_at': iso(endedAt),
      'duration_seconds': duration,
      'distance_meters': (distance * 10).round() / 10,
      'current_speed': 0.0,
      'average_speed': (distance / duration * 3.6 * 10).round() / 10,
      'max_speed': (average * (intensity == 'high' ? 1.45 : 1.18) * 10).round() / 10,
      'target_duration_seconds': target,
      ...() {
        if (!stopped) return {'stop_reason': null};
        if (stopReason != null) return {'stop_reason': stopReason, 'stop_reason__en': stopReasonEn};
        final i = _rnd.nextInt(_stopReasons.length);
        return {'stop_reason': _stopReasons[i], 'stop_reason__en': _stopReasonsEn[i]};
      }(),
      'created_at': iso(startedAt),
      'updated_at': iso(endedAt),
    });
  }

  double _cruise(Json dog, String intensity) {
    final (low, medium, high) = switch (dog['size_class']) {
      'small' => (2.4, 2.9, 3.4),
      'large' => (3.8, 4.8, 5.6),
      _ => (3.2, 4.0, 4.6),
    };
    return switch (intensity) {
      'low' => low,
      'high' => high,
      _ => medium,
    };
  }

  String _otherBranch(String home) {
    final others = [MockCatalog.yongsan, MockCatalog.goyang, MockCatalog.yeongdeungpo]..remove(home);
    return others[_rnd.nextInt(others.length)];
  }

  /// 데모 반려견 기록 다듬기: 두부는 첫 운동이 5분 미만이고 데모 전까지 29회, 망고는 하루 두 번 운동한 날이 있다.
  void _shapeDemoHistory(List<Json> sessions) {
    List<Json> of(String dogId) => sessions.where((s) => s['dog_id'] == dogId).toList()
      ..sort((a, b) => a.str('started_at').compareTo(b.str('started_at')));

    final tofu = of(DemoAccount.tofuId);
    for (final extra in tofu.take(max(0, tofu.length - DemoAccount.tofuSessionsBeforeDemo))) {
      sessions.remove(extra);
      db
        ..delete('exercise_sessions', (s) => s['id'] == extra['id'])
        ..delete('bookings', (b) => b['id'] == extra['booking_id']);
    }
    // 정상 기록 29회와 별개로, 처음 온 날 낯설어해 3분 만에 마친 기록 (점수 0점·too_short)
    final firstVisit = of(DemoAccount.tofuId).first.dateTime('started_at');
    sessions.add(_pastSession(
      _demo,
      _demo.dogs[0],
      Kst.date(firstVisit).subtract(const Duration(days: 2)),
      programId: MockCatalog.firstStep,
      branchId: MockCatalog.yongsan,
      slotIndex: 6,
      durationSeconds: 200,
      stopReason: '처음이라 낯설어해 보호자가 중단',
      stopReasonEn: 'Stopped by the owner because it was the dog\'s first visit and it seemed unsure',
    ));

    // 같은 날 두 번째 운동은 점수 0점 (daily_limit)
    final mango = of(DemoAccount.mangoId);
    final day = mango.lastWhere((s) => s.dateTime('started_at').isBefore(_now.subtract(const Duration(days: 8))));
    final morning = Kst.wall(day.dateTime('started_at')).hour < 15;
    sessions.add(_pastSession(
      _demo,
      _demo.dogs[1],
      Kst.date(day.dateTime('started_at')),
      programId: MockCatalog.dailyWalk,
      branchId: MockCatalog.goyang,
      slotIndex: morning ? 15 : 1,
    ));
  }

  /// 영상 촬영에 동의한 데모 보호자의 운동마다 AI 리포트. 두부는 관절 케어를 하며 점점 좋아지는 흐름이다.
  void _analysisReports(List<Json> sessions) {
    for (final dogId in [DemoAccount.tofuId, DemoAccount.mangoId]) {
      final dog = db.byId('dogs', dogId)!;
      final own = sessions.where((s) => s['dog_id'] == dogId).toList();
      for (final (i, session) in own.indexed) {
        final endedAt = session.dateTime('ended_at');
        final base = {
          'session_id': session['id'],
          'dog_id': dogId,
          'skeleton_video_path': null,
          'report_pdf_path': null,
          'created_at': iso(endedAt.add(const Duration(minutes: 1))),
        };
        if (session.intOr('duration_seconds') < 300) {
          db.insert('analysis_reports', {
            ...base,
            'analysis_status': 'failed',
            'care_notes': <String>[],
            'error_message': '운동 시간이 짧아 분석에 필요한 걸음 수가 부족했어요.',
            'error_message__en': 'The workout was too short to capture enough steps for analysis.',
          });
          continue;
        }
        final progress = own.length <= 1 ? 1.0 : i / (own.length - 1);
        db.insert('analysis_reports', {
          ...base,
          ...generateGaitReport(
            dog: dog,
            random: _rnd,
            issueLevel: dogId == DemoAccount.tofuId ? 0.95 - 0.7 * progress + (_rnd.nextDouble() - 0.5) * 0.2 : 0,
          ),
          'analysis_status': 'completed',
          'completed_at': iso(endedAt.add(Duration(minutes: 8 + _rnd.nextInt(6)))),
        });
      }
    }
  }

  /// 1회권 → 10회권 10번 → (현장 결제) → 지금 쓰는 10회권 6번
  void _assignMemberships() {
    final bookings = db
        .where('bookings', (b) => b['user_id'] == DemoAccount.userId && b['status'] == 'completed')
        .toList()
      ..sort((a, b) => a.str('start_at').compareTo(b.str('start_at')));
    var firstTenUsed = 0;
    var currentUsed = 0;
    var singleUsed = false;
    final currentStart = db.byId('memberships', _membershipCurrentTen)!.dateTime('starts_at');
    final firstTenStart = db.byId('memberships', _membershipFirstTen)!.dateTime('starts_at');
    for (final row in bookings) {
      final start = row.dateTime('start_at');
      String? membership;
      if (!singleUsed) {
        membership = _membershipSingle;
        singleUsed = true;
      } else if (!start.isBefore(currentStart) && currentUsed < 6) {
        membership = _membershipCurrentTen;
        currentUsed++;
      } else if (!start.isBefore(firstTenStart) && firstTenUsed < 10 && start.isBefore(currentStart)) {
        membership = _membershipFirstTen;
        firstTenUsed++;
      }
      if (membership != null) row['membership_id'] = membership;
    }
    db.byId('memberships', _membershipSingle)!['remaining_sessions'] = 0;
    db.byId('memberships', _membershipFirstTen)!['remaining_sessions'] = 10 - firstTenUsed;
    db.byId('memberships', _membershipCurrentTen)!['remaining_sessions'] = 10 - currentUsed;
  }

  // ---------------------------------------------------------------------
  // 응원 · 예약 · 고객지원 · 알림
  // ---------------------------------------------------------------------

  void _cheers() {
    final month = toDateString(ranking.currentMonth());
    final participants = [_demo, ..._others].where((o) => o.ranking).toList();
    final elapsedHours = max(1, _now.difference(Kst.at(ranking.currentMonth(), 0)).inHours);
    void cheer(String userId, String dogId, {int? hoursAgo}) {
      if (db.table('ranking_cheers').any((c) => c['dog_id'] == dogId && c['user_id'] == userId)) return;
      db.insert('ranking_cheers', {
        'period_month': month,
        'dog_id': dogId,
        'user_id': userId,
        'created_at': iso(_now.subtract(Duration(hours: hoursAgo ?? _rnd.nextInt(elapsedHours)))),
      });
    }

    cheer(_others[0].id, DemoAccount.tofuId, hoursAgo: min(3, elapsedHours - 1));
    cheer(_others[6].id, DemoAccount.tofuId);
    cheer(DemoAccount.userId, _others[0].dogs.first.id);
    cheer(DemoAccount.userId, _others[1].dogs.first.id);
    for (final owner in participants.where((o) => o != _demo)) {
      final count = 1 + _rnd.nextInt(3);
      for (var i = 0; i < count; i++) {
        final target = participants[_rnd.nextInt(participants.length)];
        if (target == owner) continue;
        cheer(owner.id, target.dogs[_rnd.nextInt(target.dogs.length)].id);
      }
    }
  }

  /// 다른 보호자의 앞으로 열흘 예약. 예약 화면에서 남은 자리·마감이 보이도록 주말 오후를 붐비게 한다.
  void _othersUpcomingBookings() {
    final dogs = [
      for (final owner in _others)
        for (final dog in owner.dogs) (owner.id, dog.id),
    ];
    const programs = [MockCatalog.dailyWalk, MockCatalog.interval, MockCatalog.jointCare, MockCatalog.gaitCheck];
    for (var day = 0; day <= 10; day++) {
      final date = _today.add(Duration(days: day));
      final weekend = date.weekday >= DateTime.saturday;
      for (final branch in db.table('branches')) {
        final opens = Kst.minutesOf(branch.str('opens_at'));
        final closes = Kst.minutesOf(branch.str('closes_at'));
        final treadmills = booking.machines(branch.str('id'));
        for (var minute = opens; minute + 30 <= closes; minute += 30) {
          final start = Kst.at(date, minute);
          if (!start.isAfter(_now)) continue;
          final hour = minute ~/ 60;
          final busy = weekend ? (hour >= 13 && hour < 18) : (hour >= 18 && hour < 21);
          var rate = busy ? 0.55 : 0.18;
          if (weekend && hour >= 14 && hour < 16 && branch['id'] == MockCatalog.goyang) rate = 1; // 마감 시간대
          for (final treadmill in treadmills) {
            if (_rnd.nextDouble() >= rate) continue;
            final (userId, dogId) = dogs[_rnd.nextInt(dogs.length)];
            final programId = programs[_rnd.nextInt(programs.length)];
            final minutes = db.byId('exercise_programs', programId)!.intOr('duration_minutes');
            db.insert('bookings', {
              'user_id': userId,
              'dog_id': dogId,
              'branch_id': branch['id'],
              'treadmill_id': treadmill['id'],
              'program_id': programId,
              'membership_id': null,
              'start_at': iso(start),
              'end_at': iso(start.add(Duration(minutes: minutes))),
              'status': 'confirmed',
              'note': null,
              'cancel_reason': null,
              'cancelled_at': null,
              'created_at': iso(_now.subtract(Duration(hours: 1 + _rnd.nextInt(72)))),
            });
          }
        }
      }
    }
  }

  /// 데모 보호자의 예약: 곧 시작하는 예약(지금 체크인 가능), 현장 결제 대기, 다음 주 예약, 지난 취소·미방문
  void _demoBookings() {
    final soon = DateTime.fromMillisecondsSinceEpoch(
      (_now.add(const Duration(minutes: 10)).millisecondsSinceEpoch ~/ 300000 + 1) * 300000,
      isUtc: true,
    );
    _insertDemoBooking(DemoAccount.tofuId, MockCatalog.yongsan, MockCatalog.gaitCheck, soon,
        status: 'confirmed', membershipId: _membershipCurrentTen);
    _insertDemoBooking(DemoAccount.mangoId, MockCatalog.goyang, MockCatalog.interval,
        Kst.at(_today.add(const Duration(days: 2)), 14 * 60),
        status: 'pending', note: '처음 가 보는 지점이에요', noteEn: 'First time at this location');
    _insertDemoBooking(DemoAccount.tofuId, MockCatalog.yongsan, MockCatalog.jointCare,
        Kst.at(_today.add(const Duration(days: 6)), 11 * 60),
        status: 'confirmed', membershipId: _membershipCurrentTen);
    _insertDemoBooking(DemoAccount.tofuId, MockCatalog.yongsan, MockCatalog.jointCare,
        Kst.at(_today.subtract(const Duration(days: 10)), 19 * 60),
        status: 'cancelled', cancelReason: '일정이 바뀌었어요', cancelReasonEn: 'My plans changed');
    _insertDemoBooking(DemoAccount.mangoId, MockCatalog.yongsan, MockCatalog.dailyWalk,
        Kst.at(_today.subtract(const Duration(days: 17)), 13 * 60),
        status: 'no_show');

    final current = db.byId('memberships', _membershipCurrentTen)!;
    current['remaining_sessions'] = current.intOr('remaining_sessions') - 2;
  }

  void _insertDemoBooking(
    String dogId,
    String branchId,
    String programId,
    DateTime startAt, {
    required String status,
    String? membershipId,
    String? note,
    String? noteEn,
    String? cancelReason,
    String? cancelReasonEn,
  }) {
    final minutes = db.byId('exercise_programs', programId)!.intOr('duration_minutes');
    final endAt = startAt.add(Duration(minutes: minutes));
    final machines = booking.machines(branchId);
    var treadmill = machines.where((t) => !booking.treadmillBusy(t.str('id'), startAt, endAt)).firstOrNull;
    if (treadmill == null) {
      // 꽉 찬 시간이면 다른 보호자 예약 하나를 비운다
      treadmill = machines.first;
      db.delete(
        'bookings',
        (b) =>
            b['treadmill_id'] == treadmill!['id'] &&
            BookingApi.activeStatuses.contains(b['status']) &&
            b.dateTime('start_at').isBefore(endAt) &&
            startAt.isBefore(b.dateTime('end_at')),
      );
    }
    db.insert('bookings', {
      'user_id': DemoAccount.userId,
      'dog_id': dogId,
      'branch_id': branchId,
      'treadmill_id': treadmill['id'],
      'program_id': programId,
      'membership_id': membershipId,
      'start_at': iso(startAt),
      'end_at': iso(endAt),
      'status': status,
      'note': note,
      'note__en': noteEn,
      'cancel_reason': cancelReason,
      'cancel_reason__en': cancelReasonEn,
      'cancelled_at': status == 'cancelled' ? iso(startAt.subtract(const Duration(days: 1))) : null,
      'created_at': iso(
          startAt.isAfter(_now) ? _now.subtract(const Duration(days: 1)) : startAt.subtract(const Duration(days: 3))),
    });
  }

  void _support() {
    for (final (i, (title, body, pinned, daysAgo)) in MockCatalog.notices.indexed) {
      db.insert('notices', {
        'title': title,
        'title_en': CatalogEn.notices[i].$1,
        'body': body,
        'body_en': CatalogEn.notices[i].$2,
        'is_pinned': pinned,
        'published_at': iso(_daysAgo(daysAgo)),
      });
    }
    db.insert('inquiries', {
      'user_id': DemoAccount.userId,
      'category': 'booking',
      'title': '예약 시간을 30분 늦출 수 있을까요?',
      'title__en': 'Could I move my booking 30 minutes later?',
      'body': '오늘 예약했는데 도착이 조금 늦어질 것 같아요. 앱에서 변경이 안 되는데 어떻게 하면 될까요?',
      'body__en': 'I booked for today but I\'ll be a bit late. I can\'t change it in the app. What should I do?',
      'status': 'answered',
      'answer': '예약 시작 1시간 전부터는 앱에서 변경할 수 없어요. 이번 예약은 운영팀에서 30분 뒤로 옮겨 드렸어요. '
          '다음에는 시작 1시간 전까지 앱에서 직접 바꿔 주세요.',
      'answer__en': 'Bookings can\'t be changed in the app within 1 hour of the start time. '
          'We\'ve moved this one 30 minutes later for you. Next time, please change it in the app up to 1 hour before it starts.',
      'answered_at': iso(_daysAgo(32, hour: 15)),
      'created_at': iso(_daysAgo(32, hour: 13, minute: 20)),
    });
  }

  /// 데모 보호자의 최근 알림. 샘플 데이터를 쌓는 동안에는 알림을 끄고, 실제로 받았을 법한 것만 다시 만든다.
  /// 실제 DB 트리거와 같이 한국어 title/body에 data.msg·data.args를 함께 저장한다 (docs/i18n.md).
  void _notifications() {
    void add(String type, String title, String body, String msg, Json args, Json data, String createdAt,
        {required bool read}) {
      db.insert('notifications', {
        'user_id': DemoAccount.userId,
        'type': type,
        'title': title,
        'body': body,
        'data': {...data, 'msg': msg, 'args': args},
        'is_read': read,
        'created_at': createdAt,
      });
    }

    Json dogArgs(String dogId) => MockDb.dogNameArgs(db.byId('dogs', dogId)!);

    final recentReport = db
        .where('analysis_reports', (r) => r['dog_id'] == DemoAccount.tofuId && r['analysis_status'] == 'completed')
        .reduce((a, b) => a.str('created_at').compareTo(b.str('created_at')) >= 0 ? a : b);
    add('analysis', 'AI 보행 분석 리포트가 도착했어요', '두부의 운동 분석 결과를 확인해 보세요.', 'analysis_completed', dogArgs(DemoAccount.tofuId),
        {'report_id': recentReport['id']}, recentReport.str('completed_at'),
        read: false);

    // 시상대 배지는 월간 수상 알림으로 함께 알린다 (배지 알림을 따로 만들지 않음)
    final badges = db
        .where(
          'dog_badges',
          (b) =>
              (b['dog_id'] == DemoAccount.tofuId || b['dog_id'] == DemoAccount.mangoId) && b['badge_code'] != 'podium',
        )
        .toList()
      ..sort((a, b) => b.str('earned_at').compareTo(a.str('earned_at')));
    for (final (i, badge) in badges.take(2).indexed) {
      final dogName = badge['dog_id'] == DemoAccount.tofuId ? '두부' : '망고';
      final badgeRow = db.find('badges', (b) => b['code'] == badge['badge_code'])!;
      final name = badgeRow['name'];
      add(
          'ranking',
          '새 배지를 받았어요',
          '$dogName의 「$name」 배지가 도착했어요. 배지함에서 확인해 보세요.',
          'badge_earned',
          {
            ...dogArgs(badge.str('dog_id')),
            'badge_code': badge['badge_code'],
            'badge_name': name,
            'badge_name_en': badgeRow['name_en'],
          },
          {'dog_id': badge['dog_id'], 'badge_code': badge['badge_code']},
          badge.str('earned_at'),
          read: i > 0);
    }

    final cheer = db.find('ranking_cheers', (c) => c['dog_id'] == DemoAccount.tofuId && c['user_id'] == _others[0].id);
    if (cheer != null) {
      add(
          'ranking',
          '응원이 도착했어요',
          '콩이맘님이 두부를 응원했어요.',
          'cheer_received',
          {
            ...dogArgs(DemoAccount.tofuId),
            'nickname': _others[0].nickname,
            'nickname__en': _others[0].nicknameEn,
          },
          {'dog_id': DemoAccount.tofuId},
          cheer.str('created_at'),
          read: false);
    }

    final previousMonth = toDateString(DateTime.utc(_today.year, _today.month - 1));
    final awards =
        db.where('monthly_awards', (a) => a['period_month'] == previousMonth && a['owner_id'] == DemoAccount.userId);
    for (final dogId in awards.map((a) => a.str('dog_id')).toSet()) {
      final mine = awards.where((a) => a['dog_id'] == dogId).toList()
        ..sort((a, b) => a.intOr('rank').compareTo(b.intOr('rank')));
      final dogName = dogId == DemoAccount.tofuId ? '두부' : '망고';
      final month = _today.month == 1 ? 12 : _today.month - 1;
      final summary =
          mine.map((a) => '${ranking.scopeLabel(a.str('scope'), a.str('scope_key'))} ${a['rank']}위').join(' · ');
      add(
          'ranking',
          '$month월 랭킹 시상대에 올랐어요',
          '${RankingApi.josa(dogName, '가', '이')} $month월 랭킹 $summary에 올랐어요. 명예의 전당에서 확인해 보세요.',
          'monthly_award',
          {
            ...dogArgs(dogId),
            'month': month,
            'awards': [
              for (final a in mine)
                {
                  'scope': a['scope'],
                  'label': ranking.scopeLabel(a.str('scope'), a.str('scope_key')),
                  'label_en': ranking.scopeLabelEn(a.str('scope'), a.str('scope_key')),
                  'rank': a['rank'],
                },
            ],
          },
          {'period_month': previousMonth, 'dog_id': dogId},
          mine.first.str('created_at'),
          read: true);
    }

    final mango = db.where('exercise_sessions', (s) => s['dog_id'] == DemoAccount.mangoId).toList()
      ..sort((a, b) => b.str('started_at').compareTo(a.str('started_at')));
    if (mango.isNotEmpty) {
      final points = db
          .where('exercise_points', (p) => p['session_id'] == mango.first['id'])
          .fold<int>(0, (sum, p) => sum + p.intOr('points'));
      add(
          'exercise',
          '운동을 완료했어요',
          '망고의 운동이 끝났어요. $points점을 받았어요! 운동 기록을 확인해 보세요.',
          'exercise_completed',
          {...dogArgs(DemoAccount.mangoId), 'points': points},
          {'session_id': mango.first['id']},
          mango.first.str('ended_at'),
          read: true);
    }
  }
}
