-- =====================================================================
-- 예약 RPC
-- 클라이언트는 bookings에 직접 쓰지 않고 아래 함수만 호출한다.
-- 오류는 영문 코드 메시지(예: SLOT_FULL)로 반환하며 앱에서 한글로 변환한다.
-- =====================================================================

-- 보호자 취소·변경 마감: 예약 시작 1시간 전
create or replace function private.booking_change_deadline()
returns interval
language sql
immutable
set search_path = ''
as $$ select interval '1 hour' $$;

-- 예약 가능한 시간인지 검증 (영업시간 내, 슬롯 간격 정렬, 미래 시각)
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

  if v_local_start::time < p_branch.opens_at
     or v_local_end::date <> v_local_start::date
     or v_local_end::time > p_branch.closes_at
     or v_offset_seconds % (p_branch.slot_minutes * 60) <> 0
     or extract(second from v_local_start) <> 0
  then
    raise exception 'SLOT_NOT_AVAILABLE' using errcode = '22023';
  end if;
end;
$$;

-- ---------------------------------------------------------------------
-- 예약 가능 시간 조회: 지점/날짜/프로그램 기준 슬롯별 잔여 트레드밀 수
-- 다른 사용자의 예약 정보는 노출하지 않고 개수만 반환한다.
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
      (p_date + v_branch.closes_at)::timestamp - make_interval(mins => v_duration),
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

-- ---------------------------------------------------------------------
-- 예약 생성: 빈 트레드밀 자동 배정 + 이용권 1회 차감
-- 이용권을 적용하면 'confirmed', 없으면 현장 결제 대기 'pending'
-- ---------------------------------------------------------------------
create or replace function public.create_booking(
  p_dog_id uuid,
  p_branch_id uuid,
  p_program_id uuid,
  p_start_at timestamptz,
  p_membership_id uuid default null,
  p_note text default null
)
returns public.bookings
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_branch public.branches%rowtype;
  v_program public.exercise_programs%rowtype;
  v_membership public.memberships%rowtype;
  v_end_at timestamptz;
  v_treadmill_id uuid;
  v_booking public.bookings%rowtype;
  v_status text := 'pending';
  v_constraint text;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;

  perform 1 from public.dogs d
  where d.id = p_dog_id and d.owner_id = v_uid and d.deleted_at is null;
  if not found then
    raise exception 'DOG_NOT_FOUND' using errcode = 'P0002';
  end if;

  select * into v_branch from public.branches b where b.id = p_branch_id and b.is_active;
  if not found then
    raise exception 'BRANCH_NOT_FOUND' using errcode = 'P0002';
  end if;

  select * into v_program from public.exercise_programs p where p.id = p_program_id and p.is_active;
  if not found then
    raise exception 'PROGRAM_NOT_FOUND' using errcode = 'P0002';
  end if;

  perform private.assert_bookable_slot(v_branch, p_start_at, v_program.duration_minutes);
  v_end_at := p_start_at + make_interval(mins => v_program.duration_minutes);

  perform 1 from public.bookings bk
  where bk.dog_id = p_dog_id
    and bk.status in ('pending', 'confirmed', 'checked_in')
    and tstzrange(bk.start_at, bk.end_at, '[)') && tstzrange(p_start_at, v_end_at, '[)');
  if found then
    raise exception 'DOG_ALREADY_BOOKED' using errcode = '23P01';
  end if;

  if p_membership_id is not null then
    select * into v_membership
    from public.memberships m
    where m.id = p_membership_id and m.user_id = v_uid
    for update;
    if not found then
      raise exception 'MEMBERSHIP_NOT_FOUND' using errcode = 'P0002';
    end if;
    if v_membership.status <> 'active'
       or v_membership.remaining_sessions <= 0
       or v_membership.starts_at > p_start_at
       or v_membership.expires_at < v_end_at then
      raise exception 'MEMBERSHIP_NOT_USABLE' using errcode = '22023';
    end if;
    v_status := 'confirmed';
  end if;

  for v_treadmill_id in
    select t.id
    from public.treadmills t
    where t.branch_id = p_branch_id and t.status in ('available', 'in_use')
    order by t.device_name
  loop
    begin
      insert into public.bookings (
        user_id, dog_id, branch_id, treadmill_id, program_id, membership_id,
        start_at, end_at, status, note
      )
      values (
        v_uid, p_dog_id, p_branch_id, v_treadmill_id, p_program_id, p_membership_id,
        p_start_at, v_end_at, v_status, nullif(trim(p_note), '')
      )
      returning * into v_booking;
      exit;
    exception when exclusion_violation then
      get stacked diagnostics v_constraint = constraint_name;
      if v_constraint = 'bookings_no_dog_overlap' then
        raise exception 'DOG_ALREADY_BOOKED' using errcode = '23P01';
      end if;
      -- 해당 트레드밀이 이미 예약됨 → 다음 트레드밀 시도
    end;
  end loop;

  if v_booking.id is null then
    raise exception 'SLOT_FULL' using errcode = '23P01';
  end if;

  if p_membership_id is not null then
    update public.memberships
    set remaining_sessions = remaining_sessions - 1
    where id = p_membership_id;
  end if;

  return v_booking;
end;
$$;

-- ---------------------------------------------------------------------
-- 예약 취소: 시작 1시간 전까지 (관리자는 제한 없음). 사용한 이용권 회차 복구.
-- ---------------------------------------------------------------------
create or replace function public.cancel_booking(
  p_booking_id uuid,
  p_reason text default null
)
returns public.bookings
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_booking public.bookings%rowtype;
  v_is_admin boolean;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;

  select * into v_booking from public.bookings bk where bk.id = p_booking_id for update;
  if not found then
    raise exception 'BOOKING_NOT_FOUND' using errcode = 'P0002';
  end if;

  v_is_admin := private.can_manage_branch(v_booking.branch_id);
  if v_booking.user_id <> v_uid and not v_is_admin then
    raise exception 'BOOKING_NOT_FOUND' using errcode = 'P0002';
  end if;

  if v_booking.status not in ('pending', 'confirmed') then
    raise exception 'BOOKING_NOT_CANCELLABLE' using errcode = '22023';
  end if;

  if not v_is_admin and v_booking.start_at - private.booking_change_deadline() <= now() then
    raise exception 'CHANGE_DEADLINE_PASSED' using errcode = '22023';
  end if;

  update public.bookings
  set status = 'cancelled',
      cancelled_at = now(),
      cancel_reason = nullif(trim(p_reason), '')
  where id = p_booking_id
  returning * into v_booking;

  if v_booking.membership_id is not null then
    update public.memberships
    set remaining_sessions = least(remaining_sessions + 1, total_sessions)
    where id = v_booking.membership_id;
  end if;

  return v_booking;
end;
$$;

-- ---------------------------------------------------------------------
-- 예약 변경: 같은 지점·프로그램으로 시간만 변경. 빈 트레드밀 재배정.
-- ---------------------------------------------------------------------
create or replace function public.reschedule_booking(
  p_booking_id uuid,
  p_new_start_at timestamptz
)
returns public.bookings
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_booking public.bookings%rowtype;
  v_branch public.branches%rowtype;
  v_duration integer;
  v_new_end timestamptz;
  v_treadmill_id uuid;
  v_updated public.bookings%rowtype;
  v_constraint text;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;

  select * into v_booking from public.bookings bk where bk.id = p_booking_id for update;
  if not found or v_booking.user_id <> v_uid then
    raise exception 'BOOKING_NOT_FOUND' using errcode = 'P0002';
  end if;

  if v_booking.status not in ('pending', 'confirmed') then
    raise exception 'BOOKING_NOT_CANCELLABLE' using errcode = '22023';
  end if;

  if v_booking.start_at - private.booking_change_deadline() <= now() then
    raise exception 'CHANGE_DEADLINE_PASSED' using errcode = '22023';
  end if;

  select * into v_branch from public.branches b where b.id = v_booking.branch_id and b.is_active;
  if not found then
    raise exception 'BRANCH_NOT_FOUND' using errcode = 'P0002';
  end if;

  v_duration := (extract(epoch from (v_booking.end_at - v_booking.start_at)) / 60)::integer;
  perform private.assert_bookable_slot(v_branch, p_new_start_at, v_duration);
  v_new_end := p_new_start_at + make_interval(mins => v_duration);

  if v_booking.membership_id is not null then
    perform 1 from public.memberships m
    where m.id = v_booking.membership_id
      and m.starts_at <= p_new_start_at
      and m.expires_at >= v_new_end;
    if not found then
      raise exception 'MEMBERSHIP_NOT_USABLE' using errcode = '22023';
    end if;
  end if;

  for v_treadmill_id in
    select t.id
    from public.treadmills t
    where t.branch_id = v_booking.branch_id and t.status in ('available', 'in_use')
    order by (t.id = v_booking.treadmill_id) desc, t.device_name
  loop
    begin
      update public.bookings
      set start_at = p_new_start_at,
          end_at = v_new_end,
          treadmill_id = v_treadmill_id
      where id = p_booking_id
      returning * into v_updated;
      exit;
    exception when exclusion_violation then
      get stacked diagnostics v_constraint = constraint_name;
      if v_constraint = 'bookings_no_dog_overlap' then
        raise exception 'DOG_ALREADY_BOOKED' using errcode = '23P01';
      end if;
    end;
  end loop;

  if v_updated.id is null then
    raise exception 'SLOT_FULL' using errcode = '23P01';
  end if;

  return v_updated;
end;
$$;

revoke execute on function public.get_available_slots(uuid, date, uuid) from public, anon;
revoke execute on function public.create_booking(uuid, uuid, uuid, timestamptz, uuid, text) from public, anon;
revoke execute on function public.cancel_booking(uuid, text) from public, anon;
revoke execute on function public.reschedule_booking(uuid, timestamptz) from public, anon;
grant execute on function public.get_available_slots(uuid, date, uuid) to authenticated;
grant execute on function public.create_booking(uuid, uuid, uuid, timestamptz, uuid, text) to authenticated;
grant execute on function public.cancel_booking(uuid, text) to authenticated;
grant execute on function public.reschedule_booking(uuid, timestamptz) to authenticated;

revoke all on function private.booking_change_deadline() from public, anon;
revoke all on function private.assert_bookable_slot(public.branches, timestamptz, integer) from public, anon;
grant execute on function private.booking_change_deadline() to authenticated, service_role;
grant execute on function private.assert_bookable_slot(public.branches, timestamptz, integer)
  to authenticated, service_role;
