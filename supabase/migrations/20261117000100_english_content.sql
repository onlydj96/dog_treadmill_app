-- =====================================================================
-- 영어 콘텐츠 (다국어: 한국어 기본 + English) — 규격은 docs/i18n.md "서버에서 오는 텍스트"
--  1. 사람이 읽는 텍스트 컬럼마다 영어 컬럼(같은 이름 + _en)을 둔다.
--     비어 있으면 앱이 영어 화면에서도 기본(한국어) 값을 보여 준다.
--  2. 운영 기준 데이터(지점 3 · 운동 프로그램 6 · 견종 40 · 질환 10 · 배지 12)의 영어 값을 채운다.
--     문구는 데모 앱 목업 데이터와 같다.
--  3. 랭킹 RPC: 표시용 문구 필드마다 같은 이름 + _en 필드를 함께 돌려준다.
--  4. 알림: 한국어 title/body는 그대로 두고 data에 문구 종류(msg)와 값(args)을 함께 저장한다.
--     앱은 아는 msg면 현재 언어로 문구를 만든다 (언어를 바꾸면 지난 알림도 새 언어로 보인다).
--  5. 회원가입: 사용자 메타데이터 locale이 en이면 영어 기본 닉네임을 만든다.
-- 서버가 만드는 _en 값(RPC 결과·알림 args)은 영어 값이 없으면 한국어 값을 넣는다.
-- 다시 정의하는 함수는 각 함수의 최신 정의(20261109000400 · 20261116000100)를 옮기고 필요한 곳만 바꿨다.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. 영어 컬럼
-- 운영자가 새 지점·상품·공지·FAQ 등을 넣을 때 영어 컬럼도 채운다.
-- 권한: 이 테이블들은 테이블 단위 SELECT 권한과 행 단위 RLS 정책을 쓰므로 새 컬럼도 지금처럼 읽힌다.
--   (컬럼 단위 GRANT는 users·notifications의 UPDATE에만 있고, 이 테이블들을 돌려주는 뷰·RPC는 없다.
--    analysis_reports의 Realtime 발행도 컬럼 목록 없이 테이블 전체를 보낸다.)
-- ---------------------------------------------------------------------
alter table public.branches
  add column name_en text,
  add column address_en text;
comment on column public.branches.name_en is '지점명(영어). null이면 영어 화면에서도 name을 보여 준다';
comment on column public.branches.address_en is '주소(영어). null이면 영어 화면에서도 address를 보여 준다';

alter table public.exercise_programs
  add column name_en text,
  add column description_en text;
comment on column public.exercise_programs.name_en is '프로그램 이름(영어). null이면 영어 화면에서도 name을 보여 준다';
comment on column public.exercise_programs.description_en is '프로그램 설명(영어)';

alter table public.membership_plans
  add column name_en text,
  add column description_en text;
comment on column public.membership_plans.name_en is
  '이용권 상품 이름(영어). 구매 기록(memberships.plan_name)에는 한국어 이름이 복사되므로 앱이 plan_id로 이 컬럼을 함께 읽는다';
comment on column public.membership_plans.description_en is '이용권 상품 설명(영어)';

alter table public.notices
  add column title_en text,
  add column body_en text;
comment on column public.notices.title_en is '공지 제목(영어). null이면 영어 화면에서도 title을 보여 준다';
comment on column public.notices.body_en is '공지 본문(영어)';

alter table public.faqs
  add column category_en text,
  add column question_en text,
  add column answer_en text;
comment on column public.faqs.category_en is
  'FAQ 분류(영어). 앱은 분류 이름으로 묶으므로 같은 category에는 같은 category_en을 넣는다';
comment on column public.faqs.question_en is '질문(영어)';
comment on column public.faqs.answer_en is '답변(영어)';

alter table public.breeds
  add column name_en text;
comment on column public.breeds.name_en is
  '견종 이름(영어). dogs.breed에는 카탈로그 한국어 이름이 복사되므로 영어는 dogs.breed_id로 이 컬럼을 읽는다';

alter table public.health_conditions
  add column name_en text,
  add column description_en text;
comment on column public.health_conditions.name_en is '질환 이름(영어)';
comment on column public.health_conditions.description_en is '질환 설명(영어)';

alter table public.badges
  add column name_en text,
  add column description_en text;
comment on column public.badges.name_en is '배지 이름(영어). 배지 알림의 data.args.badge_name_en에도 쓴다';
comment on column public.badges.description_en is '배지 설명(영어)';

alter table public.analysis_reports
  add column summary_en text,
  add column care_notes_en jsonb not null default '[]'::jsonb
    check (jsonb_typeof(care_notes_en) = 'array');
comment on column public.analysis_reports.summary_en is
  'AI 분석 요약(영어). AI 서버가 summary와 함께 쓴다 (docs/analysis-metrics.md)';
comment on column public.analysis_reports.care_notes_en is
  '운동 관리 참고사항(영어, 문자열 배열). 비어 있으면 영어 화면에서도 care_notes를 보여 준다';

-- AI·운영자 운동 계획 (exercise_plans)
alter table public.exercise_plans
  add column program_name_en text,
  add column notes_en text;
comment on column public.exercise_plans.program_name_en is '운동 계획 프로그램 이름(영어). null이면 영어 화면에서도 program_name을 보여 준다';
comment on column public.exercise_plans.notes_en is '운동 계획 메모(영어). null이면 영어 화면에서도 notes를 보여 준다';
comment on column public.exercise_plans.restrictions is
  '운동 제한 사항 목록(jsonb 배열). 각 항목은 {"name": "...", "name_en": "..."} 형태로, name_en이 없으면 영어 화면에서도 name을 보여 준다';

-- 결제 (payments): 주문명은 구매 시점의 이름이 복사되므로 영어 값도 같이 복사한다.
-- payments.method는 한국어 표시값·PG 코드를 그대로 저장하고, 앱이 현재 언어로 바꿔 보여 준다 (localizedPaymentMethod).
alter table public.payments
  add column order_name_en text;
comment on column public.payments.order_name_en is '주문명(영어). null이면 영어 화면에서도 order_name을 보여 준다';

-- ---------------------------------------------------------------------
-- 2. 운영 기준 데이터의 영어 값
--    지점·운동 프로그램(20261110000200), 견종·질환(20261113000100), 배지(20261116000100)
-- ---------------------------------------------------------------------
update public.branches b
set name_en = v.name_en, address_en = v.address_en
from (values
  ('b1000000-0000-4000-8000-000000000001'::uuid, 'Yongsan I''Park Mall',
   '55 Hangang-daero 23-gil, Yongsan-gu, Seoul (Yongsan I''Park Mall)'),
  ('b1000000-0000-4000-8000-000000000002'::uuid, 'Goyang Starfield',
   '1955 Goyang-daero, Deogyang-gu, Goyang-si, Gyeonggi-do (Starfield Goyang)'),
  ('b1000000-0000-4000-8000-000000000003'::uuid, 'Yeongdeungpo Times Square',
   '15 Yeongjung-ro, Yeongdeungpo-gu, Seoul (Times Square)')
) as v(id, name_en, address_en)
where b.id = v.id;

update public.exercise_programs p
set name_en = v.name_en, description_en = v.description_en
from (values
  ('c1000000-0000-4000-8000-000000000001'::uuid, 'Treadmill First Steps',
   'An adaptation program for dogs on their first visit. Your dog walks very slowly with breaks in between to get comfortable with the treadmill.'),
  ('c1000000-0000-4000-8000-000000000002'::uuid, 'Daily Walk',
   'For days when rain, fine dust, or a heat wave makes outdoor walks hard. Your dog gets a day''s worth of exercise at a comfortable pace.'),
  ('c1000000-0000-4000-8000-000000000003'::uuid, 'Weight Care',
   'A long walk that alternates normal and brisk paces to help manage weight. Recommended for dogs that are overweight or don''t get enough activity.'),
  ('c1000000-0000-4000-8000-000000000004'::uuid, 'Energy Interval',
   'Alternates walking and light jogging to burn off extra energy. Best for healthy adult dogs that are used to the treadmill.'),
  ('c1000000-0000-4000-8000-000000000005'::uuid, 'Joint Care Walk',
   'A slow, steady walk for senior dogs or dogs that need kneecap or hip care. If your dog recently had surgery, please talk to your vet first.'),
  ('c1000000-0000-4000-8000-000000000006'::uuid, 'AI Gait Check',
   'Walks at the same speed and duration every time, so it''s easy to compare gait changes with earlier records. Recommended once every 2–4 weeks. Reports are available if you agree to video recording.')
) as v(id, name_en, description_en)
where p.id = v.id;

update public.breeds b
set name_en = v.name_en
from (values
  ('maltese',                       'Maltese'),
  ('toy_poodle',                    'Toy Poodle'),
  ('miniature_poodle',              'Miniature Poodle'),
  ('pomeranian',                    'Pomeranian'),
  ('shih_tzu',                      'Shih Tzu'),
  ('bichon_frise',                  'Bichon Frise'),
  ('chihuahua',                     'Chihuahua'),
  ('yorkshire_terrier',             'Yorkshire Terrier'),
  ('dachshund',                     'Dachshund'),
  ('miniature_schnauzer',           'Miniature Schnauzer'),
  ('pug',                           'Pug'),
  ('japanese_spitz',                'Japanese Spitz'),
  ('papillon',                      'Papillon'),
  ('italian_greyhound',             'Italian Greyhound'),
  ('jack_russell_terrier',          'Jack Russell Terrier'),
  ('miniature_pinscher',            'Miniature Pinscher'),
  ('pekingese',                     'Pekingese'),
  ('boston_terrier',                'Boston Terrier'),
  ('cavalier_king_charles_spaniel', 'Cavalier King Charles Spaniel'),
  ('west_highland_white_terrier',   'West Highland White Terrier'),
  ('shetland_sheepdog',             'Shetland Sheepdog'),
  ('welsh_corgi',                   'Welsh Corgi'),
  ('jindo',                         'Jindo'),
  ('shiba_inu',                     'Shiba Inu'),
  ('beagle',                        'Beagle'),
  ('border_collie',                 'Border Collie'),
  ('french_bulldog',                'French Bulldog'),
  ('english_bulldog',               'English Bulldog'),
  ('cocker_spaniel',                'Cocker Spaniel'),
  ('siberian_husky',                'Siberian Husky'),
  ('standard_poodle',               'Standard Poodle'),
  ('golden_retriever',              'Golden Retriever'),
  ('labrador_retriever',            'Labrador Retriever'),
  ('samoyed',                       'Samoyed'),
  ('alaskan_malamute',              'Alaskan Malamute'),
  ('german_shepherd',               'German Shepherd'),
  ('doberman',                      'Doberman'),
  ('boxer',                         'Boxer'),
  ('bernese_mountain_dog',          'Bernese Mountain Dog'),
  ('pungsan',                       'Pungsan')
) as v(id, name_en)
where b.id = v.id;

update public.health_conditions h
set name_en = v.name_en, description_en = v.description_en
from (values
  ('joint_disease',       'Joint disease',
                          'Patellar luxation, hip dysplasia, arthritis, cruciate ligament injury, etc.'),
  ('spinal_disease',      'Spinal / disc disease',
                          'Intervertebral disc disease (IVDD), etc.'),
  ('heart_disease',       'Heart disease',
                          'Mitral valve disease, heartworm, etc.'),
  ('obesity',             'Obesity',
                          'Diagnosed as obese or overweight by a vet'),
  ('respiratory_disease', 'Respiratory disease',
                          'Tracheal collapse, brachycephalic airway syndrome, etc.'),
  ('endocrine_disease',   'Endocrine disease',
                          'Diabetes, Cushing''s syndrome, hypothyroidism, etc.'),
  ('kidney_disease',      'Kidney disease',
                          'Chronic kidney disease, etc.'),
  ('seizure_disorder',    'Epilepsy / seizures',
                          'Has a history of seizures'),
  ('paw_skin_problem',    'Paw / skin problems',
                          'Pad wounds, interdigital dermatitis, or other problems on parts of the paw that touch the ground'),
  ('recovering',          'Recovering from surgery or injury',
                          'Recently had surgery or is recovering from an injury')
) as v(code, name_en, description_en)
where h.code = v.code;

update public.badges b
set name_en = v.name_en, description_en = v.description_en
from (values
  ('first_run',     'First Steps',       'Finished a treadmill workout for the first time.'),
  ('sessions_10',   'Tenth Workout',     'Finished 10 workouts.'),
  ('sessions_30',   'Regular Runner',    'Finished 30 workouts.'),
  ('sessions_100',  '100 Dashes',        'Finished 100 workouts.'),
  ('distance_10k',  '10km Milestone',    'Total workout distance passed 10km.'),
  ('marathon',      'Marathon Finisher', 'Total workout distance passed a marathon (42.195km).'),
  ('distance_100k', '100km Club',        'Total workout distance passed 100km.'),
  ('streak_4',      '4-Week Streak',     'Worked out every week for 4 weeks in a row.'),
  ('streak_12',     '12-Week Streak',    'Worked out every week for 12 weeks in a row (about 3 months).'),
  ('stamp_tour',    'Stamp Tour',        'Worked out at 3 different locations.'),
  ('open_run',      'Open Run',          'Started 3 workouts within 30 minutes of the store opening.'),
  ('podium',        'Podium',            'Placed in the top 3 of a monthly ranking.')
) as v(code, name_en, description_en)
where b.code = v.code;

-- ---------------------------------------------------------------------
-- 3. 랭킹 RPC 영어 필드
-- 표시용 문구 필드마다 같은 이름 + _en 필드를 함께 돌려준다. 영어 값이 없으면 한국어 값을 넣는다.
-- 배지 목록은 지금처럼 code·earned_at만 돌려주므로(이름·설명은 앱이 badges 테이블에서 읽는다) 바꾸지 않는다.
-- ---------------------------------------------------------------------

-- 영어 값이 비어 있으면 한국어 값 (앱의 L10n.pick(ko, en)과 같은 규칙)
create or replace function private.pick_en(p_ko text, p_en text)
returns text
language sql
immutable
set search_path = ''
as $$ select coalesce(nullif(trim(p_en), ''), p_ko) $$;

-- private.size_class_label의 영어판
create or replace function private.size_class_label_en(p_size_class text)
returns text
language sql
immutable
set search_path = ''
as $$
  select case p_size_class
    when 'small' then 'Small dogs'
    when 'medium' then 'Medium dogs'
    when 'large' then 'Large dogs'
  end
$$;

-- private.dog_breed_label의 영어판: "Shih Tzu", "Mixed (Maltese)", "Mixed (Maltipoo)", "Mixed breed"
-- dogs.breed는 카탈로그 견종이면 카탈로그 한국어 이름이므로 breeds.name_en으로 바꾼다 (breed_id, 없으면 이름으로 찾는다).
-- 카탈로그에 없는 견종(믹스견에 보호자가 적은 견종 등)은 입력한 그대로, 영어 이름이 없는 카탈로그 견종은 한국어 이름.
create or replace function private.dog_breed_label_en(
  p_breed text,
  p_is_mixed boolean,
  p_breed_id text default null
)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select case
    when coalesce(p_is_mixed, false) then
      case when x.breed is null then 'Mixed breed' else 'Mixed (' || x.breed || ')' end
    else x.breed
  end
  from (
    select coalesce(
      (select nullif(trim(b.name_en), '') from public.breeds b where b.id = p_breed_id),
      (select nullif(trim(b.name_en), '') from public.breeds b where b.name = trim(p_breed)),
      nullif(trim(p_breed), '')
    ) as breed
  ) x
$$;

-- private.ranking_scope_label의 영어판: Overall / 지점 영어 이름 / Small dogs·Medium dogs·Large dogs
create or replace function private.ranking_scope_label_en(p_scope text, p_scope_key text)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select case p_scope
    when 'all' then 'Overall'
    when 'size' then private.size_class_label_en(p_scope_key)
    when 'branch' then (
      select private.pick_en(b.name, b.name_en) from public.branches b where b.id::text = p_scope_key
    )
  end
$$;

-- 월간 랭킹 순위표 (상위 p_limit, 최대 100)
-- 추가: breed_label_en, main_branch_name_en, title_label_en
-- 반환 컬럼이 바뀌면 create or replace를 쓸 수 없어 지우고 다시 만든다 (실행 권한은 이 파일 끝에서 다시 준다).
drop function public.get_leaderboard(date, text, text, integer);
create function public.get_leaderboard(
  p_month date default null,
  p_scope text default 'all',
  p_scope_key text default 'all',
  p_limit integer default 50
)
returns table (
  rank integer,
  dog_id uuid,
  dog_name text,
  breed_label text,
  breed_label_en text,
  size_class text,
  photo_path text,
  nickname text,
  main_branch_name text,
  main_branch_name_en text,
  points integer,
  session_count integer,
  distance_meters numeric,
  cheer_count integer,
  cheered_by_me boolean,
  is_mine boolean,
  title_period date,
  title_scope text,
  title_label text,
  title_label_en text,
  title_rank integer,
  participant_count integer
)
language plpgsql
stable
security definer
set search_path = ''
as $$
#variable_conflict use_column
declare
  v_uid uuid := (select auth.uid());
  v_month date := private.month_start(coalesce(p_month, private.kst_date(now())));
  v_prev date := (private.month_start(coalesce(p_month, private.kst_date(now()))) - interval '1 month')::date;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;
  perform private.assert_ranking_scope(p_scope, p_scope_key);

  return query
  with standings as (
    select * from private.ranking_standings(v_month, p_scope, p_scope_key, null)
  ),
  top_dogs as (
    select s.*
    from standings s
    order by s.place, s.reached_at, s.dog_id
    limit least(greatest(coalesce(p_limit, 50), 1), 100)
  ),
  branch_points as (
    select p.dog_id, b.name as branch_name, max(b.name_en) as branch_name_en, sum(p.points) as pts
    from public.exercise_points p
    join public.branches b on b.id = p.branch_id
    where p.period_month = v_month and p.voided_at is null
      and p.dog_id in (select t.dog_id from top_dogs t)
    group by p.dog_id, b.name
  ),
  main_branch as (
    select distinct on (bp.dog_id) bp.dog_id, bp.branch_name, bp.branch_name_en
    from branch_points bp
    order by bp.dog_id, bp.pts desc, bp.branch_name
  ),
  cheers as (
    select c.dog_id, count(*)::integer as cnt, bool_or(c.user_id = v_uid) as mine
    from public.ranking_cheers c
    where c.period_month = v_month and c.dog_id in (select t.dog_id from top_dogs t)
    group by c.dog_id
  ),
  titles as (
    select distinct on (a.dog_id)
      a.dog_id, a.period_month, a.scope, a.scope_key, a.rank
    from public.monthly_awards a
    where a.period_month = v_prev and a.dog_id in (select t.dog_id from top_dogs t)
    order by a.dog_id, a.rank, case a.scope when 'all' then 0 when 'branch' then 1 else 2 end
  )
  select
    t.place,
    t.dog_id,
    d.name,
    private.dog_breed_label(d.breed, d.is_mixed),
    private.dog_breed_label_en(d.breed, d.is_mixed, d.breed_id),
    d.size_class,
    case when u.ranking_show_photo then d.profile_image_path end,
    u.nickname,
    mb.branch_name,
    private.pick_en(mb.branch_name, mb.branch_name_en),
    t.points,
    t.session_count,
    t.distance_meters,
    coalesce(ch.cnt, 0),
    coalesce(ch.mine, false),
    d.owner_id = v_uid,
    ti.period_month,
    ti.scope,
    private.ranking_scope_label(ti.scope, ti.scope_key),
    private.ranking_scope_label_en(ti.scope, ti.scope_key),
    ti.rank::integer,
    t.participant_count
  from top_dogs t
  join public.dogs d on d.id = t.dog_id
  join public.users u on u.id = d.owner_id
  left join main_branch mb on mb.dog_id = t.dog_id
  left join cheers ch on ch.dog_id = t.dog_id
  left join titles ti on ti.dog_id = t.dog_id
  order by t.place, t.reached_at, t.dog_id;
end;
$$;

-- 내 반려견의 이번 달 점수·순위 (전체 / 운동한 지점별 / 체급). 랭킹에 참여하지 않았어도
-- 참여하면 몇 위인지 계산해 돌려준다(participating=false).
-- 추가: ranks[].label_en
create or replace function public.get_my_ranking(p_dog_id uuid, p_month date default null)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_month date := private.month_start(coalesce(p_month, private.kst_date(now())));
  v_dog public.dogs%rowtype;
  v_summary jsonb;
  v_ranks jsonb;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;
  select * into v_dog from public.dogs d
  where d.id = p_dog_id and d.owner_id = v_uid and d.deleted_at is null;
  if not found then
    raise exception 'DOG_NOT_FOUND' using errcode = 'P0002';
  end if;

  select jsonb_build_object(
    'points', coalesce(sum(p.points), 0),
    'session_count', count(*) filter (where p.kind = 'session' and p.qualified),
    'distance_meters', coalesce(sum(p.distance_meters) filter (where p.kind = 'session'), 0),
    'weekly_bonus_count', count(*) filter (where p.kind = 'weekly_bonus')
  )
  into v_summary
  from public.exercise_points p
  where p.dog_id = p_dog_id and p.period_month = v_month and p.voided_at is null;

  with scopes as (
    select 'all'::text as scope, 'all'::text as scope_key, 0 as ord, 0::bigint as pts
    union all
    select 'size', v_dog.size_class, 2, 0 where v_dog.size_class is not null
    union all
    select 'branch', p.branch_id::text, 1, sum(p.points)
    from public.exercise_points p
    where p.dog_id = p_dog_id and p.period_month = v_month and p.voided_at is null and p.branch_id is not null
    group by p.branch_id
  )
  select coalesce(jsonb_agg(
    jsonb_build_object(
      'scope', s.scope,
      'scope_key', s.scope_key,
      'label', private.ranking_scope_label(s.scope, s.scope_key),
      'label_en', private.ranking_scope_label_en(s.scope, s.scope_key),
      'rank', r.place,
      'participant_count', r.participant_count,
      'points', r.points,
      'points_to_next', case when r.above_points is null then null else r.above_points - r.points + 1 end,
      'top_percent', ceil(r.place * 100.0 / r.participant_count)::integer
    )
    order by s.ord, s.pts desc, s.scope_key
  ), '[]'::jsonb)
  into v_ranks
  from scopes s
  cross join lateral (
    select z.place, z.participant_count, z.points, z.above_points
    from (
      select x.dog_id, x.place, x.participant_count, x.points,
             lag(x.points) over (order by x.place, x.reached_at, x.dog_id) as above_points
      from private.ranking_standings(v_month, s.scope, s.scope_key, p_dog_id) x
    ) z
    where z.dog_id = p_dog_id
  ) r;

  return jsonb_build_object(
    'dog_id', p_dog_id,
    'period_month', v_month,
    'participating', private.has_consent(v_uid, 'ranking'),
    'nickname', (select u.nickname from public.users u where u.id = v_uid),
    'streak_weeks', (private.dog_badge_stats(p_dog_id) ->> 'streak_weeks')::integer,
    'ranks', v_ranks
  ) || v_summary;
end;
$$;

-- 지점 대항전: 지점별 이번 달 총 운동 거리 (모든 회원의 합계라 개인 정보가 드러나지 않는다)
-- 추가: branch_name_en (반환 컬럼이 바뀌어 지우고 다시 만든다)
drop function public.get_branch_battle(date);
create function public.get_branch_battle(p_month date default null)
returns table (
  rank integer,
  branch_id uuid,
  branch_name text,
  branch_name_en text,
  distance_meters numeric,
  session_count integer,
  dog_count integer,
  points integer
)
language plpgsql
stable
security definer
set search_path = ''
as $$
#variable_conflict use_column
declare
  v_month date := private.month_start(coalesce(p_month, private.kst_date(now())));
begin
  if (select auth.uid()) is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;

  return query
  with totals as (
    select
      b.id,
      b.name,
      b.name_en,
      coalesce(sum(p.distance_meters) filter (where p.kind = 'session'), 0) as distance_meters,
      (count(*) filter (where p.kind = 'session' and p.qualified))::integer as session_count,
      (count(distinct p.dog_id) filter (where p.kind = 'session' and p.qualified))::integer as dog_count,
      coalesce(sum(p.points), 0)::integer as points
    from public.branches b
    left join public.exercise_points p
      on p.branch_id = b.id and p.period_month = v_month and p.voided_at is null
    where b.is_active
    group by b.id, b.name, b.name_en
  )
  select
    (rank() over (order by t.distance_meters desc))::integer,
    t.id,
    t.name,
    private.pick_en(t.name, t.name_en),
    t.distance_meters,
    t.session_count,
    t.dog_count,
    t.points
  from totals t
  order by t.distance_meters desc, t.name;
end;
$$;

-- 랭킹에서 반려견을 눌렀을 때 보여줄 공개 프로필 (배지·수상 이력·응원)
-- 추가: breed_label_en, awards[].scope_label_en
create or replace function public.get_ranking_dog_profile(p_dog_id uuid, p_month date default null)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_month date := private.month_start(coalesce(p_month, private.kst_date(now())));
  v_dog public.dogs%rowtype;
  v_owner public.users%rowtype;
  v_is_mine boolean;
  v_participating boolean;
  v_standing record;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;

  select * into v_dog from public.dogs d where d.id = p_dog_id and d.deleted_at is null;
  if not found then
    raise exception 'DOG_NOT_FOUND' using errcode = 'P0002';
  end if;
  select * into v_owner from public.users u where u.id = v_dog.owner_id;
  v_is_mine := v_dog.owner_id = v_uid;
  v_participating := private.has_consent(v_dog.owner_id, 'ranking');
  if not v_is_mine and not v_participating then
    raise exception 'DOG_NOT_FOUND' using errcode = 'P0002';
  end if;

  select x.place, x.participant_count, x.points, x.session_count, x.distance_meters
  into v_standing
  from private.ranking_standings(v_month, 'all', 'all', case when v_is_mine then p_dog_id end) x
  where x.dog_id = p_dog_id;

  return jsonb_build_object(
    'dog_id', v_dog.id,
    'dog_name', v_dog.name,
    'breed_label', private.dog_breed_label(v_dog.breed, v_dog.is_mixed),
    'breed_label_en', private.dog_breed_label_en(v_dog.breed, v_dog.is_mixed, v_dog.breed_id),
    'size_class', v_dog.size_class,
    'photo_path', case when v_is_mine or v_owner.ranking_show_photo then v_dog.profile_image_path end,
    'nickname', v_owner.nickname,
    'is_mine', v_is_mine,
    'participating', v_participating,
    'period_month', v_month,
    'rank', v_standing.place,
    'participant_count', v_standing.participant_count,
    'points', coalesce(v_standing.points, 0),
    'session_count', coalesce(v_standing.session_count, 0),
    'distance_meters', coalesce(v_standing.distance_meters, 0),
    'cheer_count', (
      select count(*) from public.ranking_cheers c where c.dog_id = p_dog_id and c.period_month = v_month
    ),
    'cheered_by_me', exists (
      select 1 from public.ranking_cheers c
      where c.dog_id = p_dog_id and c.period_month = v_month and c.user_id = v_uid
    ),
    'badges', (
      select coalesce(jsonb_agg(jsonb_build_object('code', db.badge_code, 'earned_at', db.earned_at)
        order by db.earned_at desc, db.badge_code), '[]'::jsonb)
      from public.dog_badges db
      join public.badges b on b.code = db.badge_code and b.is_active
      where db.dog_id = p_dog_id
    ),
    'awards', (
      select coalesce(jsonb_agg(jsonb_build_object(
          'period_month', a.period_month,
          'scope', a.scope,
          'scope_key', a.scope_key,
          'scope_label', private.ranking_scope_label(a.scope, a.scope_key),
          'scope_label_en', private.ranking_scope_label_en(a.scope, a.scope_key),
          'rank', a.rank,
          'points', a.points
        ) order by a.period_month desc, a.rank, a.scope), '[]'::jsonb)
      from public.monthly_awards a
      where a.dog_id = p_dog_id
    )
  );
end;
$$;

-- 내 반려견의 배지와 진행률 지표
-- 추가: awards[].scope_label_en
create or replace function public.get_dog_achievements(p_dog_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if (select auth.uid()) is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;
  if not private.owns_dog(p_dog_id) then
    raise exception 'DOG_NOT_FOUND' using errcode = 'P0002';
  end if;

  return jsonb_build_object(
    'stats', private.dog_badge_stats(p_dog_id),
    'badges', (
      select coalesce(jsonb_agg(jsonb_build_object('code', db.badge_code, 'earned_at', db.earned_at)
        order by db.earned_at desc, db.badge_code), '[]'::jsonb)
      from public.dog_badges db
      where db.dog_id = p_dog_id
    ),
    'awards', (
      select coalesce(jsonb_agg(jsonb_build_object(
          'period_month', a.period_month,
          'scope', a.scope,
          'scope_key', a.scope_key,
          'scope_label', private.ranking_scope_label(a.scope, a.scope_key),
          'scope_label_en', private.ranking_scope_label_en(a.scope, a.scope_key),
          'rank', a.rank,
          'points', a.points
        ) order by a.period_month desc, a.rank, a.scope), '[]'::jsonb)
      from public.monthly_awards a
      where a.dog_id = p_dog_id
    )
  );
end;
$$;

-- 명예의 전당: 마감한 최근 p_months개월의 1~3위. 이후 랭킹 참여를 철회했거나 삭제된 반려견은 가린다.
-- 추가: scope_label_en, breed_label_en (반환 컬럼이 바뀌어 지우고 다시 만든다)
drop function public.get_hall_of_fame(integer);
create function public.get_hall_of_fame(p_months integer default 6)
returns table (
  period_month date,
  scope text,
  scope_key text,
  scope_label text,
  scope_label_en text,
  rank integer,
  dog_id uuid,
  dog_name text,
  breed_label text,
  breed_label_en text,
  photo_path text,
  nickname text,
  points integer,
  is_mine boolean,
  is_hidden boolean
)
language plpgsql
stable
security definer
set search_path = ''
as $$
#variable_conflict use_column
declare
  v_uid uuid := (select auth.uid());
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;

  return query
  with months as (
    select c.period_month
    from public.ranking_closings c
    order by c.period_month desc
    limit least(greatest(coalesce(p_months, 6), 1), 24)
  ),
  award_rows as (
    select
      a.*,
      d.name as d_name,
      d.breed as d_breed,
      d.breed_id as d_breed_id,
      d.is_mixed as d_is_mixed,
      d.profile_image_path as d_photo,
      u.nickname as u_nickname,
      u.ranking_show_photo as u_show_photo,
      (d.deleted_at is null and (a.owner_id = v_uid or private.has_consent(a.owner_id, 'ranking'))) as visible
    from public.monthly_awards a
    join months m on m.period_month = a.period_month
    join public.dogs d on d.id = a.dog_id
    join public.users u on u.id = a.owner_id
  )
  select
    r.period_month,
    r.scope,
    r.scope_key,
    private.ranking_scope_label(r.scope, r.scope_key),
    private.ranking_scope_label_en(r.scope, r.scope_key),
    r.rank::integer,
    case when r.visible then r.dog_id end,
    case when r.visible then r.d_name end,
    case when r.visible then private.dog_breed_label(r.d_breed, r.d_is_mixed) end,
    case when r.visible then private.dog_breed_label_en(r.d_breed, r.d_is_mixed, r.d_breed_id) end,
    case when r.visible and (r.u_show_photo or r.owner_id = v_uid) then r.d_photo end,
    case when r.visible then r.u_nickname end,
    r.points,
    r.owner_id = v_uid,
    not r.visible
  from award_rows r
  order by
    r.period_month desc,
    case r.scope when 'all' then 0 when 'branch' then 1 else 2 end,
    private.ranking_scope_label(r.scope, r.scope_key),
    r.rank,
    r.points desc;
end;
$$;

-- ---------------------------------------------------------------------
-- 4. 알림 data.msg / data.args (docs/i18n.md "알림" 표)
-- 한국어 title/body와 기존 data 키(booking_id, session_id, report_id, dog_id, badge_code, period_month)는 그대로 둔다.
-- ---------------------------------------------------------------------

-- 예약 상태 변경 (보호자 본인이 바꾼 경우는 제외)
-- msg: booking_confirmed / booking_cancelled / booking_no_show, args: dog_name, start_at(ISO 8601)
create or replace function private.on_booking_status_changed()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_dog_name text;
  v_tz text;
  v_when text;
  v_args jsonb;
begin
  if new.status is not distinct from old.status then
    return new;
  end if;
  if (select auth.uid()) is not distinct from new.user_id then
    return new;
  end if;

  select d.name into v_dog_name from public.dogs d where d.id = new.dog_id;
  select b.timezone into v_tz from public.branches b where b.id = new.branch_id;
  v_when := to_char(new.start_at at time zone coalesce(v_tz, 'Asia/Seoul'), 'FMMM"월" FMDD"일" HH24:MI');
  -- 앱은 start_at을 기기 시간대·현재 언어로 표시한다
  v_args := jsonb_build_object('dog_name', v_dog_name, 'start_at', new.start_at);

  if new.status = 'confirmed' then
    perform private.notify_user(new.user_id, 'booking', '예약이 확정되었어요',
      format('%s · %s 예약이 확정되었습니다.', v_dog_name, v_when),
      jsonb_build_object('booking_id', new.id, 'msg', 'booking_confirmed', 'args', v_args));
  elsif new.status = 'cancelled' then
    perform private.notify_user(new.user_id, 'booking', '예약이 취소되었어요',
      format('%s · %s 예약이 헬스장 사정으로 취소되었습니다.', v_dog_name, v_when),
      jsonb_build_object('booking_id', new.id, 'msg', 'booking_cancelled', 'args', v_args));
  elsif new.status = 'no_show' then
    perform private.notify_user(new.user_id, 'booking', '미방문 처리되었어요',
      format('%s · %s 예약이 미방문으로 처리되었습니다.', v_dog_name, v_when),
      jsonb_build_object('booking_id', new.id, 'msg', 'booking_no_show', 'args', v_args));
  end if;

  return new;
end;
$$;

-- 운동 시작/완료/중단. 운동 완료 알림에 받은 점수를 함께 알려 준다.
-- msg: exercise_started(dog_name) / exercise_completed(dog_name, points — 없으면 0) /
--      exercise_stopped(dog_name, reason — 없으면 null)
create or replace function private.on_exercise_session_status_changed()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_owner uuid;
  v_dog_name text;
  v_points integer;
begin
  if tg_op = 'UPDATE' and new.status is not distinct from old.status then
    return new;
  end if;

  select d.owner_id, d.name into v_owner, v_dog_name from public.dogs d where d.id = new.dog_id;

  if new.status = 'running' and (tg_op = 'INSERT' or old.status = 'ready') then
    perform private.notify_user(v_owner, 'exercise', '운동을 시작했어요',
      format('%s의 트레드밀 운동이 시작되었습니다. 실시간 현황을 확인해 보세요.', v_dog_name),
      jsonb_build_object('session_id', new.id, 'msg', 'exercise_started',
        'args', jsonb_build_object('dog_name', v_dog_name)));
  elsif new.status = 'completed' then
    select coalesce(sum(p.points), 0)::integer into v_points
    from public.exercise_points p
    where p.session_id = new.id and p.voided_at is null;

    perform private.notify_user(v_owner, 'exercise', '운동을 완료했어요',
      case
        when v_points > 0 then
          format('%s의 운동이 끝났어요. %s점을 받았어요! 운동 기록을 확인해 보세요.', v_dog_name, v_points)
        else format('%s의 운동이 끝났어요. 운동 기록을 확인해 보세요.', v_dog_name)
      end,
      jsonb_build_object('session_id', new.id, 'msg', 'exercise_completed',
        'args', jsonb_build_object('dog_name', v_dog_name, 'points', v_points)));
  elsif new.status = 'stopped' then
    perform private.notify_user(v_owner, 'exercise', '운동이 중단되었어요',
      format('%s의 운동이 중단되었습니다. 사유: %s', v_dog_name, coalesce(new.stop_reason, '-')),
      jsonb_build_object('session_id', new.id, 'msg', 'exercise_stopped',
        'args', jsonb_build_object('dog_name', v_dog_name, 'reason', new.stop_reason)));
  end if;

  return new;
end;
$$;

-- 분석 완료/실패 알림. msg: analysis_completed / analysis_failed, args: dog_name
create or replace function private.on_analysis_report_status_changed()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_owner uuid;
  v_dog_name text;
begin
  if tg_op = 'UPDATE' and new.analysis_status is not distinct from old.analysis_status then
    return new;
  end if;

  select d.owner_id, d.name into v_owner, v_dog_name from public.dogs d where d.id = new.dog_id;

  if new.analysis_status = 'completed' then
    perform private.notify_user(v_owner, 'analysis', 'AI 보행 분석 리포트가 도착했어요',
      format('%s의 운동 분석 결과를 확인해 보세요.', v_dog_name),
      jsonb_build_object('report_id', new.id, 'msg', 'analysis_completed',
        'args', jsonb_build_object('dog_name', v_dog_name)));
  elsif new.analysis_status = 'failed' then
    perform private.notify_user(v_owner, 'analysis', 'AI 분석을 완료하지 못했어요',
      format('%s의 영상 분석 중 문제가 발생했습니다. 헬스장에서 확인 후 다시 분석합니다.', v_dog_name),
      jsonb_build_object('report_id', new.id, 'msg', 'analysis_failed',
        'args', jsonb_build_object('dog_name', v_dog_name)));
  end if;

  return new;
end;
$$;

-- 새로 달성한 배지를 주고 알린다. 연속 출석은 최장 기록 기준.
-- msg: badge_earned, args: dog_name, badge_code, badge_name, badge_name_en
create or replace function private.evaluate_dog_badges(p_dog_id uuid, p_session_id uuid default null)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_stats jsonb := private.dog_badge_stats(p_dog_id);
  v_owner uuid;
  v_dog_name text;
  v_badge record;
  v_badge_name text;
  v_badge_name_en text;
begin
  select d.owner_id, d.name into v_owner, v_dog_name from public.dogs d where d.id = p_dog_id;
  if not found then
    return;
  end if;

  for v_badge in
    insert into public.dog_badges (dog_id, badge_code, session_id)
    select p_dog_id, b.code, p_session_id
    from public.badges b
    where b.is_active
      and b.metric is not null
      and coalesce(
            (v_stats ->> case b.metric when 'streak_weeks' then 'best_streak_weeks' else b.metric end)::numeric,
            0
          ) >= b.goal
    on conflict (dog_id, badge_code) do nothing
    returning badge_code
  loop
    select b.name, private.pick_en(b.name, b.name_en) into v_badge_name, v_badge_name_en
    from public.badges b where b.code = v_badge.badge_code;

    perform private.notify_user(
      v_owner, 'ranking', '새 배지를 받았어요',
      format('%s의 「%s」 배지가 도착했어요. 배지함에서 확인해 보세요.', v_dog_name, v_badge_name),
      jsonb_build_object('dog_id', p_dog_id, 'badge_code', v_badge.badge_code, 'msg', 'badge_earned',
        'args', jsonb_build_object('dog_name', v_dog_name, 'badge_code', v_badge.badge_code,
          'badge_name', v_badge_name, 'badge_name_en', v_badge_name_en))
    );
  end loop;
end;
$$;

-- 응원하기: 랭킹에 참여한 다른 반려견을 한 달에 한 번. 응원 수를 돌려준다.
-- msg: cheer_received, args: dog_name, nickname (응원한 사람이 랭킹에 참여하지 않으면 null)
create or replace function public.cheer_dog(p_dog_id uuid)
returns integer
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_month date := private.current_ranking_month();
  v_dog public.dogs%rowtype;
  v_inserted integer;
  v_nickname text;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;

  select * into v_dog from public.dogs d where d.id = p_dog_id and d.deleted_at is null;
  if not found or not private.has_consent(v_dog.owner_id, 'ranking') then
    raise exception 'DOG_NOT_FOUND' using errcode = 'P0002';
  end if;
  if v_dog.owner_id = v_uid then
    raise exception 'CANNOT_CHEER_OWN_DOG' using errcode = '22023';
  end if;

  insert into public.ranking_cheers (period_month, dog_id, user_id)
  values (v_month, p_dog_id, v_uid)
  on conflict do nothing;
  get diagnostics v_inserted = row_count;

  if v_inserted > 0 then
    -- 응원한 사람이 랭킹에 참여 중일 때만 닉네임을 알려 준다
    if private.has_consent(v_uid, 'ranking') then
      select u.nickname into v_nickname from public.users u where u.id = v_uid;
    end if;
    perform private.notify_user(
      v_dog.owner_id, 'ranking', '응원이 도착했어요',
      format('%s %s 응원했어요.',
        coalesce(v_nickname || '님이', '다른 보호자가'), private.josa(v_dog.name, '를', '을')),
      jsonb_build_object('dog_id', p_dog_id, 'msg', 'cheer_received',
        'args', jsonb_build_object('dog_name', v_dog.name, 'nickname', v_nickname))
    );
  end if;

  return (select count(*)::integer from public.ranking_cheers c where c.dog_id = p_dog_id and c.period_month = v_month);
end;
$$;

-- 지난 달의 전체·체급·지점별 1~3위를 기록하고 시상대 배지와 알림을 준다. 이미 마감한 달은 건너뛴다.
-- msg: monthly_award, args: dog_name, month(1~12), awards [{scope, label, label_en, rank}]
--      (awards 순서는 한국어 본문의 수상 목록과 같다: 전체 → 지점 → 체급, 순위)
create or replace function private.close_ranking_month(p_month date)
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_month date := private.month_start(p_month);
  v_scope record;
  v_winner record;
  v_rows integer;
  v_total integer := 0;
begin
  if v_month >= private.current_ranking_month() then
    raise exception 'RANKING_MONTH_NOT_FINISHED' using errcode = '22023';
  end if;

  insert into public.ranking_closings (period_month) values (v_month) on conflict do nothing;
  if not found then
    return 0;
  end if;

  for v_scope in
    select 'all'::text as scope, 'all'::text as scope_key
    union all
    select 'size', s.size_class from unnest(array['small', 'medium', 'large']) as s(size_class)
    union all
    select 'branch', b.id::text
    from public.branches b
    where exists (
      select 1 from public.exercise_points p where p.branch_id = b.id and p.period_month = v_month
    )
  loop
    insert into public.monthly_awards (period_month, scope, scope_key, rank, dog_id, owner_id, points)
    select v_month, v_scope.scope, v_scope.scope_key, st.place, st.dog_id, d.owner_id, st.points
    from private.ranking_standings(v_month, v_scope.scope, v_scope.scope_key, null) st
    join public.dogs d on d.id = st.dog_id
    where st.place <= 3;
    get diagnostics v_rows = row_count;
    v_total := v_total + v_rows;
  end loop;

  update public.ranking_closings set award_count = v_total where period_month = v_month;

  for v_winner in
    select
      a.dog_id,
      a.owner_id,
      d.name as dog_name,
      string_agg(
        private.ranking_scope_label(a.scope, a.scope_key) || ' ' || a.rank || '위', ' · '
        order by case a.scope when 'all' then 0 when 'branch' then 1 else 2 end, a.rank
      ) as summary,
      jsonb_agg(
        jsonb_build_object(
          'scope', a.scope,
          'label', private.ranking_scope_label(a.scope, a.scope_key),
          'label_en', private.ranking_scope_label_en(a.scope, a.scope_key),
          'rank', a.rank
        )
        order by case a.scope when 'all' then 0 when 'branch' then 1 else 2 end, a.rank
      ) as awards
    from public.monthly_awards a
    join public.dogs d on d.id = a.dog_id
    where a.period_month = v_month
    group by a.dog_id, a.owner_id, d.name
  loop
    insert into public.dog_badges (dog_id, badge_code) values (v_winner.dog_id, 'podium')
    on conflict do nothing;
    perform private.notify_user(
      v_winner.owner_id, 'ranking',
      format('%s월 랭킹 시상대에 올랐어요', extract(month from v_month)::integer),
      format('%s %s월 랭킹 %s에 올랐어요. 명예의 전당에서 확인해 보세요.',
        private.josa(v_winner.dog_name, '가', '이'), extract(month from v_month)::integer, v_winner.summary),
      jsonb_build_object('period_month', v_month, 'dog_id', v_winner.dog_id, 'msg', 'monthly_award',
        'args', jsonb_build_object('dog_name', v_winner.dog_name, 'month', extract(month from v_month)::integer,
          'awards', v_winner.awards))
    );
  end loop;

  return v_total;
end;
$$;

-- ---------------------------------------------------------------------
-- 5. 가입 닉네임: 앱이 사용자 메타데이터에 locale('ko' / 'en')을 보낸다
-- ---------------------------------------------------------------------

-- "SwiftPaw042" 같은 영어 기본 닉네임 (형용사 + 명사 + 숫자 3자리, 최대 12자)
create or replace function private.generate_nickname_en()
returns text
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_adjectives text[] := array[
    'Brave', 'Swift', 'Sunny', 'Happy', 'Jolly', 'Lucky', 'Zippy', 'Perky', 'Chill', 'Merry'
  ];
  v_nouns text[] := array['Paw', 'Tail', 'Pup', 'Dog', 'Nose', 'Run', 'Step', 'Wag'];
  v_candidate text;
begin
  for i in 1..50 loop
    v_candidate := v_adjectives[1 + floor(random() * array_length(v_adjectives, 1))::integer]
      || v_nouns[1 + floor(random() * array_length(v_nouns, 1))::integer]
      || lpad(floor(random() * 1000)::integer::text, 3, '0');
    if not exists (select 1 from public.users u where lower(u.nickname) = lower(v_candidate)) then
      return v_candidate;
    end if;
  end loop;
  return 'Owner' || substr(replace(gen_random_uuid()::text, '-', ''), 1, 7);
end;
$$;

-- 회원가입: 기본 닉네임 생성(locale이 en이면 영어, 아니면 한국어), 랭킹 참여 동의 저장
-- signUp(data: {name, phone, locale, consents: [{type, version, granted}]})
create or replace function private.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_meta jsonb := coalesce(new.raw_user_meta_data, '{}'::jsonb);
  v_consents jsonb := v_meta -> 'consents';
  v_item jsonb;
begin
  insert into public.users (id, name, phone, nickname)
  values (
    new.id,
    coalesce(
      nullif(trim(v_meta ->> 'name'), ''),
      split_part(coalesce(new.email, ''), '@', 1)
    ),
    nullif(trim(v_meta ->> 'phone'), ''),
    -- 'en', 'en-US', 'en_GB'처럼 언어가 영어면 영어 닉네임
    case
      when lower(coalesce(v_meta ->> 'locale', '')) ~ '^en([-_]|$)' then private.generate_nickname_en()
      else private.generate_nickname()
    end
  );

  if jsonb_typeof(v_consents) = 'array' then
    for v_item in select value from jsonb_array_elements(v_consents) loop
      if (v_item ->> 'type') in ('terms', 'privacy', 'video_recording', 'ai_training', 'marketing', 'ranking') then
        insert into public.data_consents (user_id, consent_type, consent_version, granted)
        values (
          new.id,
          v_item ->> 'type',
          coalesce(nullif(v_item ->> 'version', ''), '1.0'),
          coalesce(v_item -> 'granted' = 'true'::jsonb, false)
        );
      end if;
    end loop;
  end if;

  return new;
end;
$$;

-- ---------------------------------------------------------------------
-- 6. 권한
-- 다시 만든 RPC는 20261116000100과 같은 권한을 다시 준다 (함수 주석은 원래 없었다).
-- ---------------------------------------------------------------------
revoke execute on function public.get_leaderboard(date, text, text, integer) from public, anon;
revoke execute on function public.get_branch_battle(date) from public, anon;
revoke execute on function public.get_hall_of_fame(integer) from public, anon;
grant execute on function public.get_leaderboard(date, text, text, integer) to authenticated;
grant execute on function public.get_branch_battle(date) to authenticated;
grant execute on function public.get_hall_of_fame(integer) to authenticated;

revoke all on all functions in schema private from public, anon;
grant execute on all functions in schema private to authenticated, service_role;
