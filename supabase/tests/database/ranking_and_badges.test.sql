-- pgTAP: 랭킹·배지 — 점수 규칙, 공개 범위(개인정보), 닉네임, 응원, 배지, 무효 처리, 월간 마감
-- 실행: npx supabase test db
begin;
create extension if not exists pgtap with schema extensions;

select plan(89);

-- 로컬 seed.sql의 랭킹 샘플(운동 기록·지난달 마감)과 섞이지 않게 랭킹 데이터를 비우고 시작한다.
-- 테스트 전체가 한 트랜잭션이라 끝나면 되돌아간다.
delete from public.ranking_cheers;
delete from public.monthly_awards;
delete from public.ranking_closings;
delete from public.dog_badges;
delete from public.exercise_points;

-- ---------------------------------------------------------------------
-- 준비: 보호자 A(랭킹 참여), B(랭킹 참여), C(미참여), 관리자 D
-- ---------------------------------------------------------------------
insert into auth.users (id, email, raw_user_meta_data)
values
  ('a1000000-0000-4000-8000-000000000001', 'rank-a@example.com',
   '{"name": "김보호", "consents": [
      {"type": "terms", "version": "1.0", "granted": true},
      {"type": "privacy", "version": "1.0", "granted": true},
      {"type": "ranking", "version": "1.0", "granted": true}]}'::jsonb),
  ('b2000000-0000-4000-8000-000000000002', 'rank-b@example.com',
   '{"name": "이보호", "consents": [{"type": "ranking", "version": "1.0", "granted": true}]}'::jsonb),
  ('c3000000-0000-4000-8000-000000000003', 'rank-c@example.com', '{"name": "박보호"}'::jsonb),
  ('d4000000-0000-4000-8000-000000000004', 'rank-admin@example.com', '{"name": "관리자"}'::jsonb);

update public.users set role = 'admin' where id = 'd4000000-0000-4000-8000-000000000004';

insert into public.branches (id, name, address, opens_at, closes_at, slot_minutes)
values ('f0000000-0000-4000-8000-000000000011', '테스트 랭킹 지점', '서울', '10:00', '21:00', 30);
insert into public.treadmills (branch_id, device_name)
values ('f0000000-0000-4000-8000-000000000011', 'T-01');

insert into public.dogs (id, owner_id, name, breed_id)
values
  ('da000000-0000-4000-8000-000000000001', 'a1000000-0000-4000-8000-000000000001', '콩이', 'maltese'),
  ('da000000-0000-4000-8000-000000000002', 'a1000000-0000-4000-8000-000000000001', '보리', 'golden_retriever'),
  ('db000000-0000-4000-8000-000000000001', 'b2000000-0000-4000-8000-000000000002', '단풍', 'toy_poodle'),
  ('db000000-0000-4000-8000-000000000002', 'b2000000-0000-4000-8000-000000000002', '두부', 'pomeranian'),
  ('dc000000-0000-4000-8000-000000000001', 'c3000000-0000-4000-8000-000000000003', '초코', 'maltese');

create temporary table t_ctx as
select
  private.current_ranking_month() as cur,
  (private.current_ranking_month() - interval '1 month')::date as prev,
  (private.current_ranking_month() - interval '2 months')::date as prev2,
  -- 지난달 둘째 주 월요일 근처 (그 주가 모두 지난달 안에 있다)
  private.week_start((private.current_ranking_month() - interval '1 month')::date + 7) as wk,
  -- 지지난달 첫 월요일 (4주 연속이 모두 지지난달 안에 있다)
  private.week_start((private.current_ranking_month() - interval '2 months')::date + 6) as wk2,
  'f0000000-0000-4000-8000-000000000011'::uuid as branch,
  (select t.id from public.treadmills t
   where t.branch_id = 'f0000000-0000-4000-8000-000000000011' and t.device_name = 'T-01') as tm,
  (select t.id from public.treadmills t
   where t.branch_id = 'b1000000-0000-4000-8000-000000000001' and t.device_name = 'T-01') as tm_yongsan,
  (select t.id from public.treadmills t
   where t.branch_id = 'b1000000-0000-4000-8000-000000000002' and t.device_name = 'T-01') as tm_goyang,
  (select t.id from public.treadmills t
   where t.branch_id = 'b1000000-0000-4000-8000-000000000003' and t.device_name = 'T-01') as tm_ydp;
grant select on t_ctx to authenticated;

-- 기기가 운동을 끝낸 것처럼 세션을 바로 넣는다 (트리거가 점수를 쌓는다)
create function pg_temp.add_session(
  p_id uuid, p_dog uuid, p_treadmill uuid, p_day date, p_time time,
  p_minutes integer, p_meters numeric, p_status text default 'completed'
)
returns void
language sql
as $$
  insert into public.exercise_sessions (
    id, dog_id, treadmill_id, status, started_at, ended_at, duration_seconds, distance_meters,
    target_duration_seconds
  )
  values (
    p_id, p_dog, p_treadmill, p_status, (p_day + p_time) at time zone 'Asia/Seoul',
    (p_day + p_time) at time zone 'Asia/Seoul' + make_interval(mins => p_minutes),
    p_minutes * 60, p_meters, 1800
  );
$$;

-- ---------------------------------------------------------------------
-- 1~6: 가입 시 닉네임·랭킹 동의·알림 설정
-- ---------------------------------------------------------------------
select ok(
  (select nickname from public.users where id = 'a1000000-0000-4000-8000-000000000001') ~ '^[가-힣A-Za-z0-9_]{2,12}$',
  '가입하면 기본 닉네임이 생긴다');
select is(
  (select count(distinct lower(nickname))::int from public.users
   where id in ('a1000000-0000-4000-8000-000000000001', 'b2000000-0000-4000-8000-000000000002',
                'c3000000-0000-4000-8000-000000000003', 'd4000000-0000-4000-8000-000000000004')),
  4, '기본 닉네임은 서로 겹치지 않는다');
select ok(private.has_consent('a1000000-0000-4000-8000-000000000001', 'ranking'),
  '가입할 때 고른 랭킹 참여 동의가 저장된다');
select ok(not private.has_consent('c3000000-0000-4000-8000-000000000003', 'ranking'),
  '동의하지 않으면 랭킹에 참여하지 않는다');
select is(
  (select notification_prefs ->> 'ranking' from public.users where id = 'a1000000-0000-4000-8000-000000000001'),
  'true', '새 회원은 랭킹 알림이 켜져 있다');
select throws_ok($$
  update public.users set nickname = '공백 있음' where id = 'c3000000-0000-4000-8000-000000000003'
$$, '23514', null, '닉네임 형식은 DB 제약으로도 막는다');

-- ---------------------------------------------------------------------
-- 7~15: 닉네임 변경
-- ---------------------------------------------------------------------
set local role authenticated;
set local request.jwt.claims to '{"sub": "a1000000-0000-4000-8000-000000000001", "role": "authenticated"}';

select is(public.set_nickname('  Coco_Mom '), 'Coco_Mom', '자동 닉네임은 바로 바꿀 수 있다 (앞뒤 공백 제거)');
select throws_ok($$ select public.set_nickname('Coco_Dad') $$,
  '22023', 'NICKNAME_COOLDOWN', '닉네임은 30일에 한 번만 바꿀 수 있다');
select throws_ok($$
  update public.users set nickname = 'Hacker' where id = 'a1000000-0000-4000-8000-000000000001'
$$, '42501', null, '닉네임은 직접 수정할 수 없고 set_nickname으로만 바꾼다');

set local request.jwt.claims to '{"sub": "b2000000-0000-4000-8000-000000000002", "role": "authenticated"}';
select throws_ok($$ select public.set_nickname('coco_mom') $$,
  '23505', 'NICKNAME_TAKEN', '대소문자만 다른 닉네임은 쓸 수 없다');
select throws_ok($$ select public.set_nickname('단') $$,
  '22023', 'NICKNAME_INVALID', '2자 미만 닉네임은 쓸 수 없다');
select throws_ok($$ select public.set_nickname('hello world') $$,
  '22023', 'NICKNAME_INVALID', '공백·특수문자는 쓸 수 없다');
select throws_ok($$ select public.set_nickname('관리자단풍') $$,
  '22023', 'NICKNAME_FORBIDDEN', '사칭·욕설 단어가 들어간 닉네임은 쓸 수 없다');
select is(public.set_nickname('단풍이네'), '단풍이네', '한글 닉네임');
select lives_ok($$
  update public.users set ranking_show_photo = true where id = 'b2000000-0000-4000-8000-000000000002'
$$, '랭킹 사진 공개 설정은 직접 바꿀 수 있다');

reset role;

-- ---------------------------------------------------------------------
-- 16~27: 점수 규칙 (지난달 A의 콩이)
-- ---------------------------------------------------------------------
select pg_temp.add_session('e0000000-0000-4000-8000-000000000001', 'da000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select wk from t_ctx), '11:00', 30, 2500);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000002', 'da000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select wk from t_ctx), '15:00', 30, 3000);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000003', 'da000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select wk from t_ctx) + 2, '11:00', 15, 900, 'stopped');
select pg_temp.add_session('e0000000-0000-4000-8000-000000000004', 'da000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select wk from t_ctx) + 3, '11:00', 3, 200, 'stopped');
select pg_temp.add_session('e0000000-0000-4000-8000-000000000005', 'da000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select wk from t_ctx) + 4, '11:00', 30, 1000);

select is(
  (select array[attendance_points, achievement_points, distance_points, points]
   from public.exercise_points where session_id = 'e0000000-0000-4000-8000-000000000001' and kind = 'session'),
  array[10, 10, 20, 40], '완주: 출석 10 + 달성 10 + 거리 20(최대치) = 40점');
select is(
  (select array[points::text, note] from public.exercise_points
   where session_id = 'e0000000-0000-4000-8000-000000000002' and kind = 'session'),
  array['0', 'daily_limit'], '같은 날 두 번째 운동은 0점 (하루 1회)');
select is(
  (select points from public.exercise_points
   where session_id = 'e0000000-0000-4000-8000-000000000003' and kind = 'session'),
  24, '중단된 운동도 감점 없이 한 만큼 받는다 (10 + 15분/30분 5 + 9)');
select is(
  (select array[points::text, note, qualified::text] from public.exercise_points
   where session_id = 'e0000000-0000-4000-8000-000000000004' and kind = 'session'),
  array['0', 'too_short', 'false'], '5분 미만 운동은 0점이고 운동 횟수에 넣지 않는다');
select is(
  (select array[session_id::text, points::text] from public.exercise_points
   where dog_id = 'da000000-0000-4000-8000-000000000001' and kind = 'weekly_bonus' and voided_at is null),
  array['e0000000-0000-4000-8000-000000000003', '20'], '그 주 두 번째로 점수를 받은 운동에서 주간 보너스 20점');
select is(
  (select count(*)::int from public.exercise_points
   where dog_id = 'da000000-0000-4000-8000-000000000001' and kind = 'weekly_bonus'),
  1, '세 번째 운동을 해도 주간 보너스는 한 번만');
select is(
  (select sum(points)::int from public.exercise_points
   where dog_id = 'da000000-0000-4000-8000-000000000001' and period_month = (select prev from t_ctx)
     and voided_at is null),
  114, '지난달 합계 40 + 0 + 24 + 0 + 30 + 보너스 20 = 114');
select ok(
  exists (select 1 from public.notifications
          where user_id = 'a1000000-0000-4000-8000-000000000001' and type = 'exercise'
            and body like '%40점을 받았어요%'),
  '운동 완료 알림에 받은 점수를 알려 준다 (점수 트리거가 먼저 실행된다)');

update public.exercise_sessions set status = 'stopped' where id = 'e0000000-0000-4000-8000-000000000001';
select is(
  (select count(*)::int from public.exercise_points where session_id = 'e0000000-0000-4000-8000-000000000001'),
  1, '이미 끝난 운동의 상태가 바뀌어도 다시 적립하지 않는다');

-- 한국 시간 월 경계: 지지난달 말일 23:50 / 지난달 1일 00:10
select pg_temp.add_session('e0000000-0000-4000-8000-000000000006', 'da000000-0000-4000-8000-000000000002',
  (select tm from t_ctx), (select prev from t_ctx) - 1, '23:50', 4, 300);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000007', 'da000000-0000-4000-8000-000000000002',
  (select tm from t_ctx), (select prev from t_ctx), '00:10', 4, 300);
select is(
  (select period_month from public.exercise_points where session_id = 'e0000000-0000-4000-8000-000000000006'),
  (select prev2 from t_ctx), '한국 시간 말일 23:50 운동은 그 달 점수');
select is(
  (select period_month from public.exercise_points where session_id = 'e0000000-0000-4000-8000-000000000007'),
  (select prev from t_ctx), '한국 시간 1일 00:10 운동은 새 달 점수 (UTC로는 전날)');
select is(private.josa('단풍', '를', '을') || ' ' || private.josa('콩이', '가', '이'), '단풍을 콩이가',
  '알림 문구는 받침에 맞춰 조사를 붙인다');

-- ---------------------------------------------------------------------
-- 28~33: 배지 (B의 단풍: 4주 연속, 지점 4곳, 모두 개점 직후)
-- ---------------------------------------------------------------------
select pg_temp.add_session('e0000000-0000-4000-8000-000000000008', 'db000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select wk2 from t_ctx), '10:05', 30, 1000);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000009', 'db000000-0000-4000-8000-000000000001',
  (select tm_yongsan from t_ctx), (select wk2 from t_ctx) + 7, '10:35', 30, 1000);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000010', 'db000000-0000-4000-8000-000000000001',
  (select tm_goyang from t_ctx), (select wk2 from t_ctx) + 14, '10:05', 30, 1000);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000011', 'db000000-0000-4000-8000-000000000001',
  (select tm_ydp from t_ctx), (select wk2 from t_ctx) + 21, '10:35', 30, 1000);

select ok(exists (select 1 from public.dog_badges
  where dog_id = 'da000000-0000-4000-8000-000000000001' and badge_code = 'first_run'), '첫 운동이면 「첫 발걸음」');
select ok(not exists (select 1 from public.dog_badges
  where dog_id = 'da000000-0000-4000-8000-000000000001' and badge_code = 'sessions_10'), '목표에 못 미친 배지는 없다');
select ok(exists (select 1 from public.notifications
  where user_id = 'a1000000-0000-4000-8000-000000000001' and type = 'ranking' and title = '새 배지를 받았어요'),
  '배지를 받으면 랭킹 알림이 온다');
select ok(exists (select 1 from public.dog_badges
  where dog_id = 'db000000-0000-4000-8000-000000000001' and badge_code = 'streak_4'), '4주 연속 운동하면 「4주 연속 출석」');
select ok(exists (select 1 from public.dog_badges
  where dog_id = 'db000000-0000-4000-8000-000000000001' and badge_code = 'stamp_tour'), '지점 3곳 이상에서 운동하면 「스탬프 투어」');
select ok(exists (select 1 from public.dog_badges
  where dog_id = 'db000000-0000-4000-8000-000000000001' and badge_code = 'open_run'), '개점 30분 안에 3번 시작하면 「오픈런」');

-- ---------------------------------------------------------------------
-- 34~45: 이번 달 랭킹 공개 범위
-- ---------------------------------------------------------------------
select pg_temp.add_session('e0000000-0000-4000-8000-000000000012', 'da000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select cur from t_ctx), '10:00', 30, 2500);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000013', 'db000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select cur from t_ctx), '11:00', 30, 1500);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000014', 'dc000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select cur from t_ctx), '12:00', 30, 3000);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000015', 'da000000-0000-4000-8000-000000000002',
  (select tm from t_ctx), (select cur from t_ctx), '13:00', 10, 500);
select pg_temp.add_session('e0000000-0000-4000-8000-000000000016', 'db000000-0000-4000-8000-000000000002',
  (select tm from t_ctx), (select cur from t_ctx), '09:00', 30, 2500);
update public.dogs set profile_image_path = 'a1000000-0000-4000-8000-000000000001/da000000-0000-4000-8000-000000000001/p.jpg'
where id = 'da000000-0000-4000-8000-000000000001';

set local role authenticated;
set local request.jwt.claims to '{"sub": "b2000000-0000-4000-8000-000000000002", "role": "authenticated"}';

select results_eq(
  $$ select dog_name, rank from public.get_leaderboard((select cur from t_ctx), 'all', 'all', 50) $$,
  $$ values ('두부'::text, 1), ('콩이', 2), ('단풍', 3), ('보리', 4) $$,
  '랭킹 참여에 동의한 보호자의 반려견만 나오고, 동점이면 먼저 도달한 반려견이 위 (초코 제외)');
select is(
  (select array[nickname, breed_label, size_class, points::text, session_count::text, participant_count::text]
   from public.get_leaderboard((select cur from t_ctx), 'all', 'all', 50) where dog_name = '콩이'),
  array['Coco_Mom', '말티즈', 'small', '40', '1', '4'], '닉네임·견종·체구·점수·운동 횟수를 보여준다');
select is(
  (select array_agg(dog_name order by dog_name) from public.get_leaderboard((select cur from t_ctx), 'all', 'all', 50)
   where is_mine),
  array['단풍', '두부'], '내 반려견 표시');
select ok(
  pg_get_function_result('public.get_leaderboard(date, text, text, integer)'::regprocedure)
    !~ '(email|phone|owner_id|real_name|\mname\M)',
  '순위표는 이메일·연락처·실명·보호자 ID를 돌려주지 않는다');
select is(
  (select photo_path from public.get_leaderboard((select cur from t_ctx), 'all', 'all', 50) where dog_name = '콩이'),
  'a1000000-0000-4000-8000-000000000001/da000000-0000-4000-8000-000000000001/p.jpg',
  '사진 공개를 켠 보호자의 반려견 사진 경로를 준다');
select results_eq(
  $$ select dog_name from public.get_leaderboard((select cur from t_ctx), 'size', 'small', 50) $$,
  $$ values ('두부'::text), ('콩이'), ('단풍') $$, '체급 랭킹은 같은 체구끼리 (대형견 보리 제외)');
select is(
  (select count(*)::int from public.get_leaderboard((select cur from t_ctx), 'branch', (select branch::text from t_ctx), 50)),
  4, '지점 랭킹은 그 지점에서 받은 점수로 순위를 매긴다');
select is(
  (select count(*)::int from public.get_leaderboard((select cur from t_ctx), 'branch', 'b1000000-0000-4000-8000-000000000001', 50)),
  0, '그 지점에서 운동하지 않았으면 지점 랭킹에 없다');
select throws_ok($$ select * from public.get_leaderboard(null, 'size', 'huge', 10) $$,
  '22023', 'INVALID_RANKING_SCOPE', '알 수 없는 랭킹 범위는 거절한다');

set local request.jwt.claims to '{"sub": "c3000000-0000-4000-8000-000000000003", "role": "authenticated"}';
select is(
  (public.get_my_ranking('dc000000-0000-4000-8000-000000000001', (select cur from t_ctx)) ->> 'participating'),
  'false', '참여하지 않은 보호자도 내 순위를 볼 수 있다');
select is(
  (public.get_my_ranking('dc000000-0000-4000-8000-000000000001', (select cur from t_ctx)) -> 'ranks' -> 0 ->> 'rank'),
  '3', '참여하면 몇 위인지 알려 준다 (두부·콩이와 40점 동점, 가장 늦게 도달)');
select throws_ok($$ select public.get_my_ranking('da000000-0000-4000-8000-000000000001', null) $$,
  'P0002', 'DOG_NOT_FOUND', '다른 보호자의 반려견 순위 상세는 볼 수 없다');

-- ---------------------------------------------------------------------
-- 46~50: 내 순위
-- ---------------------------------------------------------------------
set local request.jwt.claims to '{"sub": "a1000000-0000-4000-8000-000000000001", "role": "authenticated"}';
select is(
  (select array[r ->> 'scope', r ->> 'rank', r ->> 'participant_count', r ->> 'points_to_next', r ->> 'top_percent']
   from jsonb_array_elements(public.get_my_ranking('da000000-0000-4000-8000-000000000001', (select cur from t_ctx)) -> 'ranks') r
   where r ->> 'scope' = 'all'),
  array['all', '2', '4', '1', '50'], '전체 2위 · 4마리 중 · 1점 더 받으면 1위 · 상위 50%');
select is(
  (select array_agg(r ->> 'scope' order by ord)
   from jsonb_array_elements(public.get_my_ranking('da000000-0000-4000-8000-000000000001', (select cur from t_ctx)) -> 'ranks')
     with ordinality as x(r, ord)),
  array['all', 'branch', 'size'], '전체 → 운동한 지점 → 체급 순서');
select is(
  (public.get_my_ranking('da000000-0000-4000-8000-000000000001', (select prev from t_ctx)) ->> 'points')::int,
  114, '지난달 점수 합계');
select is(
  (public.get_my_ranking('da000000-0000-4000-8000-000000000001', (select prev from t_ctx)) ->> 'weekly_bonus_count')::int,
  1, '주간 보너스 횟수');
select is(
  (public.get_dog_achievements('da000000-0000-4000-8000-000000000001') -> 'stats' ->> 'sessions')::int,
  5, '배지 진행률: 5분 이상 운동 횟수 (하루 1회 제한과 무관)');

-- ---------------------------------------------------------------------
-- 51~57: 응원
-- ---------------------------------------------------------------------
set local request.jwt.claims to '{"sub": "b2000000-0000-4000-8000-000000000002", "role": "authenticated"}';
select is(public.cheer_dog('da000000-0000-4000-8000-000000000001'), 1, '다른 반려견을 응원한다');
select is(public.cheer_dog('da000000-0000-4000-8000-000000000001'), 1, '같은 반려견은 한 달에 한 번만 응원된다');
select throws_ok($$ select public.cheer_dog('db000000-0000-4000-8000-000000000001') $$,
  '22023', 'CANNOT_CHEER_OWN_DOG', '내 반려견은 응원할 수 없다');
select throws_ok($$ select public.cheer_dog('dc000000-0000-4000-8000-000000000001') $$,
  'P0002', 'DOG_NOT_FOUND', '랭킹에 참여하지 않은 반려견은 응원할 수 없다');
select is(
  (select array[cheer_count::text, cheered_by_me::text]
   from public.get_leaderboard((select cur from t_ctx), 'all', 'all', 50) where dog_name = '콩이'),
  array['1', 'true'], '순위표에 응원 수와 내가 응원했는지 표시');
select is(
  (select count(*)::int from public.ranking_cheers where user_id <> 'b2000000-0000-4000-8000-000000000002'),
  0, '다른 사람의 응원 기록은 볼 수 없다');

reset role;
select ok(
  exists (select 1 from public.notifications
          where user_id = 'a1000000-0000-4000-8000-000000000001' and type = 'ranking'
            and body = '단풍이네님이 콩이를 응원했어요.'),
  '응원을 받으면 응원한 사람의 닉네임으로 알림이 온다');

-- ---------------------------------------------------------------------
-- 58~64: 공개 프로필 · 권한
-- ---------------------------------------------------------------------
set local role authenticated;
set local request.jwt.claims to '{"sub": "b2000000-0000-4000-8000-000000000002", "role": "authenticated"}';
select ok(
  (public.get_ranking_dog_profile('da000000-0000-4000-8000-000000000001', null) -> 'badges') @> '[{"code": "first_run"}]'
  and public.get_ranking_dog_profile('da000000-0000-4000-8000-000000000001', null) ->> 'nickname' = 'Coco_Mom',
  '랭킹 참여 반려견의 공개 프로필에서 배지와 닉네임을 볼 수 있다');
select throws_ok($$ select public.get_ranking_dog_profile('dc000000-0000-4000-8000-000000000001', null) $$,
  'P0002', 'DOG_NOT_FOUND', '랭킹에 참여하지 않은 반려견의 프로필은 볼 수 없다');
select throws_ok($$ select public.get_dog_achievements('da000000-0000-4000-8000-000000000001') $$,
  'P0002', 'DOG_NOT_FOUND', '다른 보호자 반려견의 배지 진행률은 볼 수 없다');
select is(
  (select count(*)::int from public.exercise_points where owner_id <> 'b2000000-0000-4000-8000-000000000002'),
  0, '다른 보호자의 점수 원장은 볼 수 없다');
select throws_ok($$
  insert into public.exercise_points (dog_id, owner_id, session_id, kind, exercise_date, period_month, week_start, bonus_points)
  values ('db000000-0000-4000-8000-000000000001', 'b2000000-0000-4000-8000-000000000002',
          'e0000000-0000-4000-8000-000000000013', 'weekly_bonus', current_date, date_trunc('month', current_date)::date,
          date_trunc('week', current_date)::date, 9999)
$$, '42501', null, '보호자는 점수를 직접 쓸 수 없다');
select is((select count(*)::int from public.badges), 12, '배지 카탈로그는 누구나 볼 수 있다');
select is(
  (select count(*)::int from public.dog_badges where dog_id not in
     ('db000000-0000-4000-8000-000000000001', 'db000000-0000-4000-8000-000000000002')),
  0, '다른 보호자 반려견의 배지 목록은 직접 볼 수 없다');

-- ---------------------------------------------------------------------
-- 65~67: 랭킹 사진 공개 (Storage 정책 함수)
-- ---------------------------------------------------------------------
reset role;
select ok(private.is_public_dog_photo('a1000000-0000-4000-8000-000000000001/da000000-0000-4000-8000-000000000001/p.jpg'),
  '랭킹 참여 + 사진 공개면 다른 회원이 현재 프로필 사진을 읽을 수 있다');
update public.users set ranking_show_photo = false where id = 'a1000000-0000-4000-8000-000000000001';
select ok(not private.is_public_dog_photo('a1000000-0000-4000-8000-000000000001/da000000-0000-4000-8000-000000000001/p.jpg'),
  '사진 공개를 끄면 읽을 수 없다');
update public.users set ranking_show_photo = true where id = 'a1000000-0000-4000-8000-000000000001';
update public.dogs set profile_image_path = 'c3000000-0000-4000-8000-000000000003/dc000000-0000-4000-8000-000000000001/p.jpg'
where id = 'dc000000-0000-4000-8000-000000000001';
select ok(not private.is_public_dog_photo('c3000000-0000-4000-8000-000000000003/dc000000-0000-4000-8000-000000000001/p.jpg'),
  '랭킹에 참여하지 않은 보호자의 사진은 공개되지 않는다');

-- ---------------------------------------------------------------------
-- 68~70: 운영자 무효 처리와 주간 보너스 재계산
-- ---------------------------------------------------------------------
set local role authenticated;
set local request.jwt.claims to '{"sub": "b2000000-0000-4000-8000-000000000002", "role": "authenticated"}';
select throws_ok($$ select public.void_exercise_points('e0000000-0000-4000-8000-000000000003', '테스트') $$,
  '42501', 'FORBIDDEN', '보호자는 점수를 무효 처리할 수 없다');

set local request.jwt.claims to '{"sub": "d4000000-0000-4000-8000-000000000004", "role": "authenticated"}';
select public.void_exercise_points('e0000000-0000-4000-8000-000000000003', '기록 오류');
select is(
  (select count(*)::int from public.exercise_points
   where dog_id = 'da000000-0000-4000-8000-000000000001' and kind = 'weekly_bonus' and voided_at is null),
  1, '무효 처리 후에도 그 주에 점수 받은 운동이 2회면 주간 보너스는 유지된다');
select public.void_exercise_points('e0000000-0000-4000-8000-000000000005', '기록 오류');
select is(
  (select count(*)::int from public.exercise_points
   where dog_id = 'da000000-0000-4000-8000-000000000001' and kind = 'weekly_bonus' and voided_at is null),
  0, '점수 받은 운동이 주 2회 미만이 되면 주간 보너스도 무효가 된다');
select is(
  (select sum(points)::int from public.exercise_points
   where dog_id = 'da000000-0000-4000-8000-000000000001' and period_month = (select prev from t_ctx)
     and voided_at is null),
  40, '무효 처리한 점수는 합계에서 빠진다');

-- ---------------------------------------------------------------------
-- 72~78: 월간 마감 · 명예의 전당 · 지난달 칭호
-- ---------------------------------------------------------------------
select throws_ok($$ select public.close_ranking_month((select cur from t_ctx)) $$,
  '22023', 'RANKING_MONTH_NOT_FINISHED', '진행 중인 달은 마감할 수 없다');
select is(public.close_ranking_month((select prev from t_ctx)), 3,
  '지난달 마감: 전체·소형견·지점 1위 기록 (참여 반려견만)');
select is(public.close_ranking_month((select prev from t_ctx)), 0, '이미 마감한 달은 다시 마감하지 않는다');

reset role;
select ok(exists (select 1 from public.dog_badges
  where dog_id = 'da000000-0000-4000-8000-000000000001' and badge_code = 'podium'), '3위 안에 들면 「시상대」 배지');
select ok(exists (select 1 from public.notifications
  where user_id = 'a1000000-0000-4000-8000-000000000001' and type = 'ranking' and title like '%시상대에 올랐어요'
    and body like '콩이가 %전체 1위%'),
  '수상 알림은 반려견별로 한 번, 받은 순위를 모아 보낸다');

set local role authenticated;
set local request.jwt.claims to '{"sub": "b2000000-0000-4000-8000-000000000002", "role": "authenticated"}';
select is(
  (select array[title_period::text, title_label, title_rank::text]
   from public.get_leaderboard((select cur from t_ctx), 'all', 'all', 50) where dog_name = '콩이'),
  array[(select prev from t_ctx)::text, '전체', '1'], '지난달 1위는 이번 달 순위표에 칭호가 붙는다');
select is(
  (select dog_name from public.get_hall_of_fame(6) where period_month = (select prev from t_ctx) and scope = 'all'),
  '콩이', '명예의 전당에 지난달 1위가 오른다');

-- ---------------------------------------------------------------------
-- 79~82: 랭킹 참여 철회
-- ---------------------------------------------------------------------
set local request.jwt.claims to '{"sub": "a1000000-0000-4000-8000-000000000001", "role": "authenticated"}';
-- 테스트는 한 트랜잭션이라 now()가 같으므로 철회 시각을 뒤로 둔다 (앱에서는 요청마다 시각이 다르다)
select lives_ok($$
  insert into public.data_consents (user_id, consent_type, consent_version, granted, responded_at)
  values ('a1000000-0000-4000-8000-000000000001', 'ranking', '1.0', false, now() + interval '1 second')
$$, '보호자는 랭킹 참여를 철회할 수 있다');
select is(
  (public.get_my_ranking('da000000-0000-4000-8000-000000000001', null) ->> 'participating'),
  'false', '철회하면 참여하지 않음으로 표시된다');

set local request.jwt.claims to '{"sub": "b2000000-0000-4000-8000-000000000002", "role": "authenticated"}';
select results_eq(
  $$ select dog_name from public.get_leaderboard((select cur from t_ctx), 'all', 'all', 50) $$,
  $$ values ('두부'::text), ('단풍') $$, '철회한 보호자의 반려견은 순위표에서 바로 빠진다');
select is(
  (select array[coalesce(dog_name, '-'), is_hidden::text]
   from public.get_hall_of_fame(6) where period_month = (select prev from t_ctx) and scope = 'all'),
  array['-', 'true'], '철회한 보호자의 명예의 전당 기록은 가려진다');

-- ---------------------------------------------------------------------
-- 83~84: 지점 대항전 (모든 회원 합계)
-- ---------------------------------------------------------------------
select is(
  (select array[rank::text, distance_meters::text, dog_count::text]
   from public.get_branch_battle((select cur from t_ctx)) where branch_id = (select branch from t_ctx)),
  array['1', '10000.0', '5'], '지점 대항전은 랭킹 참여와 무관하게 지점 전체 거리를 합산한다');
select is(
  (select count(*)::int from public.get_branch_battle(null)),
  (select count(*)::int from public.branches where is_active), '운영 중인 모든 지점이 나온다');

-- ---------------------------------------------------------------------
-- 85: 랭킹 알림을 끄면 응원 알림도 오지 않는다
-- ---------------------------------------------------------------------
select lives_ok($$
  update public.users
  set notification_prefs = '{"booking": true, "exercise": true, "analysis": true, "ranking": false, "marketing": false}'
  where id = 'b2000000-0000-4000-8000-000000000002'
$$, '랭킹 알림을 끈다');
set local request.jwt.claims to '{"sub": "c3000000-0000-4000-8000-000000000003", "role": "authenticated"}';
select public.cheer_dog('db000000-0000-4000-8000-000000000001');
reset role;
select is(
  (select count(*)::int from public.notifications
   where user_id = 'b2000000-0000-4000-8000-000000000002' and title = '응원이 도착했어요'),
  0, '랭킹 알림을 끈 보호자에게는 응원 알림을 만들지 않는다');

-- ---------------------------------------------------------------------
-- 87~89: 실제 운영 흐름 (기기가 관리자 계정으로 운동을 끝낸다) · 마감 스케줄
-- ---------------------------------------------------------------------
insert into public.exercise_sessions (
  id, dog_id, treadmill_id, status, started_at, duration_seconds, distance_meters, target_duration_seconds
)
values (
  'e0000000-0000-4000-8000-000000000017', 'dc000000-0000-4000-8000-000000000001', (select tm from t_ctx),
  'running', ((select cur from t_ctx) + 1 + time '08:00') at time zone 'Asia/Seoul', 1800, 2000, 1800
);

set local role authenticated;
set local request.jwt.claims to '{"sub": "d4000000-0000-4000-8000-000000000004", "role": "authenticated"}';
select is(
  (select status from public.finish_exercise_session('e0000000-0000-4000-8000-000000000017')),
  'completed', '기기(관리자)가 운동을 끝낸다');

reset role;
select is(
  (select points from public.exercise_points
   where session_id = 'e0000000-0000-4000-8000-000000000017' and kind = 'session'),
  40, '운동이 끝나면 점수가 바로 적립된다');
select is(
  (select count(*)::int from cron.job where jobname = 'pawfit-close-ranking-months'),
  1, '매일 지난달 마감을 확인하는 pg_cron 작업이 등록되어 있다');

select * from finish();
rollback;
