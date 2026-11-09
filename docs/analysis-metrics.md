# AI 분석 결과 저장 규격

AI 서버(FastAPI)가 `analysis_reports`에 결과를 저장할 때 따라야 하는 형식입니다.
앱(`lib/features/health/data/analysis_models.dart`)은 이 구조를 그대로 읽어 화면에 표시합니다.
모든 필드는 선택값이며, 없는 값은 앱에서 `-`로 표시합니다.

## 처리 흐름

1. 운영자가 운동을 종료하면(`finish_exercise_session`) 보호자가 **영상 촬영에 동의한 경우에만**
   `analysis_reports` 행이 `analysis_status = 'queued'`로 생성됩니다.
2. AI 서버는 `queued` 행을 가져가 `processing`으로 바꾼 뒤 분석합니다.
3. 완료 시 아래 지표와 함께 `completed`로 갱신합니다. `completed_at`은 DB가 자동 기록하고,
   보호자에게 "AI 보행 분석 리포트가 도착했어요" 알림이 자동 생성됩니다.
4. 실패 시 `failed`와 `error_message`를 기록합니다(보호자에게 실패 알림 생성).

AI 서버는 `service_role` 키로 접속합니다(RLS 우회). 키는 서버에만 두고 앱에 넣지 않습니다.

## Storage 경로

| 버킷 | 경로 | 비고 |
|---|---|---|
| `exercise-videos` | `{dog_id}/{session_id}/front.mp4`, `side.mp4`, `skeleton.mp4` | 보호자 조회 가능 |
| `pose-data` | `{dog_id}/{session_id}/keypoints.parquet` 등 | 관리자만 조회 |
| `analysis-reports` | `{dog_id}/{report_id}/report.pdf` | 보호자 조회 가능 |

- 원본 영상 경로는 `pose_records.video_file_path`(카메라별 1행, `camera_type`: `front`/`side`)에,
  스켈레톤 영상은 `analysis_reports.skeleton_video_path`에 저장합니다.
- 경로의 첫 폴더가 `dog_id`여야 보호자 접근 권한(Storage RLS)이 적용됩니다.

## 15개 관절 Keypoint

`joint` / `key` 값은 아래 키를 사용합니다. 앱은 이 키로 측면 스켈레톤 도식에 위치를 표시하고,
`label`을 생략하면 한글 이름을 자동으로 채웁니다.

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

## `joint_metrics`

```json
{
  "keypoint_count": 15,
  "joints": [
    {
      "key": "right_stifle",
      "label": "오른쪽 뒷다리 무릎",
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

- `rom_deg`: 관절 가동 범위(도). `baseline_rom_deg`: 개체별 정상 보행 기준선의 가동 범위.
- 앱은 `(rom_deg - baseline_rom_deg) / baseline_rom_deg`를 "기준선 대비 변화"로 표시합니다.

## `gait_metrics`

```json
{
  "cadence_spm": 142.0,
  "stride_time_s": 0.84,
  "stride_time_cv": 0.068,
  "symmetry_index": 0.91,
  "front_symmetry": 0.93,
  "hind_symmetry": 0.88,
  "rhythm_score": 0.88,
  "baseline": { "cadence_spm": 140.0, "symmetry_index": 0.95, "stride_time_cv": 0.05 }
}
```

| 필드 | 의미 | 범위 |
|---|---|---|
| `cadence_spm` | 분당 걸음 수 | 실수 |
| `stride_time_s` | 걸음걸이 주기(초) | 실수 |
| `stride_time_cv` | 보행 주기 변동계수 (낮을수록 일정) | 0~1 |
| `symmetry_index` / `front_symmetry` / `hind_symmetry` | 좌우 대칭성 (1 = 완전 대칭) | 0~1 |
| `rhythm_score` | 보행 리듬 점수 | 0~1 |
| `baseline` | 개체별 정상 보행 기준선 | 같은 단위 |

## `anomaly_metrics`

```json
{
  "level": "caution",
  "anomaly_score": 0.34,
  "confidence": 0.87,
  "findings": [
    { "joint": "right_stifle", "description": "가동 범위가 기준선보다 12% 줄었어요.", "severity": "caution" }
  ],
  "notes": ["측면 카메라에서 왼쪽 뒷다리가 일부 가려져 신뢰도가 다소 낮아요."]
}
```

- `level`, `severity`: `normal`(특이사항 없음) / `caution`(관찰 필요) / `warning`(주의 필요)
- `anomaly_score`: 평소 보행 패턴과의 차이(0~1). `confidence`: 분석 신뢰도(0~1).
- `notes`: 분석 주의사항(카메라 각도, 가림 등). 앱에 그대로 노출됩니다.
- 문구는 **진단 표현을 피하고** 관찰된 변화만 서술합니다(문서 3.4: 진단·진료를 대체하지 않음).

## 기타 컬럼

- `summary` (text): 분석 결과 요약 1~2문장.
- `care_notes` (jsonb, 문자열 배열): 운동 관리 참고사항.
- `fatigue_metrics` (jsonb): 피로 징후 분석(추후 개발). 현재 앱에서는 표시하지 않습니다.
- `model_version` (text): 예) `gait-v0.3`. 리포트 상단에 표시됩니다.
