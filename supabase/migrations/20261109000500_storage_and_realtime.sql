-- =====================================================================
-- Storage (DOCUMENT.md 6장) — 모든 버킷 Private
--   dog-profiles/{user_id}/{dog_id}/{file}        보호자 업로드
--   exercise-videos/{dog_id}/{session_id}/{file}  AI 서버(service_role) 업로드
--   pose-data/{dog_id}/{session_id}/{file}        AI 서버 전용
--   analysis-reports/{dog_id}/{report_id}/{file}  AI 서버(service_role) 업로드
-- =====================================================================

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('dog-profiles', 'dog-profiles', false, 5242880,
    array['image/jpeg', 'image/png', 'image/webp', 'image/heic']),
  ('exercise-videos', 'exercise-videos', false, null,
    array['video/mp4', 'video/quicktime', 'video/webm']),
  ('pose-data', 'pose-data', false, null, null),
  ('analysis-reports', 'analysis-reports', false, null,
    array['application/pdf', 'image/png', 'image/jpeg'])
on conflict (id) do nothing;

-- dog-profiles: 본인 폴더({user_id}/...)만 읽기/쓰기
create policy dog_profiles_select on storage.objects
  for select to authenticated
  using (
    bucket_id = 'dog-profiles'
    and ((storage.foldername(name))[1] = (select auth.uid())::text or (select private.is_admin()))
  );

create policy dog_profiles_insert on storage.objects
  for insert to authenticated
  with check (
    bucket_id = 'dog-profiles'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy dog_profiles_update on storage.objects
  for update to authenticated
  using (
    bucket_id = 'dog-profiles'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  )
  with check (
    bucket_id = 'dog-profiles'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

create policy dog_profiles_delete on storage.objects
  for delete to authenticated
  using (
    bucket_id = 'dog-profiles'
    and (storage.foldername(name))[1] = (select auth.uid())::text
  );

-- exercise-videos / analysis-reports: 반려견 보호자와 관리자만 읽기
create policy exercise_videos_select on storage.objects
  for select to authenticated
  using (
    bucket_id = 'exercise-videos'
    and (private.owns_dog_path((storage.foldername(name))[1]) or (select private.is_admin()))
  );

create policy analysis_reports_select on storage.objects
  for select to authenticated
  using (
    bucket_id = 'analysis-reports'
    and (private.owns_dog_path((storage.foldername(name))[1]) or (select private.is_admin()))
  );

-- pose-data: 원본 관절 좌표는 관리자만 조회 (보호자 앱은 리포트 지표를 사용)
create policy pose_data_select on storage.objects
  for select to authenticated
  using (bucket_id = 'pose-data' and (select private.is_admin()));

-- =====================================================================
-- Realtime: 운동 상태·알림·분석 상태·예약 상태 변경을 앱에 전달
-- (영상은 Realtime으로 보내지 않는다 — 문서 7장)
-- =====================================================================
alter publication supabase_realtime add table
  public.exercise_sessions,
  public.notifications,
  public.analysis_reports,
  public.bookings;
