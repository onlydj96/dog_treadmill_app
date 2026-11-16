-- =====================================================================
-- 반려견 정보 구조화 (AI 운동 강도 산정·금기 규칙·추천 입력)
--  1. 견종 카탈로그: 체구(소형/중형/대형)·단두종 여부. 믹스견·목록 밖 견종은 보호자가 직접 입력
--  2. 나이: 생년월일을 모르면 추정 나이로 입력 (birth_date_estimated)
--  3. 체중 기록: dogs.weight_kg가 바뀔 때마다 dog_weight_logs에 쌓는다
--  4. 중성화: 미응답(null)과 "안 했음"(false)을 구분
--  5. 질병·주의사항: 질환 카탈로그 코드 다중 선택 (운동 금기/제한 규칙과 연결할 키)
--  6. AI 서버용 조회 함수: 반려견 정보 + 체중 기록 + 과거 운동 이력 (service_role 전용)
--
-- 과거 운동 이력은 따로 입력받지 않는다. 트레드밀이 start/update/finish_exercise_session으로
-- exercise_sessions에 남긴 기록을 get_dog_ai_context()가 읽어 간다.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. 견종 카탈로그
-- ---------------------------------------------------------------------
create table public.breeds (
  id text primary key check (id ~ '^[a-z][a-z0-9_]*$'),
  name text not null unique check (char_length(name) between 1 and 50),
  -- 성견 평균 체중 기준 참고값: small < 10kg, medium 10~25kg, large ≥ 25kg
  size_class text not null check (size_class in ('small', 'medium', 'large')),
  -- 주둥이가 짧은 견종. 호흡기 부담이 커서 운동 강도·환경 제한 규칙에 쓴다
  is_brachycephalic boolean not null default false,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

insert into public.breeds (id, name, size_class, is_brachycephalic, sort_order) values
  ('maltese',                       '말티즈',                     'small',  false,  10),
  ('toy_poodle',                    '토이 푸들',                  'small',  false,  20),
  ('miniature_poodle',              '미니어처 푸들',              'small',  false,  30),
  ('pomeranian',                    '포메라니안',                 'small',  false,  40),
  ('shih_tzu',                      '시츄',                       'small',  true,   50),
  ('bichon_frise',                  '비숑 프리제',                'small',  false,  60),
  ('chihuahua',                     '치와와',                     'small',  false,  70),
  ('yorkshire_terrier',             '요크셔테리어',               'small',  false,  80),
  ('dachshund',                     '닥스훈트',                   'small',  false,  90),
  ('miniature_schnauzer',           '미니어처 슈나우저',          'small',  false, 100),
  ('pug',                           '퍼그',                       'small',  true,  110),
  ('japanese_spitz',                '스피츠',                     'small',  false, 120),
  ('papillon',                      '빠삐용',                     'small',  false, 130),
  ('italian_greyhound',             '이탈리안 그레이하운드',      'small',  false, 140),
  ('jack_russell_terrier',          '잭 러셀 테리어',             'small',  false, 150),
  ('miniature_pinscher',            '미니어처 핀셔',              'small',  false, 160),
  ('pekingese',                     '페키니즈',                   'small',  true,  170),
  ('boston_terrier',                '보스턴 테리어',              'small',  true,  180),
  ('cavalier_king_charles_spaniel', '카발리에 킹 찰스 스패니얼',  'small',  true,  190),
  ('west_highland_white_terrier',   '웨스트 하이랜드 화이트 테리어', 'small', false, 200),
  ('shetland_sheepdog',             '셔틀랜드 쉽독',              'small',  false, 210),
  ('welsh_corgi',                   '웰시코기',                   'medium', false, 300),
  ('jindo',                         '진돗개',                     'medium', false, 310),
  ('shiba_inu',                     '시바견',                     'medium', false, 320),
  ('beagle',                        '비글',                       'medium', false, 330),
  ('border_collie',                 '보더콜리',                   'medium', false, 340),
  ('french_bulldog',                '프렌치 불독',                'medium', true,  350),
  ('english_bulldog',               '잉글리시 불독',              'medium', true,  360),
  ('cocker_spaniel',                '코카 스파니엘',              'medium', false, 370),
  ('siberian_husky',                '시베리안 허스키',            'medium', false, 380),
  ('standard_poodle',               '스탠다드 푸들',              'large',  false, 500),
  ('golden_retriever',              '골든 리트리버',              'large',  false, 510),
  ('labrador_retriever',            '래브라도 리트리버',          'large',  false, 520),
  ('samoyed',                       '사모예드',                   'large',  false, 530),
  ('alaskan_malamute',              '알래스칸 말라뮤트',          'large',  false, 540),
  ('german_shepherd',               '저먼 셰퍼드',                'large',  false, 550),
  ('doberman',                      '도베르만',                   'large',  false, 560),
  ('boxer',                         '복서',                       'large',  true,  570),
  ('bernese_mountain_dog',          '버니즈 마운틴 독',           'large',  false, 580),
  ('pungsan',                       '풍산개',                     'large',  false, 590);

-- ---------------------------------------------------------------------
-- 2. dogs: 견종 구조화 · 추정 나이 · 중성화 미응답
-- ---------------------------------------------------------------------
alter table public.dogs
  add column breed_id text references public.breeds (id) on update cascade,
  add column is_mixed boolean not null default false,
  add column size_class text check (size_class in ('small', 'medium', 'large')),
  add column is_brachycephalic boolean,
  add column birth_date_estimated boolean not null default false,
  add constraint dogs_estimated_birth_date_check
    check (not birth_date_estimated or birth_date is not null);

comment on column public.dogs.breed is
  '표시용 견종명. breed_id가 있으면 카탈로그 이름, 없으면 보호자 입력(믹스견은 섞인 견종)';
comment on column public.dogs.breed_id is '견종 카탈로그. 믹스견·목록 밖 견종은 null';
comment on column public.dogs.size_class is
  '체구. breed_id가 있으면 카탈로그 값으로 고정, 없으면 보호자가 선택';
comment on column public.dogs.is_brachycephalic is
  '단두종 여부. breed_id가 있으면 카탈로그 값으로 고정, 없으면 보호자가 선택';
comment on column public.dogs.birth_date_estimated is
  'true면 birth_date는 보호자가 입력한 추정 나이로 계산한 날짜';
comment on column public.dogs.neutered is '중성화 여부. null = 미응답';

-- 카탈로그 견종을 고르면 이름·체구·단두종을 카탈로그 값으로 맞춘다
create or replace function private.apply_breed_catalog()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_breed public.breeds%rowtype;
begin
  if new.breed_id is not null then
    select * into v_breed from public.breeds b where b.id = new.breed_id;
    if found then
      new.breed := v_breed.name;
      new.size_class := v_breed.size_class;
      new.is_brachycephalic := v_breed.is_brachycephalic;
      new.is_mixed := false;
    end if;
  end if;
  return new;
end;
$$;

create trigger dogs_apply_breed_catalog
  before insert or update of breed_id, breed, size_class, is_brachycephalic, is_mixed
  on public.dogs
  for each row execute function private.apply_breed_catalog();

-- ---------------------------------------------------------------------
-- 3. 체중 기록
-- ---------------------------------------------------------------------
create table public.dog_weight_logs (
  id uuid primary key default gen_random_uuid(),
  dog_id uuid not null references public.dogs (id) on delete cascade,
  weight_kg numeric(5, 2) not null check (weight_kg > 0 and weight_kg < 150),
  -- owner: 보호자 앱 입력, admin: 운영자 입력, device: 매장 체중계 등 장비가 직접 기록
  source text not null default 'owner' check (source in ('owner', 'admin', 'device')),
  measured_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
create index dog_weight_logs_dog_measured_idx on public.dog_weight_logs (dog_id, measured_at desc);

-- 기존 체중을 첫 기록으로 옮긴다 (아래 dogs 갱신보다 먼저 해야 updated_at이 보존된다)
insert into public.dog_weight_logs (dog_id, weight_kg, source, measured_at)
select d.id, d.weight_kg, 'owner', d.updated_at
from public.dogs d
where d.weight_kg is not null;

create or replace function private.log_dog_weight()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.weight_kg is not null
     and (tg_op = 'INSERT' or new.weight_kg is distinct from old.weight_kg) then
    insert into public.dog_weight_logs (dog_id, weight_kg, source)
    values (
      new.id,
      new.weight_kg,
      case when (select auth.uid()) = new.owner_id then 'owner' else 'admin' end
    );
  end if;
  return null;
end;
$$;

create trigger dogs_log_weight
  after insert or update of weight_kg on public.dogs
  for each row execute function private.log_dog_weight();

-- ---------------------------------------------------------------------
-- 기존 반려견 데이터 정리
-- ---------------------------------------------------------------------
-- 자유 입력 견종을 이름이 같은 카탈로그 견종에 연결 (트리거가 체구·단두종을 채운다)
update public.dogs d
set breed_id = b.id
from public.breeds b
where d.breed_id is null and d.breed = b.name;

-- 이전 자동완성 목록의 '믹스견'·'말티푸'는 믹스견으로 옮긴다
update public.dogs
set is_mixed = true,
    breed = case when breed = '믹스견' then null else breed end
where breed_id is null and (breed like '%믹스%' or breed = '말티푸');

-- 중성화는 체크박스 기본값(false)과 "안 했음"을 구분할 수 없었으므로 미응답으로 돌린다
alter table public.dogs
  alter column neutered drop default,
  alter column neutered drop not null;
update public.dogs set neutered = null where neutered = false;

-- ---------------------------------------------------------------------
-- 5. 질병·주의사항 카탈로그
-- ---------------------------------------------------------------------
create table public.health_conditions (
  -- 운동 금기/제한 규칙이 참조하는 키. 바꾸지 말고 is_active로 내린다
  code text primary key check (code ~ '^[a-z][a-z0-9_]*$'),
  name text not null unique check (char_length(name) between 1 and 30),
  description text check (char_length(description) <= 200),
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

insert into public.health_conditions (code, name, description, sort_order) values
  ('joint_disease',       '관절질환',          '슬개골 탈구, 고관절 이형성증, 관절염, 십자인대 손상 등', 10),
  ('spinal_disease',      '척추·디스크 질환',  '추간판 탈출증(디스크) 등',                                20),
  ('heart_disease',       '심장질환',          '이첨판 폐쇄부전증, 심장사상충 등',                        30),
  ('obesity',             '비만',              '수의사에게 비만·과체중 진단을 받은 경우',                 40),
  ('respiratory_disease', '호흡기질환',        '기관 허탈, 단두종 기도 증후군 등',                        50),
  ('endocrine_disease',   '내분비질환',        '당뇨, 쿠싱 증후군, 갑상선 기능 저하증 등',                60),
  ('kidney_disease',      '신장질환',          '만성 신부전 등',                                          70),
  ('seizure_disorder',    '뇌전증·발작',       '발작 이력이 있는 경우',                                   80),
  ('paw_skin_problem',    '발바닥·피부 질환',  '패드 상처, 지간염 등 발에 닿는 부위의 문제',              90),
  ('recovering',          '수술·부상 회복 중', '최근 수술을 받았거나 부상에서 회복 중인 경우',           100);

alter table public.dog_health_profiles add column condition_codes text[];
comment on column public.dog_health_profiles.condition_codes is
  'health_conditions.code 다중 선택. null = 미응답, 빈 배열 = 해당 없음';

-- 카탈로그에 없는 코드를 막고, 중복 제거·정렬해 저장한다
create or replace function private.normalize_condition_codes()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.condition_codes is null then
    return new;
  end if;

  perform 1
  from unnest(new.condition_codes) as c(code)
  where c.code is null
     or not exists (select 1 from public.health_conditions h where h.code = c.code);
  if found then
    raise exception 'UNKNOWN_CONDITION_CODE' using errcode = '23503';
  end if;

  new.condition_codes := array(
    select distinct c.code from unnest(new.condition_codes) as c(code) order by c.code
  );
  return new;
end;
$$;

create trigger dog_health_profiles_normalize_conditions
  before insert or update of condition_codes on public.dog_health_profiles
  for each row execute function private.normalize_condition_codes();

-- ---------------------------------------------------------------------
-- 나이·생애 단계
-- 생애 단계 경계는 체구별 참고값이다. 운동 규칙에 쓰기 전에 수의사 검토가 필요하다.
--   성장기(puppy): small < 10개월, medium < 12개월, large < 18개월
--   노령견(senior): small ≥ 10살, medium ≥ 8살, large ≥ 7살
--   체구를 모르면 medium 기준
-- ---------------------------------------------------------------------
create or replace function private.dog_age_months(p_birth_date date, p_on date default current_date)
returns integer
language sql
immutable
set search_path = ''
as $$
  select case
    when p_birth_date is null then null
    -- timestamp(시간대 없음)로 계산해 세션 시간대와 무관하게 한다
    else (extract(year from age(p_on::timestamp, p_birth_date::timestamp)) * 12
          + extract(month from age(p_on::timestamp, p_birth_date::timestamp)))::integer
  end;
$$;

create or replace function private.dog_life_stage(
  p_birth_date date,
  p_size_class text,
  p_on date default current_date
)
returns text
language sql
immutable
set search_path = ''
as $$
  select case
    when a.months is null then null
    when a.months < case p_size_class when 'small' then 10 when 'large' then 18 else 12 end
      then 'puppy'
    when a.months >= case p_size_class when 'small' then 120 when 'large' then 84 else 96 end
      then 'senior'
    else 'adult'
  end
  from (select private.dog_age_months(p_birth_date, p_on) as months) a;
$$;

-- ---------------------------------------------------------------------
-- 6. AI 서버용 반려견 컨텍스트 (service_role 전용, 앱에서는 호출할 수 없다)
-- 반려견이 없으면 null. 운동 이력은 끝난 세션(completed/stopped)만 최신순으로 p_session_limit건.
-- ---------------------------------------------------------------------
create or replace function public.get_dog_ai_context(p_dog_id uuid, p_session_limit integer default 100)
returns jsonb
language sql
stable
set search_path = ''
as $$
  select jsonb_build_object(
    'dog', jsonb_build_object(
      'id', d.id,
      'breed', d.breed,
      'breed_id', d.breed_id,
      'is_mixed', d.is_mixed,
      'size_class', d.size_class,
      'is_brachycephalic', d.is_brachycephalic,
      'sex', d.sex,
      'neutered', d.neutered,
      'birth_date', d.birth_date,
      'birth_date_estimated', d.birth_date_estimated,
      'age_months', private.dog_age_months(d.birth_date),
      'life_stage', private.dog_life_stage(d.birth_date, d.size_class),
      'weight_kg', d.weight_kg,
      'is_deleted', d.deleted_at is not null
    ),
    'health', jsonb_build_object(
      'condition_codes', to_jsonb(hp.condition_codes),
      'diseases', coalesce(hp.diseases, '[]'::jsonb),
      'surgeries', coalesce(hp.surgeries, '[]'::jsonb),
      'medications', coalesce(hp.medications, '[]'::jsonb),
      'exercise_restrictions', coalesce(hp.exercise_restrictions, '[]'::jsonb),
      'veterinary_notes', hp.veterinary_notes
    ),
    'weight_history', (
      select coalesce(
        jsonb_agg(
          jsonb_build_object('weight_kg', w.weight_kg, 'measured_at', w.measured_at, 'source', w.source)
          order by w.measured_at
        ),
        '[]'::jsonb
      )
      from public.dog_weight_logs w
      where w.dog_id = d.id
    ),
    'exercise_summary', (
      select jsonb_build_object(
        'session_count', count(*),
        'completed_count', count(*) filter (where s.status = 'completed'),
        'stopped_count', count(*) filter (where s.status = 'stopped'),
        'total_duration_seconds', coalesce(sum(s.duration_seconds), 0),
        'total_distance_meters', coalesce(sum(s.distance_meters), 0),
        'first_session_at', min(s.started_at),
        'last_session_at', max(s.started_at)
      )
      from public.exercise_sessions s
      where s.dog_id = d.id and s.status in ('completed', 'stopped')
    ),
    'exercise_history', (
      select coalesce(jsonb_agg(h.item order by h.started_at desc), '[]'::jsonb)
      from (
        select
          s.started_at,
          jsonb_build_object(
            'session_id', s.id,
            'status', s.status,
            'started_at', s.started_at,
            'ended_at', s.ended_at,
            'duration_seconds', s.duration_seconds,
            'target_duration_seconds', s.target_duration_seconds,
            'distance_meters', s.distance_meters,
            'average_speed_kmh', s.average_speed,
            'max_speed_kmh', s.max_speed,
            'stop_reason', s.stop_reason,
            'program', case when p.id is null then null else jsonb_build_object(
              'id', p.id,
              'name', p.name,
              'intensity', p.intensity,
              'duration_minutes', p.duration_minutes,
              'target_speed_kmh', p.target_speed_kmh
            ) end
          ) as item
        from public.exercise_sessions s
        left join public.bookings b on b.id = s.booking_id
        left join public.exercise_programs p on p.id = b.program_id
        where s.dog_id = d.id and s.status in ('completed', 'stopped')
        order by s.started_at desc nulls last
        limit least(greatest(coalesce(p_session_limit, 100), 1), 1000)
      ) h
    )
  )
  from public.dogs d
  left join public.dog_health_profiles hp on hp.dog_id = d.id
  where d.id = p_dog_id;
$$;

-- ---------------------------------------------------------------------
-- 권한
-- ---------------------------------------------------------------------
alter table public.breeds enable row level security;
alter table public.health_conditions enable row level security;
alter table public.dog_weight_logs enable row level security;
revoke all on public.breeds, public.health_conditions, public.dog_weight_logs from anon;

create policy breeds_select on public.breeds
  for select to authenticated
  using (is_active or (select private.is_admin()));
create policy breeds_admin_write on public.breeds
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

create policy health_conditions_select on public.health_conditions
  for select to authenticated
  using (is_active or (select private.is_admin()));
create policy health_conditions_admin_write on public.health_conditions
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

-- 체중 기록은 dogs 트리거가 쓴다. 보호자는 조회만, 관리자는 직접 기록·정정 가능
create policy dog_weight_logs_select_owner_or_admin on public.dog_weight_logs
  for select to authenticated
  using ((select private.owns_dog(dog_id)) or (select private.is_admin()));
create policy dog_weight_logs_admin_write on public.dog_weight_logs
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

revoke all on function private.apply_breed_catalog() from public, anon;
revoke all on function private.log_dog_weight() from public, anon;
revoke all on function private.normalize_condition_codes() from public, anon;
revoke all on function private.dog_age_months(date, date) from public, anon;
revoke all on function private.dog_life_stage(date, text, date) from public, anon;
grant execute on function private.dog_age_months(date, date) to authenticated, service_role;
grant execute on function private.dog_life_stage(date, text, date) to authenticated, service_role;

revoke execute on function public.get_dog_ai_context(uuid, integer) from public, anon, authenticated;
grant execute on function public.get_dog_ai_context(uuid, integer) to service_role;
