-- =====================================================================
-- 무인 매장: 보호자 셀프 체크인
-- 매장에 직원이 없으므로 보호자가 앱에서 직접 체크인한다.
--  - 본인 예약만, 예약 대기(현장 결제)·예약 확정 상태에서
--  - 예약 시작 15분 전부터 종료 전까지 (매장 도착 여부는 확인하지 않는다)
-- 운동 시작·종료·비상정지는 보호자가 트레드밀 기기에서 한다. 기기는 지점 관리자 계정으로
-- start_exercise_session / update_exercise_session_metrics / finish_exercise_session을 호출한다.
-- 관리자용 check_in_booking은 운영자 대시보드·매장 기기용으로 그대로 둔다.
-- =====================================================================

-- 셀프 체크인이 열리는 시점: 예약 시작 15분 전
create or replace function private.check_in_opens_before()
returns interval
language sql
immutable
set search_path = ''
as $$ select interval '15 minutes' $$;

create or replace function public.self_check_in_booking(p_booking_id uuid)
returns public.bookings
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_uid uuid := (select auth.uid());
  v_booking public.bookings%rowtype;
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

  update public.bookings set status = 'checked_in'
  where id = p_booking_id
  returning * into v_booking;
  return v_booking;
end;
$$;

revoke all on function private.check_in_opens_before() from public, anon;
grant execute on function private.check_in_opens_before() to authenticated, service_role;

revoke execute on function public.self_check_in_booking(uuid) from public, anon;
grant execute on function public.self_check_in_booking(uuid) to authenticated;
