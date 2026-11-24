-- =====================================================================
-- 로컬 개발용 샘플 데이터 (supabase db reset 시 마이그레이션 다음에 자동 적용)
-- 지점·운동 프로그램·트레드밀은 운영 데이터라 마이그레이션(20261110000200~0300)에 있다.
-- 가격 등은 샘플 값이므로 운영 환경에서는 실제 값으로 넣는다.
-- 상품·FAQ·공지는 영어 컬럼(*_en)도 함께 채운다 (docs/i18n.md). 비우면 영어 화면에서도 한국어가 보인다.
-- =====================================================================

insert into public.membership_plans
  (name, description, name_en, description_en, total_sessions, validity_days, price, sort_order)
values
  ('1회 이용권', '처음 방문하는 반려견에게 추천해요.',
   '1-session pass', 'Recommended for dogs on their first visit.', 1, 30, 25000, 1),
  ('10회 이용권', '주 1~2회 꾸준한 운동에 적합해요.',
   '10-session pass', 'Great for steady workouts once or twice a week.', 10, 90, 220000, 2),
  ('20회 이용권', '재활·체중 관리처럼 꾸준함이 필요한 경우에 좋아요.',
   '20-session pass', 'Good for goals that need consistency, like rehab or weight care.', 20, 180, 400000, 3);

insert into public.faqs (category, question, answer, category_en, question_en, answer_en, sort_order)
values
  ('예약', '예약은 언제까지 변경하거나 취소할 수 있나요?',
   '예약 시작 1시간 전까지 앱에서 직접 변경·취소할 수 있습니다. 이용권으로 예약한 경우 취소하면 사용한 횟수가 복구됩니다.',
   'Booking', 'How late can I change or cancel a booking?',
   'You can change or cancel a booking in the app up to 1 hour before it starts. If you booked with a pass, cancelling gives the used session back.', 1),
  ('예약', '체크인은 어떻게 하나요?',
   '모든 매장은 무인으로 운영됩니다. 매장에 도착하면 앱의 예약 상세 화면이나 홈에서 "QR 체크인"을 누르고, 운동할 트레드밀에 붙은 QR을 스캔해 주세요. 배정된 트레드밀이 아니어도 그 시간에 비어 있으면 그 기기로 체크인됩니다. 예약 시작 15분 전부터 예약 종료 전까지 체크인할 수 있습니다.',
   'Booking', 'How do I check in?',
   'All our stores are self-service. When you arrive, tap "QR check-in" on the booking details screen or on Home and scan the QR code on the treadmill you''ll use. It doesn''t have to be your assigned treadmill as long as it''s free at that time. You can check in from 15 minutes before your booking starts until it ends.', 2),
  ('예약', '이용권 없이도 예약할 수 있나요?',
   '네. 결제 방법에서 "현장 결제"를 고르면 예약이 바로 확정되고, 이용 당일 매장에서 결제한 뒤 이용할 수 있습니다. 앱 결제는 준비 중입니다.',
   'Booking', 'Can I book without a pass?',
   'Yes. If you choose "Pay at store" as the payment method, your booking is confirmed right away. Pay at the store on the day of your visit before your workout. In-app payment is coming soon.', 3),
  ('운동', '운동 중에는 누가 트레드밀을 조작하나요?',
   '매장에 직원이 없어 보호자가 직접 조작합니다. QR로 체크인한 트레드밀에서 시작 버튼을 눌러 운동을 시작하고, 운동하는 동안 반려견 곁을 지켜 주세요. 이상이 있으면 트레드밀의 비상정지 버튼을 눌러 주세요. 앱에서는 운동 현황을 실시간으로 확인할 수 있습니다.',
   'Workout', 'Who operates the treadmill during a workout?',
   'There''s no staff at the store, so you operate it yourself. Press Start on the treadmill you checked in on with the QR code, and stay by your dog''s side the whole time. If anything seems wrong, press the treadmill''s emergency stop button. You can follow the workout live in the app.', 4),
  ('AI 분석', 'AI 보행 분석 결과는 진단인가요?',
   '아니요. AI 분석 결과는 보행 패턴의 변화를 알려 드리는 참고 정보이며, 질병 진단이나 수의사의 진료를 대체하지 않습니다. 이상 징후가 의심되면 동물병원 진료를 받아 주세요.',
   'AI analysis', 'Is the AI gait analysis a diagnosis?',
   'No. AI analysis results are reference information about changes in your dog''s gait. They do not replace a diagnosis or veterinary care. If you notice anything unusual, please see a veterinarian.', 5),
  ('AI 분석', 'AI 분석 리포트를 받으려면 어떻게 해야 하나요?',
   '마이페이지 > 개인정보 및 영상 이용 동의에서 "운동 영상 촬영"에 동의하면, 운동이 끝난 뒤 촬영 영상을 분석해 리포트를 보내 드립니다.',
   'AI analysis', 'How do I get AI analysis reports?',
   'In Account, open the privacy and video consent settings and agree to workout video recording. After each workout, we''ll analyze the recorded video and send you a report.', 6),
  ('계정', '영상 촬영 동의와 AI 학습 활용 동의는 무엇이 다른가요?',
   '영상 촬영 동의는 내 반려견의 분석 리포트를 만들기 위한 것이고, AI 학습 활용 동의는 비식별화한 데이터를 모델 개선에 쓰는 것에 대한 동의입니다. 각각 따로 동의하거나 철회할 수 있습니다.',
   'Account', 'What''s the difference between video recording consent and AI training consent?',
   'Video recording consent lets us create analysis reports for your dog. AI training consent lets us use de-identified data to improve our models. You can give or withdraw each one separately.', 7);

insert into public.notices (title, body, title_en, body_en, is_pinned)
values
  ('AI 보행 분석 리포트 서비스를 시작합니다',
   '트레드밀 운동 영상을 분석해 관절 움직임과 보행 패턴을 리포트로 제공합니다. 리포트를 받으려면 마이페이지에서 운동 영상 촬영에 동의해 주세요.',
   'AI gait analysis reports are here',
   'We now analyze treadmill workout videos and send you reports on joint movement and gait patterns. To get reports, agree to workout video recording in Account.', true),
  ('예약 변경·취소 기준 안내',
   '예약 변경과 취소는 예약 시작 1시간 전까지 앱에서 할 수 있습니다. 이후에는 앱의 1:1 문의로 알려 주세요.',
   'Booking change and cancellation policy',
   'You can change or cancel a booking in the app up to 1 hour before it starts. After that, please let us know through 1:1 inquiry in the app.', false);

-- =====================================================================
-- 랭킹 샘플 (로컬 전용)
-- 보호자 6명·반려견 8마리의 지난달~오늘 운동 기록. 기록을 넣으면 트리거가 점수·배지를 쌓고,
-- 지난달은 마감해서 명예의 전당을 채운다. '산책왕'은 랭킹에 참여하지 않은 보호자다.
-- 샘플 계정으로 로그인해 볼 수 있다: sample1@pawfit.local ~ sample6@pawfit.local / pawfit1234
-- =====================================================================
insert into auth.users (
  instance_id, id, aud, role, email, encrypted_password, email_confirmed_at,
  raw_app_meta_data, raw_user_meta_data, created_at, updated_at,
  confirmation_token, recovery_token, email_change_token_new, email_change,
  email_change_token_current, phone_change, phone_change_token, reauthentication_token
)
select
  '00000000-0000-0000-0000-000000000000', s.id, 'authenticated', 'authenticated', s.email,
  extensions.crypt('pawfit1234', extensions.gen_salt('bf')), now(),
  '{"provider": "email", "providers": ["email"]}'::jsonb,
  jsonb_build_object(
    'name', s.name,
    'phone', s.phone,
    'consents', jsonb_build_array(
      jsonb_build_object('type', 'terms', 'version', '1.0', 'granted', true),
      jsonb_build_object('type', 'privacy', 'version', '1.0', 'granted', true),
      jsonb_build_object('type', 'ranking', 'version', '1.0', 'granted', s.ranking)
    )
  ),
  now(), now(), '', '', '', '', '', '', '', ''
from (values
  ('5eed0000-0000-4000-8000-000000000001'::uuid, 'sample1@pawfit.local', '김샘플', '010-1000-0001', true),
  ('5eed0000-0000-4000-8000-000000000002'::uuid, 'sample2@pawfit.local', '이샘플', '010-1000-0002', true),
  ('5eed0000-0000-4000-8000-000000000003'::uuid, 'sample3@pawfit.local', '박샘플', '010-1000-0003', true),
  ('5eed0000-0000-4000-8000-000000000004'::uuid, 'sample4@pawfit.local', '최샘플', '010-1000-0004', true),
  ('5eed0000-0000-4000-8000-000000000005'::uuid, 'sample5@pawfit.local', '정샘플', '010-1000-0005', true),
  ('5eed0000-0000-4000-8000-000000000006'::uuid, 'sample6@pawfit.local', '강샘플', '010-1000-0006', false)
) as s(id, email, name, phone, ranking);

insert into auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
select u.id::text, u.id, jsonb_build_object('sub', u.id::text, 'email', u.email, 'email_verified', true),
       'email', now(), now(), now()
from auth.users u
where u.email like 'sample%@pawfit.local';

update public.users u
set nickname = v.nickname
from (values
  ('5eed0000-0000-4000-8000-000000000001'::uuid, '콩이맘'),
  ('5eed0000-0000-4000-8000-000000000002'::uuid, '보리아빠'),
  ('5eed0000-0000-4000-8000-000000000003'::uuid, '단풍언니'),
  ('5eed0000-0000-4000-8000-000000000004'::uuid, '모카집사'),
  ('5eed0000-0000-4000-8000-000000000005'::uuid, '초코러버'),
  ('5eed0000-0000-4000-8000-000000000006'::uuid, '산책왕')
) as v(id, nickname)
where u.id = v.id;

insert into public.dogs (id, owner_id, name, breed_id, sex, birth_date, weight_kg)
values
  ('5eedd000-0000-4000-8000-000000000001', '5eed0000-0000-4000-8000-000000000001', '콩이', 'maltese', 'female', '2021-04-02', 3.4),
  ('5eedd000-0000-4000-8000-000000000002', '5eed0000-0000-4000-8000-000000000002', '보리', 'golden_retriever', 'male', '2020-08-15', 29.5),
  ('5eedd000-0000-4000-8000-000000000003', '5eed0000-0000-4000-8000-000000000003', '단풍', 'toy_poodle', 'female', '2022-10-01', 3.1),
  ('5eedd000-0000-4000-8000-000000000004', '5eed0000-0000-4000-8000-000000000004', '모카', 'pomeranian', 'male', '2019-03-20', 2.8),
  ('5eedd000-0000-4000-8000-000000000005', '5eed0000-0000-4000-8000-000000000004', '호두', 'welsh_corgi', 'male', '2021-12-11', 12.4),
  ('5eedd000-0000-4000-8000-000000000006', '5eed0000-0000-4000-8000-000000000005', '초코', 'shiba_inu', 'female', '2020-05-05', 9.8),
  ('5eedd000-0000-4000-8000-000000000007', '5eed0000-0000-4000-8000-000000000006', '해피', 'jindo', 'male', '2018-01-30', 18.0),
  ('5eedd000-0000-4000-8000-000000000008', '5eed0000-0000-4000-8000-000000000006', '구름', 'samoyed', 'female', '2022-02-14', 22.5);

-- 반려견마다 지점·운동 주기·시작 시각·시간·속도를 다르게 둔다. 11일에 한 번꼴로 중간에 멈춘 운동이 섞인다.
with plan(dog_id, idx, branch_id, every_days, start_time, minutes, speed_kmh) as (
  values
    ('5eedd000-0000-4000-8000-000000000001'::uuid, 1, 'b1000000-0000-4000-8000-000000000001'::uuid, 3, time '10:35', 25, 3.6),
    ('5eedd000-0000-4000-8000-000000000002'::uuid, 2, 'b1000000-0000-4000-8000-000000000002'::uuid, 2, time '10:05', 40, 5.4),
    ('5eedd000-0000-4000-8000-000000000003'::uuid, 3, 'b1000000-0000-4000-8000-000000000003'::uuid, 4, time '14:20', 20, 3.2),
    ('5eedd000-0000-4000-8000-000000000004'::uuid, 4, 'b1000000-0000-4000-8000-000000000002'::uuid, 3, time '18:40', 15, 3.0),
    ('5eedd000-0000-4000-8000-000000000005'::uuid, 5, 'b1000000-0000-4000-8000-000000000002'::uuid, 2, time '19:10', 25, 4.6),
    ('5eedd000-0000-4000-8000-000000000006'::uuid, 6, 'b1000000-0000-4000-8000-000000000001'::uuid, 3, time '11:15', 25, 4.4),
    ('5eedd000-0000-4000-8000-000000000007'::uuid, 7, 'b1000000-0000-4000-8000-000000000003'::uuid, 2, time '10:40', 30, 5.0),
    ('5eedd000-0000-4000-8000-000000000008'::uuid, 8, 'b1000000-0000-4000-8000-000000000003'::uuid, 5, time '16:00', 30, 4.8)
),
days as (
  select d::date as day
  from generate_series(
    (date_trunc('month', now() at time zone 'Asia/Seoul') - interval '1 month')::date,
    (now() at time zone 'Asia/Seoul')::date,
    interval '1 day'
  ) as d
),
sessions as (
  select
    p.dog_id,
    (select t.id from public.treadmills t where t.branch_id = p.branch_id
     order by t.device_name offset (p.idx % 4) limit 1) as treadmill_id,
    (x.day + p.start_time) at time zone 'Asia/Seoul' as started_at,
    (extract(day from x.day)::integer + p.idx) % 11 = 0 as stopped,
    p.minutes,
    -- 날마다 85~114% 사이로 거리를 흔든다
    p.speed_kmh * (0.85 + ((x.day - date '2000-01-01') * p.idx % 30) / 100.0) as speed_kmh
  from plan p
  cross join days x
  where (x.day - date '2000-01-01' + p.idx) % p.every_days = 0
)
-- created_at은 실제 기기 기록처럼 시작 시각으로 둔다 (앱의 운동 기록은 created_at 순)
insert into public.exercise_sessions (
  dog_id, treadmill_id, status, started_at, ended_at, duration_seconds, distance_meters,
  target_duration_seconds, average_speed, max_speed, stop_reason, created_at
)
select
  s.dog_id,
  s.treadmill_id,
  case when s.stopped then 'stopped' else 'completed' end,
  s.started_at,
  s.started_at + make_interval(mins => case when s.stopped then s.minutes / 2 else s.minutes end),
  (case when s.stopped then s.minutes / 2 else s.minutes end) * 60,
  round((s.speed_kmh * 1000 / 60 * (case when s.stopped then s.minutes / 2 else s.minutes end))::numeric, 1),
  s.minutes * 60,
  round(s.speed_kmh::numeric, 1),
  round((s.speed_kmh * 1.25)::numeric, 1),
  case when s.stopped then '보호자 비상정지' end,
  s.started_at
from sessions s
order by s.started_at;

-- 지난달 마감 → 명예의 전당·시상대 배지
select private.close_ranking_month((date_trunc('month', now() at time zone 'Asia/Seoul') - interval '1 month')::date);

-- 이번 달 응원 몇 개
insert into public.ranking_cheers (period_month, dog_id, user_id)
select date_trunc('month', now() at time zone 'Asia/Seoul')::date, v.dog_id, v.user_id
from (values
  ('5eedd000-0000-4000-8000-000000000002'::uuid, '5eed0000-0000-4000-8000-000000000001'::uuid),
  ('5eedd000-0000-4000-8000-000000000002'::uuid, '5eed0000-0000-4000-8000-000000000003'::uuid),
  ('5eedd000-0000-4000-8000-000000000002'::uuid, '5eed0000-0000-4000-8000-000000000004'::uuid),
  ('5eedd000-0000-4000-8000-000000000001'::uuid, '5eed0000-0000-4000-8000-000000000002'::uuid),
  ('5eedd000-0000-4000-8000-000000000006'::uuid, '5eed0000-0000-4000-8000-000000000001'::uuid)
) as v(dog_id, user_id);
