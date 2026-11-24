#!/usr/bin/env python3
"""PawFit 트레드밀 기기 테스트 클라이언트 (Jetson Orin Nano 등 리눅스 기기용).

표준 라이브러리만 쓴다. 사용법과 준비 과정은 device/README.md를 본다.

  python3 pawfit_device.py qr     # 이 트레드밀의 QR 내용 (qrcode 패키지가 있으면 터미널에 QR도 그린다)
  python3 pawfit_device.py run    # QR 체크인 대기 → 시작 버튼 → 운동(지표 시뮬레이션) → 종료, 반복

흐름 (서버 함수는 supabase/migrations/20261124000100_qr_check_in.sql 참고):
  1. 보호자가 앱으로 이 트레드밀의 QR을 스캔해 체크인한다 (check_in_with_treadmill_qr).
  2. 기기는 get_treadmill_active_booking으로 자기에게 체크인한 예약을 찾아 화면에 보여 준다.
  3. 보호자가 기기의 시작 버튼을 누르면 start_exercise_session을 호출한다.
  4. 운동 중에는 update_exercise_session_metrics로 속도·거리·시간을 보낸다 (앱에 실시간으로 보인다).
  5. 목표 시간이 되면 finish_exercise_session(completed=true), 비상정지면 completed=false로 끝낸다.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.request


class RpcError(Exception):
    """서버 함수가 돌려준 오류. message는 TREADMILL_NOT_FOUND 같은 오류 코드다."""

    def __init__(self, message: str, code: str | None = None, status: int | None = None):
        super().__init__(message)
        self.message = message
        self.code = code
        self.status = status


class Supabase:
    """Supabase REST(PostgREST)·Auth(GoTrue)를 직접 호출하는 작은 클라이언트."""

    def __init__(self, url: str, key: str):
        self.url = url.rstrip('/')
        self.key = key
        self.access_token: str | None = None
        self.refresh_token: str | None = None
        self.expires_at = 0.0
        self._email = ''
        self._password = ''

    def _request(self, method: str, path: str, body: object | None = None, auth: bool = True) -> object:
        headers = {'apikey': self.key, 'Content-Type': 'application/json'}
        if auth:
            self._ensure_session()
            headers['Authorization'] = f'Bearer {self.access_token}'
        data = None if body is None else json.dumps(body).encode()
        request = urllib.request.Request(self.url + path, data=data, headers=headers, method=method)
        try:
            with urllib.request.urlopen(request, timeout=15) as response:
                raw = response.read()
        except urllib.error.HTTPError as error:
            raw = error.read()
            try:
                payload = json.loads(raw or b'{}')
            except ValueError:
                payload = {}
            message = payload.get('message') or payload.get('msg') or payload.get('error_description') or str(error)
            raise RpcError(message, payload.get('code') or payload.get('error_code'), error.code) from None
        return json.loads(raw) if raw else None

    def sign_in(self, email: str, password: str) -> None:
        self._email, self._password = email, password
        session = self._request('POST', '/auth/v1/token?grant_type=password',
                                {'email': email, 'password': password}, auth=False)
        self._store(session)

    def _store(self, session: object) -> None:
        assert isinstance(session, dict)
        self.access_token = session['access_token']
        self.refresh_token = session['refresh_token']
        self.expires_at = time.time() + float(session.get('expires_in', 3600))

    def _ensure_session(self) -> None:
        if self.access_token and time.time() < self.expires_at - 60:
            return
        try:
            session = self._request('POST', '/auth/v1/token?grant_type=refresh_token',
                                    {'refresh_token': self.refresh_token}, auth=False)
            self._store(session)
        except RpcError:
            self.sign_in(self._email, self._password)

    def rpc(self, name: str, params: dict | None = None) -> object:
        return self._request('POST', f'/rest/v1/rpc/{name}', params or {})


# ---------------------------------------------------------------------------
# 기기 하드웨어 연결 지점. 실제 기기에서는 이 함수들을 GPIO·모터 제어로 바꾼다.
# ---------------------------------------------------------------------------

def wait_for_start_button(auto: bool) -> None:
    """시작 버튼을 기다린다. 테스트에서는 Enter 키로 대신한다.

    Jetson.GPIO 예시:
        import Jetson.GPIO as GPIO
        GPIO.setmode(GPIO.BOARD); GPIO.setup(START_PIN, GPIO.IN)
        GPIO.wait_for_edge(START_PIN, GPIO.FALLING)
    """
    if auto:
        return
    input('  ▶ 시작 버튼 대신 Enter를 누르세요 (운동 중 Ctrl+C = 비상정지) ')


def belt_speed_at(elapsed: float, cruise_kmh: float) -> float:
    """벨트 속도 시뮬레이션: 처음 30초 동안 천천히 올린다. 실제 기기에서는 센서 값을 읽는다."""
    return round(min(cruise_kmh, cruise_kmh * elapsed / 30), 1)


# ---------------------------------------------------------------------------

def env(name: str) -> str:
    value = os.environ.get(name, '').strip()
    if not value:
        sys.exit(f'환경 변수 {name}가 필요합니다. device/README.md를 보세요.')
    return value


def connect() -> tuple[Supabase, str]:
    client = Supabase(env('PAWFIT_SUPABASE_URL'), env('PAWFIT_SUPABASE_KEY'))
    client.sign_in(env('PAWFIT_DEVICE_EMAIL'), env('PAWFIT_DEVICE_PASSWORD'))
    return client, env('PAWFIT_TREADMILL_ID')


def show_qr(client: Supabase, treadmill_id: str) -> None:
    payload = client.rpc('get_treadmill_qr', {'p_treadmill_id': treadmill_id})
    print(payload)
    try:
        import qrcode  # 선택: pip install qrcode
    except ImportError:
        print('\n(qrcode 패키지를 설치하면 터미널에 QR을 그려 줍니다: pip install qrcode)')
        print('위 문자열을 아무 QR 생성기에 넣어 출력해 트레드밀에 붙여도 됩니다.')
        return
    qr = qrcode.QRCode(border=2)
    qr.add_data(payload)
    qr.print_ascii(invert=True)


def wait_for_check_in(client: Supabase, treadmill_id: str, poll: float) -> dict:
    print('QR 체크인을 기다리는 중... (앱에서 이 트레드밀의 QR을 스캔하세요)')
    while True:
        rows = client.rpc('get_treadmill_active_booking', {'p_treadmill_id': treadmill_id})
        if isinstance(rows, list) and rows:
            return rows[0]
        time.sleep(poll)


def run_session(client: Supabase, booking: dict, args: argparse.Namespace) -> None:
    session_id = booking.get('session_id')
    if session_id and booking.get('session_status') in ('running', 'paused'):
        print(f'  이미 진행 중인 운동을 이어서 기록합니다 (세션 {session_id})')
    else:
        wait_for_start_button(args.auto_start)
        session = client.rpc('start_exercise_session', {'p_booking_id': booking['booking_id']})
        assert isinstance(session, dict)
        session_id = session['id']
        print(f'  운동 시작 (세션 {session_id})')

    target = int(booking.get('duration_minutes') or 15) * 60
    elapsed = 0.0
    distance = 0.0
    last = time.monotonic()
    try:
        while elapsed < target:
            time.sleep(args.interval)
            now = time.monotonic()
            step = (now - last) * args.speed_factor
            last = now
            speed = belt_speed_at(elapsed, args.speed)
            elapsed = min(target, elapsed + step)
            distance += speed / 3.6 * step
            client.rpc('update_exercise_session_metrics', {
                'p_session_id': session_id,
                'p_current_speed': speed,
                'p_distance_meters': round(distance, 1),
                'p_duration_seconds': int(elapsed),
            })
            print(f'\r  {int(elapsed) // 60:02d}:{int(elapsed) % 60:02d} / {target // 60:02d}:00 · '
                  f'{speed:.1f} km/h · {distance:.0f} m', end='', flush=True)
    except KeyboardInterrupt:
        print('\n  ■ 비상정지')
        client.rpc('finish_exercise_session', {
            'p_session_id': session_id,
            'p_completed': False,
            'p_stop_reason': '비상정지 버튼으로 중단',
        })
        return
    print()
    client.rpc('finish_exercise_session', {'p_session_id': session_id, 'p_completed': True})
    print('  운동 완료 (예약 → 이용 완료)')


def run(client: Supabase, treadmill_id: str, args: argparse.Namespace) -> None:
    while True:
        booking = wait_for_check_in(client, treadmill_id, args.poll)
        print(f"체크인됨: {booking['dog_name']} · {booking.get('program_name') or '운동'} "
              f"({booking.get('duration_minutes')}분)")
        run_session(client, booking, args)
        if args.once:
            return


def main() -> None:
    parser = argparse.ArgumentParser(description='PawFit 트레드밀 기기 테스트 클라이언트')
    sub = parser.add_subparsers(dest='command', required=True)
    sub.add_parser('qr', help='이 트레드밀의 QR 내용을 출력한다')
    run_parser = sub.add_parser('run', help='체크인 대기 → 시작 → 운동 → 종료를 반복한다')
    run_parser.add_argument('--auto-start', action='store_true', help='체크인되면 Enter 없이 바로 시작')
    run_parser.add_argument('--once', action='store_true', help='운동 한 번만 하고 끝낸다')
    run_parser.add_argument('--speed', type=float, default=3.0, help='시뮬레이션 순항 속도 km/h (기본 3.0)')
    run_parser.add_argument('--speed-factor', type=float, default=1.0,
                            help='시간 배속. 10이면 15분 프로그램이 1분 30초에 끝난다 (기본 1)')
    run_parser.add_argument('--interval', type=float, default=2.0, help='지표 전송 간격(초, 기본 2)')
    run_parser.add_argument('--poll', type=float, default=3.0, help='체크인 확인 간격(초, 기본 3)')
    args = parser.parse_args()

    try:
        client, treadmill_id = connect()
        if args.command == 'qr':
            show_qr(client, treadmill_id)
        else:
            run(client, treadmill_id, args)
    except RpcError as error:
        sys.exit(f'서버 오류: {error.message} (HTTP {error.status})')
    except KeyboardInterrupt:
        print('\n종료')


if __name__ == '__main__':
    main()
