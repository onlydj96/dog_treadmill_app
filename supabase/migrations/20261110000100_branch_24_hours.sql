-- =====================================================================
-- 24시간 운영 지점 지원 (현재 지점은 모두 몰 영업시간을 따르며, 몰 밖 무인 매장용으로 둔다)
-- 24시간 지점은 opens_at '00:00', closes_at '24:00'으로 저장한다.
--  - 예약 슬롯: 0시부터 자정 직전까지 slot_minutes 간격 (30분이면 00:00~23:30, 48개)
--  - 자정을 넘기는 예약 허용 (예: 23:30 시작 40분 프로그램 → 다음 날 00:10 종료)
-- 일반 지점은 기존처럼 영업시간 안에서 끝나는 예약만 받는다.
-- =====================================================================

alter table public.branches
  add column is_24_hours boolean
    generated always as (opens_at = time '00:00' and closes_at = time '24:00') stored;

comment on column public.branches.is_24_hours is
  '24시간 운영 여부. opens_at 00:00, closes_at 24:00이면 true이며 자정을 넘기는 예약을 허용한다.';

-- 예약 가능한 시간인지 검증 (슬롯 간격 정렬, 미래 시각, 일반 지점은 영업시간 내)
create or replace function private.assert_bookable_slot(
  p_branch public.branches,
  p_start_at timestamptz,
  p_duration_minutes integer
)
returns void
language plpgsql
stable
set search_path = ''
as $$
declare
  v_local_start timestamp := p_start_at at time zone p_branch.timezone;
  v_local_end timestamp := (p_start_at + make_interval(mins => p_duration_minutes))
    at time zone p_branch.timezone;
  v_offset_seconds integer;
begin
  if p_start_at <= now() then
    raise exception 'SLOT_IN_PAST' using errcode = '22023';
  end if;

  v_offset_seconds := extract(epoch from (v_local_start::time - p_branch.opens_at))::integer;

  if v_offset_seconds % (p_branch.slot_minutes * 60) <> 0
     or extract(second from v_local_start) <> 0
  then
    raise exception 'SLOT_NOT_AVAILABLE' using errcode = '22023';
  end if;

  -- 24시간 지점은 영업시간 제한이 없고 자정을 넘겨도 된다.
  if p_branch.is_24_hours then
    return;
  end if;

  -- 날짜 + 시각(timestamp)으로 비교해야 closes_at이 24:00인 지점도 마지막 슬롯을 받을 수 있다.
  if v_local_start < v_local_start::date + p_branch.opens_at
     or v_local_end > v_local_start::date + p_branch.closes_at
  then
    raise exception 'SLOT_NOT_AVAILABLE' using errcode = '22023';
  end if;
end;
$$;

-- ---------------------------------------------------------------------
-- 예약 가능 시간 조회: 지점/날짜/프로그램 기준 슬롯별 잔여 트레드밀 수
-- 24시간 지점은 프로그램 길이와 관계없이 하루의 모든 슬롯을 연다(자정을 넘기는 예약 허용).
-- 전날 밤에 시작해 자정을 넘긴 예약도 겹침 검사로 잔여 대수에 반영된다.
-- ---------------------------------------------------------------------
create or replace function public.get_available_slots(
  p_branch_id uuid,
  p_date date,
  p_program_id uuid
)
returns table (
  slot_start timestamptz,
  slot_end timestamptz,
  available_count integer,
  total_count integer
)
language plpgsql
stable
security definer
set search_path = ''
as $$
#variable_conflict use_column
declare
  v_branch public.branches%rowtype;
  v_duration integer;
begin
  if (select auth.uid()) is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;

  select * into v_branch from public.branches b where b.id = p_branch_id and b.is_active;
  if not found then
    raise exception 'BRANCH_NOT_FOUND' using errcode = 'P0002';
  end if;

  select p.duration_minutes into v_duration
  from public.exercise_programs p
  where p.id = p_program_id and p.is_active;
  if not found then
    raise exception 'PROGRAM_NOT_FOUND' using errcode = 'P0002';
  end if;

  return query
  with slots as (
    select (gs at time zone v_branch.timezone) as s_start
    from generate_series(
      (p_date + v_branch.opens_at)::timestamp,
      case
        when v_branch.is_24_hours
          then (p_date + v_branch.closes_at)::timestamp - make_interval(mins => v_branch.slot_minutes)
        else (p_date + v_branch.closes_at)::timestamp - make_interval(mins => v_duration)
      end,
      make_interval(mins => v_branch.slot_minutes)
    ) as gs
  ),
  machines as (
    select t.id
    from public.treadmills t
    where t.branch_id = p_branch_id and t.status in ('available', 'in_use')
  )
  select
    s.s_start,
    s.s_start + make_interval(mins => v_duration),
    (
      select count(*)::integer
      from machines m
      where not exists (
        select 1
        from public.bookings bk
        where bk.treadmill_id = m.id
          and bk.status in ('pending', 'confirmed', 'checked_in')
          and tstzrange(bk.start_at, bk.end_at, '[)')
              && tstzrange(s.s_start, s.s_start + make_interval(mins => v_duration), '[)')
      )
    ),
    (select count(*)::integer from machines)
  from slots s
  where s.s_start > now()
  order by s.s_start;
end;
$$;
