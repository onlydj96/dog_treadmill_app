-- pgTAP: 권한(RLS)·예약·운동 세션·알림 흐름 검증
-- 실행: npx supabase test db
begin;
create extension if not exists pgtap with schema extensions;

select plan(43);

-- ---------------------------------------------------------------------
-- 준비: 보호자 A, 다른 보호자 B, 관리자 C
-- ---------------------------------------------------------------------
insert into auth.users (id, email, raw_user_meta_data)
values
  ('aaaaaaaa-0000-4000-8000-000000000001', 'owner-a@example.com',
   '{"name": "김보호", "phone": "010-1111-2222", "consents": [
      {"type": "terms", "version": "1.0", "granted": true},
      {"type": "privacy", "version": "1.0", "granted": true},
      {"type": "video_recording", "version": "1.0", "granted": true},
      {"type": "ai_training", "version": "1.0", "granted": false},
      {"type": "unknown", "version": "1.0", "granted": true}]}'::jsonb),
  ('bbbbbbbb-0000-4000-8000-000000000002', 'owner-b@example.com', '{"name": "이보호"}'::jsonb),
  ('cccccccc-0000-4000-8000-000000000003', 'admin-c@example.com', '{"name": "관리자"}'::jsonb);

update public.users set role = 'admin' where id = 'cccccccc-0000-4000-8000-000000000003';

insert into public.memberships (id, user_id, plan_name, total_sessions, remaining_sessions, expires_at)
values ('eeeeeeee-0000-4000-8000-000000000001', 'aaaaaaaa-0000-4000-8000-000000000001',
        '10회 이용권', 10, 10, now() + interval '90 days');

create temporary table t_ctx as
select
  ((now() at time zone 'Asia/Seoul')::date + 1) as tomorrow,
  '11111111-1111-4111-8111-111111111111'::uuid as gangnam,
  (select id from public.exercise_programs where name = '표준 유산소') as program_30,
  (select id from public.exercise_programs where name = '근력 강화 인터벌') as program_40;
grant select on t_ctx to authenticated;

-- 1~3: 회원가입 트리거
select is(
  (select name from public.users where id = 'aaaaaaaa-0000-4000-8000-000000000001'),
  '김보호', '회원가입 시 users 프로필이 생성된다');
select is(
  (select count(*)::int from public.data_consents where user_id = 'aaaaaaaa-0000-4000-8000-000000000001'),
  4, '알 수 없는 동의 유형은 무시하고 동의 이력을 저장한다');
select is(
  (select name from public.users where id = 'bbbbbbbb-0000-4000-8000-000000000002'),
  '이보호', '메타데이터 이름이 저장된다');

-- ---------------------------------------------------------------------
-- 보호자 A: 반려견 등록
-- ---------------------------------------------------------------------
set local role authenticated;
set local request.jwt.claims to '{"sub": "aaaaaaaa-0000-4000-8000-000000000001", "role": "authenticated"}';

select lives_ok($$
  insert into public.dogs (id, owner_id, name, breed, sex, weight_kg)
  values
    ('d0000000-0000-4000-8000-000000000001', 'aaaaaaaa-0000-4000-8000-000000000001', '코코', '말티즈', 'female', 3.2),
    ('d0000000-0000-4000-8000-000000000002', 'aaaaaaaa-0000-4000-8000-000000000001', '보리', '푸들', 'male', 5.1),
    ('d0000000-0000-4000-8000-000000000003', 'aaaaaaaa-0000-4000-8000-000000000001', '두부', '비숑', 'male', 6.0),
    ('d0000000-0000-4000-8000-000000000004', 'aaaaaaaa-0000-4000-8000-000000000001', '라떼', '시츄', 'female', 4.4),
    ('d0000000-0000-4000-8000-000000000005', 'aaaaaaaa-0000-4000-8000-000000000001', '모카', '믹스견', 'female', 8.0)
$$, '보호자는 본인 반려견을 등록할 수 있다');

select lives_ok($$
  insert into public.dog_health_profiles (dog_id, diseases, exercise_restrictions)
  values ('d0000000-0000-4000-8000-000000000001',
          '[{"name": "슬개골 탈구", "detail": "2기"}]', '[{"name": "경사 운동 금지"}]')
$$, '보호자는 반려견 건강 정보를 등록할 수 있다');

select throws_ok($$
  update public.users set role = 'admin' where id = 'aaaaaaaa-0000-4000-8000-000000000001'
$$, '42501', null, '보호자는 본인 role을 변경할 수 없다');

select lives_ok($$
  update public.users set name = '김보호자' where id = 'aaaaaaaa-0000-4000-8000-000000000001'
$$, '보호자는 본인 이름을 수정할 수 있다');

select throws_ok($$
  delete from public.dogs where id = 'd0000000-0000-4000-8000-000000000005'
$$, '42501', null, '반려견 하드 삭제는 허용되지 않는다(소프트 삭제만)');

-- ---------------------------------------------------------------------
-- 보호자 B: 다른 보호자 데이터 접근 차단
-- ---------------------------------------------------------------------
set local request.jwt.claims to '{"sub": "bbbbbbbb-0000-4000-8000-000000000002", "role": "authenticated"}';

select is((select count(*)::int from public.dogs), 0, 'B는 A의 반려견을 볼 수 없다');
select is((select count(*)::int from public.dog_health_profiles), 0, 'B는 A의 건강 정보를 볼 수 없다');
select is((select count(*)::int from public.users), 1, 'B는 본인 프로필만 볼 수 있다');
select throws_ok($$
  insert into public.dogs (owner_id, name) values ('aaaaaaaa-0000-4000-8000-000000000001', '침입')
$$, '42501', null, 'B는 A 명의로 반려견을 등록할 수 없다');

-- ---------------------------------------------------------------------
-- 예약 가능 시간 / 예약 생성
-- ---------------------------------------------------------------------
set local request.jwt.claims to '{"sub": "aaaaaaaa-0000-4000-8000-000000000001", "role": "authenticated"}';

select is(
  (select count(*)::int from public.get_available_slots(
    (select gangnam from t_ctx), (select tomorrow from t_ctx), (select program_30 from t_ctx))),
  22, '10:00~21:00, 30분 프로그램이면 30분 간격 22개 슬롯');

select is(
  (select min(available_count)::int from public.get_available_slots(
    (select gangnam from t_ctx), (select tomorrow from t_ctx), (select program_30 from t_ctx))),
  4, '예약이 없으면 모든 슬롯에 트레드밀 4대가 비어 있다');

select is(
  (select status from public.create_booking(
    'd0000000-0000-4000-8000-000000000001', (select gangnam from t_ctx), (select program_30 from t_ctx),
    ((select tomorrow from t_ctx) + time '10:00') at time zone 'Asia/Seoul')),
  'pending', '이용권 없이 예약하면 예약 대기(pending)');

select throws_ok($$
  select public.create_booking(
    'd0000000-0000-4000-8000-000000000001', (select gangnam from t_ctx), (select program_30 from t_ctx),
    ((select tomorrow from t_ctx) + time '10:00') at time zone 'Asia/Seoul')
$$, '23P01', 'DOG_ALREADY_BOOKED', '같은 반려견은 같은 시간에 중복 예약할 수 없다');

select is(
  (select status from public.create_booking(
    'd0000000-0000-4000-8000-000000000002', (select gangnam from t_ctx), (select program_30 from t_ctx),
    ((select tomorrow from t_ctx) + time '10:00') at time zone 'Asia/Seoul',
    'eeeeeeee-0000-4000-8000-000000000001')),
  'confirmed', '이용권을 적용하면 예약 확정(confirmed)');

select is(
  (select remaining_sessions from public.memberships where id = 'eeeeeeee-0000-4000-8000-000000000001'),
  9, '예약 확정 시 이용권 1회 차감');

select is(
  (select count(distinct treadmill_id)::int from public.bookings
   where start_at = ((select tomorrow from t_ctx) + time '10:00') at time zone 'Asia/Seoul'),
  2, '같은 시간 예약은 서로 다른 트레드밀에 배정된다');

select is(
  (select available_count from public.get_available_slots(
    (select gangnam from t_ctx), (select tomorrow from t_ctx), (select program_30 from t_ctx))
   where slot_start = ((select tomorrow from t_ctx) + time '10:00') at time zone 'Asia/Seoul'),
  2, '10:00 슬롯 잔여 트레드밀 2대');

select is(
  (select available_count from public.get_available_slots(
    (select gangnam from t_ctx), (select tomorrow from t_ctx), (select program_30 from t_ctx))
   where slot_start = ((select tomorrow from t_ctx) + time '10:30') at time zone 'Asia/Seoul'),
  4, '겹치지 않는 10:30 슬롯은 4대 모두 가능');

select throws_ok($$
  select public.create_booking(
    'd0000000-0000-4000-8000-000000000003', (select gangnam from t_ctx), (select program_30 from t_ctx),
    ((select tomorrow from t_ctx) + time '10:15') at time zone 'Asia/Seoul')
$$, '22023', 'SLOT_NOT_AVAILABLE', '슬롯 간격에 맞지 않는 시간은 예약할 수 없다');

select throws_ok($$
  select public.create_booking(
    'd0000000-0000-4000-8000-000000000003', (select gangnam from t_ctx), (select program_40 from t_ctx),
    ((select tomorrow from t_ctx) + time '20:30') at time zone 'Asia/Seoul')
$$, '22023', 'SLOT_NOT_AVAILABLE', '영업 종료(21:00) 이후까지 이어지는 예약은 할 수 없다');

select throws_ok($$
  select public.create_booking(
    'd0000000-0000-4000-8000-000000000003', (select gangnam from t_ctx), (select program_30 from t_ctx),
    now() - interval '1 day')
$$, '22023', 'SLOT_IN_PAST', '지난 시간은 예약할 수 없다');

select lives_ok($$
  select public.create_booking(
    ('d0000000-0000-4000-8000-00000000000' || n)::uuid, (select gangnam from t_ctx), (select program_30 from t_ctx),
    ((select tomorrow from t_ctx) + time '10:00') at time zone 'Asia/Seoul')
  from (values ('3'), ('4')) as v(n)
$$, '남은 트레드밀 2대도 예약할 수 있다');

select throws_ok($$
  select public.create_booking(
    'd0000000-0000-4000-8000-000000000005', (select gangnam from t_ctx), (select program_30 from t_ctx),
    ((select tomorrow from t_ctx) + time '10:00') at time zone 'Asia/Seoul')
$$, '23P01', 'SLOT_FULL', '트레드밀이 모두 예약되면 SLOT_FULL');

-- ---------------------------------------------------------------------
-- 취소 / 변경
-- ---------------------------------------------------------------------
set local request.jwt.claims to '{"sub": "bbbbbbbb-0000-4000-8000-000000000002", "role": "authenticated"}';

select is((select count(*)::int from public.bookings), 0, 'B는 A의 예약을 볼 수 없다');
select throws_ok($$
  select public.cancel_booking(
    (select id from public.bookings where dog_id = 'd0000000-0000-4000-8000-000000000002'))
$$, 'P0002', 'BOOKING_NOT_FOUND', 'B는 A의 예약을 취소할 수 없다');

set local request.jwt.claims to '{"sub": "aaaaaaaa-0000-4000-8000-000000000001", "role": "authenticated"}';

select is(
  (select status from public.cancel_booking(
    (select id from public.bookings where dog_id = 'd0000000-0000-4000-8000-000000000002'), '일정 변경')),
  'cancelled', '보호자는 본인 예약을 취소할 수 있다');

select is(
  (select remaining_sessions from public.memberships where id = 'eeeeeeee-0000-4000-8000-000000000001'),
  10, '취소하면 이용권 회차가 복구된다');

select is(
  (select start_at from public.reschedule_booking(
    (select id from public.bookings where dog_id = 'd0000000-0000-4000-8000-000000000001'),
    ((select tomorrow from t_ctx) + time '11:00') at time zone 'Asia/Seoul')),
  ((select tomorrow from t_ctx) + time '11:00') at time zone 'Asia/Seoul',
  '보호자는 예약 시간을 변경할 수 있다');

-- ---------------------------------------------------------------------
-- 운동 세션 (관리자) / 실시간 지표 / 종료 / AI 분석 대기열 / 알림
-- ---------------------------------------------------------------------
select throws_ok($$
  select public.start_exercise_session(
    (select id from public.bookings where dog_id = 'd0000000-0000-4000-8000-000000000001'))
$$, 'P0002', 'BOOKING_NOT_FOUND', '보호자는 운동 세션을 시작할 수 없다');

set local request.jwt.claims to '{"sub": "cccccccc-0000-4000-8000-000000000003", "role": "authenticated"}';

select is(
  (select status from public.start_exercise_session(
    (select id from public.bookings where dog_id = 'd0000000-0000-4000-8000-000000000001'))),
  'running', '관리자가 운동 세션을 시작한다');

select is(
  (select current_speed from public.update_exercise_session_metrics(
    (select id from public.exercise_sessions where dog_id = 'd0000000-0000-4000-8000-000000000001'),
    4.5, 120, 100)),
  4.5::numeric, '실시간 속도가 갱신된다');

select is(
  (select average_speed from public.finish_exercise_session(
    (select id from public.exercise_sessions where dog_id = 'd0000000-0000-4000-8000-000000000001'))),
  4.3::numeric, '종료 시 평균 속도(120m/100s = 4.3km/h)를 계산한다');

select is(
  (select status from public.bookings where dog_id = 'd0000000-0000-4000-8000-000000000001'
     and status <> 'cancelled'),
  'completed', '운동 종료 시 예약은 이용 완료 처리된다');

set local request.jwt.claims to '{"sub": "aaaaaaaa-0000-4000-8000-000000000001", "role": "authenticated"}';

select is(
  (select analysis_status from public.analysis_reports where dog_id = 'd0000000-0000-4000-8000-000000000001'),
  'queued', '영상 촬영 동의 시 AI 분석이 대기열에 등록되고 보호자가 조회할 수 있다');

select is(
  (select count(*)::int from public.notifications where type = 'exercise'),
  2, '운동 시작·완료 알림이 생성된다');

select lives_ok($$
  update public.notifications set is_read = true
$$, '보호자는 알림을 읽음 처리할 수 있다');

select throws_ok($$
  update public.notifications set title = '변조'
$$, '42501', null, '보호자는 알림 내용을 수정할 수 없다');

select lives_ok($$
  update public.users set notification_prefs = '{"booking": true, "exercise": true, "analysis": false, "marketing": false}'
  where id = 'aaaaaaaa-0000-4000-8000-000000000001'
$$, '보호자는 알림 설정을 변경할 수 있다');

reset role;
update public.analysis_reports
set analysis_status = 'completed', summary = '좌우 대칭성이 양호합니다.'
where dog_id = 'd0000000-0000-4000-8000-000000000001';

select is(
  (select count(*)::int from public.notifications
   where user_id = 'aaaaaaaa-0000-4000-8000-000000000001' and type = 'analysis'),
  0, '분석 알림을 끈 사용자에게는 분석 완료 알림을 만들지 않는다');

select ok(
  (select completed_at is not null from public.analysis_reports
   where dog_id = 'd0000000-0000-4000-8000-000000000001'),
  '분석 완료 시각이 기록된다');

select * from finish();
rollback;
