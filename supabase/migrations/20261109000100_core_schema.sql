-- =====================================================================
-- 반려견 AI 헬스장 — 핵심 스키마
-- DOCUMENT.md 5장 기반. 문서 대비 추가/변경 사항은 README의
-- "스키마 변경 사항" 절 참고.
-- =====================================================================

create extension if not exists btree_gist with schema extensions;

-- 내부 헬퍼 함수 전용 스키마 (PostgREST API로 노출되지 않음)
create schema if not exists private;

-- ---------------------------------------------------------------------
-- 공통: updated_at 자동 갱신
-- ---------------------------------------------------------------------
create or replace function private.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- ---------------------------------------------------------------------
-- 5.2 지점 (users.managed_branch_id가 참조하므로 먼저 생성)
-- ---------------------------------------------------------------------
create table public.branches (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  address text not null,
  phone text,
  timezone text not null default 'Asia/Seoul',
  opens_at time not null default '10:00',
  closes_at time not null default '21:00',
  slot_minutes integer not null default 30 check (slot_minutes between 10 and 120),
  is_active boolean not null default true,
  created_at timestamptz not null default now(),
  constraint branches_hours_valid check (closes_at > opens_at)
);

-- ---------------------------------------------------------------------
-- 5.1 사용자 및 반려견
-- ---------------------------------------------------------------------
create table public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  name text not null default '',
  phone text,
  role text not null default 'user' check (role in ('user', 'admin')),
  -- 관리자의 담당 지점. NULL이면 전 지점 관리자.
  managed_branch_id uuid references public.branches (id) on delete set null,
  notification_prefs jsonb not null default
    '{"booking": true, "exercise": true, "analysis": true, "marketing": false}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.dogs (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references public.users (id) on delete cascade,
  name text not null check (char_length(name) between 1 and 30),
  breed text check (char_length(breed) <= 50),
  birth_date date,
  sex text check (sex in ('male', 'female')),
  neutered boolean not null default false,
  weight_kg numeric(5, 2) check (weight_kg > 0 and weight_kg < 150),
  -- 비공개 버킷(dog-profiles)의 객체 경로. 표시할 때 서명 URL을 발급한다.
  profile_image_path text,
  -- 운동·분석 이력 보존을 위해 소프트 삭제
  deleted_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint dogs_id_owner_key unique (id, owner_id)
);
create index dogs_owner_id_idx on public.dogs (owner_id) where deleted_at is null;

create table public.dog_health_profiles (
  id uuid primary key default gen_random_uuid(),
  dog_id uuid not null unique references public.dogs (id) on delete cascade,
  -- 각 항목: [{"name": "...", "detail": "...", "date": "YYYY-MM-DD"}]
  diseases jsonb not null default '[]'::jsonb check (jsonb_typeof(diseases) = 'array'),
  surgeries jsonb not null default '[]'::jsonb check (jsonb_typeof(surgeries) = 'array'),
  medications jsonb not null default '[]'::jsonb check (jsonb_typeof(medications) = 'array'),
  exercise_restrictions jsonb not null default '[]'::jsonb
    check (jsonb_typeof(exercise_restrictions) = 'array'),
  veterinary_notes text check (char_length(veterinary_notes) <= 2000),
  updated_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- 5.2 예약 및 결제
-- ---------------------------------------------------------------------
create table public.treadmills (
  id uuid primary key default gen_random_uuid(),
  branch_id uuid not null references public.branches (id) on delete cascade,
  device_name text not null,
  status text not null default 'available'
    check (status in ('available', 'in_use', 'maintenance', 'inactive')),
  created_at timestamptz not null default now(),
  constraint treadmills_branch_device_key unique (branch_id, device_name),
  constraint treadmills_id_branch_key unique (id, branch_id)
);

-- 예약 시 선택하는 운동 프로그램 카탈로그 (문서 3.2 "운동 프로그램 선택")
create table public.exercise_programs (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  duration_minutes integer not null check (duration_minutes between 5 and 120),
  target_speed_kmh numeric(4, 1) check (target_speed_kmh > 0 and target_speed_kmh <= 20),
  intensity text not null default 'medium' check (intensity in ('low', 'medium', 'high')),
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

-- 판매하는 이용권 상품 카탈로그
create table public.membership_plans (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  description text,
  total_sessions integer not null check (total_sessions > 0),
  validity_days integer not null check (validity_days > 0),
  price integer not null check (price >= 0), -- KRW
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table public.memberships (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  plan_id uuid references public.membership_plans (id) on delete set null,
  plan_name text not null,
  total_sessions integer not null check (total_sessions > 0),
  remaining_sessions integer not null check (remaining_sessions >= 0),
  starts_at timestamptz not null default now(),
  expires_at timestamptz not null,
  status text not null default 'active'
    check (status in ('active', 'expired', 'cancelled', 'refunded')),
  created_at timestamptz not null default now(),
  constraint memberships_sessions_valid check (remaining_sessions <= total_sessions),
  constraint memberships_period_valid check (expires_at > starts_at)
);
create index memberships_user_id_idx on public.memberships (user_id, expires_at desc);

create table public.bookings (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  dog_id uuid not null,
  branch_id uuid not null references public.branches (id),
  treadmill_id uuid not null,
  program_id uuid references public.exercise_programs (id) on delete set null,
  membership_id uuid references public.memberships (id) on delete set null,
  start_at timestamptz not null,
  end_at timestamptz not null,
  status text not null default 'pending'
    check (status in ('pending', 'confirmed', 'checked_in', 'completed', 'cancelled', 'no_show')),
  note text check (char_length(note) <= 500),
  cancel_reason text check (char_length(cancel_reason) <= 200),
  cancelled_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint bookings_time_valid check (end_at > start_at),
  -- 예약자는 반드시 반려견의 보호자여야 한다
  constraint bookings_dog_owner_fkey foreign key (dog_id, user_id)
    references public.dogs (id, owner_id) on delete cascade,
  -- 트레드밀은 반드시 예약 지점 소속이어야 한다
  constraint bookings_treadmill_branch_fkey foreign key (treadmill_id, branch_id)
    references public.treadmills (id, branch_id),
  -- 같은 트레드밀의 시간 중복 예약 차단 (문서 8장: DB 제약조건으로 차단)
  constraint bookings_no_treadmill_overlap exclude using gist (
    treadmill_id with =,
    tstzrange(start_at, end_at, '[)') with &&
  ) where (status in ('pending', 'confirmed', 'checked_in')),
  -- 같은 반려견의 시간 중복 예약 차단
  constraint bookings_no_dog_overlap exclude using gist (
    dog_id with =,
    tstzrange(start_at, end_at, '[)') with &&
  ) where (status in ('pending', 'confirmed', 'checked_in'))
);
create index bookings_user_start_idx on public.bookings (user_id, start_at desc);
create index bookings_branch_start_idx on public.bookings (branch_id, start_at);
create index bookings_dog_start_idx on public.bookings (dog_id, start_at desc);

create table public.payments (
  id uuid primary key default gen_random_uuid(),
  -- 전자상거래 기록 보존을 위해 회원 탈퇴 시에도 결제 기록은 남긴다
  user_id uuid references public.users (id) on delete set null,
  booking_id uuid references public.bookings (id) on delete set null,
  membership_id uuid references public.memberships (id) on delete set null,
  order_id text unique,
  order_name text,
  amount integer not null check (amount >= 0), -- KRW
  method text,
  status text not null default 'pending'
    check (status in ('pending', 'paid', 'cancelled', 'refunded', 'partial_refunded', 'failed')),
  pg_provider text,
  pg_transaction_id text,
  refunded_amount integer not null default 0 check (refunded_amount >= 0),
  paid_at timestamptz,
  refunded_at timestamptz,
  created_at timestamptz not null default now(),
  constraint payments_refund_valid check (refunded_amount <= amount)
);
create index payments_user_created_idx on public.payments (user_id, created_at desc);

-- ---------------------------------------------------------------------
-- 5.3 운동 기록
-- ---------------------------------------------------------------------
create table public.exercise_sessions (
  id uuid primary key default gen_random_uuid(),
  dog_id uuid not null references public.dogs (id) on delete cascade,
  booking_id uuid unique references public.bookings (id) on delete set null,
  treadmill_id uuid references public.treadmills (id) on delete set null,
  status text not null default 'ready'
    check (status in ('ready', 'running', 'paused', 'completed', 'stopped')),
  started_at timestamptz,
  ended_at timestamptz,
  duration_seconds integer not null default 0 check (duration_seconds >= 0),
  distance_meters numeric(8, 1) not null default 0 check (distance_meters >= 0),
  current_speed numeric(4, 1) not null default 0 check (current_speed >= 0), -- km/h
  average_speed numeric(4, 1) check (average_speed >= 0), -- km/h
  max_speed numeric(4, 1) check (max_speed >= 0), -- km/h
  target_duration_seconds integer check (target_duration_seconds > 0),
  stop_reason text check (char_length(stop_reason) <= 200),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  constraint exercise_sessions_id_dog_key unique (id, dog_id)
);
create index exercise_sessions_dog_created_idx on public.exercise_sessions (dog_id, created_at desc);

create table public.pose_records (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.exercise_sessions (id) on delete cascade,
  camera_type text not null check (camera_type in ('front', 'side')),
  pose_file_path text,
  video_file_path text,
  fps numeric(6, 2) check (fps > 0),
  frame_count integer check (frame_count >= 0),
  created_at timestamptz not null default now(),
  constraint pose_records_session_camera_key unique (session_id, camera_type)
);

create table public.analysis_reports (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null,
  dog_id uuid not null references public.dogs (id) on delete cascade,
  analysis_status text not null default 'queued'
    check (analysis_status in ('queued', 'processing', 'completed', 'failed')),
  -- 지표 JSON 구조는 docs/analysis-metrics.md 참고
  joint_metrics jsonb,
  gait_metrics jsonb,
  anomaly_metrics jsonb,
  fatigue_metrics jsonb,
  summary text,
  care_notes jsonb not null default '[]'::jsonb check (jsonb_typeof(care_notes) = 'array'),
  skeleton_video_path text,
  report_pdf_path text,
  model_version text,
  error_message text,
  reviewed_by uuid references public.users (id) on delete set null,
  reviewed_at timestamptz,
  created_at timestamptz not null default now(),
  completed_at timestamptz,
  -- 리포트의 반려견은 세션의 반려견과 같아야 한다
  constraint analysis_reports_session_dog_fkey foreign key (session_id, dog_id)
    references public.exercise_sessions (id, dog_id) on delete cascade
);
create index analysis_reports_dog_created_idx on public.analysis_reports (dog_id, created_at desc);
create index analysis_reports_session_idx on public.analysis_reports (session_id, created_at desc);

create table public.exercise_plans (
  id uuid primary key default gen_random_uuid(),
  dog_id uuid not null references public.dogs (id) on delete cascade,
  program_name text not null,
  target_duration_seconds integer check (target_duration_seconds > 0),
  target_speed numeric(4, 1) check (target_speed > 0), -- km/h
  restrictions jsonb not null default '[]'::jsonb check (jsonb_typeof(restrictions) = 'array'),
  notes text,
  approved_by uuid references public.users (id) on delete set null,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);
create index exercise_plans_dog_idx on public.exercise_plans (dog_id, created_at desc);

-- ---------------------------------------------------------------------
-- 5.4 서비스 관리
-- ---------------------------------------------------------------------
create table public.notifications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  type text not null default 'general'
    check (type in ('general', 'booking', 'exercise', 'analysis', 'notice')),
  title text not null,
  body text not null default '',
  -- 딥링크용 데이터. 예: {"booking_id": "..."} / {"report_id": "..."}
  data jsonb not null default '{}'::jsonb,
  is_read boolean not null default false,
  created_at timestamptz not null default now()
);
create index notifications_user_created_idx on public.notifications (user_id, created_at desc);

-- 동의 이력은 변경 시마다 새 행을 추가한다 (최신 행이 현재 상태)
create table public.data_consents (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  consent_type text not null
    check (consent_type in ('terms', 'privacy', 'video_recording', 'ai_training', 'marketing')),
  consent_version text not null,
  granted boolean not null,
  responded_at timestamptz not null default now()
);
create index data_consents_user_type_idx
  on public.data_consents (user_id, consent_type, responded_at desc);

create table public.notices (
  id uuid primary key default gen_random_uuid(),
  branch_id uuid references public.branches (id) on delete cascade, -- NULL이면 전체 공지
  title text not null,
  body text not null,
  is_pinned boolean not null default false,
  published_at timestamptz not null default now(),
  created_at timestamptz not null default now()
);
create index notices_published_idx on public.notices (is_pinned desc, published_at desc);

create table public.faqs (
  id uuid primary key default gen_random_uuid(),
  category text not null,
  question text not null,
  answer text not null,
  sort_order integer not null default 0,
  is_active boolean not null default true
);

create table public.inquiries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  category text not null
    check (category in ('booking', 'payment', 'exercise', 'analysis', 'account', 'etc')),
  title text not null check (char_length(title) between 1 and 100),
  body text not null check (char_length(body) between 1 and 2000),
  status text not null default 'open' check (status in ('open', 'answered', 'closed')),
  answer text,
  answered_by uuid references public.users (id) on delete set null,
  answered_at timestamptz,
  created_at timestamptz not null default now()
);
create index inquiries_user_created_idx on public.inquiries (user_id, created_at desc);

-- ---------------------------------------------------------------------
-- updated_at 트리거
-- ---------------------------------------------------------------------
create trigger users_set_updated_at before update on public.users
  for each row execute function private.set_updated_at();
create trigger dogs_set_updated_at before update on public.dogs
  for each row execute function private.set_updated_at();
create trigger dog_health_profiles_set_updated_at before update on public.dog_health_profiles
  for each row execute function private.set_updated_at();
create trigger bookings_set_updated_at before update on public.bookings
  for each row execute function private.set_updated_at();
create trigger exercise_sessions_set_updated_at before update on public.exercise_sessions
  for each row execute function private.set_updated_at();
