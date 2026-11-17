-- pgTAP: 영어 콘텐츠 — 영어 컬럼·운영 기준 데이터의 영어 값, 랭킹 RPC의 _en 필드,
--        알림 data.msg/args, 영어 가입 닉네임 (docs/i18n.md "서버에서 오는 텍스트")
-- 실행: npx supabase test db
begin;
create extension if not exists pgtap with schema extensions;

select plan(63);

-- 로컬 seed.sql의 랭킹 샘플(운동 기록·지난달 마감)과 섞이지 않게 랭킹 데이터를 비우고 시작한다.
-- 테스트 전체가 한 트랜잭션이라 끝나면 되돌아간다.
delete from public.ranking_cheers;
delete from public.monthly_awards;
delete from public.ranking_closings;
delete from public.dog_badges;
delete from public.exercise_points;

-- ---------------------------------------------------------------------
-- 1: 영어 컬럼
-- ---------------------------------------------------------------------
select is(
  (select array_agg(c.table_name || '.' || c.column_name order by c.table_name, c.column_name)
   from information_schema.columns c
   where c.table_schema = 'public' and c.column_name like '%\_en'),
  array[
    'analysis_reports.care_notes_en', 'analysis_reports.summary_en',
    'badges.description_en', 'badges.name_en',
    'branches.address_en', 'branches.name_en',
    'breeds.name_en',
    'exercise_plans.notes_en', 'exercise_plans.program_name_en',
    'exercise_programs.description_en', 'exercise_programs.name_en',
    'faqs.answer_en', 'faqs.category_en', 'faqs.question_en',
    'health_conditions.description_en', 'health_conditions.name_en',
    'membership_plans.description_en', 'membership_plans.name_en',
    'notices.body_en', 'notices.title_en',
    'payments.order_name_en'
  ],
  '사람이 읽는 텍스트 컬럼마다 영어 컬럼(같은 이름 + _en)이 있다');

select is(
  (select count(*)::int from information_schema.columns
   where table_schema = 'public' and is_nullable = 'YES' and data_type = 'text'
     and (table_name, column_name) in
       (('exercise_plans', 'program_name_en'), ('exercise_plans', 'notes_en'), ('payments', 'order_name_en'))),
  3,
  '운동 계획·결제의 영어 컬럼은 text이고 비워 둘 수 있다');


-- ---------------------------------------------------------------------
-- 2~11: 운영 기준 데이터의 영어 값 (catalog_en과 같은 문구)
-- ---------------------------------------------------------------------
select is(
  (select array_agg(name_en order by id) from public.branches where id::text like 'b1000000-%'),
  array['Yongsan I''Park Mall', 'Goyang Starfield', 'Yeongdeungpo Times Square'],
  '운영 지점 3곳의 영어 이름');
select is(
  (select array_agg(address_en order by id) from public.branches where id::text like 'b1000000-%'),
  array['55 Hangang-daero 23-gil, Yongsan-gu, Seoul (Yongsan I''Park Mall)',
        '1955 Goyang-daero, Deogyang-gu, Goyang-si, Gyeonggi-do (Starfield Goyang)',
        '15 Yeongjung-ro, Yeongdeungpo-gu, Seoul (Times Square)'],
  '운영 지점 3곳의 영어 주소');
select is(
  (select array_agg(name_en order by sort_order) from public.exercise_programs where id::text like 'c1000000-%'),
  array['Treadmill First Steps', 'Daily Walk', 'Weight Care', 'Energy Interval', 'Joint Care Walk', 'AI Gait Check'],
  '운동 프로그램 6개의 영어 이름');
select is(
  (select array[count(*), count(description_en),
                count(*) filter (where description_en like '%Recommended once every 2–4 weeks.%')]::int[]
   from public.exercise_programs where id::text like 'c1000000-%'),
  array[6, 6, 1],
  '운동 프로그램 6개 모두 영어 설명이 있다 (AI 보행 체크: "Recommended once every 2–4 weeks.")');
select is(
  (select array[count(*), count(name_en)]::int[] from public.breeds),
  array[40, 40], '견종 40종 모두 영어 이름이 있다');
select is(
  (select array_agg(name_en order by sort_order) from public.breeds
   where id in ('maltese', 'shih_tzu', 'cavalier_king_charles_spaniel', 'jindo', 'pungsan')),
  array['Maltese', 'Shih Tzu', 'Cavalier King Charles Spaniel', 'Jindo', 'Pungsan'],
  '견종 영어 이름');
select is(
  (select array[count(*), count(name_en), count(description_en)]::int[] from public.health_conditions),
  array[10, 10, 10], '질환 10개 모두 영어 이름·설명이 있다');
select is(
  (select array[name_en, description_en] from public.health_conditions where code = 'endocrine_disease'),
  array['Endocrine disease', 'Diabetes, Cushing''s syndrome, hypothyroidism, etc.'],
  '질환 영어 이름·설명');
select is(
  (select array[count(*), count(name_en), count(description_en)]::int[] from public.badges),
  array[12, 12, 12], '배지 12개 모두 영어 이름·설명이 있다');
select is(
  (select array[name_en, description_en] from public.badges where code = 'marathon'),
  array['Marathon Finisher', 'Total workout distance passed a marathon (42.195km).'],
  '배지 영어 이름·설명');

-- ---------------------------------------------------------------------
-- 12~17: 영어 표시 이름 규칙
-- ---------------------------------------------------------------------
select is(
  array[private.size_class_label_en('small'), private.size_class_label_en('medium'), private.size_class_label_en('large')],
  array['Small dogs', 'Medium dogs', 'Large dogs'], '체급 영어 이름');
select is(
  array[private.ranking_scope_label_en('all', 'all'), private.ranking_scope_label_en('size', 'large'),
        private.ranking_scope_label_en('branch', 'b1000000-0000-4000-8000-000000000002')],
  array['Overall', 'Large dogs', 'Goyang Starfield'], '랭킹 범위 영어 이름: 전체 · 체급 · 지점');
select is(
  array[private.dog_breed_label_en('시츄', false, 'shih_tzu'), private.dog_breed_label_en('말티즈', false)],
  array['Shih Tzu', 'Maltese'], '카탈로그 견종은 breeds.name_en (breed_id, 없으면 한국어 이름으로 찾는다)');
select is(
  array[private.dog_breed_label_en('말티즈', true), private.dog_breed_label_en('말티푸', true),
        private.dog_breed_label_en('Maltipoo', true), private.dog_breed_label_en(null, true),
        private.dog_breed_label_en('  ', true)],
  array['Mixed (Maltese)', 'Mixed (말티푸)', 'Mixed (Maltipoo)', 'Mixed breed', 'Mixed breed'],
  '믹스견: Mixed (카탈로그 견종이면 영어 이름, 아니면 입력한 그대로) / 견종이 없으면 Mixed breed');
select is(
  array[private.dog_breed_label_en('푸들', false), coalesce(private.dog_breed_label_en(null, false), '-')],
  array['푸들', '-'], '카탈로그에 없는 견종은 입력한 그대로, 견종이 없으면 null');
select is(
  array[private.pick_en('한국어', null), private.pick_en('한국어', ' '), private.pick_en('한국어', 'English')],
  array['한국어', '한국어', 'English'], '영어 값이 비어 있으면 한국어 값 (앱의 L10n.pick과 같은 규칙)');

-- ---------------------------------------------------------------------
-- 준비: 보호자 A(영어 앱, 랭킹 참여), B(한국어 앱, 랭킹 참여), C(locale 없음, 미참여), 관리자 D,
--       E(locale en-US)
-- ---------------------------------------------------------------------
insert into auth.users (id, email, raw_user_meta_data)
values
  ('a5000000-0000-4000-8000-000000000001', 'en-a@example.com',
   '{"name": "Jane", "locale": "en", "consents": [
      {"type": "terms", "version": "1.0", "granted": true},
      {"type": "privacy", "version": "1.0", "granted": true},
      {"type": "ranking", "version": "1.0", "granted": true}]}'::jsonb),
  ('b5000000-0000-4000-8000-000000000002', 'en-b@example.com',
   '{"name": "김보호", "locale": "ko", "consents": [{"type": "ranking", "version": "1.0", "granted": true}]}'::jsonb),
  ('c5000000-0000-4000-8000-000000000003', 'en-c@example.com', '{"name": "박보호"}'::jsonb),
  ('d5000000-0000-4000-8000-000000000004', 'en-admin@example.com', '{"name": "관리자", "locale": "ko"}'::jsonb),
  ('e5000000-0000-4000-8000-000000000005', 'en-e@example.com', '{"name": "Sam", "locale": "en-US"}'::jsonb);

update public.users set role = 'admin' where id = 'd5000000-0000-4000-8000-000000000004';

-- ---------------------------------------------------------------------
-- 18~22: 가입 닉네임
-- ---------------------------------------------------------------------
select ok(
  (select nickname from public.users where id = 'a5000000-0000-4000-8000-000000000001')
    ~ '^(Brave|Swift|Sunny|Happy|Jolly|Lucky|Zippy|Perky|Chill|Merry)(Paw|Tail|Pup|Dog|Nose|Run|Step|Wag)[0-9]{3}$',
  '가입할 때 앱 언어가 영어(locale en)면 영어 기본 닉네임 (형용사 + 명사 + 숫자 3자리)');
select ok(
  (select nickname from public.users where id = 'e5000000-0000-4000-8000-000000000005') ~ '^[A-Za-z]+[0-9]{3}$',
  'locale en-US도 영어 기본 닉네임');
select ok(
  (select nickname from public.users where id = 'b5000000-0000-4000-8000-000000000002') ~ '^[가-힣]+[0-9]{4}$',
  'locale ko면 지금처럼 한국어 기본 닉네임');
select ok(
  (select nickname from public.users where id = 'c5000000-0000-4000-8000-000000000003') ~ '^[가-힣]+[0-9]{4}$',
  'locale이 없으면(이전 앱) 한국어 기본 닉네임');
select ok(
  (select bool_and(x.n ~ '^[A-Za-z]+[0-9]{3}$' and char_length(x.n) between 2 and 12
                   and not private.is_forbidden_nickname(x.n))
   from (select private.generate_nickname_en() as n from generate_series(1, 50)) x),
  '영어 기본 닉네임은 닉네임 형식(2~12자, 영문·숫자)을 지키고 금칙어가 없다');

-- ---------------------------------------------------------------------
-- 준비: 영어 이름이 없는 테스트 지점, 반려견, 지난달·이번 달 운동 (트리거가 점수·배지·알림을 만든다)
-- ---------------------------------------------------------------------
insert into public.branches (id, name, address, opens_at, closes_at, slot_minutes)
values ('f0000000-0000-4000-8000-000000000021', '테스트 영어 지점', '서울', '10:00', '21:00', 30);
insert into public.treadmills (branch_id, device_name)
values ('f0000000-0000-4000-8000-000000000021', 'T-01');

insert into public.dogs (id, owner_id, name, breed_id)
values ('ea000000-0000-4000-8000-000000000001', 'a5000000-0000-4000-8000-000000000001', '콩이', 'maltese');
insert into public.dogs (id, owner_id, name, breed, is_mixed, size_class)
values ('eb000000-0000-4000-8000-000000000001', 'b5000000-0000-4000-8000-000000000002', '해피', '말티즈', true, 'small');

create temporary table t_ctx as
select
  private.current_ranking_month() as cur,
  (private.current_ranking_month() - interval '1 month')::date as prev,
  'f0000000-0000-4000-8000-000000000021'::uuid as branch,
  (select t.id from public.treadmills t
   where t.branch_id = 'f0000000-0000-4000-8000-000000000021' and t.device_name = 'T-01') as tm,
  (select t.id from public.treadmills t
   where t.branch_id = 'b1000000-0000-4000-8000-000000000001' and t.device_name = 'T-01') as tm_yongsan;
grant select on t_ctx to authenticated;

-- 기기가 운동을 끝낸 것처럼 세션을 바로 넣는다
create function pg_temp.add_session(
  p_id uuid, p_dog uuid, p_treadmill uuid, p_day date, p_time time, p_minutes integer, p_meters numeric
)
returns void
language sql
as $$
  insert into public.exercise_sessions (
    id, dog_id, treadmill_id, status, started_at, ended_at, duration_seconds, distance_meters,
    target_duration_seconds
  )
  values (
    p_id, p_dog, p_treadmill, 'completed', (p_day + p_time) at time zone 'Asia/Seoul',
    (p_day + p_time) at time zone 'Asia/Seoul' + make_interval(mins => p_minutes),
    p_minutes * 60, p_meters, 1800
  );
$$;

-- 지난달: 콩이 용산 40점(전체·체급·용산 1위), 해피 테스트 지점 30점(전체·체급 2위, 테스트 지점 1위)
select pg_temp.add_session('e5000000-0000-4000-8000-000000000001', 'ea000000-0000-4000-8000-000000000001',
  (select tm_yongsan from t_ctx), (select prev from t_ctx) + 9, '11:00', 30, 2500);
select pg_temp.add_session('e5000000-0000-4000-8000-000000000002', 'eb000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select prev from t_ctx) + 9, '12:00', 30, 1000);
-- 이번 달: 같은 점수. 콩이의 두 번째 운동은 하루 1회 제한으로 0점
select pg_temp.add_session('e5000000-0000-4000-8000-000000000003', 'ea000000-0000-4000-8000-000000000001',
  (select tm_yongsan from t_ctx), (select cur from t_ctx), '10:00', 30, 2500);
select pg_temp.add_session('e5000000-0000-4000-8000-000000000004', 'ea000000-0000-4000-8000-000000000001',
  (select tm_yongsan from t_ctx), (select cur from t_ctx), '15:00', 30, 2500);
select pg_temp.add_session('e5000000-0000-4000-8000-000000000005', 'eb000000-0000-4000-8000-000000000001',
  (select tm from t_ctx), (select cur from t_ctx), '11:00', 30, 1000);

-- 23~24
select is(private.close_ranking_month((select prev from t_ctx)), 6,
  '지난달 마감: 콩이(전체·소형견·용산), 해피(전체·소형견·테스트 지점)');
select is(private.ranking_scope_label_en('branch', 'f0000000-0000-4000-8000-000000000021'), '테스트 영어 지점',
  '영어 이름이 없는 지점은 영어 범위 이름도 한국어 이름');

-- ---------------------------------------------------------------------
-- 25~33: 랭킹 RPC의 _en 필드
-- ---------------------------------------------------------------------
set local role authenticated;
set local request.jwt.claims to '{"sub": "b5000000-0000-4000-8000-000000000002", "role": "authenticated"}';

select is(
  (select array[breed_label, breed_label_en, main_branch_name, main_branch_name_en, title_label, title_label_en]
   from public.get_leaderboard((select cur from t_ctx), 'all', 'all', 50) where dog_name = '콩이'),
  array['말티즈', 'Maltese', '용산 아이파크몰점', 'Yongsan I''Park Mall', '전체', 'Overall'],
  'get_leaderboard: breed_label_en · main_branch_name_en · title_label_en');
select is(
  (select array[breed_label, breed_label_en, main_branch_name_en, title_label_en]
   from public.get_leaderboard((select cur from t_ctx), 'all', 'all', 50) where dog_name = '해피'),
  array['믹스견(말티즈)', 'Mixed (Maltese)', '테스트 영어 지점', '테스트 영어 지점'],
  'get_leaderboard: 믹스견은 Mixed (견종), 영어 이름이 없는 지점은 한국어 이름');
select is(
  (select array[
     (select branch_name_en from public.get_branch_battle((select cur from t_ctx))
      where branch_id = 'b1000000-0000-4000-8000-000000000001'),
     (select branch_name_en from public.get_branch_battle((select cur from t_ctx))
      where branch_id = (select branch from t_ctx))]),
  array['Yongsan I''Park Mall', '테스트 영어 지점'],
  'get_branch_battle: branch_name_en');
select is(
  (select array[p ->> 'breed_label', p ->> 'breed_label_en']
   from (select public.get_ranking_dog_profile('ea000000-0000-4000-8000-000000000001', null) as p) x),
  array['말티즈', 'Maltese'], 'get_ranking_dog_profile: breed_label_en');
select is(
  (select array_agg(a ->> 'scope_label_en' order by a ->> 'scope')
   from jsonb_array_elements(public.get_ranking_dog_profile('ea000000-0000-4000-8000-000000000001', null) -> 'awards') a),
  array['Overall', 'Yongsan I''Park Mall', 'Small dogs'], 'get_ranking_dog_profile: 수상 기록마다 scope_label_en');
select is(
  (select array[scope_label, scope_label_en, breed_label, breed_label_en]
   from public.get_hall_of_fame(6) where period_month = (select prev from t_ctx) and scope = 'all' and rank = 1),
  array['전체', 'Overall', '말티즈', 'Maltese'], 'get_hall_of_fame: scope_label_en · breed_label_en');
select is(
  (select array[scope_label_en, breed_label_en]
   from public.get_hall_of_fame(6) where period_month = (select prev from t_ctx) and scope = 'branch' and dog_name = '해피'),
  array['테스트 영어 지점', 'Mixed (Maltese)'], 'get_hall_of_fame: 지점 범위·믹스견');

set local request.jwt.claims to '{"sub": "a5000000-0000-4000-8000-000000000001", "role": "authenticated"}';
select is(
  (select array_agg(array[r ->> 'label', r ->> 'label_en'] order by ord)
   from jsonb_array_elements(
     public.get_my_ranking('ea000000-0000-4000-8000-000000000001', (select cur from t_ctx)) -> 'ranks'
   ) with ordinality as x(r, ord)),
  array[['전체', 'Overall'], ['용산 아이파크몰점', 'Yongsan I''Park Mall'], ['소형견', 'Small dogs']],
  'get_my_ranking: 범위마다 label과 label_en (전체 → 지점 → 체급)');
select is(
  (select array_agg(a ->> 'scope_label_en' order by a ->> 'scope')
   from jsonb_array_elements(public.get_dog_achievements('ea000000-0000-4000-8000-000000000001') -> 'awards') a),
  array['Overall', 'Yongsan I''Park Mall', 'Small dogs'], 'get_dog_achievements: 수상 기록마다 scope_label_en');

reset role;

-- ---------------------------------------------------------------------
-- 34~41: 알림 — 운동 완료 · 배지 · 월간 수상 (위 준비 단계에서 트리거가 만든 알림)
-- ---------------------------------------------------------------------
select is(
  (select data from public.notifications where data ->> 'session_id' = 'e5000000-0000-4000-8000-000000000001'),
  '{"session_id": "e5000000-0000-4000-8000-000000000001", "msg": "exercise_completed",
    "args": {"dog_name": "콩이", "points": 40}}'::jsonb,
  '운동 완료 알림 data: session_id + msg exercise_completed, args(dog_name, points)');
select is(
  (select array[data -> 'args' ->> 'points', body] from public.notifications
   where data ->> 'session_id' = 'e5000000-0000-4000-8000-000000000004'),
  array['0', '콩이의 운동이 끝났어요. 운동 기록을 확인해 보세요.'],
  '점수를 받지 못한 운동은 points 0 (한국어 본문은 그대로)');
select is(
  (select data from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and data ->> 'msg' = 'badge_earned'
     and data ->> 'badge_code' = 'first_run'),
  '{"dog_id": "ea000000-0000-4000-8000-000000000001", "badge_code": "first_run", "msg": "badge_earned",
    "args": {"dog_name": "콩이", "badge_code": "first_run", "badge_name": "첫 발걸음", "badge_name_en": "First Steps"}}'::jsonb,
  '배지 알림 data: dog_id·badge_code + msg badge_earned, args(dog_name, badge_code, badge_name, badge_name_en)');
select is(
  (select array[title, body] from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and data ->> 'msg' = 'badge_earned'),
  array['새 배지를 받았어요', '콩이의 「첫 발걸음」 배지가 도착했어요. 배지함에서 확인해 보세요.'],
  '배지 알림의 한국어 제목·본문은 그대로');
select is(
  (select data - 'period_month' - 'dog_id' from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and data ->> 'msg' = 'monthly_award'),
  jsonb_build_object('msg', 'monthly_award', 'args', jsonb_build_object(
    'dog_name', '콩이',
    'month', extract(month from (select prev from t_ctx))::int,
    'awards', '[{"scope": "all", "label": "전체", "label_en": "Overall", "rank": 1},
                {"scope": "branch", "label": "용산 아이파크몰점", "label_en": "Yongsan I''Park Mall", "rank": 1},
                {"scope": "size", "label": "소형견", "label_en": "Small dogs", "rank": 1}]'::jsonb)),
  '월간 수상 알림 data: msg monthly_award, args(dog_name, month, awards[{scope, label, label_en, rank}])');
select ok(
  (select data ->> 'period_month' = (select prev from t_ctx)::text
          and data ->> 'dog_id' = 'ea000000-0000-4000-8000-000000000001'
   from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and data ->> 'msg' = 'monthly_award'),
  '월간 수상 알림의 기존 키(period_month, dog_id)는 그대로');
select is(
  (select array[title, body] from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and data ->> 'msg' = 'monthly_award'),
  array[
    format('%s월 랭킹 시상대에 올랐어요', extract(month from (select prev from t_ctx))::int),
    format('콩이가 %s월 랭킹 전체 1위 · 용산 아이파크몰점 1위 · 소형견 1위에 올랐어요. 명예의 전당에서 확인해 보세요.',
      extract(month from (select prev from t_ctx))::int)],
  '월간 수상 알림의 한국어 제목·본문은 그대로');
select is(
  (select data -> 'args' -> 'awards' from public.notifications
   where user_id = 'b5000000-0000-4000-8000-000000000002' and data ->> 'msg' = 'monthly_award'),
  '[{"scope": "all", "label": "전체", "label_en": "Overall", "rank": 2},
    {"scope": "branch", "label": "테스트 영어 지점", "label_en": "테스트 영어 지점", "rank": 1},
    {"scope": "size", "label": "소형견", "label_en": "Small dogs", "rank": 2}]'::jsonb,
  '영어 이름이 없는 지점의 수상은 label_en에 한국어 이름');

-- ---------------------------------------------------------------------
-- 42~46: 알림 — 예약 확정 · 취소 · 미방문
-- ---------------------------------------------------------------------
insert into public.bookings (id, user_id, dog_id, branch_id, treadmill_id, start_at, end_at, status)
select v.id::uuid, 'a5000000-0000-4000-8000-000000000001', 'ea000000-0000-4000-8000-000000000001',
       (select branch from t_ctx), (select tm from t_ctx),
       ((select cur from t_ctx) + v.days + time '11:00') at time zone 'Asia/Seoul',
       ((select cur from t_ctx) + v.days + time '11:30') at time zone 'Asia/Seoul', v.status
from (values
  ('c5000000-0000-4000-8000-000000000001', 40, 'pending'),
  ('c5000000-0000-4000-8000-000000000002', 41, 'confirmed')
) as v(id, days, status);

-- 운영자가 바꾸면 보호자에게 알림이 간다 (보호자 본인이 바꾼 경우는 제외하므로 요청자를 관리자로 둔다)
set local request.jwt.claims to '{"sub": "d5000000-0000-4000-8000-000000000004", "role": "authenticated"}';
update public.bookings set status = 'confirmed' where id = 'c5000000-0000-4000-8000-000000000001';
update public.bookings set status = 'cancelled', cancelled_at = now() where id = 'c5000000-0000-4000-8000-000000000001';

set local role authenticated;
set local request.jwt.claims to '{"sub": "d5000000-0000-4000-8000-000000000004", "role": "authenticated"}';
select lives_ok($$ select public.mark_booking_no_show('c5000000-0000-4000-8000-000000000002') $$,
  '관리자가 미방문 처리한다');
reset role;

select is(
  (select array_agg(data ->> 'msg' order by data ->> 'msg') from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and type = 'booking'),
  array['booking_cancelled', 'booking_confirmed', 'booking_no_show'],
  '예약 확정·취소·미방문 알림에 msg가 있다');
select is(
  (select data from public.notifications
   where data ->> 'booking_id' = 'c5000000-0000-4000-8000-000000000001' and data ->> 'msg' = 'booking_confirmed'),
  jsonb_build_object('booking_id', 'c5000000-0000-4000-8000-000000000001', 'msg', 'booking_confirmed',
    'args', jsonb_build_object('dog_name', '콩이',
      'start_at', (select start_at from public.bookings where id = 'c5000000-0000-4000-8000-000000000001'))),
  '예약 확정 알림 data: booking_id + msg booking_confirmed, args(dog_name, start_at)');
select ok(
  (select bool_and(n.data -> 'args' ->> 'start_at' ~ '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}'
                   and (n.data -> 'args' ->> 'start_at')::timestamptz = b.start_at
                   and n.data -> 'args' ->> 'dog_name' = '콩이')
   from public.notifications n
   join public.bookings b on b.id = (n.data ->> 'booking_id')::uuid
   where n.user_id = 'a5000000-0000-4000-8000-000000000001' and n.type = 'booking'),
  '예약 알림 args.start_at은 예약 시작 시각(ISO 8601)');
select is(
  (select array[title, body] from public.notifications
   where data ->> 'booking_id' = 'c5000000-0000-4000-8000-000000000002' and data ->> 'msg' = 'booking_no_show'),
  array['미방문 처리되었어요',
        format('콩이 · %s 예약이 미방문으로 처리되었습니다.',
          to_char((select start_at from public.bookings where id = 'c5000000-0000-4000-8000-000000000002')
            at time zone 'Asia/Seoul', 'FMMM"월" FMDD"일" HH24:MI'))],
  '예약 알림의 한국어 제목·본문은 그대로');

-- ---------------------------------------------------------------------
-- 47~49: 알림 — 운동 시작 · 중단 (사유 없이)
-- ---------------------------------------------------------------------
insert into public.exercise_sessions (
  id, dog_id, treadmill_id, status, started_at, duration_seconds, distance_meters, target_duration_seconds
)
values (
  'e5000000-0000-4000-8000-000000000006', 'ea000000-0000-4000-8000-000000000001', (select tm_yongsan from t_ctx),
  'running', ((select cur from t_ctx) + time '18:00') at time zone 'Asia/Seoul', 120, 100, 1800
);
update public.exercise_sessions set status = 'stopped', ended_at = started_at + interval '2 minutes'
where id = 'e5000000-0000-4000-8000-000000000006';

select is(
  (select data from public.notifications
   where data ->> 'session_id' = 'e5000000-0000-4000-8000-000000000006' and data ->> 'msg' = 'exercise_started'),
  '{"session_id": "e5000000-0000-4000-8000-000000000006", "msg": "exercise_started",
    "args": {"dog_name": "콩이"}}'::jsonb,
  '운동 시작 알림 data: session_id + msg exercise_started, args(dog_name)');
select is(
  (select data -> 'args' from public.notifications
   where data ->> 'session_id' = 'e5000000-0000-4000-8000-000000000006' and data ->> 'msg' = 'exercise_stopped'),
  '{"dog_name": "콩이", "reason": null}'::jsonb,
  '운동 중단 알림 args: 사유가 없으면 reason null');
select is(
  (select array[title, body] from public.notifications
   where data ->> 'session_id' = 'e5000000-0000-4000-8000-000000000006' and data ->> 'msg' = 'exercise_stopped'),
  array['운동이 중단되었어요', '콩이의 운동이 중단되었습니다. 사유: -'],
  '운동 중단 알림의 한국어 제목·본문은 그대로');

-- ---------------------------------------------------------------------
-- 50~53: 분석 리포트 영어 컬럼 · 분석 완료/실패 알림
-- ---------------------------------------------------------------------
insert into public.analysis_reports (id, session_id, dog_id, analysis_status)
values
  ('a7000000-0000-4000-8000-000000000001', 'e5000000-0000-4000-8000-000000000003',
   'ea000000-0000-4000-8000-000000000001', 'queued'),
  ('a7000000-0000-4000-8000-000000000002', 'e5000000-0000-4000-8000-000000000004',
   'ea000000-0000-4000-8000-000000000001', 'queued');

select is(
  (select array[summary_en, care_notes_en::text] from public.analysis_reports
   where id = 'a7000000-0000-4000-8000-000000000001'),
  array[null, '[]'], '영어 요약은 비어 있고 영어 운동 관리 참고사항은 빈 배열로 시작한다');
select throws_ok($$
  update public.analysis_reports set care_notes_en = '{"note": "x"}' where id = 'a7000000-0000-4000-8000-000000000001'
$$, '23514', null, '영어 운동 관리 참고사항은 배열만 받는다');

update public.analysis_reports
set analysis_status = 'completed',
    summary = '좌우 대칭성이 양호합니다.', summary_en = 'Left-right symmetry looks good.',
    care_notes = '["평소처럼 운동해도 좋아요."]', care_notes_en = '["Keep up the usual routine."]'
where id = 'a7000000-0000-4000-8000-000000000001';
update public.analysis_reports set analysis_status = 'failed', error_message = 'camera'
where id = 'a7000000-0000-4000-8000-000000000002';

select is(
  (select care_notes_en ->> 0 from public.analysis_reports where id = 'a7000000-0000-4000-8000-000000000001'),
  'Keep up the usual routine.', 'AI 서버가 영어 요약·참고사항을 함께 저장한다');
select is(
  (select array_agg(data order by data ->> 'msg') from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and type = 'analysis'),
  array[
    '{"report_id": "a7000000-0000-4000-8000-000000000001", "msg": "analysis_completed", "args": {"dog_name": "콩이"}}'::jsonb,
    '{"report_id": "a7000000-0000-4000-8000-000000000002", "msg": "analysis_failed", "args": {"dog_name": "콩이"}}'::jsonb],
  '분석 완료·실패 알림 data: report_id + msg, args(dog_name)');

-- ---------------------------------------------------------------------
-- 54~58: 알림 — 응원 (응원한 사람이 랭킹 참여 중이면 닉네임, 아니면 null)
-- ---------------------------------------------------------------------
set local role authenticated;
set local request.jwt.claims to '{"sub": "b5000000-0000-4000-8000-000000000002", "role": "authenticated"}';
select is(public.cheer_dog('ea000000-0000-4000-8000-000000000001'), 1, 'B(랭킹 참여)가 콩이를 응원한다');
set local request.jwt.claims to '{"sub": "c5000000-0000-4000-8000-000000000003", "role": "authenticated"}';
select is(public.cheer_dog('ea000000-0000-4000-8000-000000000001'), 2, 'C(랭킹 미참여)도 응원할 수 있다');
reset role;

select is(
  (select array_agg(data order by data -> 'args' ->> 'nickname' nulls last) from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and data ->> 'msg' = 'cheer_received'),
  array[
    jsonb_build_object('dog_id', 'ea000000-0000-4000-8000-000000000001', 'msg', 'cheer_received',
      'args', jsonb_build_object('dog_name', '콩이',
        'nickname', (select nickname from public.users where id = 'b5000000-0000-4000-8000-000000000002'))),
    jsonb_build_object('dog_id', 'ea000000-0000-4000-8000-000000000001', 'msg', 'cheer_received',
      'args', jsonb_build_object('dog_name', '콩이', 'nickname', null))],
  '응원 알림 data: dog_id + msg cheer_received, args(dog_name, nickname — 랭킹 미참여자는 null)');
select is(
  (select body from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and data ->> 'msg' = 'cheer_received'
     and data -> 'args' -> 'nickname' = 'null'::jsonb),
  '다른 보호자가 콩이를 응원했어요.', '응원 알림의 한국어 본문은 그대로');
select is(
  (select body from public.notifications
   where user_id = 'a5000000-0000-4000-8000-000000000001' and data ->> 'msg' = 'cheer_received'
     and data -> 'args' -> 'nickname' <> 'null'::jsonb),
  (select nickname || '님이 콩이를 응원했어요.' from public.users where id = 'b5000000-0000-4000-8000-000000000002'),
  '닉네임이 있는 응원 알림의 한국어 본문도 그대로');

-- ---------------------------------------------------------------------
-- 59~62: 다시 만든 RPC의 실행 권한 · 이전 알림 키
-- ---------------------------------------------------------------------
select ok(
  not has_function_privilege('anon', 'public.get_leaderboard(date, text, text, integer)', 'execute')
  and not has_function_privilege('anon', 'public.get_branch_battle(date)', 'execute')
  and not has_function_privilege('anon', 'public.get_hall_of_fame(integer)', 'execute'),
  '다시 만든 랭킹 RPC도 비로그인(anon)은 호출할 수 없다');
select ok(
  has_function_privilege('authenticated', 'public.get_leaderboard(date, text, text, integer)', 'execute')
  and has_function_privilege('authenticated', 'public.get_branch_battle(date)', 'execute')
  and has_function_privilege('authenticated', 'public.get_hall_of_fame(integer)', 'execute'),
  '다시 만든 랭킹 RPC는 로그인 회원이 호출할 수 있다');
select ok(
  not has_function_privilege('anon', 'private.generate_nickname_en()', 'execute')
  and not has_function_privilege('anon', 'private.dog_breed_label_en(text, boolean, text)', 'execute'),
  '새 private 함수는 비로그인(anon)이 실행할 수 없다');
select is(
  (select count(*)::int from public.notifications
   where user_id in ('a5000000-0000-4000-8000-000000000001', 'b5000000-0000-4000-8000-000000000002')
     and (data ->> 'msg' is null or jsonb_typeof(data -> 'args') <> 'object')),
  0, 'DB 트리거가 만든 알림에는 모두 msg와 args가 있다');

select * from finish();
rollback;
