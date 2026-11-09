-- =====================================================================
-- 권한 및 보안 (DOCUMENT.md 8장)
-- - 모든 테이블 RLS 활성화
-- - 관리자 권한은 서버(DB 함수)에서 검증
-- - 사용자는 본인 데이터와 본인 반려견 데이터만 접근
-- =====================================================================

grant usage on schema private to authenticated, service_role;

-- ---------------------------------------------------------------------
-- 권한 헬퍼 (SECURITY DEFINER로 RLS 재귀를 피한다)
-- ---------------------------------------------------------------------
create or replace function private.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.users u
    where u.id = (select auth.uid()) and u.role = 'admin'
  );
$$;

-- 담당 지점 관리자 여부 (managed_branch_id가 NULL이면 전 지점)
create or replace function private.can_manage_branch(p_branch_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.users u
    where u.id = (select auth.uid())
      and u.role = 'admin'
      and (u.managed_branch_id is null or u.managed_branch_id = p_branch_id)
  );
$$;

create or replace function private.owns_dog(p_dog_id uuid)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.dogs d
    where d.id = p_dog_id and d.owner_id = (select auth.uid())
  );
$$;

-- Storage 경로의 첫 폴더(dog_id 문자열)로 소유 여부 확인. 잘못된 UUID여도 오류 없이 false.
create or replace function private.owns_dog_path(p_dog_id text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1 from public.dogs d
    where d.id::text = p_dog_id and d.owner_id = (select auth.uid())
  );
$$;

-- 사용자의 최신 동의 상태
create or replace function private.has_consent(p_user_id uuid, p_type text)
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select coalesce((
    select c.granted
    from public.data_consents c
    where c.user_id = p_user_id and c.consent_type = p_type
    order by c.responded_at desc
    limit 1
  ), false);
$$;

-- ---------------------------------------------------------------------
-- 회원가입 시 프로필/동의 이력 생성
-- signUp(data: {name, phone, consents: [{type, version, granted}]})
-- ---------------------------------------------------------------------
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
  insert into public.users (id, name, phone)
  values (
    new.id,
    coalesce(
      nullif(trim(v_meta ->> 'name'), ''),
      split_part(coalesce(new.email, ''), '@', 1)
    ),
    nullif(trim(v_meta ->> 'phone'), '')
  );

  if jsonb_typeof(v_consents) = 'array' then
    for v_item in select value from jsonb_array_elements(v_consents) loop
      if (v_item ->> 'type') in ('terms', 'privacy', 'video_recording', 'ai_training', 'marketing') then
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

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function private.handle_new_user();

-- ---------------------------------------------------------------------
-- RLS 활성화
-- ---------------------------------------------------------------------
alter table public.branches enable row level security;
alter table public.users enable row level security;
alter table public.dogs enable row level security;
alter table public.dog_health_profiles enable row level security;
alter table public.treadmills enable row level security;
alter table public.exercise_programs enable row level security;
alter table public.membership_plans enable row level security;
alter table public.memberships enable row level security;
alter table public.bookings enable row level security;
alter table public.payments enable row level security;
alter table public.exercise_sessions enable row level security;
alter table public.pose_records enable row level security;
alter table public.analysis_reports enable row level security;
alter table public.exercise_plans enable row level security;
alter table public.notifications enable row level security;
alter table public.data_consents enable row level security;
alter table public.notices enable row level security;
alter table public.faqs enable row level security;
alter table public.inquiries enable row level security;

-- ---------------------------------------------------------------------
-- users: 본인 조회·수정 (수정 가능한 컬럼은 아래 GRANT로 제한)
-- ---------------------------------------------------------------------
create policy users_select_own_or_admin on public.users
  for select to authenticated
  using (id = (select auth.uid()) or (select private.is_admin()));

create policy users_update_own on public.users
  for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

-- 사용자는 이름/연락처/알림 설정만 수정할 수 있다 (role, managed_branch_id 변경 불가)
revoke insert, update, delete on public.users from anon, authenticated;
grant update (name, phone, notification_prefs) on public.users to authenticated;

-- ---------------------------------------------------------------------
-- dogs / dog_health_profiles: 보호자 본인 관리, 관리자 조회
-- ---------------------------------------------------------------------
create policy dogs_select_owner_or_admin on public.dogs
  for select to authenticated
  using (owner_id = (select auth.uid()) or (select private.is_admin()));

create policy dogs_insert_owner on public.dogs
  for insert to authenticated
  with check (owner_id = (select auth.uid()));

create policy dogs_update_owner on public.dogs
  for update to authenticated
  using (owner_id = (select auth.uid()))
  with check (owner_id = (select auth.uid()));

-- 삭제는 deleted_at 갱신(소프트 삭제)으로만 처리한다
revoke delete on public.dogs from anon, authenticated;

create policy dog_health_select_owner_or_admin on public.dog_health_profiles
  for select to authenticated
  using ((select private.owns_dog(dog_id)) or (select private.is_admin()));

create policy dog_health_insert_owner on public.dog_health_profiles
  for insert to authenticated
  with check ((select private.owns_dog(dog_id)));

create policy dog_health_update_owner on public.dog_health_profiles
  for update to authenticated
  using ((select private.owns_dog(dog_id)))
  with check ((select private.owns_dog(dog_id)));

-- ---------------------------------------------------------------------
-- 카탈로그(지점/트레드밀/프로그램/이용권 상품/FAQ/공지): 로그인 사용자 조회, 관리자 관리
-- ---------------------------------------------------------------------
create policy branches_select_authenticated on public.branches
  for select to authenticated using (true);
create policy branches_admin_write on public.branches
  for all to authenticated
  using ((select private.can_manage_branch(id)))
  with check ((select private.can_manage_branch(id)));

create policy treadmills_select_authenticated on public.treadmills
  for select to authenticated using (true);
create policy treadmills_admin_write on public.treadmills
  for all to authenticated
  using ((select private.can_manage_branch(branch_id)))
  with check ((select private.can_manage_branch(branch_id)));

create policy exercise_programs_select_authenticated on public.exercise_programs
  for select to authenticated using (true);
create policy exercise_programs_admin_write on public.exercise_programs
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

create policy membership_plans_select_authenticated on public.membership_plans
  for select to authenticated using (true);
create policy membership_plans_admin_write on public.membership_plans
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

create policy faqs_select_authenticated on public.faqs
  for select to authenticated using (is_active or (select private.is_admin()));
create policy faqs_admin_write on public.faqs
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

create policy notices_select_published on public.notices
  for select to authenticated
  using (published_at <= now() or (select private.is_admin()));
create policy notices_admin_write on public.notices
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

-- ---------------------------------------------------------------------
-- memberships / payments: 본인 조회만. 발급·결제 반영은 관리자 또는 서버(service_role)
-- ---------------------------------------------------------------------
create policy memberships_select_own_or_admin on public.memberships
  for select to authenticated
  using (user_id = (select auth.uid()) or (select private.is_admin()));
create policy memberships_admin_write on public.memberships
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

create policy payments_select_own_or_admin on public.payments
  for select to authenticated
  using (user_id = (select auth.uid()) or (select private.is_admin()));
create policy payments_admin_write on public.payments
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

-- ---------------------------------------------------------------------
-- bookings: 본인 조회. 생성·변경·취소는 RPC(create_booking 등)로만.
-- 담당 지점 관리자는 조회·상태 변경 가능.
-- ---------------------------------------------------------------------
create policy bookings_select_own_or_branch_admin on public.bookings
  for select to authenticated
  using (user_id = (select auth.uid()) or (select private.can_manage_branch(branch_id)));

create policy bookings_branch_admin_write on public.bookings
  for all to authenticated
  using ((select private.can_manage_branch(branch_id)))
  with check ((select private.can_manage_branch(branch_id)));

-- ---------------------------------------------------------------------
-- 운동 기록 / 분석: 반려견 보호자 조회, 관리자 조회·검토
-- 쓰기는 운영 RPC 또는 AI 서버(service_role)가 수행
-- ---------------------------------------------------------------------
create policy exercise_sessions_select_owner_or_admin on public.exercise_sessions
  for select to authenticated
  using ((select private.owns_dog(dog_id)) or (select private.is_admin()));

create policy pose_records_select_owner_or_admin on public.pose_records
  for select to authenticated
  using (
    (select private.is_admin())
    or exists (
      select 1 from public.exercise_sessions s
      where s.id = session_id and (select private.owns_dog(s.dog_id))
    )
  );

create policy analysis_reports_select_owner_or_admin on public.analysis_reports
  for select to authenticated
  using ((select private.owns_dog(dog_id)) or (select private.is_admin()));

create policy analysis_reports_admin_review on public.analysis_reports
  for update to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

create policy exercise_plans_select_owner_or_admin on public.exercise_plans
  for select to authenticated
  using ((select private.owns_dog(dog_id)) or (select private.is_admin()));

create policy exercise_plans_admin_write on public.exercise_plans
  for all to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

-- ---------------------------------------------------------------------
-- notifications: 본인 조회, 읽음 처리, 삭제
-- ---------------------------------------------------------------------
create policy notifications_select_own on public.notifications
  for select to authenticated
  using (user_id = (select auth.uid()));

create policy notifications_update_own on public.notifications
  for update to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

create policy notifications_delete_own on public.notifications
  for delete to authenticated
  using (user_id = (select auth.uid()));

revoke insert, update on public.notifications from anon, authenticated;
grant update (is_read) on public.notifications to authenticated;

-- ---------------------------------------------------------------------
-- data_consents: 본인 조회·추가 (수정/삭제 불가 — 이력 보존)
-- ---------------------------------------------------------------------
create policy data_consents_select_own_or_admin on public.data_consents
  for select to authenticated
  using (user_id = (select auth.uid()) or (select private.is_admin()));

create policy data_consents_insert_own on public.data_consents
  for insert to authenticated
  with check (user_id = (select auth.uid()));

revoke update, delete on public.data_consents from anon, authenticated;

-- ---------------------------------------------------------------------
-- inquiries: 본인 작성·조회, 관리자 답변
-- ---------------------------------------------------------------------
create policy inquiries_select_own_or_admin on public.inquiries
  for select to authenticated
  using (user_id = (select auth.uid()) or (select private.is_admin()));

create policy inquiries_insert_own on public.inquiries
  for insert to authenticated
  with check (
    user_id = (select auth.uid())
    and status = 'open'
    and answer is null
    and answered_by is null
    and answered_at is null
  );

create policy inquiries_admin_answer on public.inquiries
  for update to authenticated
  using ((select private.is_admin()))
  with check ((select private.is_admin()));

-- ---------------------------------------------------------------------
-- 비로그인(anon) 사용자는 어떤 테이블에도 접근할 수 없다
-- ---------------------------------------------------------------------
revoke all on all tables in schema public from anon;

-- 헬퍼 함수 실행 권한
revoke all on all functions in schema private from public, anon;
grant execute on all functions in schema private to authenticated, service_role;
