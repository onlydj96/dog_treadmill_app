# 반려견 AI 헬스장 모바일 앱 개발 기획서

## 1. 프로젝트 개요

### 서비스 목적
반려견 전용 트레드밀 헬스장에서 보호자가 운동을 예약하고, AI 기반 보행 분석 결과와 운동 이력을 관리할 수 있는 모바일 애플리케이션 개발.

### 핵심 기능
1. 반려견 프로필 및 건강 정보 관리
2. 트레드밀 예약 및 이용권 결제
3. 실시간 운동 현황 확인
4. AI 관절·보행 분석 리포트
5. 운동 이력 및 건강 변화 추적
6. 맞춤형 운동 프로그램 추천

### 기술 스택
- **Frontend:** Flutter (Android / iOS)
- **State Management:** Riverpod
- **Routing:** GoRouter
- **Backend / Database:** Supabase (PostgreSQL)
- **Authentication:** Supabase Auth
- **File Storage:** Supabase Storage
- **Realtime:** Supabase Realtime
- **Server Logic:** Supabase Edge Functions
- **AI Server:** Python, FastAPI, PyTorch
- **AI Models:** YOLO Pose, TCN / ST-GCN, XGBoost
- **Push Notification:** Firebase Cloud Messaging (FCM)

---

## 2. 사용자 유형

### 보호자 (User)
- 본인의 반려견 등록 및 관리
- 운동 예약 및 결제
- 운동 진행 상황 확인
- AI 분석 리포트 조회
- 운동 이력 및 건강 상태 변화 확인

### 헬스장 운영자 (Admin)
- 회원 및 반려견 관리
- 예약 및 이용권 관리
- 트레드밀 기기 관리
- 운동 세션 시작·종료
- AI 분석 결과 확인
- 매출 및 이용 현황 관리

운영자 기능은 Flutter Web 기반 별도 대시보드로 구성하는 것을 권장.

---

## 3. Flutter 앱 화면 구성

### 하단 Navigation Bar

**Home / Reservation / Exercise / Health / My Page**

### 3.1 Home (홈)

**목적:** 반려견의 주요 정보와 현재 운동 상태를 한눈에 확인.

주요 기능:
- 선택한 반려견 프로필 표시
- 다견 등록 시 반려견 전환
- 다음 운동 예약 정보
- 최근 운동 기록
- 최근 AI 보행 분석 요약
- 운동 관련 공지 및 알림
- 빠른 예약 버튼

### 3.2 Reservation (예약)

**목적:** 반려견 트레드밀 이용 예약 및 결제.

주요 기능:
- 헬스장 지점 선택
- 날짜 및 이용 시간 선택
- 트레드밀 예약 가능 여부 확인
- 운동 프로그램 선택
- 이용권 및 멤버십 적용
- 예약 확정
- 예약 변경 및 취소
- 예약 내역 조회
- 결제 및 환불 내역

예약 상태:
- Pending: 예약 대기
- Confirmed: 예약 확정
- Checked-in: 체크인 완료
- Completed: 이용 완료
- Cancelled: 취소
- No-show: 미방문

### 3.3 Exercise (운동)

**목적:** 현재 운동 진행 상황과 과거 운동 기록 확인.

#### 운동 진행 화면
- 반려견 이름
- 트레드밀 기기 번호
- 운동 시작 시간
- 운동 경과 시간
- 현재 트레드밀 속도
- 이동 거리
- 운동 진행 상태
- 운동 완료 알림

#### 운동 기록 화면
- 날짜별 운동 기록
- 총 운동 시간
- 평균 및 최고 속도
- 총 이동 거리
- 운동 중단 사유
- AI 분석 리포트 연결

※ 트레드밀의 실제 구동과 비상정지는 현장 운영자가 관리하며, 모바일 앱은 기본적으로 조회 기능 중심으로 구성.

### 3.4 Health (AI 건강 분석)

**목적:** AI로 분석한 반려견의 보행 패턴과 운동 중 변화를 확인.

#### A. AI Pose 분석
- 15개 관절 Keypoint 추적
- 관절 스켈레톤 영상
- 관절별 움직임 정보
- 관절 각도 변화
- 관절 가동 범위(ROM)

#### B. 보행 패턴 분석
- 걸음걸이 주기
- 좌우 움직임 대칭성
- 보행 리듬
- 보행 패턴 변동성
- 과거 정상 보행 기준선과 비교

#### C. 이상 움직임 탐지
- 평소와 다른 관절 패턴 감지
- 좌우 다리 움직임 차이
- 비정상적 보행 패턴 알림
- 분석 신뢰도 및 주의사항 표시

#### D. 피로 징후 분석 — 추후 개발
- 운동 시간에 따른 관절 움직임 변화
- 보행 리듬 및 안정성 변화
- 헐떡임 및 행동 변화
- 웨어러블 연동 시 심박 정보
- 피로 관련 징후 추정

#### E. AI 분석 리포트
- 운동 날짜 및 시간
- 반려견 정보
- 관절 움직임 분석
- 보행 패턴 분석
- 이전 운동 대비 변화
- 원본 및 스켈레톤 영상
- 분석 결과 요약
- 운동 관리 참고사항

※ AI 결과는 건강 이상 징후에 대한 참고 정보이며, 질병 진단이나 수의사의 진료를 대체하지 않음.

### 3.5 My Page (마이페이지)

#### 회원 관리
- 프로필 수정
- 로그인 계정 관리
- 알림 설정
- 회원 탈퇴

#### 반려견 관리
- 반려견 등록·수정·삭제
- 이름 및 사진
- 견종
- 생년월일 및 나이
- 성별
- 체중
- 기저질환
- 수술 및 치료 이력
- 약물 복용 여부
- 운동 제한 사항
- 수의사 권고사항

#### 이용 내역
- 이용권 및 멤버십
- 결제 내역
- 예약 내역
- 운동 누적 기록

#### 기타
- 공지사항
- FAQ
- 고객 문의
- 개인정보 및 영상 이용 동의 관리

---

## 4. AI 분석 시스템 설계

### 4.1 데이터 입력

**Vision Data**
- 정면 카메라 영상
- 측면 카메라 영상
- 15개 관절 Keypoint
- 프레임별 관절 좌표 (x, y, confidence)

**Dog Metadata**
- Dog ID
- 견종
- 나이
- 성별
- 체중
- 기저질환
- 수술 이력

**Exercise Metadata**
- 운동 시간
- 트레드밀 속도
- 운동 거리
- 운동 프로그램
- 과거 운동 기록

### 4.2 AI 처리 파이프라인

1. 트레드밀 카메라 영상 수집
2. YOLO Pose로 15개 관절 검출
3. 관절 좌표 정규화 및 시계열 데이터 생성
4. 관절 각도·보행 주기·좌우 대칭성 계산
5. TCN / ST-GCN 기반 관절 움직임 분석
6. 강아지 메타데이터와 움직임 특징 결합
7. 개체별 정상 보행 기준선과 비교
8. 이상 움직임 및 변화 지표 산출
9. AI 분석 리포트 생성
10. Supabase에 결과 저장
11. Flutter 앱에 리포트 제공

### 4.3 향후 AI 기능

- 전문가 라벨 기반 정상/비정상 보행 분류
- 피로 징후 추정
- 혀 날름거림 횟수 분석
- 심박 및 호흡 정보 연동
- 운동 지속·휴식 판단 보조
- 개체별 운동 프로그램 추천

피로도와 적정 운동량은 별도의 전문가 평가 데이터 및 안전성 검증 확보 후 개발.

---

## 5. Supabase 데이터베이스 설계

### 5.1 사용자 및 반려견

**users**
- id: UUID (Auth User ID)
- name: TEXT
- phone: TEXT
- role: TEXT (user / admin)
- created_at: TIMESTAMPTZ

**dogs**
- id: UUID (PK)
- owner_id: UUID (FK → users.id)
- name: TEXT
- breed: TEXT
- birth_date: DATE
- sex: TEXT
- weight_kg: NUMERIC
- profile_image_url: TEXT
- created_at: TIMESTAMPTZ

**dog_health_profiles**
- id: UUID (PK)
- dog_id: UUID (FK)
- diseases: JSONB
- surgeries: JSONB
- medications: JSONB
- exercise_restrictions: JSONB
- veterinary_notes: TEXT
- updated_at: TIMESTAMPTZ

### 5.2 예약 및 결제

**branches**
- id: UUID (PK)
- name: TEXT
- address: TEXT
- phone: TEXT

**treadmills**
- id: UUID (PK)
- branch_id: UUID (FK)
- device_name: TEXT
- status: TEXT
- created_at: TIMESTAMPTZ

**bookings**
- id: UUID (PK)
- user_id: UUID (FK)
- dog_id: UUID (FK)
- treadmill_id: UUID (FK)
- start_at: TIMESTAMPTZ
- end_at: TIMESTAMPTZ
- status: TEXT
- created_at: TIMESTAMPTZ

**memberships**
- id: UUID (PK)
- user_id: UUID (FK)
- plan_name: TEXT
- total_sessions: INTEGER
- remaining_sessions: INTEGER
- expires_at: TIMESTAMPTZ

**payments**
- id: UUID (PK)
- user_id: UUID (FK)
- booking_id: UUID (FK, Nullable)
- membership_id: UUID (FK, Nullable)
- amount: NUMERIC
- status: TEXT
- pg_transaction_id: TEXT
- paid_at: TIMESTAMPTZ

### 5.3 운동 기록

**exercise_sessions**
- id: UUID (PK)
- dog_id: UUID (FK)
- booking_id: UUID (FK)
- treadmill_id: UUID (FK)
- started_at: TIMESTAMPTZ
- ended_at: TIMESTAMPTZ
- duration_seconds: INTEGER
- distance_meters: NUMERIC
- average_speed: NUMERIC
- max_speed: NUMERIC
- status: TEXT

**pose_records**
- id: UUID (PK)
- session_id: UUID (FK)
- camera_type: TEXT (front / side)
- pose_file_path: TEXT
- video_file_path: TEXT
- fps: NUMERIC
- frame_count: INTEGER
- created_at: TIMESTAMPTZ

**analysis_reports**
- id: UUID (PK)
- session_id: UUID (FK)
- dog_id: UUID (FK)
- joint_metrics: JSONB
- gait_metrics: JSONB
- anomaly_metrics: JSONB
- fatigue_metrics: JSONB (Nullable)
- model_version: TEXT
- analysis_status: TEXT
- summary: TEXT
- created_at: TIMESTAMPTZ

**exercise_plans**
- id: UUID (PK)
- dog_id: UUID (FK)
- program_name: TEXT
- target_duration_seconds: INTEGER
- target_speed: NUMERIC
- restrictions: JSONB
- approved_by: UUID (Nullable)
- created_at: TIMESTAMPTZ

### 5.4 서비스 관리

**notifications**
- id: UUID (PK)
- user_id: UUID (FK)
- title: TEXT
- body: TEXT
- is_read: BOOLEAN
- created_at: TIMESTAMPTZ

**data_consents**
- id: UUID (PK)
- user_id: UUID (FK)
- consent_type: TEXT
- consent_version: TEXT
- granted: BOOLEAN
- responded_at: TIMESTAMPTZ

---

## 6. Supabase Storage 구성

**dog-profiles/**
- 반려견 프로필 사진

**exercise-videos/**
- 트레드밀 정면 영상
- 트레드밀 측면 영상
- 스켈레톤 시각화 영상

**pose-data/**
- 관절 좌표 시계열 파일
- Keypoint JSON 또는 Parquet

**analysis-reports/**
- PDF 리포트
- 분석 시각화 자료

운동 영상과 관절 좌표 원본은 Storage에 저장하고, PostgreSQL에는 세션 ID, 파일 경로, 주요 통계 및 분석 결과를 저장.

모든 버킷은 기본 Private로 설정하고 사용자·반려견별 접근권한과 보관 정책을 적용.

---

## 7. Flutter ↔ Supabase ↔ AI Server 구조

### Flutter
- Supabase Auth를 이용한 로그인
- Supabase Database CRUD
- Supabase Realtime으로 운동 상태 확인
- Supabase Storage의 허가된 영상 및 리포트 조회
- FCM으로 예약 및 운동 알림 수신

### Supabase
- 사용자·반려견·예약·운동 기록 관리
- Row Level Security(RLS) 적용
- 운동 세션 상태 저장 및 Realtime 전달
- AI 분석 작업 상태 관리
- Edge Functions를 이용한 서버 작업 연계

### AI Server
- 운동 영상 수신 및 처리
- YOLO Pose 추론
- 관절 좌표 시계열 분석
- 보행 지표 계산
- 학습된 분석 모델 추론
- 리포트 생성
- 결과를 Supabase에 저장

### 데이터 흐름

1. Flutter에서 운동 예약
2. Supabase에 예약 데이터 저장
3. 현장 직원이 예약 확인 및 운동 시작
4. 트레드밀 카메라 영상 촬영
5. Edge AI 또는 AI Server에서 Pose 추론
6. 분석 서버에서 보행 특징 추출 및 리포트 생성
7. Supabase Database / Storage에 결과 저장
8. Flutter에 분석 완료 알림
9. 보호자가 AI 리포트 확인

운동 중에는 영상 전체를 Supabase Realtime으로 전송하지 않고, 운동 상태와 주요 지표만 전달.

---

## 8. 권한 및 보안

### User
- 본인 계정 정보 조회·수정
- 본인이 등록한 반려견 관리
- 본인 반려견의 운동·분석 기록 조회
- 예약 및 결제 내역 조회

### Admin
- 담당 지점의 예약 및 운동 세션 관리
- 필요한 범위의 반려견 건강·운동 정보 확인
- 운동 시작·종료 및 기록 관리
- AI 결과 검토

### 시스템
- Supabase RLS로 데이터 접근 제한
- 관리자 권한은 서버에서 검증
- 결제 승인·환불은 서버에서 검증
- 예약 시간 중복은 DB 제약조건과 트랜잭션으로 차단
- AI 서버는 제한된 서버 인증으로 데이터 처리
- 영상 촬영 동의와 AI 학습 활용 동의 분리
- 원본 영상 보관·삭제 정책 적용

---

## 9. MVP 개발 범위

### Phase 1 — 기본 서비스

- [ ] Flutter 프로젝트 초기 설정
- [ ] Supabase 프로젝트 생성
- [ ] Supabase Auth 연동
- [ ] 사용자 프로필 관리
- [ ] 반려견 등록 및 건강 정보 관리
- [ ] 예약 기능
- [ ] 이용권 및 결제 연동
- [ ] 운영자 대시보드
- [ ] 운동 세션 기록
- [ ] 기본 운동 이력 조회

### Phase 2 — AI 서비스 연동

- [ ] AI Server와 Supabase 연동
- [ ] 운동 영상 저장
- [ ] Pose 데이터 저장
- [ ] 관절 특징 추출
- [ ] 보행 분석 결과 저장
- [ ] AI 운동 리포트 UI
- [ ] 스켈레톤 영상 재생
- [ ] 과거 운동 기록 비교
- [ ] 분석 완료 알림

### Phase 3 — 개인화 건강 관리

- [ ] 개체별 정상 보행 기준선 구축
- [ ] 보행 이상 탐지 모델
- [ ] 피로 징후 분석 모델
- [ ] 행동 분석 모델
- [ ] 웨어러블 심박수 연동
- [ ] 운동 프로그램 추천
- [ ] 장기 건강 변화 대시보드

---

## 10. 우선 개발할 Flutter 화면

1. `LoginScreen` — 로그인
2. `HomeScreen` — 홈 대시보드
3. `DogRegistrationScreen` — 반려견 등록
4. `DogProfileScreen` — 반려견 상세 정보
5. `BookingScreen` — 운동 예약
6. `BookingDetailScreen` — 예약 상세
7. `ExerciseScreen` — 현재 운동 현황
8. `ExerciseHistoryScreen` — 운동 기록
9. `AnalysisReportScreen` — AI 분석 결과
10. `HealthDashboardScreen` — 보행·건강 변화
11. `MembershipScreen` — 이용권 관리
12. `MyPageScreen` — 계정 관리

---

## 11. 최종 개발 목표

**단기 목표**

Flutter와 Supabase를 기반으로 반려견 등록, 트레드밀 예약, 운동 기록 및 AI 보행 분석 결과를 제공하는 MVP 개발.

**중기 목표**

반복 운동 데이터와 개체별 관절 패턴을 축적해 보행 이상 징후와 변화 추이를 분석하는 AI 서비스 구현.

**장기 목표**

반려견의 나이, 견종, 질병 이력, 관절 움직임, 생체신호 및 운동 데이터를 종합하여 전문가 검증 기반의 개인화 운동 관리 서비스로 확장.