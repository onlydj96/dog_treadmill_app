# 트레드밀 기기 연동 (Jetson Orin Nano 테스트)

무인 매장에서 트레드밀 기기가 하는 일과, Jetson Orin Nano 한 대로 처음부터 끝까지 테스트하는 방법입니다.
함수별 파라미터·단위·오류는 [앱 연동 인터페이스](../docs/app-interface.md) 3장에 있습니다.

## 흐름

```
보호자 앱                         Supabase                          트레드밀 기기 (Orin Nano)
───────────                       ────────                          ─────────────────────────
예약 → 바로 "예약 확정"
(시작 15분 전부터)
"QR 체크인" → 기기 QR 스캔  ──▶  check_in_with_treadmill_qr
                                  (스캔한 기기로 예약을 옮기고 체크인)
                                                              ◀──  get_treadmill_active_booking (몇 초마다)
                                                                   화면에 "두부 · 20분 프로그램" 표시
                                                              ◀──  시작 버튼 → start_exercise_session
운동 탭에서 실시간으로 봄   ◀──  Realtime                     ◀──  update_exercise_session_metrics (몇 초마다)
                                                              ◀──  목표 시간 → finish_exercise_session(true)
                                                                   비상정지 → finish_exercise_session(false, 사유)
"운동을 완료했어요" 알림    ◀──  예약 → 이용 완료
```

- 기기는 **지점 관리자 계정**으로 로그인합니다. 담당 지점(`managed_branch_id`)의 기기만 다룰 수 있습니다.
- 보호자는 배정된 기기가 아니어도, 그 시간에 비어 있는 기기의 QR을 스캔하면 그 기기로 체크인됩니다.
- QR 토큰은 API로 노출되지 않는 `private.treadmill_qr_codes`에만 있어서, 앱으로는 매장에 가야만 체크인할 수 있습니다.

## 1. 서버 준비 (한 번)

1. migration을 반영합니다: `npx supabase db push`
2. Supabase 대시보드 SQL Editor에서 테스트 지점과 트레드밀을 만듭니다. QR 토큰은 트레드밀을 만들면 자동으로 생깁니다.

   ```sql
   -- 테스트 지점. 밤에도 테스트하려면 opens_at '00:00', closes_at '24:00' (24시간 지점)
   insert into public.branches (name, address, opens_at, closes_at, slot_minutes)
   values ('테스트 지점 (Orin)', '테스트용', '09:00', '22:00', 30)
   returning id;  -- ← <branch_id>

   insert into public.treadmills (branch_id, device_name)
   values ('<branch_id>', 'T-01')
   returning id;  -- ← <treadmill_id> (Orin의 PAWFIT_TREADMILL_ID)
   ```

   > 테스트 지점은 다른 회원 앱에도 보입니다. 테스트가 끝나면 `update public.branches set is_active = false where id = '<branch_id>';`로 숨기세요.
   > 기존 지점에 트레드밀을 하나 더 추가해 써도 됩니다. 그 지점을 예약한 뒤 Orin의 QR을 스캔하면 예약이 Orin으로 옮겨집니다.

3. 기기용 계정을 만듭니다. 대시보드 **Authentication → Users → Add user → Create new user**에서 이메일·비밀번호를 넣고 **Auto Confirm User**를 켭니다. 그다음 관리자 권한과 담당 지점을 줍니다.

   ```sql
   update public.users
   set role = 'admin', managed_branch_id = '<branch_id>'
   where id = (select id from auth.users where email = '<기기 계정 이메일>');
   ```

   `managed_branch_id`를 비워 두면 전 지점 관리자가 되니 꼭 지점을 지정하세요.

4. 트레드밀에 붙일 QR 내용을 확인합니다 (Orin에서 `python3 pawfit_device.py qr`로도 볼 수 있어요).

   ```sql
   select t.device_name, 'pawfit://treadmill?code=' || q.token as qr
   from public.treadmills t
   join private.treadmill_qr_codes q on q.treadmill_id = t.id
   where t.branch_id = '<branch_id>';
   ```

   이 문자열을 아무 QR 생성기에 넣어 출력해 트레드밀에 붙이거나, Orin 화면에 띄웁니다.

## 2. Orin Nano 설정

JetPack에 들어 있는 Python 3만 있으면 됩니다. 추가 패키지는 필요 없습니다 (터미널에 QR을 그리려면 `pip install qrcode`).

```bash
# pawfit_device.py를 Orin으로 복사한 뒤
export PAWFIT_SUPABASE_URL=https://<프로젝트>.supabase.co
export PAWFIT_SUPABASE_KEY=<앱과 같은 publishable(anon) 키>
export PAWFIT_DEVICE_EMAIL=<기기 계정 이메일>
export PAWFIT_DEVICE_PASSWORD=<기기 계정 비밀번호>
export PAWFIT_TREADMILL_ID=<treadmill_id>

python3 pawfit_device.py qr     # QR 내용 확인
python3 pawfit_device.py run    # 체크인 대기 → 시작 → 운동 → 종료를 반복
```

`run` 옵션:

| 옵션 | 뜻 |
|---|---|
| `--auto-start` | 체크인되면 Enter 없이 바로 시작 |
| `--speed-factor 10` | 시간을 10배로 흘림 (15분 프로그램이 1분 30초에 끝남) |
| `--speed 3.0` | 시뮬레이션 벨트 속도 km/h |
| `--once` | 운동 한 번만 하고 끝냄 |

비밀번호는 환경 변수 파일에 넣는다면 권한을 `chmod 600`으로 제한하세요.

## 3. 테스트 순서

1. 앱에서 테스트 지점을 예약합니다 (현장 결제여도 바로 "예약 확정").
2. 예약 시작 15분 전부터 예약 상세나 홈의 **QR 체크인**을 누르고, 트레드밀 QR을 스캔합니다.
3. Orin 터미널에 `체크인됨: <반려견> · <프로그램>`이 뜨면 Enter를 누릅니다 (= 시작 버튼).
4. 앱 운동 탭에서 속도·거리·시간이 실시간으로 바뀌는지 봅니다.
5. 목표 시간이 되면 자동으로 끝납니다. 중간에 `Ctrl+C`를 누르면 비상정지로 기록됩니다.
6. 앱에서 예약이 "이용 완료"가 되고 운동 기록·알림이 생겼는지 확인합니다.

## 4. 실제 기기로 바꿀 곳

`pawfit_device.py`에서 하드웨어에 닿는 부분은 두 함수뿐입니다.

| 함수 | 지금 (테스트) | 실제 기기 |
|---|---|---|
| `wait_for_start_button` | Enter 키 | 시작 버튼 GPIO (`Jetson.GPIO`) |
| `belt_speed_at` | 30초 동안 속도를 올리는 시뮬레이션 | 벨트 속도 센서 값 |

- **비상정지는 네트워크와 상관없이 모터를 직접 멈춰야 합니다.** 서버 호출(`finish_exercise_session`)은 기록용입니다.
- 잠깐 멈췄다 다시 할 때는 끝내지 말고 `update_exercise_session_metrics(..., p_status := 'paused' | 'running')`로 일시정지·재개를 보냅니다. `finish_exercise_session`을 부르면 예약이 이용 완료가 되어 다시 시작할 수 없습니다.
- 기기가 재시작되면 `get_treadmill_active_booking`이 진행 중인 세션(`session_id`, `session_status`)을 돌려주므로 이어서 기록할 수 있습니다.

## 5. 운영 메모

- QR 스티커 사진이 퍼졌으면 토큰을 바꿉니다. 기존 스티커는 더 이상 통하지 않습니다.

  ```sql
  update private.treadmill_qr_codes
  set token = replace(gen_random_uuid()::text, '-', ''), rotated_at = now()
  where treadmill_id = '<treadmill_id>';
  ```

- 점검 중인 기기는 `update public.treadmills set status = 'maintenance' where id = '<treadmill_id>';`로 바꾸면 예약 배정과 QR 체크인에서 빠집니다.
