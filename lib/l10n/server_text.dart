import 'l10n.dart';

/// 서버(DB 함수)가 기본값으로 저장하는 한국어 문구를 현재 언어로 바꾼다.
/// 운영자·기기가 직접 입력한 문구는 그대로 둔다.
///
/// 예) 사유 없이 중단된 운동의 stop_reason '운영자 판단에 의한 중단'
///     (supabase/migrations/20261109000400_exercise_rpc_and_notifications.sql)
String localizedStopReason(String reason) => switch (reason.trim()) {
      '운영자 판단에 의한 중단' => L10n.current.serverStopReasonByStaff,
      _ => reason,
    };
