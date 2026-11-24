# PawFit — 반려견 AI 헬스장 (보호자 앱)

반려견 트레드밀 헬스장의 보호자용 모바일 앱입니다. 기획은 [DOCUMENT.md](DOCUMENT.md)를 따릅니다.
반려견 등록·건강 정보, 트레드밀 예약, 실시간 운동 현황, AI 보행 분석 리포트, 운동 이력,
월간 랭킹·배지·명예의 전당([docs/ranking.md](docs/ranking.md))을 제공합니다.
실제 서버 없이 시연할 수 있는 [데모 앱(목업 서버)](#데모-앱-목업-서버)을 같은 저장소에 함께 둡니다.
화면은 한국어(기본)와 English를 지원합니다([언어](#언어-한국어--english)).

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

## 언어 (한국어 · English)

실제 앱과 데모 앱 모두 한국어(기본)와 영어를 지원합니다. 마이페이지 › 설정 › **언어 (Language)** 또는
로그인 화면 오른쪽 위 언어 버튼에서 바꾸고, 선택한 언어는 기기에 저장됩니다(로그인과 무관).

- 화면 문구는 `lib/l10n/app_ko.arb`·`app_en.arb`에 있고 `flutter gen-l10n`이 `lib/l10n/generated/`를 만듭니다.
  문구 추가 규칙, 키 이름, 영어 용어집은 [docs/i18n.md](docs/i18n.md)에 있습니다.
- 서버 텍스트(지점·운동 프로그램·이용권 상품·공지·FAQ·견종·질병·배지·AI 리포트)는 같은 이름에 `_en`을 붙인
  컬럼의 영어를 보여 주고, 비어 있으면 한국어를 보여 줍니다. 운영자가 새 콘텐츠를 넣을 때 영어 컬럼도 채워 주세요.
- 알림은 DB 트리거가 문구 종류와 값(`data.msg`·`data.args`)을 함께 저장하고 앱이 현재 언어로 문구를 만듭니다.
  언어를 바꾸면 지난 알림도 새 언어로 보입니다.
- 영어 화면에서 가입하면 랭킹 닉네임도 영어로 자동 생성됩니다(예: `SunnyPaw382`).
- iOS 권한 안내(카메라·사진 보관함)는 앱 설정이 아니라 기기 언어를 따릅니다(`ios/Runner/{ko,en}.lproj/InfoPlist.strings`).

## 구조

```
lib/
  main.dart      실제 앱 진입점 (Supabase)
  main_demo.dart 데모 앱 진입점 (목업 서버. Supabase·config/supabase.env 없이 실행)
  core/        설정(env), 테마, 라우터, Supabase Provider, 공통 위젯·유틸
  l10n/        다국어 문구(ARB: 한국어·English) · 언어 설정 · 생성 코드(generated/)
  features/
    auth/          로그인 · 회원가입(필수/선택 동의 분리)
    home/          홈 대시보드
    dogs/          반려견 등록·수정·상세·전환
    booking/       예약 생성·내역·상세·변경·취소
    exercise/      실시간 운동 현황(Realtime) · 운동 기록
    health/        건강 대시보드 · AI 분석 리포트 · 영상 재생
    membership/    이용권 · 결제 내역
    notifications/ 알림(Realtime)
    consents/      개인정보·영상 이용·랭킹 참여 동의 관리
    mypage/        마이페이지 · 프로필/비밀번호 · 알림 설정
    ranking/       월간 랭킹 · 지점 대항전 · 명예의 전당 · 배지함 · 응원 · 자랑하기 · 매장 랭킹 보드
    support/       공지 · FAQ · 1:1 문의
  demo/        데모 앱 전용 (실제 앱은 import하지 않음)
    mock_server/   목업 서버: 인메모리 테이블 · 예약/점수/랭킹 규칙 · 트레드밀·AI 서버 시뮬레이터 · 샘플 데이터
    demo_*.dart    목업 저장소 · 데모 로그인 · Provider 교체 · DEMO 버튼과 데모 컨트롤
supabase/
  migrations/  스키마 · RLS · 예약/운동 RPC · 알림 트리거 · Storage · Realtime · 랭킹 점수·배지·월간 마감
  functions/   delete-account (회원 탈퇴)
  tests/       pgTAP 테스트
  seed.sql     로컬 개발용 샘플 데이터 (이용권 상품·FAQ·공지, 랭킹 샘플 계정·운동 기록)
docs/          개발계획서 · 기능명세서 · 앱 연동 인터페이스(기기·AI 서버) · 랭킹·배지 규격 · 다국어 규칙(i18n.md)
device/        트레드밀 기기(Jetson Orin Nano) 테스트 클라이언트와 연동 방법
test/          단위·위젯 테스트, 로컬 Supabase 통합 테스트
```

## 실행

### 1. Supabase 프로젝트에 스키마 적용

```bash
npx supabase link --project-ref <project-ref>
npx supabase db push                          # supabase/migrations 적용
npx supabase functions deploy delete-account  # 회원 탈퇴 함수
```

- 지점 3곳, 운동 프로그램 6개, 트레드밀 30대(용산 8 · 고양 12 · 영등포 10)는 마이그레이션으로 함께 들어갑니다.
- `seed.sql`은 샘플 데이터라 원격에는 자동 적용되지 않습니다. 이용권 상품은 실제 값으로 넣어 주세요.
- 운영자 계정은 `public.users.role = 'admin'`으로 지정하고, 담당 지점이 있으면 `managed_branch_id`를 넣습니다(NULL이면 전 지점).

### 2. 앱 실행

`config/supabase.env`(커밋 금지, [config/supabase.env.example](config/supabase.env.example)을 복사)에 값을 넣고 그냥 실행합니다.
앱이 시작할 때 이 파일을 읽으므로 `--dart-define` 플래그가 필요 없습니다.

```bash
# config/supabase.env
SUPABASE_URL=https://<project-ref>.supabase.co
SUPABASE_PUBLISHABLE_KEY=sb_publishable_...

flutter run
```

파일이 없으면 설정 안내 화면이 뜹니다. 기존 anon 키를 쓰는 경우 `SUPABASE_ANON_KEY`도 인식합니다.
배포·CI 빌드에서는 `--dart-define-from-file=<파일>`로 넣은 값이 파일보다 먼저 쓰입니다.
저장소가 공개라서 키 파일만 git 밖에 둡니다 (publishable 키는 앱에 들어가는 공개용 키이고, 데이터는 RLS가 지킵니다).

### 로컬 Supabase로 개발 (Docker 필요)

```bash
npx supabase start      # 처음 실행 시 마이그레이션과 seed.sql 적용
npx supabase db reset   # 스키마 변경 후 다시 적용
npx supabase status -o env
```

로컬 Auth는 이메일 인증 없이 바로 가입됩니다. 원격 프로젝트에서 이메일 인증을 켜 두면 가입 후 "인증 메일을 보냈어요" 안내가 뜹니다.

로컬 `seed.sql`에는 랭킹 샘플 보호자 6명(`sample1@pawfit.local` ~ `sample6@pawfit.local`, 비밀번호 `pawfit1234`)과
지난달~오늘 운동 기록이 들어 있어, 로그인하면 순위표·배지함·명예의 전당을 바로 볼 수 있습니다.

## 데모 앱 (목업 서버)

실제 서버 없이 앱이 어떻게 돌아가는지 보여 주는 데모 앱입니다. 화면 코드는 실제 앱과 같고, 서버에 닿는 부분
(저장소·로그인·Realtime)만 앱 안의 목업 서버로 바꿉니다. 인터넷·Supabase·`config/supabase.env` 없이 실행되고 실제 데이터를 건드리지 않습니다.

```bash
flutter run -t lib/main_demo.dart          # 데모 앱
flutter run                                # 실제 앱 (config/supabase.env 필요)
```

VS Code 실행 구성에는 「PawFit 데모 (목업 서버)」가 있습니다.

| | 실제 앱 | 데모 앱 |
|---|---|---|
| 진입점 | `lib/main.dart` | `lib/main_demo.dart` |
| 서버 | Supabase (원격·로컬) | `lib/demo/mock_server` (앱 메모리) |
| Android 설치 | `com.example.dog_treadmill_app` · PawFit | `com.example.dog_treadmill_app.demo` · PawFit 데모 (영어 기기: PawFit Demo) |
| 데이터 | 실제 회원 데이터 | 샘플 데이터. 앱을 다시 켜면 처음 상태 |

- **분리**: 실제 앱 코드는 `lib/demo/`를 import하지 않습니다(`test/demo/separation_test.dart`가 검사). 그래서 실제 앱 빌드에는 목업 서버·샘플 데이터가 들어가지 않습니다. Android는 진입점이 `main_demo.dart`면 패키지 이름을 바꿔(`android/app/build.gradle`) 한 기기에 두 앱을 함께 설치할 수 있습니다. iOS는 번들 ID를 나누지 않아 데모를 설치하면 실제 앱을 덮어씁니다.
- **목업 서버**: 테이블은 실제와 같은 이름·컬럼의 JSON 행이라 모델의 `fromJson`을 그대로 씁니다. 예약·QR 체크인·이용권 차감·점수·배지·순위·응원·닉네임 규칙과 오류 코드(`SLOT_FULL` 등)는 DB 함수를 옮긴 것이라 안내 문구도 실제와 같습니다.
- **아직 연동 전인 장치 흉내**: 트레드밀 기기(QR 체크인 3초 뒤 보호자가 시작 버튼을 누른 것으로 보고 운동 시작, 매초 속도·거리 갱신, 기본 10배속)와 AI 서버(운동이 끝나고 8초 뒤 보행 분석 리포트)를 시뮬레이션합니다.
- **데모 계정**: `demo@pawfit.local` / `pawfit1234` (보호자 이서연, 반려견 두부·망고). 로그인 화면의 「DEMO · 데모 계정으로 시작」을 누르면 바로 로그인됩니다. 회원가입도 목업 서버에 새 계정을 만듭니다.
- **데모 컨트롤**: 화면에 떠 있는 DEMO 버튼(끌어서 옮길 수 있음)으로 운동 시작·일시정지·비상정지·바로 완료, 시뮬레이션 속도, AI 분석 바로 끝내기, 다른 보호자 응원 받기, 처음 상태로 되돌리기를 합니다.
- **시연 순서 예**: 홈에서 곧 시작하는 예약을 QR 체크인(데모는 카메라 대신 스캔할 트레드밀을 고름) → 운동 탭 실시간 기록 → 끝나면 점수 알림과 배지 → 몇 초 뒤 AI 리포트 → 랭킹 점수 변화. 두부는 29번 운동한 상태라 데모에서 한 번 더 하면 「단골 러너」(30회) 배지를 받습니다.
- **데모에 없는 것**: 운동 영상 재생(샘플 영상 없음), 결제(실제 앱도 준비 중), 푸시 알림. 올린 사진은 앱 메모리에만 있습니다.
- **웹으로 공유**: `flutter build web -t lib/main_demo.dart`로 만든 `build/web`을 정적 호스팅에 올리면 링크로 시연할 수 있습니다.
- **규칙을 바꿀 때**: DB 함수(예약·점수·랭킹 등)를 바꾸면 `lib/demo/mock_server/`의 같은 규칙도 고치고 `flutter test test/demo`로 확인합니다.

## 테스트

| 명령 | 내용 |
|---|---|
| `flutter analyze` | 정적 분석 (strict-casts, strict-raw-types) |
| `flutter test` | 단위·위젯 테스트 169개(영어 화면 포함) (통합 테스트는 키가 없으면 건너뜀) |
| `flutter test test/demo` | 그중 데모 앱 34개: 목업 서버 규칙(예약·체크인·점수·배지·순위·응원·닉네임·인증), 데모 시연 흐름, 실제 앱↔데모 코드 분리 |
| `npx supabase test db` | pgTAP 218개: RLS 격리, 중복 예약 차단, 24시간 지점(자정 넘김 예약), QR 체크인(기기 이동·QR 토큰 비공개), 이용권 차감·복구, 운동 세션, 알림 설정, 랭킹(점수 규칙·하루 1회·주간 보너스·한국 시간 월 경계·공개 범위·닉네임·응원·배지·무효 처리·월간 마감, 영어 콘텐츠·영어 라벨·알림 msg/args·영어 닉네임) |
| `flutter test test/integration --dart-define-from-file=<로컬 키 파일>` | 로컬 Supabase 대상 21개: 저장소 계층 전체, Realtime, Storage(랭킹 공개 사진 포함), Edge Function, 랭킹 흐름 |

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
| 결제(PG) 연동 | **형식만** — 예약 결제 단계와 이용권 구매 시트에 "앱 결제(준비 중)" 자리만 있음. PG사 결정 필요. 현재는 매장 구매 이용권 차감 또는 현장 결제(예약은 바로 확정) |
| FCM 푸시 | **미구현** — Firebase 프로젝트 필요. 알림은 DB 트리거 → 앱 내 알림함(Realtime)으로 동작 |
| 운영자 대시보드 (Flutter Web) | **미구현** — 필요한 DB 함수는 준비됨 (아래) |
| AI 서버 (FastAPI) | **미구현** — 결과 저장 규격: [docs/app-interface.md](docs/app-interface.md) 4장 |

### 무인 운영 흐름 (DOCUMENT.md 3.3 대비)

매장에 직원이 없어 문서의 "현장 운영자" 역할을 보호자와 트레드밀 기기가 나눠 맡습니다.

0. 예약은 결제 방식(이용권·현장 결제)과 상관없이 바로 **예약 확정**됩니다. 승인하는 사람이 없습니다.
1. 보호자가 매장에서 운동할 트레드밀의 QR을 앱으로 스캔해 체크인합니다: `check_in_with_treadmill_qr(booking_id, qr_token)`. 본인 예약, 시작 15분 전부터 종료 전까지 가능합니다. 배정된 기기가 아니어도 그 시간에 비어 있으면 예약을 스캔한 기기로 옮깁니다. QR 토큰은 API에 노출되지 않는 `private.treadmill_qr_codes`에만 있어 매장에 가야 체크인할 수 있습니다.
2. 보호자가 그 트레드밀의 시작 버튼으로 운동을 시작하고, 이상하면 기기의 비상정지 버튼을 누릅니다. 앱은 조회 중심입니다.
3. 트레드밀 기기는 지점 관리자 계정(`managed_branch_id`)으로 아래 함수를 호출해 세션을 기록합니다. Jetson Orin Nano 테스트 방법과 테스트 스크립트는 [device/README.md](device/README.md)에 있습니다.

### 운영자 대시보드·트레드밀 기기용 DB 함수

관리자 계정으로 호출하며, 담당 지점 권한을 DB에서 검증합니다.

| 함수 | 용도 |
|---|---|
| `get_treadmill_qr(treadmill_id)` | 기기 화면에 띄우거나 스티커로 출력할 QR 내용 `pawfit://treadmill?code=<토큰>` |
| `get_treadmill_active_booking(treadmill_id)` | 이 기기에서 QR 체크인한 예약 (반려견 이름·프로그램·진행 중 세션) |
| `check_in_booking(booking_id)` | 체크인 (대시보드용. 보호자는 `check_in_with_treadmill_qr`) |
| `start_exercise_session(booking_id)` | 운동 시작 — 기기의 시작 버튼 (보호자 앱에 실시간 반영, 시작 알림) |
| `update_exercise_session_metrics(session_id, speed, distance, duration, status)` | 실시간 지표 갱신, 일시정지/재개 |
| `finish_exercise_session(session_id, completed, stop_reason)` | 종료/중단, 평균 속도 계산, 동의 시 AI 분석 대기열 등록 |
| `mark_booking_no_show(booking_id)` | 미방문 처리 |

## 스키마 변경 사항 (DOCUMENT.md 5장 대비)

- **추가 테이블**: `exercise_programs`(예약 시 프로그램 선택), `membership_plans`(이용권 상품), `notices`, `faqs`, `inquiries`
- **랭킹 테이블**: `exercise_points`(점수 원장), `badges`·`dog_badges`, `ranking_cheers`, `monthly_awards`·`ranking_closings` ([docs/ranking.md](docs/ranking.md))
- `users`: `managed_branch_id`(관리자 담당 지점), `notification_prefs`(알림 설정), `nickname`·`nickname_updated_at`·`ranking_show_photo`(랭킹)
- `dogs`: `profile_image_url` → `profile_image_path`(비공개 버킷 경로, 서명 URL로 표시), `neutered`, `deleted_at`(소프트 삭제)
- `bookings`: `branch_id`, `program_id`, `membership_id`, `note`, 취소 정보. 같은 트레드밀·같은 반려견의 시간 중복을 배제 제약조건으로 차단
- `exercise_sessions`: `current_speed`, `target_duration_seconds`, `stop_reason`, `updated_at`(실시간 표시용)
- `analysis_reports`: `care_notes`, `skeleton_video_path`, `report_pdf_path`, `error_message`, 검토자 정보, `completed_at`
- `payments`: `order_id`, `method`, 환불 금액·일시. 금액은 원 단위 정수
- `notifications`: `type`(`ranking` 포함), `data`(딥링크용) / `data_consents`: 동의 유형 `terms`·`privacy`·`video_recording`·`ai_training`·`ranking`·`marketing`

## 확인이 필요한 운영 정책 (현재 기본값)

| 항목 | 기본값 | 변경 위치 |
|---|---|---|
| 지점 운영 시간 | 몰 영업시간을 따름: 용산 10:30~20:30(매장 구역 미정이라 가장 이른 마감 기준), 고양 10:00~22:00, 영등포 10:30~22:00. 요일별·명절 예외 시간은 지원하지 않음 | `branches.opens_at`·`closes_at` |
| 24시간 지점 | 00:00~24:00으로 넣으면 `is_24_hours`가 켜져 하루 전체 슬롯과 자정을 넘기는 예약을 받음 (현재 해당 지점 없음) | `branches.is_24_hours` |
| 운동 프로그램 속도 | 비워 둠(체격별 적정 속도 차이가 커서 숫자 하나로 안내하지 않음) | `exercise_programs.target_speed_kmh` |
| 보호자 변경·취소 마감 | 예약 시작 1시간 전 | `private.booking_change_deadline()`, `Booking.changeDeadline` |
| 이용권 없이 예약 | 현장 결제로 예약하면 바로 예약 확정, 이용 당일 매장에서 결제. 앱 결제는 준비 중 | `create_booking` |
| QR 체크인 | 예약 시작 15분 전 ~ 종료 전. 매장 트레드밀 QR을 스캔해야 하고, 비어 있는 다른 기기를 스캔하면 그 기기로 옮김 | `private.check_in_opens_before()`, `check_in_with_treadmill_qr` |
| 취소 시 이용권 | 사용한 1회 복구 | `cancel_booking` |
| AI 분석 | 영상 촬영 동의자만 대기열 등록 | `finish_exercise_session` |
| 회원 탈퇴 시 결제 기록 | `user_id`만 비우고 보관 | `payments.user_id on delete set null` |
| 반려견 삭제 | 소프트 삭제(이력 보존) | `dogs.deleted_at` |
| 시간대 | Asia/Seoul (지점별 `timezone`) | `branches.timezone` |
| 랭킹 점수 | 출석 10 + 달성 최대 10 + 거리 100m당 1(최대 20), 주 2회 운동 시 보너스 20. 5분 미만 0점, 반려견당 하루 1회, 중단 감점 없음 | `private.award_session_points` ([docs/ranking.md](docs/ranking.md)) |
| 랭킹 수상 보상 | 배지·칭호·명예의 전당만 (경품 없음) | - |

## 배포 전 할 일

- 번들 ID 변경 (현재 `com.example.dog_treadmill_app`), 스플래시 화면
- 약관·개인정보 처리방침 전문 연결 (현재 회원가입 화면에는 요약 문구만 있음)
- 원격 Auth의 이메일 인증을 켜는 경우 모바일 딥링크 리디렉션 설정
- 영어 지원 마이그레이션(`20261117000100_english_content.sql`) 원격 적용(`npx supabase db push`) 후,
  원격에 따로 넣은 이용권 상품·공지·FAQ의 영어 컬럼(`*_en`) 채우기
