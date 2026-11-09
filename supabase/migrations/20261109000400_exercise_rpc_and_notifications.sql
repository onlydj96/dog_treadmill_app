-- =====================================================================
-- 운동 세션 운영 RPC + 알림 트리거
-- 트레드밀 구동/비상정지는 현장 운영자가 관리한다(문서 3.3).
-- 아래 함수는 운영자 대시보드 또는 트레드밀 연동 장치(관리자 계정)가 호출한다.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 알림 생성 (사용자의 notification_prefs 반영)
-- ---------------------------------------------------------------------
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

  if p_type in ('booking', 'exercise', 'analysis', 'marketing')
     and coalesce(v_prefs -> p_type, 'true'::jsonb) = 'false'::jsonb then
    return;
  end if;

  insert into public.notifications (user_id, type, title, body, data)
  values (p_user_id, p_type, p_title, coalesce(p_body, ''), coalesce(p_data, '{}'::jsonb));
end;
$$;

-- ---------------------------------------------------------------------
-- 운영 RPC
-- ---------------------------------------------------------------------
create or replace function public.check_in_booking(p_booking_id uuid)
returns public.bookings
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_booking public.bookings%rowtype;
begin
  select * into v_booking from public.bookings bk where bk.id = p_booking_id for update;
  if not found or not private.can_manage_branch(v_booking.branch_id) then
    raise exception 'BOOKING_NOT_FOUND' using errcode = 'P0002';
  end if;
  if v_booking.status not in ('pending', 'confirmed') then
    raise exception 'INVALID_BOOKING_STATUS' using errcode = '22023';
  end if;

  update public.bookings set status = 'checked_in'
  where id = p_booking_id
  returning * into v_booking;
  return v_booking;
end;
$$;

create or replace function public.mark_booking_no_show(p_booking_id uuid)
returns public.bookings
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_booking public.bookings%rowtype;
begin
  select * into v_booking from public.bookings bk where bk.id = p_booking_id for update;
  if not found or not private.can_manage_branch(v_booking.branch_id) then
    raise exception 'BOOKING_NOT_FOUND' using errcode = 'P0002';
  end if;
  if v_booking.status not in ('pending', 'confirmed') then
    raise exception 'INVALID_BOOKING_STATUS' using errcode = '22023';
  end if;

  update public.bookings set status = 'no_show'
  where id = p_booking_id
  returning * into v_booking;
  return v_booking;
end;
$$;

create or replace function public.start_exercise_session(p_booking_id uuid)
returns public.exercise_sessions
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_booking public.bookings%rowtype;
  v_session public.exercise_sessions%rowtype;
  v_target integer;
begin
  select * into v_booking from public.bookings bk where bk.id = p_booking_id for update;
  if not found or not private.can_manage_branch(v_booking.branch_id) then
    raise exception 'BOOKING_NOT_FOUND' using errcode = 'P0002';
  end if;
  if v_booking.status not in ('pending', 'confirmed', 'checked_in') then
    raise exception 'INVALID_BOOKING_STATUS' using errcode = '22023';
  end if;

  perform 1 from public.exercise_sessions s where s.booking_id = p_booking_id;
  if found then
    raise exception 'SESSION_ALREADY_EXISTS' using errcode = '23505';
  end if;

  select p.duration_minutes * 60 into v_target
  from public.exercise_programs p
  where p.id = v_booking.program_id;

  insert into public.exercise_sessions (
    dog_id, booking_id, treadmill_id, status, started_at, target_duration_seconds
  )
  values (
    v_booking.dog_id,
    v_booking.id,
    v_booking.treadmill_id,
    'running',
    now(),
    coalesce(v_target, extract(epoch from (v_booking.end_at - v_booking.start_at))::integer)
  )
  returning * into v_session;

  update public.bookings set status = 'checked_in'
  where id = p_booking_id and status <> 'checked_in';

  update public.treadmills set status = 'in_use'
  where id = v_booking.treadmill_id and status = 'available';

  return v_session;
end;
$$;

-- 운동 중 실시간 지표 갱신 (Realtime으로 앱에 전달). p_status로 일시정지/재개.
create or replace function public.update_exercise_session_metrics(
  p_session_id uuid,
  p_current_speed numeric,
  p_distance_meters numeric default null,
  p_duration_seconds integer default null,
  p_status text default null
)
returns public.exercise_sessions
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_session public.exercise_sessions%rowtype;
  v_branch_id uuid;
  v_speed numeric;
begin
  select s.* into v_session from public.exercise_sessions s where s.id = p_session_id for update;
  if not found then
    raise exception 'SESSION_NOT_FOUND' using errcode = 'P0002';
  end if;

  select t.branch_id into v_branch_id from public.treadmills t where t.id = v_session.treadmill_id;
  if not private.can_manage_branch(v_branch_id) then
    raise exception 'SESSION_NOT_FOUND' using errcode = 'P0002';
  end if;

  if v_session.status not in ('running', 'paused') then
    raise exception 'SESSION_NOT_ACTIVE' using errcode = '22023';
  end if;
  if p_status is not null and p_status not in ('running', 'paused') then
    raise exception 'INVALID_SESSION_STATUS' using errcode = '22023';
  end if;

  v_speed := case when coalesce(p_status, v_session.status) = 'paused'
                  then 0 else greatest(coalesce(p_current_speed, 0), 0) end;

  update public.exercise_sessions
  set current_speed = v_speed,
      distance_meters = greatest(coalesce(p_distance_meters, distance_meters), 0),
      duration_seconds = greatest(coalesce(p_duration_seconds, duration_seconds), 0),
      max_speed = greatest(coalesce(max_speed, 0), v_speed),
      status = coalesce(p_status, status)
  where id = p_session_id
  returning * into v_session;

  return v_session;
end;
$$;

-- 운동 종료. p_completed=false면 중단(stop_reason 기록).
-- 보호자가 영상 촬영에 동의한 경우 AI 분석 작업을 대기열에 등록한다.
create or replace function public.finish_exercise_session(
  p_session_id uuid,
  p_completed boolean default true,
  p_stop_reason text default null
)
returns public.exercise_sessions
language plpgsql
volatile
security definer
set search_path = ''
as $$
declare
  v_session public.exercise_sessions%rowtype;
  v_branch_id uuid;
  v_owner uuid;
begin
  select s.* into v_session from public.exercise_sessions s where s.id = p_session_id for update;
  if not found then
    raise exception 'SESSION_NOT_FOUND' using errcode = 'P0002';
  end if;

  select t.branch_id into v_branch_id from public.treadmills t where t.id = v_session.treadmill_id;
  if not private.can_manage_branch(v_branch_id) then
    raise exception 'SESSION_NOT_FOUND' using errcode = 'P0002';
  end if;

  if v_session.status not in ('ready', 'running', 'paused') then
    raise exception 'SESSION_NOT_ACTIVE' using errcode = '22023';
  end if;

  update public.exercise_sessions
  set status = case when p_completed then 'completed' else 'stopped' end,
      ended_at = now(),
      current_speed = 0,
      stop_reason = case
        when p_completed then null
        else coalesce(nullif(trim(p_stop_reason), ''), '운영자 판단에 의한 중단')
      end,
      average_speed = case
        when duration_seconds > 0
          then round((distance_meters / duration_seconds * 3.6)::numeric, 1)
        else null
      end
  where id = p_session_id
  returning * into v_session;

  update public.bookings set status = 'completed'
  where id = v_session.booking_id and status in ('pending', 'confirmed', 'checked_in');

  update public.treadmills set status = 'available'
  where id = v_session.treadmill_id and status = 'in_use';

  select d.owner_id into v_owner from public.dogs d where d.id = v_session.dog_id;
  if private.has_consent(v_owner, 'video_recording') then
    insert into public.analysis_reports (session_id, dog_id, analysis_status)
    values (v_session.id, v_session.dog_id, 'queued');
  end if;

  return v_session;
end;
$$;

revoke execute on function public.check_in_booking(uuid) from public, anon;
revoke execute on function public.mark_booking_no_show(uuid) from public, anon;
revoke execute on function public.start_exercise_session(uuid) from public, anon;
revoke execute on function public.update_exercise_session_metrics(uuid, numeric, numeric, integer, text) from public, anon;
revoke execute on function public.finish_exercise_session(uuid, boolean, text) from public, anon;
grant execute on function public.check_in_booking(uuid) to authenticated;
grant execute on function public.mark_booking_no_show(uuid) to authenticated;
grant execute on function public.start_exercise_session(uuid) to authenticated;
grant execute on function public.update_exercise_session_metrics(uuid, numeric, numeric, integer, text) to authenticated;
grant execute on function public.finish_exercise_session(uuid, boolean, text) to authenticated;

-- ---------------------------------------------------------------------
-- 알림 트리거
-- ---------------------------------------------------------------------

-- 예약 상태 변경 (보호자 본인이 바꾼 경우는 제외)
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

  if new.status = 'confirmed' then
    perform private.notify_user(new.user_id, 'booking', '예약이 확정되었어요',
      format('%s · %s 예약이 확정되었습니다.', v_dog_name, v_when),
      jsonb_build_object('booking_id', new.id));
  elsif new.status = 'cancelled' then
    perform private.notify_user(new.user_id, 'booking', '예약이 취소되었어요',
      format('%s · %s 예약이 헬스장 사정으로 취소되었습니다.', v_dog_name, v_when),
      jsonb_build_object('booking_id', new.id));
  elsif new.status = 'no_show' then
    perform private.notify_user(new.user_id, 'booking', '미방문 처리되었어요',
      format('%s · %s 예약이 미방문으로 처리되었습니다.', v_dog_name, v_when),
      jsonb_build_object('booking_id', new.id));
  end if;

  return new;
end;
$$;

create trigger bookings_notify_status
  after update of status on public.bookings
  for each row execute function private.on_booking_status_changed();

-- 운동 시작/완료/중단
create or replace function private.on_exercise_session_status_changed()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_owner uuid;
  v_dog_name text;
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
    perform private.notify_user(v_owner, 'exercise', '운동을 완료했어요',
      format('%s의 운동이 끝났어요. 운동 기록을 확인해 보세요.', v_dog_name),
      jsonb_build_object('session_id', new.id));
  elsif new.status = 'stopped' then
    perform private.notify_user(v_owner, 'exercise', '운동이 중단되었어요',
      format('%s의 운동이 중단되었습니다. 사유: %s', v_dog_name, coalesce(new.stop_reason, '-')),
      jsonb_build_object('session_id', new.id));
  end if;

  return new;
end;
$$;

create trigger exercise_sessions_notify_status
  after insert or update of status on public.exercise_sessions
  for each row execute function private.on_exercise_session_status_changed();

-- 분석 완료 시각 기록
create or replace function private.on_analysis_report_completing()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  if new.analysis_status = 'completed' and new.completed_at is null then
    new.completed_at := now();
  end if;
  return new;
end;
$$;

create trigger analysis_reports_set_completed_at
  before insert or update of analysis_status on public.analysis_reports
  for each row execute function private.on_analysis_report_completing();

-- 분석 완료/실패 알림
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
      jsonb_build_object('report_id', new.id));
  elsif new.analysis_status = 'failed' then
    perform private.notify_user(v_owner, 'analysis', 'AI 분석을 완료하지 못했어요',
      format('%s의 영상 분석 중 문제가 발생했습니다. 헬스장에서 확인 후 다시 분석합니다.', v_dog_name),
      jsonb_build_object('report_id', new.id));
  end if;

  return new;
end;
$$;

create trigger analysis_reports_notify_status
  after insert or update of analysis_status on public.analysis_reports
  for each row execute function private.on_analysis_report_status_changed();

revoke all on all functions in schema private from public, anon;
grant execute on all functions in schema private to authenticated, service_role;
