import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'PawFit';

  @override
  String get commonConfirm => '확인';

  @override
  String get commonCancel => '취소';

  @override
  String get commonRetry => '다시 시도';

  @override
  String get commonSave => '저장';

  @override
  String get commonDelete => '삭제';

  @override
  String get commonEdit => '수정';

  @override
  String get commonClose => '닫기';

  @override
  String get commonDone => '완료';

  @override
  String get commonNext => '다음';

  @override
  String get commonPrevious => '이전';

  @override
  String get commonAdd => '추가';

  @override
  String get commonManage => '관리';

  @override
  String get commonViewAll => '전체 보기';

  @override
  String get commonYes => '예';

  @override
  String get commonNo => '아니요';

  @override
  String get commonNone => '없음';

  @override
  String get commonOptional => '선택';

  @override
  String get commonRequired => '필수';

  @override
  String get commonOwnerFallbackName => '보호자';

  @override
  String get commonAiDisclaimer =>
      'AI 분석 결과는 보행 변화에 대한 참고 정보이며, 질병 진단이나 수의사의 진료를 대체하지 않습니다. 이상 징후가 의심되면 동물병원 진료를 받아 주세요.';

  @override
  String get navHome => '홈';

  @override
  String get navBooking => '예약';

  @override
  String get navExercise => '운동';

  @override
  String get navHealth => '건강';

  @override
  String get navMyPage => '마이페이지';

  @override
  String get languageMenuTitle => '언어 (Language)';

  @override
  String get languagePickerTitle => '언어 / Language';

  @override
  String get videoDefaultTitle => '운동 영상';

  @override
  String get configMissingTitle => 'Supabase 설정이 필요해요';

  @override
  String get configMissingBody =>
      '프로젝트 루트의 .env에 SUPABASE_URL과 SUPABASE_PUBLISHABLE_KEY를 넣고 아래와 같이 실행해 주세요.';

  @override
  String get fmtPatternDate => 'M월 d일 (E)';

  @override
  String get fmtPatternDateFull => 'yyyy년 M월 d일 (E)';

  @override
  String get fmtPatternDateShort => 'yyyy.MM.dd';

  @override
  String get fmtPatternMonthDay => 'M.d';

  @override
  String get fmtPatternYearMonth => 'yyyy년 M월';

  @override
  String get fmtPatternMonth => 'M월';

  @override
  String get fmtPatternWeekday => 'E';

  @override
  String get fmtAm => '오전';

  @override
  String get fmtPm => '오후';

  @override
  String fmtTime(String period, String time) {
    return '$period $time';
  }

  @override
  String fmtDateTime(String date, String time) {
    return '$date $time';
  }

  @override
  String fmtTimeRange(String start, String end) {
    return '$start ~ $end';
  }

  @override
  String fmtWon(String amount) {
    return '$amount원';
  }

  @override
  String fmtPoints(num count, String formatted) {
    return '$formatted점';
  }

  @override
  String fmtDurationHourMinute(int hours, int minutes) {
    return '$hours시간 $minutes분';
  }

  @override
  String fmtDurationHour(int hours) {
    return '$hours시간';
  }

  @override
  String fmtDurationMinuteSecond(int minutes, int seconds) {
    return '$minutes분 $seconds초';
  }

  @override
  String fmtDurationMinute(int minutes) {
    return '$minutes분';
  }

  @override
  String fmtDurationSecond(int seconds) {
    return '$seconds초';
  }

  @override
  String get fmtJustNow => '방금 전';

  @override
  String fmtMinutesAgo(int minutes) {
    return '$minutes분 전';
  }

  @override
  String fmtHoursAgo(int hours) {
    return '$hours시간 전';
  }

  @override
  String fmtDaysAgo(int days) {
    return '$days일 전';
  }

  @override
  String get fmtDogAgeUnderOneMonth => '1개월 미만';

  @override
  String fmtDogAgeMonths(int months) {
    return '$months개월';
  }

  @override
  String fmtDogAgeYears(int years) {
    return '$years살';
  }

  @override
  String validationRequired(String label) {
    return '$label을(를) 입력해 주세요.';
  }

  @override
  String get validationEmailRequired => '이메일을 입력해 주세요.';

  @override
  String get validationEmailInvalid => '올바른 이메일 형식이 아니에요.';

  @override
  String get validationPasswordRequired => '비밀번호를 입력해 주세요.';

  @override
  String get validationPasswordTooShort => '8자 이상 입력해 주세요.';

  @override
  String get validationPasswordLettersAndDigits => '영문과 숫자를 함께 사용해 주세요.';

  @override
  String get validationPhoneRequired => '휴대전화 번호를 입력해 주세요.';

  @override
  String get validationPhoneInvalid => '올바른 휴대전화 번호가 아니에요.';

  @override
  String get validationNameRequired => '이름을 입력해 주세요.';

  @override
  String get validationNameTooLong => '20자 이내로 입력해 주세요.';

  @override
  String get validationNicknameRequired => '닉네임을 입력해 주세요.';

  @override
  String get validationNicknameLength => '2~12자로 입력해 주세요.';

  @override
  String get validationNicknameCharacters => '한글·영문·숫자·밑줄(_)만 쓸 수 있어요.';

  @override
  String get errorAuthRequired => '로그인이 필요해요. 다시 로그인해 주세요.';

  @override
  String get errorDogNotFound => '반려견 정보를 찾을 수 없어요.';

  @override
  String get errorBranchNotFound => '지점 정보를 찾을 수 없어요.';

  @override
  String get errorProgramNotFound => '운동 프로그램 정보를 찾을 수 없어요.';

  @override
  String get errorSlotInPast => '이미 지난 시간이에요. 다른 시간을 선택해 주세요.';

  @override
  String get errorSlotNotAvailable => '예약할 수 없는 시간이에요. 다른 시간을 선택해 주세요.';

  @override
  String get errorSlotFull => '선택한 시간의 트레드밀이 모두 예약되었어요. 다른 시간을 선택해 주세요.';

  @override
  String get errorDogAlreadyBooked => '같은 시간에 이미 이 반려견의 예약이 있어요.';

  @override
  String get errorMembershipNotFound => '이용권을 찾을 수 없어요.';

  @override
  String get errorMembershipNotUsable =>
      '선택한 이용권은 이 시간에 사용할 수 없어요. 잔여 횟수와 유효기간을 확인해 주세요.';

  @override
  String get errorBookingNotFound => '예약 정보를 찾을 수 없어요.';

  @override
  String get errorBookingNotCancellable => '이미 진행되었거나 취소된 예약이에요.';

  @override
  String get errorChangeDeadlinePassed =>
      '예약 시작 1시간 전부터는 앱에서 변경·취소할 수 없어요. 1:1 문의로 알려 주세요.';

  @override
  String get errorInvalidBookingStatus => '이미 체크인했거나 끝난 예약이에요.';

  @override
  String get errorCheckInTooEarly => '체크인은 예약 시작 15분 전부터 할 수 있어요.';

  @override
  String get errorCheckInClosed => '예약 시간이 지나 체크인할 수 없어요.';

  @override
  String get errorNicknameInvalid => '닉네임은 2~12자의 한글·영문·숫자·밑줄(_)로 입력해 주세요.';

  @override
  String get errorNicknameForbidden => '사용할 수 없는 단어가 들어 있어요. 다른 닉네임을 입력해 주세요.';

  @override
  String get errorNicknameTaken => '이미 사용 중인 닉네임이에요.';

  @override
  String get errorNicknameCooldown => '닉네임은 30일에 한 번 바꿀 수 있어요.';

  @override
  String get errorCannotCheerOwnDog => '내 반려견은 응원할 수 없어요.';

  @override
  String get errorInvalidRankingScope => '랭킹 정보를 불러오지 못했어요. 다시 시도해 주세요.';

  @override
  String get errorInvalidCredentials => '이메일 또는 비밀번호가 올바르지 않아요.';

  @override
  String get errorEmailNotConfirmed => '이메일 인증을 완료한 뒤 로그인해 주세요.';

  @override
  String get errorUserAlreadyExists => '이미 가입된 이메일이에요.';

  @override
  String get errorWeakPassword => '비밀번호가 너무 단순해요. 영문과 숫자를 섞어 8자 이상 입력해 주세요.';

  @override
  String get errorSamePassword => '기존 비밀번호와 다른 비밀번호를 입력해 주세요.';

  @override
  String get errorRateLimited => '요청이 많아요. 잠시 후 다시 시도해 주세요.';

  @override
  String get errorSignupDisabled => '현재 회원가입을 받을 수 없어요.';

  @override
  String get errorPermissionDenied => '이 작업을 수행할 권한이 없어요.';

  @override
  String get errorNotFound => '요청한 정보를 찾을 수 없어요.';

  @override
  String get errorAuthGeneric => '인증 처리 중 문제가 발생했어요. 다시 시도해 주세요.';

  @override
  String get errorStorage => '파일을 처리하지 못했어요. 사진 크기(5MB 이하)와 형식을 확인해 주세요.';

  @override
  String get errorFunction => '요청을 처리하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get errorNetwork => '네트워크 연결을 확인한 뒤 다시 시도해 주세요.';

  @override
  String get errorGeneric => '문제가 발생했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get serverStopReasonByStaff => '운영자 판단에 의한 중단';

  @override
  String get exerciseStatusReady => '준비 중';

  @override
  String get exerciseStatusRunning => '운동 중';

  @override
  String get exerciseStatusPaused => '일시정지';

  @override
  String get exerciseStatusCompleted => '운동 완료';

  @override
  String get exerciseStatusStopped => '운동 중단';

  @override
  String get exerciseHistoryTitle => '운동 기록';

  @override
  String exerciseHistoryTitleDog(String dog) {
    return '$dog의 운동 기록';
  }

  @override
  String get exerciseTitle => '운동';

  @override
  String exerciseTitleDog(String dog) {
    return '$dog의 운동';
  }

  @override
  String get exerciseNoDogTitle => '등록된 반려견이 없어요';

  @override
  String get exerciseNoDogHistoryMessage => '반려견을 등록하면 운동 기록을 볼 수 있어요.';

  @override
  String get exerciseNoDogLiveMessage => '반려견을 등록하면 운동 현황과 기록을 볼 수 있어요.';

  @override
  String get exerciseRegisterDog => '반려견 등록';

  @override
  String get exerciseNoRecordsTitle => '아직 운동 기록이 없어요';

  @override
  String get exerciseNoRecordsHistoryMessage => '운동을 마치면 날짜별 기록이 쌓여요.';

  @override
  String get exerciseNoRecordsSummaryMessage => '운동을 마치면 시간, 거리, 속도가 기록돼요.';

  @override
  String exerciseSessionCount(int count) {
    return '$count회';
  }

  @override
  String get exerciseTotalsTitle => '누적 운동 기록';

  @override
  String get exerciseStatTotalWorkouts => '총 운동';

  @override
  String get exerciseStatTotalTime => '총 시간';

  @override
  String get exerciseStatTotalDistance => '총 거리';

  @override
  String get exerciseStatBestSpeed => '최고 속도';

  @override
  String get exerciseUnitTimes => '회';

  @override
  String get exerciseUnitMinutes => '분';

  @override
  String get exerciseCompletedToast => '운동을 완료했어요!';

  @override
  String get exerciseStoppedToast => '운동이 중단되었어요.';

  @override
  String get exerciseLive => '실시간';

  @override
  String get exerciseElapsed => '경과 시간';

  @override
  String exerciseTarget(String duration) {
    return '목표 $duration';
  }

  @override
  String get exerciseCurrentSpeed => '현재 속도';

  @override
  String get exerciseDistance => '이동 거리';

  @override
  String get exerciseStartTime => '시작 시간';

  @override
  String get exerciseTreadmill => '트레드밀';

  @override
  String get exerciseUnmannedNotice =>
      '무인 매장이에요. 운동하는 동안 반려견 곁을 지켜 주시고, 이상하면 트레드밀의 비상정지 버튼을 눌러 주세요.';

  @override
  String get exerciseNoLiveTitle => '진행 중인 운동이 없어요';

  @override
  String get exerciseNoLiveMessage => '운동이 시작되면 이곳에서 실시간으로 확인할 수 있어요.';

  @override
  String get exerciseBookWorkout => '운동 예약하기';

  @override
  String get exerciseNextBooking => '다음 예약';

  @override
  String get exerciseMyBookings => '예약 내역';

  @override
  String exerciseMonthSummary(int month) {
    return '$month월 운동 요약';
  }

  @override
  String get exerciseStatCount => '운동 횟수';

  @override
  String get exerciseStatTotalWorkoutTime => '총 운동 시간';

  @override
  String get exerciseRecentRecords => '최근 운동 기록';

  @override
  String get exerciseAllRecords => '전체 기록';

  @override
  String exerciseTreadmillName(String name) {
    return '트레드밀 $name';
  }

  @override
  String get exerciseWorkoutTime => '운동 시간';

  @override
  String get exerciseAvgMax => '평균 / 최고';

  @override
  String exerciseStopReason(String reason) {
    return '중단 사유: $reason';
  }

  @override
  String get exercisePointsVoided => '운영자 확인 후 무효 처리된 기록이에요';

  @override
  String exercisePointsWeeklyBonus(String points) {
    return '주간 보너스 $points 포함';
  }

  @override
  String get exercisePointsDefault => '랭킹 점수';

  @override
  String get exerciseReportAi => 'AI 리포트';

  @override
  String get exerciseReportFailed => '분석 실패';

  @override
  String get exerciseReportPending => '분석 중';

  @override
  String get analysisStatusQueued => '분석 대기';

  @override
  String get analysisStatusProcessing => '분석 중';

  @override
  String get analysisStatusCompleted => '분석 완료';

  @override
  String get analysisStatusFailed => '분석 실패';

  @override
  String get analysisLevelNormal => '특이사항 없음';

  @override
  String get analysisLevelCaution => '관찰 필요';

  @override
  String get analysisLevelWarning => '주의 필요';

  @override
  String get analysisCameraFront => '정면 영상';

  @override
  String get analysisCameraSide => '측면 영상';

  @override
  String get healthTitle => '건강';

  @override
  String healthTitleDog(String dog) {
    return '$dog의 건강 분석';
  }

  @override
  String get healthNoDogMessage => '반려견을 등록하고 운동하면 AI 보행 분석 결과를 볼 수 있어요.';

  @override
  String get healthReports => '분석 리포트';

  @override
  String healthPendingBanner(int count) {
    return '운동 영상 $count건을 분석하고 있어요. 완료되면 알림으로 알려 드릴게요.';
  }

  @override
  String get healthPreparingTitle => '첫 분석 리포트를 준비하고 있어요';

  @override
  String get healthPreparingMessage =>
      '운동 영상으로 관절 움직임과 보행 패턴을 분석 중이에요. 완료되면 알림으로 알려 드릴게요.';

  @override
  String get healthConsentTitle => '운동 영상 촬영 동의가 필요해요';

  @override
  String get healthConsentMessage =>
      'AI 보행 분석 리포트는 운동 영상으로 만들어요. 동의하면 다음 운동부터 관절 움직임과 보행 패턴을 분석해 드려요.';

  @override
  String get healthConsentAction => '동의하러 가기';

  @override
  String get healthNoReportTitle => '아직 분석 리포트가 없어요';

  @override
  String get healthNoReportMessage =>
      '트레드밀 운동을 마치면 촬영 영상으로 관절 움직임과 보행 패턴을 분석해 드려요.';

  @override
  String get healthLatestAnalysis => '최근 분석';

  @override
  String get healthSymmetry => '좌우 대칭성';

  @override
  String get healthCadence => '분당 걸음 수';

  @override
  String get healthRhythm => '보행 리듬';

  @override
  String get healthUnitPoints => '점';

  @override
  String get healthConfidence => '분석 신뢰도';

  @override
  String get healthViewReport => '리포트 자세히 보기 →';

  @override
  String get healthTrendSymmetryDesc =>
      '좌우 다리 움직임이 얼마나 비슷한지 보여줘요. 높을수록 균형 잡힌 보행이에요.';

  @override
  String get healthTrendCadenceDesc =>
      '1분 동안의 걸음 수예요. 평소 기준선과 크게 달라지면 관찰이 필요해요.';

  @override
  String get healthTrendVariabilityDesc =>
      '걸음걸이 주기가 얼마나 일정한지 보여줘요. 낮을수록 리듬이 안정적이에요.';

  @override
  String get healthTrendTitle => '보행 변화 추이';

  @override
  String get healthTrendSegSymmetry => '대칭성';

  @override
  String get healthTrendSegCadence => '걸음 수';

  @override
  String get healthTrendSegVariability => '변동성';

  @override
  String get healthTrendNeedMore => '추이를 보려면 분석 결과가 2건 이상 필요해요.';

  @override
  String get healthJointRomTitle => '관절 가동 범위 변화';

  @override
  String get healthAllJoints => '전체 관절';

  @override
  String get healthPlanTitle => '맞춤 운동 계획';

  @override
  String get healthPlanTargetTime => '목표 시간';

  @override
  String get healthPlanTargetSpeed => '목표 속도';

  @override
  String get healthVideoPause => '일시정지';

  @override
  String get healthVideoPlay => '재생';
}
