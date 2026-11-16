import '../../core/utils/json.dart';

/// 실제 서버의 기준 데이터와 같은 값 (supabase/migrations, supabase/seed.sql).
/// 지점·운동 프로그램·트레드밀 ID도 운영 DB와 같다.
abstract final class MockCatalog {
  static const yongsan = 'b1000000-0000-4000-8000-000000000001';
  static const goyang = 'b1000000-0000-4000-8000-000000000002';
  static const yeongdeungpo = 'b1000000-0000-4000-8000-000000000003';

  static const firstStep = 'c1000000-0000-4000-8000-000000000001';
  static const dailyWalk = 'c1000000-0000-4000-8000-000000000002';
  static const weightCare = 'c1000000-0000-4000-8000-000000000003';
  static const interval = 'c1000000-0000-4000-8000-000000000004';
  static const jointCare = 'c1000000-0000-4000-8000-000000000005';
  static const gaitCheck = 'c1000000-0000-4000-8000-000000000006';

  static const planSingle = 'e1000000-0000-4000-8000-000000000001';
  static const planTen = 'e1000000-0000-4000-8000-000000000002';
  static const planTwenty = 'e1000000-0000-4000-8000-000000000003';

  /// 지점별 트레드밀 대수 (20261110000300_branch_treadmills.sql)
  static const treadmillCounts = {yongsan: 8, goyang: 12, yeongdeungpo: 10};

  static String treadmillId(String branchId, int number) {
    final branchNo = int.parse(branchId.substring(branchId.length - 1));
    return 'a1000000-0000-4000-8000-${(branchNo * 100 + number).toString().padLeft(12, '0')}';
  }

  static List<Json> branches() => [
        _branch(yongsan, '용산 아이파크몰점', '서울특별시 용산구 한강대로23길 55 (용산 아이파크몰)', '10:30:00', '20:30:00'),
        _branch(goyang, '고양 스타필드점', '경기도 고양시 덕양구 고양대로 1955 (스타필드 고양)', '10:00:00', '22:00:00'),
        _branch(yeongdeungpo, '영등포 타임스퀘어점', '서울특별시 영등포구 영중로 15 (타임스퀘어)', '10:30:00', '22:00:00'),
      ];

  static Json _branch(String id, String name, String address, String opensAt, String closesAt) => {
        'id': id,
        'name': name,
        'address': address,
        'phone': null,
        'opens_at': opensAt,
        'closes_at': closesAt,
        'slot_minutes': 30,
        'is_24_hours': false,
        'timezone': 'Asia/Seoul',
        'is_active': true,
      };

  static List<Json> treadmills() => [
        for (final entry in treadmillCounts.entries)
          for (var n = 1; n <= entry.value; n++)
            {
              'id': treadmillId(entry.key, n),
              'branch_id': entry.key,
              'device_name': 'T-${n.toString().padLeft(2, '0')}',
              'status': 'available',
            },
      ];

  static List<Json> programs() => [
        _program(firstStep, '트레드밀 첫걸음', '처음 오는 반려견을 위한 적응 프로그램이에요. 아주 느린 속도로 걷다 쉬기를 반복하며 트레드밀과 친해져요.', 15, 'low', 1),
        _program(dailyWalk, '데일리 산책', '비·미세먼지·폭염으로 바깥 산책이 어려운 날, 편안한 걸음으로 하루 운동량을 채워요.', 25, 'medium', 2),
        _program(
            weightCare, '체중 관리', '보통 걸음과 빠른 걸음을 번갈아 오래 걸으며 체중 관리를 도와요. 과체중이거나 활동량이 부족한 반려견에게 추천해요.', 40, 'medium', 3),
        _program(interval, '활력 인터벌', '걷기와 가벼운 달리기를 번갈아 넘치는 에너지를 풀어요. 트레드밀에 익숙한 건강한 성견에게 맞아요.', 25, 'high', 4),
        _program(jointCare, '관절 케어 걷기', '노령견이나 슬개골·고관절 관리가 필요한 반려견을 위해 느리고 일정한 속도로 걸어요. 수술 후라면 수의사와 먼저 상의해 주세요.', 20,
            'low', 5),
        _program(gaitCheck, 'AI 보행 체크',
            '매번 같은 속도·시간으로 걸어서 이전 기록과 보행 변화를 비교하기 좋아요. 2~4주에 한 번 추천해요. 리포트는 영상 촬영에 동의하면 받을 수 있어요.', 15, 'low', 6),
      ];

  static Json _program(String id, String name, String description, int minutes, String intensity, int order) => {
        'id': id,
        'name': name,
        'description': description,
        'duration_minutes': minutes,
        'target_speed_kmh': null,
        'intensity': intensity,
        'sort_order': order,
        'is_active': true,
      };

  static List<Json> membershipPlans() => [
        _plan(planSingle, '1회 이용권', '처음 방문하는 반려견에게 추천해요.', 1, 30, 25000, 1),
        _plan(planTen, '10회 이용권', '주 1~2회 꾸준한 운동에 적합해요.', 10, 90, 220000, 2),
        _plan(planTwenty, '20회 이용권', '재활·체중 관리처럼 꾸준함이 필요한 경우에 좋아요.', 20, 180, 400000, 3),
      ];

  static Json _plan(String id, String name, String description, int sessions, int days, int price, int order) => {
        'id': id,
        'name': name,
        'description': description,
        'total_sessions': sessions,
        'validity_days': days,
        'price': price,
        'sort_order': order,
        'is_active': true,
      };

  /// (id, 이름, 체구, 단두종)
  static const _breeds = <(String, String, String, bool)>[
    ('maltese', '말티즈', 'small', false),
    ('toy_poodle', '토이 푸들', 'small', false),
    ('miniature_poodle', '미니어처 푸들', 'small', false),
    ('pomeranian', '포메라니안', 'small', false),
    ('shih_tzu', '시츄', 'small', true),
    ('bichon_frise', '비숑 프리제', 'small', false),
    ('chihuahua', '치와와', 'small', false),
    ('yorkshire_terrier', '요크셔테리어', 'small', false),
    ('dachshund', '닥스훈트', 'small', false),
    ('miniature_schnauzer', '미니어처 슈나우저', 'small', false),
    ('pug', '퍼그', 'small', true),
    ('japanese_spitz', '스피츠', 'small', false),
    ('papillon', '빠삐용', 'small', false),
    ('italian_greyhound', '이탈리안 그레이하운드', 'small', false),
    ('jack_russell_terrier', '잭 러셀 테리어', 'small', false),
    ('miniature_pinscher', '미니어처 핀셔', 'small', false),
    ('pekingese', '페키니즈', 'small', true),
    ('boston_terrier', '보스턴 테리어', 'small', true),
    ('cavalier_king_charles_spaniel', '카발리에 킹 찰스 스패니얼', 'small', true),
    ('west_highland_white_terrier', '웨스트 하이랜드 화이트 테리어', 'small', false),
    ('shetland_sheepdog', '셔틀랜드 쉽독', 'small', false),
    ('welsh_corgi', '웰시코기', 'medium', false),
    ('jindo', '진돗개', 'medium', false),
    ('shiba_inu', '시바견', 'medium', false),
    ('beagle', '비글', 'medium', false),
    ('border_collie', '보더콜리', 'medium', false),
    ('french_bulldog', '프렌치 불독', 'medium', true),
    ('english_bulldog', '잉글리시 불독', 'medium', true),
    ('cocker_spaniel', '코카 스파니엘', 'medium', false),
    ('siberian_husky', '시베리안 허스키', 'medium', false),
    ('standard_poodle', '스탠다드 푸들', 'large', false),
    ('golden_retriever', '골든 리트리버', 'large', false),
    ('labrador_retriever', '래브라도 리트리버', 'large', false),
    ('samoyed', '사모예드', 'large', false),
    ('alaskan_malamute', '알래스칸 말라뮤트', 'large', false),
    ('german_shepherd', '저먼 셰퍼드', 'large', false),
    ('doberman', '도베르만', 'large', false),
    ('boxer', '복서', 'large', true),
    ('bernese_mountain_dog', '버니즈 마운틴 독', 'large', false),
    ('pungsan', '풍산개', 'large', false),
  ];

  static List<Json> breeds() => [
        for (final (i, (id, name, size, brachy)) in _breeds.indexed)
          {
            'id': id,
            'name': name,
            'size_class': size,
            'is_brachycephalic': brachy,
            'sort_order': (i + 1) * 10,
            'is_active': true,
          },
      ];

  static List<Json> healthConditions() => [
        for (final (i, (code, name, description)) in const [
          ('joint_disease', '관절질환', '슬개골 탈구, 고관절 이형성증, 관절염, 십자인대 손상 등'),
          ('spinal_disease', '척추·디스크 질환', '추간판 탈출증(디스크) 등'),
          ('heart_disease', '심장질환', '이첨판 폐쇄부전증, 심장사상충 등'),
          ('obesity', '비만', '수의사에게 비만·과체중 진단을 받은 경우'),
          ('respiratory_disease', '호흡기질환', '기관 허탈, 단두종 기도 증후군 등'),
          ('endocrine_disease', '내분비질환', '당뇨, 쿠싱 증후군, 갑상선 기능 저하증 등'),
          ('kidney_disease', '신장질환', '만성 신부전 등'),
          ('seizure_disorder', '뇌전증·발작', '발작 이력이 있는 경우'),
          ('paw_skin_problem', '발바닥·피부 질환', '패드 상처, 지간염 등 발에 닿는 부위의 문제'),
          ('recovering', '수술·부상 회복 중', '최근 수술을 받았거나 부상에서 회복 중인 경우'),
        ].indexed)
          {'code': code, 'name': name, 'description': description, 'sort_order': (i + 1) * 10, 'is_active': true},
      ];

  static List<Json> badges() => [
        for (final (code, name, description, metric, goal, icon, tier, order) in const [
          ('first_run', '첫 발걸음', '처음으로 트레드밀 운동을 마쳤어요.', 'sessions', 1, 'flag', 'bronze', 10),
          ('sessions_10', '열 번째 운동', '운동을 10번 마쳤어요.', 'sessions', 10, 'run', 'bronze', 20),
          ('sessions_30', '단골 러너', '운동을 30번 마쳤어요.', 'sessions', 30, 'run', 'silver', 30),
          ('sessions_100', '백 번의 질주', '운동을 100번 마쳤어요.', 'sessions', 100, 'run', 'gold', 40),
          ('distance_10k', '10km 돌파', '누적 운동 거리가 10km를 넘었어요.', 'distance_meters', 10000, 'route', 'bronze', 50),
          ('marathon', '마라톤 완주', '누적 운동 거리가 마라톤 거리(42.195km)를 넘었어요.', 'distance_meters', 42195, 'route', 'silver', 60),
          ('distance_100k', '100km 클럽', '누적 운동 거리가 100km를 넘었어요.', 'distance_meters', 100000, 'route', 'gold', 70),
          ('streak_4', '4주 연속 출석', '4주 연속으로 매주 운동했어요.', 'streak_weeks', 4, 'fire', 'silver', 80),
          ('streak_12', '12주 연속 출석', '12주(약 3개월) 연속으로 매주 운동했어요.', 'streak_weeks', 12, 'fire', 'gold', 90),
          ('stamp_tour', '스탬프 투어', '서로 다른 지점 3곳에서 운동했어요.', 'branches', 3, 'stamp', 'silver', 100),
          ('open_run', '오픈런', '매장 문을 연 지 30분 안에 시작한 운동이 3번이에요.', 'open_runs', 3, 'sunrise', 'bronze', 110),
          ('podium', '시상대', '월간 랭킹에서 3위 안에 들었어요.', null, null, 'trophy', 'gold', 120),
        ])
          {
            'code': code,
            'name': name,
            'description': description,
            'metric': metric,
            'goal': goal,
            'icon': icon,
            'tier': tier,
            'sort_order': order,
            'is_active': true,
          },
      ];

  static List<Json> faqs() => [
        for (final (i, (category, question, answer)) in const [
          ('예약', '예약은 언제까지 변경하거나 취소할 수 있나요?', '예약 시작 1시간 전까지 앱에서 직접 변경·취소할 수 있습니다. 이용권으로 예약한 경우 취소하면 사용한 횟수가 복구됩니다.'),
          (
            '예약',
            '체크인은 어떻게 하나요?',
            '모든 매장은 무인으로 운영됩니다. 매장에 도착하면 앱의 예약 상세 화면이나 홈에서 "체크인"을 눌러 주세요. 예약 시작 15분 전부터 예약 종료 전까지 체크인할 수 있습니다.'
          ),
          (
            '예약',
            '이용권 없이도 예약할 수 있나요?',
            '네. 결제 방법에서 "현장 결제"를 고르면 "예약 대기" 상태로 접수되며, 이용 당일 매장에서 결제한 뒤 이용할 수 있습니다. 앱 결제는 준비 중입니다.'
          ),
          (
            '운동',
            '운동 중에는 누가 트레드밀을 조작하나요?',
            '매장에 직원이 없어 보호자가 직접 조작합니다. 체크인한 뒤 배정된 트레드밀에서 운동을 시작하고, 운동하는 동안 반려견 곁을 지켜 주세요. 이상이 있으면 트레드밀의 비상정지 버튼을 눌러 주세요. 앱에서는 운동 현황을 실시간으로 확인할 수 있습니다.'
          ),
          (
            'AI 분석',
            'AI 보행 분석 결과는 진단인가요?',
            '아니요. AI 분석 결과는 보행 패턴의 변화를 알려 드리는 참고 정보이며, 질병 진단이나 수의사의 진료를 대체하지 않습니다. 이상 징후가 의심되면 동물병원 진료를 받아 주세요.'
          ),
          (
            'AI 분석',
            'AI 분석 리포트를 받으려면 어떻게 해야 하나요?',
            '마이페이지 > 개인정보 및 영상 이용 동의에서 "운동 영상 촬영"에 동의하면, 운동이 끝난 뒤 촬영 영상을 분석해 리포트를 보내 드립니다.'
          ),
          (
            '계정',
            '영상 촬영 동의와 AI 학습 활용 동의는 무엇이 다른가요?',
            '영상 촬영 동의는 내 반려견의 분석 리포트를 만들기 위한 것이고, AI 학습 활용 동의는 비식별화한 데이터를 모델 개선에 쓰는 것에 대한 동의입니다. 각각 따로 동의하거나 철회할 수 있습니다.'
          ),
        ].indexed)
          {
            'id': 'f1000000-0000-4000-8000-${(i + 1).toString().padLeft(12, '0')}',
            'category': category,
            'question': question,
            'answer': answer,
            'sort_order': i + 1,
            'is_active': true,
          },
      ];

  /// (제목, 본문, 고정, 며칠 전)
  static const notices = <(String, String, bool, int)>[
    (
      'AI 보행 분석 리포트 서비스를 시작합니다',
      '트레드밀 운동 영상을 분석해 관절 움직임과 보행 패턴을 리포트로 제공합니다. 리포트를 받으려면 마이페이지에서 운동 영상 촬영에 동의해 주세요.',
      true,
      40
    ),
    ('예약 변경·취소 기준 안내', '예약 변경과 취소는 예약 시작 1시간 전까지 앱에서 할 수 있습니다. 이후에는 앱의 1:1 문의로 알려 주세요.', false, 35),
    (
      '월간 랭킹과 배지가 생겼어요',
      '운동을 마칠 때마다 점수가 쌓이고, 매달 전체·지점·체급별 순위가 정해집니다. 마이페이지 > 동의 관리에서 랭킹 참여에 동의하면 순위표에 이름을 올릴 수 있어요.',
      false,
      12
    ),
  ];
}
