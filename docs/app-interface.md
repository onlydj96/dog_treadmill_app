# PawFit 앱 연동 인터페이스

| 항목 | 내용 |
|---|---|
| 기준 | 2026-11-24, DB migration `20261124000100_qr_check_in.sql`까지 반영된 앱 |
| 대상 | 트레드밀 기기(엣지, Jetson Orin Nano 등), AI·API 서버 |
| 함께 볼 문서 | [기기 테스트 방법](../device/README.md) · [기능명세서](functional-spec.md) · [랭킹·배지 규격](ranking.md) |

이 문서는 **보호자 앱이 지금 읽는 형식**을 정리한 계약서입니다. 외부 시스템이 이 형식을 지키면 앱을 고치지 않아도 화면에 나옵니다.

## 1. 구조

```
보호자 앱 ──(조회 · 예약 · QR 체크인)──▶ Supabase ◀──(운동 기록)── 트레드밀 기기 (엣지)
                                          ▲
                                          └──────(분석 결과 저장)── AI · API 서버
```

- 앱, 기기, AI 서버는 서로 직접 통신하지 않습니다. 모두 Supabase(DB 함수, 테이블, Storage)를 거칩니다.
- 앱은 `exercise_sessions`, `analysis_reports`, `bookings`, `notifications`를 Realtime으로 구독합니다. 기기·AI 서버가 값을 바꾸면 앱 화면이 바로 바뀝니다.

## 2. 공통 규칙

| 항목 | 규칙 |
|---|---|
| 기기 접속 | publishable 키 + **지점 관리자 계정**으로 로그인. 계정은 `users.role = 'admin'`, `managed_branch_id = <지점>` (비우면 전 지점 관리자가 되니 꼭 지정) |
| AI·API 서버 접속 | `service_role` 키 (RLS 우회). 키는 서버에만 두고 앱·기기에 넣지 않음 |
| DB 함수 호출 | `POST {SUPABASE_URL}/rest/v1/rpc/<함수 이름>`, JSON 본문에 `p_` 파라미터 (Supabase SDK의 `rpc()`도 같음) |
| 오류 | HTTP 400, 본문 `{"code": "P0002", "message": "TREADMILL_NOT_FOUND"}`. `message`가 영문 오류 코드 |
| 시간 | `timestamptz`, ISO 8601. 기준 시각은 서버 `now()`. 앱 표시 시간대는 Asia/Seoul |
| 단위 | 속도 km/h · 거리 m · 시간 초 · 각도 도(°) · 비율 0~1 |
| JSON 컬럼 | jsonb에는 **객체·배열을 그대로** 넣습니다. `json.dumps()`한 문자열을 넣으면 앱이 읽지 못합니다 |
| 모르는 키 | 규격에 없는 키는 오류 없이 무시합니다 (화면에 나오지 않음) |
| 측정 못 한 값 | 키를 **빼 주세요**. `0`을 넣으면 실제 값으로 보입니다 (예: 대칭성 0 = 완전 비대칭). 앱은 없는 값을 `-`로 표시 |
| 언어 | 사람이 읽는 문구는 한국어 기본 + 같은 이름에 `_en`을 붙인 영어. 영어가 비면 앱은 한국어를 보여 줌 |
| 문구 원칙 | 진단 표현을 쓰지 않고 관찰된 변화만 서술 (AI 결과는 진단·진료를 대체하지 않음) |

## 3. 트레드밀 기기 (엣지)

### 3.1 흐름

1. 보호자가 매장에서 기기의 QR을 앱으로 스캔합니다. 앱이 `check_in_with_treadmill_qr`를 호출하면 예약이 `checked_in`이 되고 **이 기기로 배정**됩니다 (배정된 기기가 아니어도 그 시간에 비어 있으면 옮겨짐).
2. 기기는 `get_treadmill_active_booking`을 2~5초마다 불러 체크인된 예약을 찾고 화면에 보여 줍니다.
3. 보호자가 기기의 시작 버튼을 누르면 `start_exercise_session`.
4. 운동 중에는 1~2초마다 `update_exercise_session_metrics`.
5. 목표 시간이 되면 `finish_exercise_session(completed = true)`, 비상정지면 `completed = false`.

비상정지는 네트워크와 상관없이 **모터를 먼저 직접 멈추고**, 서버 호출은 기록용으로 합니다.

### 3.2 QR

| 항목 | 값 |
|---|---|
| 내용 | `pawfit://treadmill?code=<토큰>` (다른 형식은 앱이 "PawFit 트레드밀 QR이 아니에요"로 거절) |
| 얻는 법 | `get_treadmill_qr(트레드밀 id)` |
| 표시 | 스티커로 출력하거나 기기 화면에 띄움 |
| 토큰 교체 | 스티커 사진이 퍼졌을 때 SQL로 교체 ([device/README.md](../device/README.md) 5장) |

### 3.3 DB 함수

모두 지점 관리자 계정으로 호출합니다. 담당 지점이 아니면 "찾을 수 없음" 오류가 납니다.

**`get_treadmill_qr(p_treadmill_id uuid) → text`**

QR 내용 `pawfit://treadmill?code=<토큰>`을 돌려줍니다. 오류: `TREADMILL_NOT_FOUND`.

**`get_treadmill_active_booking(p_treadmill_id uuid) → 0~1행`**

| 컬럼 | 타입 | 뜻 |
|---|---|---|
| `booking_id` | uuid | `start_exercise_session`에 넘길 예약 |
| `dog_id`, `dog_name` | uuid, text | 기기 화면 표시용 |
| `program_name`, `duration_minutes` | text, int | 프로그램 이름과 목표 시간(분) |
| `start_at`, `end_at` | timestamptz | 예약 시간 |
| `session_id`, `session_status` | uuid, text \| null | 이미 시작한 세션 (기기가 재시작됐을 때 이어서 기록) |

조건: 이 기기에 배정된 `checked_in` 예약 중에서, 종료 전이거나 운동 중(`running`·`paused`) 세션이 있는 것. 운동 중인 예약을 먼저 돌려줍니다. 오류: `TREADMILL_NOT_FOUND`.

**`start_exercise_session(p_booking_id uuid) → exercise_sessions 행`**

- 허용: 예약 `pending`·`confirmed`·`checked_in`, 세션이 아직 없을 때.
- 결과: 세션 `running` 생성(목표 시간 = 프로그램 시간), 예약 `checked_in`, 트레드밀 `in_use`, 보호자에게 "운동을 시작했어요" 알림.
- 돌려받은 행의 `id`가 이후 함수의 `p_session_id`입니다.
- 오류: `BOOKING_NOT_FOUND`, `INVALID_BOOKING_STATUS`, `SESSION_ALREADY_EXISTS`.

**`update_exercise_session_metrics(p_session_id uuid, p_current_speed numeric, p_distance_meters numeric = null, p_duration_seconds int = null, p_status text = null) → exercise_sessions 행`**

| 파라미터 | 단위 | 비고 |
|---|---|---|
| `p_current_speed` | km/h | 지금 벨트 속도. 일시정지면 0으로 기록됨 |
| `p_distance_meters` | m | 시작부터의 **누적** 거리 |
| `p_duration_seconds` | 초 | 시작부터의 **누적** 운동 시간 (일시정지 시간 제외 권장) |
| `p_status` | | `'running'` 또는 `'paused'` (일시정지·재개). 생략하면 그대로 |

최고 속도(`max_speed`)는 서버가 갱신합니다. 오류: `SESSION_NOT_FOUND`, `SESSION_NOT_ACTIVE`, `INVALID_SESSION_STATUS`.

**`finish_exercise_session(p_session_id uuid, p_completed boolean = true, p_stop_reason text = null) → exercise_sessions 행`**

- 결과: 세션 `completed`(정상) 또는 `stopped`(중단), `ended_at` 기록, 평균 속도 = 누적 거리 ÷ 누적 시간(km/h), 예약 `completed`(중단도 이용 완료), 트레드밀 `available`, 보호자 알림.
- 보호자가 영상 촬영에 동의했으면 `analysis_reports` 행이 `queued`로 생깁니다 (4장).
- 랭킹 점수가 자동 적립됩니다. 달성 점수 = `floor(10 × duration_seconds ÷ target_duration_seconds)` (최대 10). 그래서 **누적 시간을 정확히** 보내야 합니다.
- `p_stop_reason`은 중단 알림과 운동 기록에 그대로 보입니다 (예: `비상정지 버튼으로 중단`). 비우면 `운영자 판단에 의한 중단`.
- 잠깐 멈췄다 다시 할 때는 이 함수를 부르지 말고 `p_status = 'paused'`로 보내세요. 끝내면 다시 시작할 수 없습니다.
- 오류: `SESSION_NOT_FOUND`, `SESSION_NOT_ACTIVE`.

### 3.4 앱에 보이는 운동 값 (`exercise_sessions`)

| 컬럼 | 앱 표시 | 채우는 쪽 |
|---|---|---|
| `status` | 운동 중 / 일시정지 / 완료 / 중단 | 함수 |
| `duration_seconds`, `target_duration_seconds` | 경과 시간 / 목표 시간, 진행률 | 기기 / 시작 함수 |
| `distance_meters` | 거리 | 기기 |
| `current_speed` | 실시간 속도 | 기기 |
| `max_speed`, `average_speed` | 운동 기록 | 서버 계산 |
| `stop_reason` | 중단 사유 | 종료 함수 |

## 4. AI·API 서버 (분석 결과)

### 4.1 흐름

1. 운동이 끝나면(`finish_exercise_session`) 보호자가 영상 촬영에 동의한 경우에만 `analysis_reports` 행이 `analysis_status = 'queued'`로 생깁니다 (`session_id`, `dog_id` 채워짐).
2. AI 서버가 `queued` 행을 가져가 `processing`으로 바꿉니다.
3. 분석 후 4.2의 컬럼을 채우고 `completed`로 바꿉니다. `completed_at`은 DB가 기록하고, 보호자에게 "AI 보행 분석 리포트가 도착했어요" 알림이 자동으로 갑니다.
4. 실패하면 `failed`와 `error_message`를 기록합니다. 보호자에게 실패 알림이 자동으로 갑니다.

- **새 행을 만들지 말고 생긴 행을 업데이트**하세요. 행이 늘면 리포트 목록에 같은 운동이 여러 번 보입니다.
- 다시 분석할 때는 같은 행을 `processing` → `completed`로 바꾸면 알림이 다시 갑니다. 완료 시각을 새로 남기려면 `completed_at`을 `null`로 비운 뒤 `completed`로 바꾸세요.

### 4.2 컬럼

| 컬럼 | 타입 | 앱 표시 위치 | 비어 있으면 |
|---|---|---|---|
| `summary` / `summary_en` | text | 리포트 "분석 결과 요약" (1~2문장) | 카드 숨김 |
| `care_notes` / `care_notes_en` | jsonb **문자열 배열** | 리포트 "운동 관리 참고사항" | 섹션 숨김 |
| `gait_metrics` | jsonb 객체 (4.3) | 리포트 "보행 패턴 분석", 홈 요약, 건강 탭 추세, 이전 운동 대비 | 섹션 숨김 |
| `joint_metrics` | jsonb 객체 (4.4) | 리포트 "관절 움직임 분석", 건강 탭 "관절 가동 범위 변화" | 섹션 숨김 |
| `anomaly_metrics` | jsonb 객체 (4.5) | 리포트 "이상 움직임 탐지", 등급 배지(홈·건강 탭·리포트 목록) | 섹션 숨김 |
| `skeleton_video_path` | text | 리포트 "운동 영상"의 스켈레톤 영상 | 숨김 |
| `analysis_status` | text | `queued`·`processing`이면 "분석 중", `failed`면 실패 안내 | |
| `error_message` | text | 표시 안 함 (운영 기록용) | |
| `model_version` | text | 표시 안 함 (운영 기록용, 예: `pipeline=0.1.0;pose=yolov8s-pose-2`) | |
| `report_pdf_path`, `fatigue_metrics` | | 지금은 표시 안 함 | |

`care_notes`·`care_notes_en`은 배열이 아니면 DB가 거절합니다. 배열 안 항목은 **문자열**이어야 합니다. 객체(`{"kind": …, "text": …}`)는 앱이 건너뜁니다.

### 4.3 `gait_metrics`

```json
{
  "cadence_spm": 171.0,
  "stride_time_s": 0.35,
  "stride_time_cv": 0.056,
  "symmetry_index": 0.91,
  "front_symmetry": 0.93,
  "hind_symmetry": 0.88,
  "rhythm_score": 0.88,
  "baseline": { "cadence_spm": 165.0, "symmetry_index": 0.95, "stride_time_cv": 0.05 }
}
```

| 키 | 단위·범위 | 앱 표시 |
|---|---|---|
| `cadence_spm` | 분당 걸음 수 | "분당 걸음 수" (리포트, 홈, 건강 탭 추세, 이전 대비) |
| `stride_time_s` | 초 | "걸음걸이 주기" |
| `stride_time_cv` | 0~1 (0.056 = 5.6%), 낮을수록 일정 | "보행 변동성" (×100 %로 표시), 이전 대비 |
| `symmetry_index` | 0~1, 1 = 완전 대칭 | "좌우 대칭성" (리포트, 홈, 건강 탭, 목록, 이전 대비) |
| `front_symmetry`, `hind_symmetry` | 0~1 | "앞다리 대칭", "뒷다리 대칭" |
| `rhythm_score` | 0~1 | "보행 리듬 점수" (×100점) |
| `baseline` | 위와 같은 키·단위 | "기준선 대비 ±" 표시, 건강 탭 추세의 기준선. **비교할 과거 자료가 없으면 키를 빼세요** |

### 4.4 `joint_metrics`

```json
{
  "keypoint_count": 15,
  "joints": [
    {
      "key": "right_stifle",
      "label": "오른쪽 뒷다리 무릎",
      "label_en": "Right hind knee",
      "rom_deg": 44.0,
      "mean_angle_deg": 128.4,
      "min_angle_deg": 106.0,
      "max_angle_deg": 150.0,
      "baseline_rom_deg": 50.0,
      "confidence": 0.91
    }
  ]
}
```

| 키 | 뜻 | 앱 표시 |
|---|---|---|
| `keypoint_count` | 분석한 관절 수 | 섹션 제목 "관절 움직임 분석 · N개 관절" |
| `joints[].key` | 아래 15개 키 중 하나 | 관절 이름, 측면 스켈레톤 도식 위치 |
| `joints[].label` / `label_en` | 관절 이름을 바꿔 보여 줄 때만 | 생략하면 앱의 관절 이름 |
| `rom_deg` | 관절 가동 범위(°) | "가동 범위" |
| `min_angle_deg`, `max_angle_deg` | 각도 범위(°) | "각도 106°~150°" |
| `baseline_rom_deg` | 이 반려견의 평소 가동 범위 | "기준선 대비 %" = (rom − baseline) ÷ baseline, 건강 탭 "관절 가동 범위 변화" 순위 |
| `mean_angle_deg`, `confidence` | | 저장만 (지금은 표시 안 함) |

관절별 굴곡각이 아직 없으면 `joint_metrics`를 비워 두세요(섹션이 숨겨짐). 다리 스윙 각도처럼 관절별이 아닌 값은 지금 넣을 자리가 없습니다.

**관절 키 (15개)**

| key | 이름 | key | 이름 |
|---|---|---|---|
| `nose` | 코 | `left_stifle` | 왼쪽 뒷다리 무릎 |
| `withers` | 기갑(어깨 위) | `left_hock` | 왼쪽 뒷발목(비절) |
| `tail_base` | 꼬리 시작점 | `left_hind_paw` | 왼쪽 뒷발 |
| `left_elbow` | 왼쪽 앞다리 팔꿈치 | `right_stifle` | 오른쪽 뒷다리 무릎 |
| `left_carpus` | 왼쪽 앞발목 | `right_hock` | 오른쪽 뒷발목(비절) |
| `left_front_paw` | 왼쪽 앞발 | `right_hind_paw` | 오른쪽 뒷발 |
| `right_elbow` | 오른쪽 앞다리 팔꿈치 | | |
| `right_carpus` | 오른쪽 앞발목 | | |
| `right_front_paw` | 오른쪽 앞발 | | |

### 4.5 `anomaly_metrics`

```json
{
  "level": "caution",
  "anomaly_score": 0.34,
  "confidence": 0.87,
  "findings": [
    {
      "joint": "right_stifle",
      "description": "가동 범위가 기준선보다 12% 줄었어요.",
      "description_en": "Range of motion is 12% lower than the baseline.",
      "severity": "caution"
    }
  ],
  "notes": ["측면 카메라에서 왼쪽 뒷다리가 일부 가려져 신뢰도가 다소 낮아요."],
  "notes_en": ["The left hind leg was partly hidden from the side camera, so confidence is a little lower."]
}
```

| 키 | 값 | 앱 표시 |
|---|---|---|
| `level` | `normal`(특이사항 없음) · `caution`(관찰 필요) · `warning`(주의 필요) | 등급 배지 (리포트, 홈, 건강 탭, 목록). 없으면 `normal` |
| `anomaly_score` | 0~1, 평소 패턴과의 차이 | "평소 보행 패턴과의 차이" 막대, 이전 대비 |
| `confidence` | 0~1 | "분석 신뢰도 N%" |
| `findings[]` | `joint`(관절 키, 선택), `description`/`description_en`, `severity`, `label`/`label_en`(선택) | 소견 목록. `caution`·`warning`이고 `joint`가 있으면 스켈레톤 도식에 번호 표시. 비어 있으면 "평소와 다른 움직임이 발견되지 않았어요." |
| `notes` / `notes_en` | 문자열 배열 | 분석 주의사항 (카메라 각도, 가림, 비교 자료 없음 등) |

### 4.6 Storage

업로드는 `service_role`(AI·API 서버)만 할 수 있습니다. 기기 계정에는 쓰기 권한이 없습니다. 경로의 첫 폴더가 `dog_id`여야 보호자가 볼 수 있습니다.

| 버킷 | 경로 | 앱 사용 |
|---|---|---|
| `exercise-videos` | `{dog_id}/{session_id}/front.mp4`, `side.mp4` | `pose_records`에 카메라별 1행 (`session_id`, `camera_type` = `front`·`side`, `video_file_path`, `fps`, `frame_count`) → 리포트 "운동 영상" |
| `exercise-videos` | `{dog_id}/{session_id}/skeleton.mp4` | `analysis_reports.skeleton_video_path` → 스켈레톤 영상 |
| `pose-data` | `{dog_id}/{session_id}/keypoints.parquet` 등 | 관리자만 (앱 표시 없음) |
| `analysis-reports` | `{dog_id}/{report_id}/report.pdf` | 지금은 표시 안 함 |

### 4.7 전체 예시 (완료 업데이트 본문)

```json
{
  "analysis_status": "completed",
  "model_version": "pipeline=0.1.0;pose=yolov8s-pose-2",
  "summary": "바미의 이번 보행은 리듬이 일정하게 유지되었어요.",
  "summary_en": "Bami kept a steady walking rhythm this time.",
  "care_notes": ["다음에도 같은 속도와 촬영 위치에서 비교해 보세요."],
  "care_notes_en": ["Next time, compare at the same speed and camera position."],
  "gait_metrics": { "cadence_spm": 170, "stride_time_s": 0.35, "stride_time_cv": 0.056 },
  "anomaly_metrics": {
    "level": "normal",
    "findings": [],
    "notes": ["측면 영상이라 좌우 다리 구분이 완벽하지 않아 대칭성은 판단하지 않았어요."],
    "notes_en": ["Left and right legs can't be fully told apart from the side view, so symmetry wasn't assessed."]
  }
}
```

측정하지 않은 값(대칭성, 관절별 각도, 기준선)은 키 자체를 뺐습니다. 앱에는 해당 칸이 `-`로, 해당 섹션은 숨겨진 채로 보입니다.

### 4.8 점검 목록

- [ ] jsonb 컬럼에 문자열이 아니라 객체·배열을 넣었다 (`jsonb_typeof(gait_metrics) = 'object'`)
- [ ] `care_notes`·`care_notes_en`·`notes`·`notes_en`은 문자열 배열이다
- [ ] 단위: 걸음 주기는 초, 변동성·대칭성·점수는 0~1 비율 (퍼센트·밀리초 아님)
- [ ] 측정 못 한 값은 `0`이 아니라 키를 뺐다
- [ ] `baseline`에는 숫자만 넣었다 (상태 문자열이나 세션 수 넣지 않기)
- [ ] 같은 세션에 행을 새로 만들지 않고 생긴 행을 업데이트했다
- [ ] 사람이 읽는 문구에 `_en` 영어 값을 같이 넣었다

## 부록. 현재 파이프라인 출력(`schema_version: 1`) → 이 규격

2026-11-24 바미 리포트에서 확인한 출력 기준입니다.

| 지금 출력 | 이 규격 | 변환 |
|---|---|---|
| `gait_metrics.stride.per_minute` (170) | `gait_metrics.cadence_spm` | 그대로 |
| `gait_metrics.stride.period_s` (0.35) | `gait_metrics.stride_time_s` | 그대로 |
| `gait_metrics.stride.variability_pct` (5.59) | `gait_metrics.stride_time_cv` | ÷ 100 → 0.0559 |
| `gait_metrics.regularity.code` (`high`) | (`rhythm_score`는 0~1 숫자) | 숫자 점수가 있을 때만 넣기 |
| `gait_metrics.baseline` (`{status: "insufficient_history"}`) | `gait_metrics.baseline` | 비교 자료가 없으면 키 빼기 |
| `gait_metrics.cards`, `stride.length_m`, `gait_type`, `quality`, `belt_speed_kmh`, `analyzed_seconds` | 규격에 없음 | 넣어도 무시됨. 보여 주려면 규격·앱에 추가 필요 |
| `joint_metrics.swing_rom_deg` (`{front, hind}`) | 관절별 `joints[]`가 아님 | 관절별 각도가 생길 때까지 `joint_metrics` 비우기 |
| `anomaly_metrics` (`{count, items}`) | `level`, `findings[]`, `notes[]` | 소견이 없으면 `level: "normal"`, `findings: []` |
| `care_notes[]` (`{kind, text}` 객체) | `care_notes` 문자열 배열 | `kind`가 `observation`·`recommendation`인 `text`만 |
| `care_notes[]` 중 `kind: "caution"` | `anomaly_metrics.notes` | 분석 주의사항으로 옮기기 |
| `summary_en`, `care_notes_en` (비어 있음) | 영어 값 | 함께 생성 |
