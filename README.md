# PawFit — 반려견 AI 헬스장 (보호자 앱)

반려견 트레드밀 헬스장의 보호자용 모바일 앱입니다. 기획은 [DOCUMENT.md](DOCUMENT.md)를 따릅니다.
반려견 등록·건강 정보, 트레드밀 예약, 실시간 운동 현황, AI 보행 분석 리포트, 운동 이력을 제공합니다.

| 구분 | 사용 기술 |
|---|---|
| 앱 | Flutter 3.27 (Dart 3.6) · Android / iOS (개발 확인용 Web) |
| 상태 관리 / 라우팅 | flutter_riverpod 2.6 · go_router 16 |
| 백엔드 | Supabase — Postgres(RLS), Auth, Storage, Realtime, Edge Functions |
| 차트 / 영상 | fl_chart · video_player |

## 디자인

PawFit 로고([assets/logo](assets/logo))에서 뽑은 색을 씁니다.

| 색 | 값 | 로고 속 위치 | 역할 |
|---|---|---|---|
| 민트 | `#39AD8E` | "Fit" 글자 | 주요 버튼, 선택 상태 |
| 차콜 | `#232630` | "Paw" 글자·트레드밀 | 본문 글자, 히어로 카드 |
| 청록 | `#22BBB0` | 하트 | AI·건강 분석 영역, 정상 상태 |
| 허니 | `#FDC678` | 강아지 털 | 관찰 필요 상태, 반려견 아바타 |
| 코랄 | `#B6374B` | 혀(진하게) | 주의 필요 상태, 삭제·취소 |
| 크림 | `#FDFAF4` | 배경 | 기본 표면 |

- 원색은 밝아서 글자에 쓰면 대비가 부족합니다. 글자·버튼에는 명도만 낮춘 파생 톤(예: 버튼 민트 `#02755C`, 흰 글자 5.7:1)을 씁니다.
- 히어로 카드는 트레드밀 같은 차콜 면에, 로고 뒤 민트 덩어리를 닮은 두 원을 겹쳐 그립니다.
- 상태 색은 신호등처럼 단계적으로 진해집니다: 정상(청록) → 관찰 필요(허니) → 주의 필요(코랄).
- 앱 아이콘과 앱 안 브랜드 마크는 글자 없는 로고(`PawFit_without_letter.png`)로 만듭니다.
- 숫자·통계는 Outfit 폰트(OFL, `assets/fonts`), 한글은 각 플랫폼 시스템 폰트를 씁니다.
- 라이트/다크 모드는 시스템 설정을 따릅니다. 색 정의는 [app_colors.dart](lib/core/theme/app_colors.dart), [app_theme.dart](lib/core/theme/app_theme.dart)에 있습니다.

## 구조

```
lib/
  core/        설정(env), 테마, 라우터, Supabase Provider, 공통 위젯·유틸
  features/
    auth/          로그인 · 회원가입(필수/선택 동의 분리)
    home/          홈 대시보드
    dogs/          반려견 등록·수정·상세·전환
    booking/       예약 생성·내역·상세·변경·취소
    exercise/      실시간 운동 현황(Realtime) · 운동 기록
    health/        건강 대시보드 · AI 분석 리포트 · 영상 재생
    membership/    이용권 · 결제 내역
    notifications/ 알림(Realtime)
    consents/      개인정보·영상 이용 동의 관리
    mypage/        마이페이지 · 프로필/비밀번호 · 알림 설정
    support/       공지 · FAQ · 1:1 문의
supabase/
  migrations/  스키마 · RLS · 예약/운동 RPC · 알림 트리거 · Storage · Realtime
  functions/   delete-account (회원 탈퇴)
  tests/       pgTAP 테스트
  seed.sql     로컬 개발용 샘플 데이터 (트레드밀·이용권 상품·FAQ·공지)
docs/          AI 서버 결과 저장 규격
test/          단위·위젯 테스트, 로컬 Supabase 통합 테스트
```

## 실행

### 1. Supabase 프로젝트에 스키마 적용

```bash
npx supabase link --project-ref <project-ref>
npx supabase db push                          # supabase/migrations 적용
npx supabase functions deploy delete-account  # 회원 탈퇴 함수
```

- 지점 3곳과 운동 프로그램 6개는 마이그레이션(`20261110000200_branches_and_programs.sql`)으로 함께 들어갑니다.
- `seed.sql`은 샘플 데이터라 원격에는 자동 적용되지 않습니다. 트레드밀 기기와 이용권 상품은 실제 값으로 넣어 주세요. 트레드밀이 없는 지점은 모든 시간이 마감으로 보입니다.
- 운영자 계정은 `public.users.role = 'admin'`으로 지정하고, 담당 지점이 있으면 `managed_branch_id`를 넣습니다(NULL이면 전 지점).

### 2. 앱 실행

프로젝트 루트의 `.env`(커밋 금지, [.env.example](.env.example) 참고)에 값을 넣고 실행합니다.

```bash
# .env
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_PUBLISHABLE_KEY=sb_publishable_...

flutter run --dart-define-from-file=.env
```

`.env` 없이 실행하면 설정 안내 화면이 뜹니다. 기존 anon 키를 쓰는 경우 `SUPABASE_ANON_KEY`도 인식합니다.

### 로컬 Supabase로 개발 (Docker 필요)

```bash
npx supabase start      # 처음 실행 시 마이그레이션과 seed.sql 적용
npx supabase db reset   # 스키마 변경 후 다시 적용
npx supabase status -o env
```

로컬 Auth는 이메일 인증 없이 바로 가입됩니다. 원격 프로젝트에서 이메일 인증을 켜 두면 가입 후 "인증 메일을 보냈어요" 안내가 뜹니다.

## 테스트

| 명령 | 내용 |
|---|---|
| `flutter analyze` | 정적 분석 (strict-casts, strict-raw-types) |
| `flutter test` | 단위·위젯 테스트 46개 (통합 테스트는 키가 없으면 건너뜀) |
| `npx supabase test db` | pgTAP 49개: RLS 격리, 중복 예약 차단, 24시간 지점(자정 넘김 예약), 이용권 차감·복구, 운동 세션, 알림 설정 |
| `flutter test test/integration --dart-define-from-file=<로컬 키 파일>` | 로컬 Supabase 대상 12개: 저장소 계층 전체, Realtime, Storage, Edge Function |

통합 테스트 키 파일에는 `SUPABASE_URL`, `SUPABASE_PUBLISHABLE_KEY`, `SUPABASE_SERVICE_ROLE_KEY`가 필요하며,
안전을 위해 `localhost`/`127.0.0.1`이 아니면 실행하지 않습니다.

## DOCUMENT.md 대비 구현 범위

| 항목 | 상태 |
|---|---|
| 10장 우선 개발 화면 12개 | 완료 (로그인~마이페이지) |
| 3.5 마이페이지 하위 기능 (프로필, 계정, 알림 설정, 탈퇴, 반려견 관리, 이용 내역, 공지, FAQ, 문의, 동의 관리) | 완료 |
| 5장 DB · 6장 Storage · 8장 권한 | 완료 (RLS, 서버 측 예약·관리자 검증, 영상/AI 학습 동의 분리) |
| 3.3 실시간 운동 현황 | 완료 (Realtime 구독, 영상은 전송하지 않음) |
| 3.4 AI 리포트 UI · 3.4-D 피로 징후 | UI 완료 / 피로 징후는 문서대로 추후 개발 |
| 결제(PG) 연동 | **미구현** — PG사 결정 필요. 현재는 지점 데스크 구매 + 앱 예약 시 이용권 차감 또는 현장 결제(예약 대기) |
| FCM 푸시 | **미구현** — Firebase 프로젝트 필요. 알림은 DB 트리거 → 앱 내 알림함(Realtime)으로 동작 |
| 운영자 대시보드 (Flutter Web) | **미구현** — 필요한 DB 함수는 준비됨 (아래) |
| AI 서버 (FastAPI) | **미구현** — 결과 저장 규격: [docs/analysis-metrics.md](docs/analysis-metrics.md) |

### 운영자 대시보드·트레드밀 연동용 DB 함수

관리자 계정으로 호출하며, 담당 지점 권한을 DB에서 검증합니다.

| 함수 | 용도 |
|---|---|
| `check_in_booking(booking_id)` | 체크인 |
| `start_exercise_session(booking_id)` | 운동 시작 (보호자 앱에 실시간 반영, 시작 알림) |
| `update_exercise_session_metrics(session_id, speed, distance, duration, status)` | 실시간 지표 갱신, 일시정지/재개 |
| `finish_exercise_session(session_id, completed, stop_reason)` | 종료/중단, 평균 속도 계산, 동의 시 AI 분석 대기열 등록 |
| `mark_booking_no_show(booking_id)` | 미방문 처리 |

## 스키마 변경 사항 (DOCUMENT.md 5장 대비)

- **추가 테이블**: `exercise_programs`(예약 시 프로그램 선택), `membership_plans`(이용권 상품), `notices`, `faqs`, `inquiries`
- `users`: `managed_branch_id`(관리자 담당 지점), `notification_prefs`(알림 설정)
- `dogs`: `profile_image_url` → `profile_image_path`(비공개 버킷 경로, 서명 URL로 표시), `neutered`, `deleted_at`(소프트 삭제)
- `bookings`: `branch_id`, `program_id`, `membership_id`, `note`, 취소 정보. 같은 트레드밀·같은 반려견의 시간 중복을 배제 제약조건으로 차단
- `exercise_sessions`: `current_speed`, `target_duration_seconds`, `stop_reason`, `updated_at`(실시간 표시용)
- `analysis_reports`: `care_notes`, `skeleton_video_path`, `report_pdf_path`, `error_message`, 검토자 정보, `completed_at`
- `payments`: `order_id`, `method`, 환불 금액·일시. 금액은 원 단위 정수
- `notifications`: `type`, `data`(딥링크용) / `data_consents`: 동의 유형 `terms`·`privacy`·`video_recording`·`ai_training`·`marketing`

## 확인이 필요한 운영 정책 (현재 기본값)

| 항목 | 기본값 | 변경 위치 |
|---|---|---|
| 지점 운영 시간 | 몰 영업시간을 따름: 용산 10:30~20:30(매장 구역 미정이라 가장 이른 마감 기준), 고양 10:00~22:00, 영등포 10:30~22:00. 요일별·명절 예외 시간은 지원하지 않음 | `branches.opens_at`·`closes_at` |
| 24시간 지점 | 00:00~24:00으로 넣으면 `is_24_hours`가 켜져 하루 전체 슬롯과 자정을 넘기는 예약을 받음 (현재 해당 지점 없음) | `branches.is_24_hours` |
| 운동 프로그램 속도 | 비워 둠(체격별 적정 속도 차이가 커서 숫자 하나로 안내하지 않음) | `exercise_programs.target_speed_kmh` |
| 보호자 변경·취소 마감 | 예약 시작 1시간 전 | `private.booking_change_deadline()`, `Booking.changeDeadline` |
| 이용권 없이 예약 | 예약 대기(현장 결제) 상태로 접수 | `create_booking` |
| 취소 시 이용권 | 사용한 1회 복구 | `cancel_booking` |
| AI 분석 | 영상 촬영 동의자만 대기열 등록 | `finish_exercise_session` |
| 회원 탈퇴 시 결제 기록 | `user_id`만 비우고 보관 | `payments.user_id on delete set null` |
| 반려견 삭제 | 소프트 삭제(이력 보존) | `dogs.deleted_at` |
| 시간대 | Asia/Seoul (지점별 `timezone`) | `branches.timezone` |

## 배포 전 할 일

- 번들 ID 변경 (현재 `com.example.dog_treadmill_app`), 스플래시 화면
- 약관·개인정보 처리방침 전문 연결 (현재 회원가입 화면에는 요약 문구만 있음)
- 원격 Auth의 이메일 인증을 켜는 경우 모바일 딥링크 리디렉션 설정
