-- =====================================================================
-- 예약 바로 확정 + 트레드밀 QR 체크인
--  - 예약은 결제 방식과 상관없이 바로 '예약 확정'으로 만든다. 무인 매장이라 승인할 사람이 없다.
--    결제 방식은 membership_id로 구분한다 (있으면 이용권, 없으면 현장 결제).
--    'pending'은 앱 결제(PG)를 붙일 때 "결제 진행 중"으로 쓰려고 상태 목록에 남겨 둔다.
--  - 체크인: 보호자가 매장에서 트레드밀의 QR을 앱으로 스캔한다 (check_in_with_treadmill_qr).
--    스캔한 기기가 그 시간에 비어 있으면 예약을 그 기기로 옮긴다. 버튼 체크인(self_check_in_booking)은 없앤다.
--  - 트레드밀 기기 (Jetson Orin Nano 등, 지점 관리자 계정으로 로그인):
--    get_treadmill_qr로 QR 내용을 받고, get_treadmill_active_booking으로 체크인된 예약을 찾은 뒤
--    시작 버튼이 눌리면 start_exercise_session을 호출한다 (device/README.md).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 트레드밀 QR 토큰
-- API로 노출하지 않는 private 스키마에 둔다. 앱이 토큰 목록을 읽을 수 있으면 매장에 가지 않고도 체크인할 수 있다.
-- 스티커 사진이 퍼졌으면 토큰을 바꾼다 (기존 스티커는 더 이상 통하지 않는다):
--   update private.treadmill_qr_codes
--   set token = replace(gen_random_uuid()::text, '-', ''), rotated_at = now()
--   where treadmill_id = '<트레드밀 id>';
-- ---------------------------------------------------------------------
create table private.treadmill_qr_codes (
  treadmill_id uuid primary key references public.treadmills (id) on delete cascade,
  token text not null unique default replace(gen_random_uuid()::text, '-', ''),
  rotated_at timestamptz not null default now()
);

alter table private.treadmill_qr_codes enable row level security;
revoke all on private.treadmill_qr_codes from public, anon, authenticated;

insert into private.treadmill_qr_codes (treadmill_id)
select t.id from public.treadmills t
on conflict (treadmill_id) do nothing;

-- 트레드밀을 새로 등록하면 QR 토큰도 만든다
create or replace function private.create_treadmill_qr_code()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into private.treadmill_qr_codes (treadmill_id) values (new.id)
  on conflict (treadmill_id) do nothing;
  return new;
end;
$$;

create trigger treadmills_create_qr_code
  after insert on public.treadmills
  for each row execute function private.create_treadmill_qr_code();

-- QR에 담는 내용. 앱(lib/features/booking/data/treadmill_qr.dart)이 같은 형식을 읽는다.
create or replace function private.treadmill_qr_payload(p_token text)
returns text
language sql
immutable
set search_path = ''
as $$ select 'pawfit://treadmill?code=' || p_token $$;

revoke all on function private.create_treadmill_qr_code() from public, anon, authenticated;
revoke all on function private.treadmill_qr_payload(text) from public, anon, authenticated;

-- ---------------------------------------------------------------------
-- 예약 생성: 빈 트레드밀 자동 배정 + 이용권 1회 차감. 결제 방식과 상관없이 바로 확정한다.
-- (20261109000300_booking_rpc.sql과 같고, 이용권이 없을 때 'pending' 대신 'confirmed'로 만드는 것만 다르다)
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
        p_start_at, v_end_at, 'confirmed', nullif(trim(p_note), '')
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

-- 이미 '예약 대기'로 접수된 현장 결제 예약도 확정으로 바꾼다.
-- 보호자가 직접 한 일이 아니므로 "예약이 확정되었어요" 알림이 가지 않게 알림 트리거를 잠시 끈다.
alter table public.bookings disable trigger bookings_notify_status;
update public.bookings set status = 'confirmed' where status = 'pending';
alter table public.bookings enable trigger bookings_notify_status;

-- ---------------------------------------------------------------------
-- 보호자: 트레드밀 QR 체크인
--  - 본인 예약, 예약 확정(또는 결제 진행 중) 상태, 예약 시작 15분 전부터 종료 전까지
--  - 예약한 지점의 트레드밀이어야 하고, 점검·비활성 기기는 안 된다
--  - 스캔한 기기가 배정된 기기와 다르면, 그 시간에 비어 있을 때 예약을 그 기기로 옮긴다
-- ---------------------------------------------------------------------
create or replace function public.check_in_with_treadmill_qr(p_booking_id uuid, p_qr_token text)
returns public.bookings
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_booking public.bookings%rowtype;
  v_treadmill public.treadmills%rowtype;
begin
  if v_uid is null then
    raise exception 'AUTH_REQUIRED' using errcode = '42501';
  end if;

  select * into v_booking from public.bookings bk where bk.id = p_booking_id for update;
  if not found or v_booking.user_id is distinct from v_uid then
    raise exception 'BOOKING_NOT_FOUND' using errcode = 'P0002';
  end if;

  if v_booking.status not in ('pending', 'confirmed') then
    raise exception 'INVALID_BOOKING_STATUS' using errcode = '22023';
  end if;

  if now() < v_booking.start_at - private.check_in_opens_before() then
    raise exception 'CHECK_IN_TOO_EARLY' using errcode = '22023';
  end if;

  if now() >= v_booking.end_at then
    raise exception 'CHECK_IN_CLOSED' using errcode = '22023';
  end if;

  select t.* into v_treadmill
  from private.treadmill_qr_codes q
  join public.treadmills t on t.id = q.treadmill_id
  where q.token = trim(coalesce(p_qr_token, ''));
  if not found then
    raise exception 'QR_INVALID' using errcode = 'P0002';
  end if;

  if v_treadmill.branch_id <> v_booking.branch_id then
    raise exception 'QR_OTHER_BRANCH' using errcode = '22023';
  end if;

  if v_treadmill.status not in ('available', 'in_use') then
    raise exception 'TREADMILL_UNAVAILABLE' using errcode = '22023';
  end if;

  begin
    update public.bookings
    set treadmill_id = v_treadmill.id,
        status = 'checked_in'
    where id = p_booking_id
    returning * into v_booking;
  exception when exclusion_violation then
    -- 스캔한 기기에 이 시간과 겹치는 다른 예약이 있다 (bookings_no_overlap)
    raise exception 'TREADMILL_BUSY' using errcode = '23P01';
  end;

  return v_booking;
end;
$$;

drop function if exists public.self_check_in_booking(uuid);

-- ---------------------------------------------------------------------
-- 트레드밀 기기 (지점 관리자 계정)
-- ---------------------------------------------------------------------

-- 기기 화면에 띄우거나 스티커로 출력할 QR 내용
create or replace function public.get_treadmill_qr(p_treadmill_id uuid)
returns text
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_branch_id uuid;
  v_token text;
begin
  select t.branch_id into v_branch_id from public.treadmills t where t.id = p_treadmill_id;
  if not found or not private.can_manage_branch(v_branch_id) then
    raise exception 'TREADMILL_NOT_FOUND' using errcode = 'P0002';
  end if;

  select q.token into v_token from private.treadmill_qr_codes q where q.treadmill_id = p_treadmill_id;
  return private.treadmill_qr_payload(v_token);
end;
$$;

-- 이 기기에서 QR 체크인한 예약 (운동 중인 세션이 있으면 그 예약을 먼저).
-- 기기는 이 예약을 화면에 보여 주고, 시작 버튼이 눌리면 start_exercise_session(booking_id)을 호출한다.
create or replace function public.get_treadmill_active_booking(p_treadmill_id uuid)
returns table (
  booking_id uuid,
  dog_id uuid,
  dog_name text,
  program_name text,
  duration_minutes integer,
  start_at timestamptz,
  end_at timestamptz,
  session_id uuid,
  session_status text
)
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_branch_id uuid;
begin
  select t.branch_id into v_branch_id from public.treadmills t where t.id = p_treadmill_id;
  if not found or not private.can_manage_branch(v_branch_id) then
    raise exception 'TREADMILL_NOT_FOUND' using errcode = 'P0002';
  end if;

  return query
  select
    bk.id,
    bk.dog_id,
    d.name,
    p.name,
    p.duration_minutes,
    bk.start_at,
    bk.end_at,
    s.id,
    s.status
  from public.bookings bk
  join public.dogs d on d.id = bk.dog_id
  left join public.exercise_programs p on p.id = bk.program_id
  left join public.exercise_sessions s on s.booking_id = bk.id
  where bk.treadmill_id = p_treadmill_id
    and bk.status = 'checked_in'
    and (bk.end_at > now() or s.status in ('running', 'paused'))
  order by coalesce(s.status in ('running', 'paused'), false) desc, bk.start_at
  limit 1;
end;
$$;

revoke execute on function public.check_in_with_treadmill_qr(uuid, text) from public, anon;
revoke execute on function public.get_treadmill_qr(uuid) from public, anon;
revoke execute on function public.get_treadmill_active_booking(uuid) from public, anon;
grant execute on function public.check_in_with_treadmill_qr(uuid, text) to authenticated;
grant execute on function public.get_treadmill_qr(uuid) to authenticated;
grant execute on function public.get_treadmill_active_booking(uuid) to authenticated;
