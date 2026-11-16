-- =====================================================================
-- 랭킹·배지 (게이미피케이션) — 규격은 docs/ranking.md
--  1. 랭킹 참여 동의(data_consents 'ranking'), 랭킹 알림(notifications 'ranking')
--  2. 닉네임: 이메일·실명 대신 랭킹에 보이는 이름. 가입 시 자동 생성, 30일에 한 번 변경
--  3. 점수 원장(exercise_points): 운동 세션이 끝나면 트리거가 적립한다 (보호자는 쓸 수 없다)
--     - 출석 10 + 달성 0~10 + 거리 100m당 1(최대 20), 5분 미만은 0점, 반려견당 하루 1회만
--     - 한 주(월~일)에 2회 이상 점수를 받으면 주간 보너스 20
--     - 중단된 운동도 감점하지 않는다 (비상정지를 망설이지 않게)
--  4. 배지(badges, dog_badges): 누적 운동 지표가 목표에 닿으면 자동 지급
--  5. 월간 랭킹 RPC: 전체 / 지점 / 체급. 랭킹 참여에 동의한 보호자의 반려견만 노출하고
--     닉네임·반려견 이름·견종·사진(공개 설정 시)만 돌려준다 (실명·이메일·연락처 없음)
--  6. 월간 마감(pg_cron): 지난달 1~3위를 명예의 전당(monthly_awards)에 기록하고 알림
--  7. 응원(ranking_cheers): 다른 반려견을 한 달에 한 번 응원
--  8. 랭킹 사진 공개: 동의 + 사진 공개 설정인 반려견의 현재 프로필 사진만 다른 회원이 읽을 수 있다
-- 기간은 모두 한국 시간(Asia/Seoul) 기준이다.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. 동의·알림 유형 확장
-- ---------------------------------------------------------------------
alter table public.data_consents
  drop constraint data_consents_consent_type_check,
  add constraint data_consents_consent_type_check check (
    consent_type in ('terms', 'privacy', 'video_recording', 'ai_training', 'marketing', 'ranking')
  );

alter table public.notifications
  drop constraint notifications_type_check,
  add constraint notifications_type_check check (
    type in ('general', 'booking', 'exercise', 'analysis', 'notice', 'ranking')
  );

alter table public.users
  alter column notification_prefs set default
    '{"booking": true, "exercise": true, "analysis": true, "ranking": true, "marketing": false}'::jsonb;

-- 알림 설정에 ranking을 추가한다 (기존 사용자는 키가 없으면 켜진 것으로 본다)
create or replace function private.notify_user(
  p_user_id uuid,
  p_type text,
  p_title text,
  p_body text,
  p_data jsonb default '{}'::jsonb
)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_prefs jsonb;
begin
  if p_user_id is null then
    return;
  end if;

  select u.notification_prefs into v_prefs from public.users u where u.id = p_user_id;
  if not found then
    return;
  end if;

  if p_type in ('booking', 'exercise', 'analysis', 'ranking', 'marketing')
     and coalesce(v_prefs -> p_type, 'true'::jsonb) = 'false'::jsonb then
    return;
  end if;

  insert into public.notifications (user_id, type, title, body, data)
  values (p_user_id, p_type, p_title, coalesce(p_body, ''), coalesce(p_data, '{}'::jsonb));
end;
$$;

-- ---------------------------------------------------------------------
-- 공통 헬퍼: 한국 시간 기준 날짜·주·월, 표시 문구
-- ---------------------------------------------------------------------
create or replace function private.kst_date(p_at timestamptz)
returns date
language sql
stable
set search_path = ''
as $$ select (p_at at time zone 'Asia/Seoul')::date $$;

create or replace function private.month_start(p_date date)
returns date
language sql
immutable
set search_path = ''
as $$ select date_trunc('month', p_date::timestamp)::date $$;

-- 월요일 시작
create or replace function private.week_start(p_date date)
returns date
language sql
immutable
set search_path = ''
as $$ select date_trunc('week', p_date::timestamp)::date $$;

create or replace function private.current_ranking_month()
returns date
language sql
stable
set search_path = ''
as $$ select private.month_start(private.kst_date(now())) $$;

create or replace function private.size_class_label(p_size_class text)
returns text
language sql
immutable
set search_path = ''
as $$
  select case p_size_class
    when 'small' then '소형견'
    when 'medium' then '중형견'
    when 'large' then '대형견'
  end
$$;

-- 앱의 Dog.breedLabel과 같은 규칙: "시츄", "믹스견(말티푸)", "믹스견"
create or replace function private.dog_breed_label(p_breed text, p_is_mixed boolean)
returns text
language sql
immutable
set search_path = ''
as $$
  select case
    when coalesce(p_is_mixed, false) then
      case when nullif(trim(p_breed), '') is null then '믹스견' else '믹스견(' || trim(p_breed) || ')' end
    else nullif(trim(p_breed), '')
  end
$$;

-- 받침 유무에 따라 조사를 붙인다 (앱의 josa와 같은 규칙). 예) josa('콩이', '를', '을') → '콩이를'
create or replace function private.josa(p_word text, p_without_batchim text, p_with_batchim text)
returns text
language sql
immutable
set search_path = ''
as $$
  select coalesce(p_word, '') || case
    when coalesce(p_word, '') = '' then ''
    when ascii(right(p_word, 1)) between 44032 and 55203
         and (ascii(right(p_word, 1)) - 44032) % 28 <> 0 then p_with_batchim
    else p_without_batchim
  end
$$;

-- 랭킹 범위 표시 이름: 전체 / 지점명 / 소형견·중형견·대형견
create or replace function private.ranking_scope_label(p_scope text, p_scope_key text)
returns text
language sql
stable
security definer
set search_path = ''
as $$
  select case p_scope
    when 'all' then '전체'
    when 'size' then private.size_class_label(p_scope_key)
    when 'branch' then (select b.name from public.branches b where b.id::text = p_scope_key)
  end
$$;

create or replace function private.assert_ranking_scope(p_scope text, p_scope_key text)
returns void
language plpgsql
stable
security definer
set search_path = ''
as $$
begin
  if p_scope = 'all' then
    return;
  end if;
  if p_scope = 'size' and p_scope_key in ('small', 'medium', 'large') then
    return;
  end if;
  if p_scope = 'branch'
     and exists (select 1 from public.branches b where b.id::text = lower(p_scope_key)) then
    return;
  end if;
  raise exception 'INVALID_RANKING_SCOPE' using errcode = '22023';
end;
$$;

-- ---------------------------------------------------------------------
-- 2. 닉네임 · 랭킹 사진 공개 설정
-- ---------------------------------------------------------------------
alter table public.users
  add column nickname text,
  -- null이면 가입 시 자동으로 만든 닉네임 (바로 바꿀 수 있다)
  add column nickname_updated_at timestamptz,
  -- 랭킹에 반려견 프로필 사진을 보여줄지 (랭킹 참여 동의와 별개로 끌 수 있다)
  add column ranking_show_photo boolean not null default true,
  add constraint users_nickname_format check (
    char_length(nickname) between 2 and 12 and nickname ~ '^[가-힣A-Za-z0-9_]+$'
  );

comment on column public.users.nickname is
  '랭킹·응원에 보이는 이름. 이메일·실명 대신 쓴다. 대소문자 구분 없이 고유';
comment on column public.users.nickname_updated_at is
  '보호자가 닉네임을 마지막으로 바꾼 시각. null이면 자동 생성 닉네임';

create unique index users_nickname_key on public.users (lower(nickname));

-- "씩씩한발바닥0427" 같은 기본 닉네임
create or replace function private.generate_nickname()
returns text
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_adjectives text[] := array[
    '씩씩한', '날쌘', '다정한', '용감한', '부지런한', '신나는', '튼튼한', '반짝이는', '느긋한', '명랑한'
  ];
  v_nouns text[] := array['발바닥', '꼬리', '산책러', '러너', '댕댕이', '멍멍이', '발도장', '콧등'];
  v_candidate text;
begin
  for i in 1..50 loop
    v_candidate := v_adjectives[1 + floor(random() * array_length(v_adjectives, 1))::integer]
      || v_nouns[1 + floor(random() * array_length(v_nouns, 1))::integer]
      || lpad(floor(random() * 10000)::integer::text, 4, '0');
    if not exists (select 1 from public.users u where lower(u.nickname) = lower(v_candidate)) then
      return v_candidate;
    end if;
  end loop;
  return '보호자' || substr(replace(gen_random_uuid()::text, '-', ''), 1, 8);
end;
$$;

-- 기존 회원에게 기본 닉네임을 준다
do $$
declare
  v_user_id uuid;
begin
  for v_user_id in select u.id from public.users u where u.nickname is null loop
    update public.users set nickname = private.generate_nickname() where id = v_user_id;
  end loop;
end;
$$;

alter table public.users alter column nickname set not null;

-- 쓸 수 없는 닉네임 (사칭·욕설). 영문은 대소문자를 구분하지 않는다.
create or replace function private.is_forbidden_nickname(p_nickname text)
returns boolean
language sql
immutable
set search_path = ''
as $$
  select exists (
    select 1
    from unnest(array[
      'pawfit', '포핏', '파우핏', '관리자', '운영자', '운영팀', '매니저', '공식', 'admin', 'official',
      '시발', '씨발', '병신', '개새', '좆', '존나', '느금', '니미', '섹스', 'fuck', 'shit', 'sex'
    ]) as w(word)
    where position(w.word in lower(p_nickname)) > 0
  );
$$;

-- 닉네임 변경 주기
create or replace function private.nickname_change_interval()
returns interval
language sql
immutable
set search_path = ''
as $$ select interval '30 days' $$;

create or replace function public.set_nickname(p_nickname text)
returns text
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_nickname text := trim(coalesce(p_nickname, ''));
  v_user public.users%rowtype;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;
  if char_length(v_nickname) not between 2 and 12 or v_nickname !~ '^[가-힣A-Za-z0-9_]+$' then
    raise exception 'NICKNAME_INVALID' using errcode = '22023';
  end if;
  if private.is_forbidden_nickname(v_nickname) then
    raise exception 'NICKNAME_FORBIDDEN' using errcode = '22023';
  end if;

  select * into v_user from public.users u where u.id = v_uid for update;
  if not found then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;
  if v_user.nickname = v_nickname then
    return v_nickname;
  end if;
  if v_user.nickname_updated_at is not null
     and v_user.nickname_updated_at > now() - private.nickname_change_interval() then
    raise exception 'NICKNAME_COOLDOWN' using errcode = '22023';
  end if;

  begin
    update public.users
    set nickname = v_nickname, nickname_updated_at = now()
    where id = v_uid;
  exception when unique_violation then
    raise exception 'NICKNAME_TAKEN' using errcode = '23505';
  end;
  return v_nickname;
end;
$$;

-- 보호자는 랭킹 사진 공개 설정을 직접 바꿀 수 있다 (닉네임은 set_nickname으로만)
grant update (ranking_show_photo) on public.users to authenticated;

-- 회원가입: 기본 닉네임 생성, 랭킹 참여 동의 저장
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
    private.generate_nickname()
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
-- 3. 점수 원장
-- ---------------------------------------------------------------------
create table public.exercise_points (
  id uuid primary key default gen_random_uuid(),
  dog_id uuid not null references public.dogs (id) on delete cascade,
  owner_id uuid not null references public.users (id) on delete cascade,
  -- session: 운동 1회 점수 / weekly_bonus: 그 주 두 번째 운동(session_id)으로 받은 주간 보너스
  session_id uuid not null references public.exercise_sessions (id) on delete cascade,
  kind text not null check (kind in ('session', 'weekly_bonus')),
  branch_id uuid references public.branches (id) on delete set null,
  exercise_date date not null,
  period_month date not null,
  week_start date not null,
  -- 5분 이상 운동했는지 (배지·운동 횟수 집계 대상)
  qualified boolean not null default false,
  attendance_points integer not null default 0 check (attendance_points >= 0),
  achievement_points integer not null default 0 check (achievement_points >= 0),
  distance_points integer not null default 0 check (distance_points >= 0),
  bonus_points integer not null default 0 check (bonus_points >= 0),
  points integer generated always as (
    attendance_points + achievement_points + distance_points + bonus_points
  ) stored,
  distance_meters numeric(8, 1) not null default 0 check (distance_meters >= 0),
  duration_seconds integer not null default 0 check (duration_seconds >= 0),
  -- 0점인 이유: too_short(5분 미만), daily_limit(그날 이미 점수를 받음)
  note text check (note in ('too_short', 'daily_limit')),
  scoring_version smallint not null default 1,
  earned_at timestamptz not null default now(),
  -- 운영자가 무효 처리하면 랭킹·배지 집계에서 빠진다
  voided_at timestamptz,
  void_reason text check (char_length(void_reason) <= 200),
  created_at timestamptz not null default now(),
  constraint exercise_points_month_valid check (period_month = date_trunc('month', exercise_date::timestamp)::date)
);

comment on table public.exercise_points is
  '랭킹 점수 원장. 운동 세션 종료 트리거와 운영 RPC만 쓴다. 규칙은 docs/ranking.md';

create unique index exercise_points_session_key on public.exercise_points (session_id) where kind = 'session';
create unique index exercise_points_weekly_key
  on public.exercise_points (dog_id, week_start)
  where kind = 'weekly_bonus' and voided_at is null;
create index exercise_points_period_idx on public.exercise_points (period_month, dog_id) where voided_at is null;
create index exercise_points_dog_date_idx on public.exercise_points (dog_id, exercise_date);
create index exercise_points_session_idx on public.exercise_points (session_id);
create index exercise_points_owner_idx on public.exercise_points (owner_id, earned_at desc);

-- 주간 보너스: 그 주에 점수를 받은 운동이 2회 이상이면 하나 두고, 무효 처리로 2회 미만이 되면 무효로 돌린다
create or replace function private.refresh_weekly_bonus(p_dog_id uuid, p_week_start date)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_count integer;
  v_bonus_id uuid;
  v_second public.exercise_points%rowtype;
begin
  select count(*) into v_count
  from public.exercise_points p
  where p.dog_id = p_dog_id and p.kind = 'session' and p.week_start = p_week_start
    and p.voided_at is null and p.attendance_points > 0;

  select p.id into v_bonus_id
  from public.exercise_points p
  where p.dog_id = p_dog_id and p.kind = 'weekly_bonus' and p.week_start = p_week_start
    and p.voided_at is null;

  if v_count >= 2 and v_bonus_id is null then
    -- 두 번째로 점수를 받은 운동 시점(그 운동의 달)에 준다
    select p.* into v_second
    from public.exercise_points p
    where p.dog_id = p_dog_id and p.kind = 'session' and p.week_start = p_week_start
      and p.voided_at is null and p.attendance_points > 0
    order by p.earned_at, p.id
    offset 1 limit 1;

    insert into public.exercise_points (
      dog_id, owner_id, session_id, kind, branch_id, exercise_date, period_month, week_start,
      bonus_points, earned_at
    )
    values (
      p_dog_id, v_second.owner_id, v_second.session_id, 'weekly_bonus', v_second.branch_id,
      v_second.exercise_date, v_second.period_month, p_week_start, 20, v_second.earned_at
    );
  elsif v_count < 2 and v_bonus_id is not null then
    update public.exercise_points
    set voided_at = now(), void_reason = '주 2회 운동 조건 미달 (운동 점수 무효 처리)'
    where id = v_bonus_id;
  end if;
end;
$$;

-- ---------------------------------------------------------------------
-- 4. 배지
-- ---------------------------------------------------------------------
create table public.badges (
  code text primary key check (code ~ '^[a-z][a-z0-9_]*$'),
  name text not null unique check (char_length(name) between 1 and 30),
  description text not null check (char_length(description) <= 200),
  -- 누적 지표(metric)가 goal 이상이면 지급. 시상대처럼 월간 마감 때 주는 배지는 null
  metric text check (metric in ('sessions', 'distance_meters', 'streak_weeks', 'branches', 'open_runs')),
  goal numeric check (goal > 0),
  -- 앱 아이콘 키 (앱에서 Material 아이콘으로 바꾼다)
  icon text not null default 'paw',
  tier text not null default 'bronze' check (tier in ('bronze', 'silver', 'gold')),
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  constraint badges_metric_goal check ((metric is null) = (goal is null))
);

insert into public.badges (code, name, description, metric, goal, icon, tier, sort_order) values
  ('first_run',     '첫 발걸음',      '처음으로 트레드밀 운동을 마쳤어요.',                     'sessions',        1,      'flag',     'bronze',  10),
  ('sessions_10',   '열 번째 운동',   '운동을 10번 마쳤어요.',                                  'sessions',        10,     'run',      'bronze',  20),
  ('sessions_30',   '단골 러너',      '운동을 30번 마쳤어요.',                                  'sessions',        30,     'run',      'silver',  30),
  ('sessions_100',  '백 번의 질주',   '운동을 100번 마쳤어요.',                                 'sessions',        100,    'run',      'gold',    40),
  ('distance_10k',  '10km 돌파',      '누적 운동 거리가 10km를 넘었어요.',                       'distance_meters', 10000,  'route',    'bronze',  50),
  ('marathon',      '마라톤 완주',    '누적 운동 거리가 마라톤 거리(42.195km)를 넘었어요.',      'distance_meters', 42195,  'route',    'silver',  60),
  ('distance_100k', '100km 클럽',     '누적 운동 거리가 100km를 넘었어요.',                      'distance_meters', 100000, 'route',    'gold',    70),
  ('streak_4',      '4주 연속 출석',  '4주 연속으로 매주 운동했어요.',                           'streak_weeks',    4,      'fire',     'silver',  80),
  ('streak_12',     '12주 연속 출석', '12주(약 3개월) 연속으로 매주 운동했어요.',               'streak_weeks',    12,     'fire',     'gold',    90),
  ('stamp_tour',    '스탬프 투어',    '서로 다른 지점 3곳에서 운동했어요.',                      'branches',        3,      'stamp',    'silver', 100),
  ('open_run',      '오픈런',         '매장 문을 연 지 30분 안에 시작한 운동이 3번이에요.',      'open_runs',       3,      'sunrise',  'bronze', 110),
  ('podium',        '시상대',         '월간 랭킹에서 3위 안에 들었어요.',                         null,              null,   'trophy',   'gold',   120);

create table public.dog_badges (
  dog_id uuid not null references public.dogs (id) on delete cascade,
  badge_code text not null references public.badges (code) on update cascade,
  earned_at timestamptz not null default now(),
  session_id uuid references public.exercise_sessions (id) on delete set null,
  primary key (dog_id, badge_code)
);
create index dog_badges_dog_earned_idx on public.dog_badges (dog_id, earned_at desc);

-- 배지·진행률용 누적 지표 (무효 처리되지 않은 5분 이상 운동 기준)
--   sessions, distance_meters, branches(운동한 지점 수), open_runs(개점 30분 안에 시작),
--   streak_weeks(이번 주 또는 지난주까지 이어진 연속 운동 주), best_streak_weeks(최장 연속 주)
create or replace function private.dog_badge_stats(p_dog_id uuid)
returns jsonb
language sql
stable
security definer
set search_path = ''
as $$
  with sessions as (
    select p.session_id, p.branch_id, p.exercise_date, p.distance_meters, s.started_at
    from public.exercise_points p
    join public.exercise_sessions s on s.id = p.session_id
    where p.dog_id = p_dog_id and p.kind = 'session' and p.qualified and p.voided_at is null
  ),
  weeks as (
    select distinct private.week_start(x.exercise_date) as wk from sessions x
  ),
  islands as (
    select w.wk, w.wk - (row_number() over (order by w.wk) * 7)::integer as grp from weeks w
  ),
  streaks as (
    select i.grp, count(*)::integer as len, max(i.wk) as last_wk from islands i group by i.grp
  )
  select jsonb_build_object(
    'sessions', (select count(*) from sessions),
    'distance_meters', (select coalesce(sum(x.distance_meters), 0) from sessions x),
    'branches', (select count(distinct x.branch_id) from sessions x),
    'open_runs', (
      select count(*)
      from sessions x
      join public.branches b on b.id = x.branch_id
      where x.started_at is not null
        and not b.is_24_hours
        and (x.started_at at time zone b.timezone)::time >= b.opens_at
        and (x.started_at at time zone b.timezone)::time < b.opens_at + interval '30 minutes'
    ),
    'streak_weeks', coalesce((
      select st.len from streaks st
      where st.last_wk >= private.week_start(private.kst_date(now())) - 7
      order by st.last_wk desc
      limit 1
    ), 0),
    'best_streak_weeks', coalesce((select max(st.len) from streaks st), 0)
  );
$$;

-- 새로 달성한 배지를 주고 알린다. 연속 출석은 최장 기록 기준.
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
    perform private.notify_user(
      v_owner, 'ranking', '새 배지를 받았어요',
      format('%s의 「%s」 배지가 도착했어요. 배지함에서 확인해 보세요.',
        v_dog_name, (select b.name from public.badges b where b.code = v_badge.badge_code)),
      jsonb_build_object('dog_id', p_dog_id, 'badge_code', v_badge.badge_code)
    );
  end loop;
end;
$$;

-- ---------------------------------------------------------------------
-- 5. 운동 점수 적립 (운동 종료 시)
-- ---------------------------------------------------------------------
create or replace function private.award_session_points(p_session_id uuid)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_session public.exercise_sessions%rowtype;
  v_owner uuid;
  v_branch uuid;
  v_date date;
  v_target integer;
  v_attendance integer := 0;
  v_achievement integer := 0;
  v_distance integer := 0;
  v_note text;
begin
  select * into v_session from public.exercise_sessions s where s.id = p_session_id;
  if not found or v_session.status not in ('completed', 'stopped') then
    return;
  end if;

  -- 한 운동은 한 번만 적립한다
  perform 1 from public.exercise_points p where p.session_id = p_session_id and p.kind = 'session';
  if found then
    return;
  end if;

  select d.owner_id into v_owner from public.dogs d where d.id = v_session.dog_id;
  if v_owner is null then
    return;
  end if;

  v_branch := coalesce(
    (select b.branch_id from public.bookings b where b.id = v_session.booking_id),
    (select t.branch_id from public.treadmills t where t.id = v_session.treadmill_id)
  );
  v_date := private.kst_date(coalesce(v_session.started_at, v_session.ended_at, now()));

  if v_session.duration_seconds < 300 then
    v_note := 'too_short';
  elsif exists (
    -- 반려견당 하루 한 번만 점수를 준다 (무리한 운동을 부추기지 않게)
    select 1 from public.exercise_points p
    where p.dog_id = v_session.dog_id and p.kind = 'session' and p.exercise_date = v_date
      and p.voided_at is null and p.attendance_points > 0
  ) then
    v_note := 'daily_limit';
  else
    -- 목표 시간이 없으면 30분 기준
    v_target := coalesce(nullif(v_session.target_duration_seconds, 0), 1800);
    v_attendance := 10;
    v_achievement := least(10, floor(10.0 * v_session.duration_seconds / v_target))::integer;
    v_distance := least(20, floor(v_session.distance_meters / 100))::integer;
  end if;

  insert into public.exercise_points (
    dog_id, owner_id, session_id, kind, branch_id, exercise_date, period_month, week_start, qualified,
    attendance_points, achievement_points, distance_points, distance_meters, duration_seconds, note,
    earned_at
  )
  values (
    v_session.dog_id, v_owner, v_session.id, 'session', v_branch, v_date, private.month_start(v_date),
    private.week_start(v_date), v_session.duration_seconds >= 300,
    v_attendance, v_achievement, v_distance, v_session.distance_meters, v_session.duration_seconds, v_note,
    coalesce(v_session.ended_at, now())
  );

  if v_attendance > 0 then
    perform private.refresh_weekly_bonus(v_session.dog_id, private.week_start(v_date));
  end if;

  perform private.evaluate_dog_badges(v_session.dog_id, v_session.id);
end;
$$;

create or replace function private.on_exercise_session_finished()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  if new.status in ('completed', 'stopped')
     and (tg_op = 'INSERT' or old.status not in ('completed', 'stopped')) then
    perform private.award_session_points(new.id);
  end if;
  return null;
end;
$$;

-- 트리거 이름 순서대로 실행되므로 운동 완료 알림(exercise_sessions_notify_status)보다 먼저 점수가 쌓인다
create trigger exercise_sessions_award_points
  after insert or update of status on public.exercise_sessions
  for each row execute function private.on_exercise_session_finished();

-- 운동 완료 알림에 받은 점수를 함께 알려 준다
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
      jsonb_build_object('session_id', new.id));
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
      jsonb_build_object('session_id', new.id));
  elsif new.status = 'stopped' then
    perform private.notify_user(v_owner, 'exercise', '운동이 중단되었어요',
      format('%s의 운동이 중단되었습니다. 사유: %s', v_dog_name, coalesce(new.stop_reason, '-')),
      jsonb_build_object('session_id', new.id));
  end if;

  return new;
end;
$$;

-- 운영자: 부정 기록 등 점수 무효 처리 (주간 보너스도 다시 계산)
create or replace function public.void_exercise_points(p_session_id uuid, p_reason text default null)
returns void
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_dog_id uuid;
  v_week date;
begin
  if not private.is_admin() then
    raise exception 'FORBIDDEN' using errcode = '42501';
  end if;

  update public.exercise_points
  set voided_at = now(), void_reason = coalesce(nullif(trim(p_reason), ''), '운영자 판단에 의한 무효 처리')
  where session_id = p_session_id and kind = 'session' and voided_at is null
  returning dog_id, week_start into v_dog_id, v_week;

  if v_dog_id is null then
    raise exception 'POINTS_NOT_FOUND' using errcode = 'P0002';
  end if;
  perform private.refresh_weekly_bonus(v_dog_id, v_week);
end;
$$;

-- ---------------------------------------------------------------------
-- 6. 랭킹 집계
-- ---------------------------------------------------------------------
-- 한 달·한 범위의 순위표. 랭킹 참여에 동의한 보호자의 반려견만 들어간다.
-- p_extra_dog를 주면 동의하지 않았어도 그 반려견을 함께 넣어 순위를 계산한다 ("참여하면 n위").
-- 동점이면 그 점수에 먼저 도달한 반려견이 위.
create or replace function private.ranking_standings(
  p_month date,
  p_scope text,
  p_scope_key text,
  p_extra_dog uuid default null
)
returns table (
  dog_id uuid,
  points integer,
  session_count integer,
  distance_meters numeric,
  reached_at timestamptz,
  place integer,
  participant_count integer
)
language sql
stable
security definer
set search_path = ''
as $$
  with consented as (
    select distinct on (c.user_id) c.user_id, c.granted
    from public.data_consents c
    where c.consent_type = 'ranking'
    order by c.user_id, c.responded_at desc
  ),
  totals as (
    select
      p.dog_id,
      sum(p.points)::integer as points,
      (count(*) filter (where p.kind = 'session' and p.qualified))::integer as session_count,
      coalesce(sum(p.distance_meters) filter (where p.kind = 'session'), 0) as distance_meters,
      max(p.earned_at) filter (where p.points > 0) as reached_at
    from public.exercise_points p
    where p.period_month = p_month
      and p.voided_at is null
      and (p_scope <> 'branch' or p.branch_id::text = lower(p_scope_key))
    group by p.dog_id
  ),
  eligible as (
    select t.*
    from totals t
    join public.dogs d on d.id = t.dog_id and d.deleted_at is null
    left join consented c on c.user_id = d.owner_id
    where t.points > 0
      and (p_scope <> 'size' or d.size_class = p_scope_key)
      and (coalesce(c.granted, false) or t.dog_id = p_extra_dog)
  )
  select
    e.dog_id,
    e.points,
    e.session_count,
    e.distance_meters,
    e.reached_at,
    (rank() over (order by e.points desc, e.reached_at asc))::integer,
    (count(*) over ())::integer
  from eligible e;
$$;

create table public.ranking_cheers (
  period_month date not null,
  dog_id uuid not null references public.dogs (id) on delete cascade,
  user_id uuid not null references public.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (period_month, dog_id, user_id)
);
create index ranking_cheers_user_idx on public.ranking_cheers (user_id, created_at desc);

create table public.monthly_awards (
  id uuid primary key default gen_random_uuid(),
  period_month date not null check (extract(day from period_month) = 1),
  scope text not null check (scope in ('all', 'branch', 'size')),
  scope_key text not null,
  rank smallint not null check (rank between 1 and 3),
  dog_id uuid not null references public.dogs (id) on delete cascade,
  owner_id uuid not null references public.users (id) on delete cascade,
  points integer not null check (points > 0),
  created_at timestamptz not null default now(),
  constraint monthly_awards_dog_scope_key unique (period_month, scope, scope_key, dog_id)
);
create index monthly_awards_period_idx on public.monthly_awards (period_month desc, scope, scope_key, rank);
create index monthly_awards_dog_idx on public.monthly_awards (dog_id, period_month desc);

create table public.ranking_closings (
  period_month date primary key check (extract(day from period_month) = 1),
  closed_at timestamptz not null default now(),
  award_count integer not null default 0
);

-- 월간 랭킹 순위표 (상위 p_limit, 최대 100)
create or replace function public.get_leaderboard(
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
  size_class text,
  photo_path text,
  nickname text,
  main_branch_name text,
  points integer,
  session_count integer,
  distance_meters numeric,
  cheer_count integer,
  cheered_by_me boolean,
  is_mine boolean,
  title_period date,
  title_scope text,
  title_label text,
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
    select p.dog_id, b.name as branch_name, sum(p.points) as pts
    from public.exercise_points p
    join public.branches b on b.id = p.branch_id
    where p.period_month = v_month and p.voided_at is null
      and p.dog_id in (select t.dog_id from top_dogs t)
    group by p.dog_id, b.name
  ),
  main_branch as (
    select distinct on (bp.dog_id) bp.dog_id, bp.branch_name
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
    d.size_class,
    case when u.ranking_show_photo then d.profile_image_path end,
    u.nickname,
    mb.branch_name,
    t.points,
    t.session_count,
    t.distance_meters,
    coalesce(ch.cnt, 0),
    coalesce(ch.mine, false),
    d.owner_id = v_uid,
    ti.period_month,
    ti.scope,
    private.ranking_scope_label(ti.scope, ti.scope_key),
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
create or replace function public.get_branch_battle(p_month date default null)
returns table (
  rank integer,
  branch_id uuid,
  branch_name text,
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
      coalesce(sum(p.distance_meters) filter (where p.kind = 'session'), 0) as distance_meters,
      (count(*) filter (where p.kind = 'session' and p.qualified))::integer as session_count,
      (count(distinct p.dog_id) filter (where p.kind = 'session' and p.qualified))::integer as dog_count,
      coalesce(sum(p.points), 0)::integer as points
    from public.branches b
    left join public.exercise_points p
      on p.branch_id = b.id and p.period_month = v_month and p.voided_at is null
    where b.is_active
    group by b.id, b.name
  )
  select
    (rank() over (order by t.distance_meters desc))::integer,
    t.id,
    t.name,
    t.distance_meters,
    t.session_count,
    t.dog_count,
    t.points
  from totals t
  order by t.distance_meters desc, t.name;
end;
$$;

-- 랭킹에서 반려견을 눌렀을 때 보여줄 공개 프로필 (배지·수상 이력·응원)
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
          'rank', a.rank,
          'points', a.points
        ) order by a.period_month desc, a.rank, a.scope), '[]'::jsonb)
      from public.monthly_awards a
      where a.dog_id = p_dog_id
    )
  );
end;
$$;

-- 응원하기: 랭킹에 참여한 다른 반려견을 한 달에 한 번. 응원 수를 돌려준다.
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
      jsonb_build_object('dog_id', p_dog_id)
    );
  end if;

  return (select count(*)::integer from public.ranking_cheers c where c.dog_id = p_dog_id and c.period_month = v_month);
end;
$$;

-- ---------------------------------------------------------------------
-- 7. 월간 마감 · 명예의 전당
-- ---------------------------------------------------------------------
-- 지난 달의 전체·체급·지점별 1~3위를 기록하고 시상대 배지와 알림을 준다. 이미 마감한 달은 건너뛴다.
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
      ) as summary
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
      jsonb_build_object('period_month', v_month, 'dog_id', v_winner.dog_id)
    );
  end loop;

  return v_total;
end;
$$;

-- pg_cron이 매일 호출한다. 점수가 있는데 마감하지 않은 지난 달을 모두 마감한다.
create or replace function private.close_due_ranking_months()
returns integer
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_month date;
  v_total integer := 0;
begin
  for v_month in
    select distinct p.period_month
    from public.exercise_points p
    where p.period_month < private.current_ranking_month()
      and not exists (select 1 from public.ranking_closings c where c.period_month = p.period_month)
    order by p.period_month
  loop
    v_total := v_total + private.close_ranking_month(v_month);
  end loop;
  return v_total;
end;
$$;

-- 운영자가 수동으로 마감할 때 (예: cron 장애)
create or replace function public.close_ranking_month(p_month date)
returns integer
language plpgsql
volatile
security definer
set search_path = ''
as $$
begin
  if not private.is_admin() then
    raise exception 'FORBIDDEN' using errcode = '42501';
  end if;
  return private.close_ranking_month(p_month);
end;
$$;

-- 명예의 전당: 마감한 최근 p_months개월의 1~3위. 이후 랭킹 참여를 철회했거나 삭제된 반려견은 가린다.
create or replace function public.get_hall_of_fame(p_months integer default 6)
returns table (
  period_month date,
  scope text,
  scope_key text,
  scope_label text,
  rank integer,
  dog_id uuid,
  dog_name text,
  breed_label text,
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
    r.rank::integer,
    case when r.visible then r.dog_id end,
    case when r.visible then r.d_name end,
    case when r.visible then private.dog_breed_label(r.d_breed, r.d_is_mixed) end,
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

-- 매일 00:10(한국 시간, UTC 15:10)에 지난달 마감을 확인한다
create extension if not exists pg_cron with schema pg_catalog;
select cron.schedule(
  'pawfit-close-ranking-months',
  '10 15 * * *',
  'select private.close_due_ranking_months()'
);

-- ---------------------------------------------------------------------
-- 8. 랭킹 사진 공개 (dog-profiles 버킷)
-- 랭킹에 참여하고 사진 공개를 켠 보호자의 반려견 "현재" 프로필 사진만 다른 회원이 읽을 수 있다.
-- ---------------------------------------------------------------------
create index dogs_profile_image_path_idx on public.dogs (profile_image_path) where profile_image_path is not null;

create or replace function private.is_public_dog_photo(p_path text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.dogs d
    join public.users u on u.id = d.owner_id
    where d.profile_image_path = p_path
      and d.deleted_at is null
      and u.ranking_show_photo
      and private.has_consent(u.id, 'ranking')
  );
$$;

create policy dog_profiles_select_ranking on storage.objects
  for select to authenticated
  using (bucket_id = 'dog-profiles' and private.is_public_dog_photo(name));

-- ---------------------------------------------------------------------
-- 9. 권한
-- ---------------------------------------------------------------------
alter table public.exercise_points enable row level security;
alter table public.badges enable row level security;
alter table public.dog_badges enable row level security;
alter table public.ranking_cheers enable row level security;
alter table public.monthly_awards enable row level security;
alter table public.ranking_closings enable row level security;

revoke all on public.exercise_points, public.badges, public.dog_badges, public.ranking_cheers,
  public.monthly_awards, public.ranking_closings from anon;

-- 점수·배지·응원·수상은 트리거와 RPC만 쓴다
revoke insert, update, delete on public.exercise_points, public.dog_badges, public.ranking_cheers,
  public.monthly_awards, public.ranking_closings from authenticated;

create policy exercise_points_select_owner_or_admin on public.exercise_points
  for select to authenticated
  using (owner_id = (select auth.uid()) or (select private.is_admin()));

create policy badges_select on public.badges
  for select to authenticated
  using (is_active or (select private.is_admin()));
create policy badges_admin_write on public.badges
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

create policy dog_badges_select_owner_or_admin on public.dog_badges
  for select to authenticated
  using ((select private.owns_dog(dog_id)) or (select private.is_admin()));

create policy ranking_cheers_select_own on public.ranking_cheers
  for select to authenticated
  using (user_id = (select auth.uid()) or (select private.is_admin()));

create policy monthly_awards_select_own_or_admin on public.monthly_awards
  for select to authenticated
  using (owner_id = (select auth.uid()) or (select private.is_admin()));

create policy ranking_closings_select_admin on public.ranking_closings
  for select to authenticated
  using ((select private.is_admin()));

revoke execute on function public.set_nickname(text) from public, anon;
revoke execute on function public.void_exercise_points(uuid, text) from public, anon;
revoke execute on function public.get_leaderboard(date, text, text, integer) from public, anon;
revoke execute on function public.get_my_ranking(uuid, date) from public, anon;
revoke execute on function public.get_branch_battle(date) from public, anon;
revoke execute on function public.get_ranking_dog_profile(uuid, date) from public, anon;
revoke execute on function public.get_dog_achievements(uuid) from public, anon;
revoke execute on function public.cheer_dog(uuid) from public, anon;
revoke execute on function public.close_ranking_month(date) from public, anon;
revoke execute on function public.get_hall_of_fame(integer) from public, anon;
grant execute on function public.set_nickname(text) to authenticated;
grant execute on function public.void_exercise_points(uuid, text) to authenticated;
grant execute on function public.get_leaderboard(date, text, text, integer) to authenticated;
grant execute on function public.get_my_ranking(uuid, date) to authenticated;
grant execute on function public.get_branch_battle(date) to authenticated;
grant execute on function public.get_ranking_dog_profile(uuid, date) to authenticated;
grant execute on function public.get_dog_achievements(uuid) to authenticated;
grant execute on function public.cheer_dog(uuid) to authenticated;
grant execute on function public.close_ranking_month(date) to authenticated;
grant execute on function public.get_hall_of_fame(integer) to authenticated;

revoke all on all functions in schema private from public, anon;
grant execute on all functions in schema private to authenticated, service_role;
