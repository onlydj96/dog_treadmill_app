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
  String get bookingHours24 => '24시간';

  @override
  String get bookingIntensityLow => '저강도';

  @override
  String get bookingIntensityMedium => '중강도';

  @override
  String get bookingIntensityHigh => '고강도';

  @override
  String get bookingStatusPending => '예약 대기';

  @override
  String get bookingStatusConfirmed => '예약 확정';

  @override
  String get bookingStatusCheckedIn => '체크인 완료';

  @override
  String get bookingStatusCompleted => '이용 완료';

  @override
  String get bookingStatusCancelled => '취소';

  @override
  String get bookingStatusNoShow => '미방문';

  @override
  String get membershipStatusRefunded => '환불';

  @override
  String get membershipStatusCancelled => '취소';

  @override
  String get membershipStatusExpired => '만료';

  @override
  String get membershipStatusUsedUp => '소진';

  @override
  String get membershipStatusAvailable => '사용 가능';

  @override
  String get paymentStatusPending => '결제 대기';

  @override
  String get paymentStatusPaid => '결제 완료';

  @override
  String get paymentStatusCancelled => '결제 취소';

  @override
  String get paymentStatusRefunded => '환불 완료';

  @override
  String get paymentStatusPartialRefunded => '부분 환불';

  @override
  String get paymentStatusFailed => '결제 실패';

  @override
  String get homeNotificationsTooltip => '알림';

  @override
  String homeGreeting(String name) {
    return '$name님, 안녕하세요';
  }

  @override
  String get homeGreetingNoDog => '반려견을 등록하고 시작해 볼까요?';

  @override
  String homeGreetingWithDog(String dog) {
    return '오늘도 $dog 건강하게 걸어요';
  }

  @override
  String homeDogTapHint(String dog) {
    return '$dog 정보 보기';
  }

  @override
  String get homeProfileIncomplete => '프로필을 완성해 주세요';

  @override
  String homeRankOverallThisMonth(int rank) {
    return '이번 달 전체 $rank위';
  }

  @override
  String get homeSwitchDog => '전환';

  @override
  String get homeStatMonthWorkouts => '이번 달 운동';

  @override
  String get homeUnitTimes => '회';

  @override
  String get homeStatMonthDistance => '이번 달 거리';

  @override
  String get homeStatLatestSymmetry => '최근 좌우 대칭';

  @override
  String get homeNoDogTitle => '반려견을 등록해 주세요';

  @override
  String get homeNoDogBody => '건강 정보와 운동 제한 사항을 함께 등록하면\n예약할 때 주의할 점을 알려 드려요.';

  @override
  String get homeNoDogAction => '반려견 등록하기';

  @override
  String get homeLiveTapHint => '실시간 운동 현황 보기';

  @override
  String get homeQuickBook => '운동 예약';

  @override
  String get homeQuickBookCaption => '빈 시간 확인';

  @override
  String get homeQuickReport => 'AI 리포트';

  @override
  String get homeQuickReportCaption => '보행 분석';

  @override
  String get homeQuickHistory => '운동 기록';

  @override
  String get homeQuickHistoryCaption => '전체 이력';

  @override
  String get homeNextBookingTitle => '다음 예약';

  @override
  String get homeNextBookingAll => '예약 내역';

  @override
  String get homeNextBookingEmpty => '예정된 예약이 없어요.';

  @override
  String get homeNextBookingEmptyAction => '예약하기';

  @override
  String homeRankingTitle(String month) {
    return '$month 랭킹';
  }

  @override
  String get homeRankingAll => '전체 랭킹';

  @override
  String get homeRankingWaitingTitle => '이번 달 첫 운동을 기다리고 있어요';

  @override
  String get homeRankingWaitingCaption => '운동을 마치면 점수가 쌓이고 바로 랭킹에 올라요.';

  @override
  String homeRankingJoinTitle(int rank) {
    return '참여하면 전체 $rank위예요';
  }

  @override
  String homeRankingJoinCaption(String dog) {
    return '랭킹에 참여하고 $dog 자랑해 보세요.';
  }

  @override
  String homeRankingMineTitle(String dog, int rank) {
    return '$dog · 전체 $rank위';
  }

  @override
  String homeRankingHoldingFirst(String points) {
    return '$points · 1위를 지키고 있어요!';
  }

  @override
  String homeRankingPointsToNext(String points, int gap) {
    return '$points · $gap점 더 받으면 순위가 올라요';
  }

  @override
  String homeRankingStreak(int weeks) {
    return '$weeks주 연속 운동';
  }

  @override
  String get homeRankingJoinAction => '랭킹 참여하기';

  @override
  String get homeRecentTitle => '최근 운동';

  @override
  String get homeRecentAll => '전체 기록';

  @override
  String get homeRecentEmpty => '아직 운동 기록이 없어요. 첫 운동을 예약해 보세요!';

  @override
  String get homeAnalysisTitle => 'AI 보행 분석';

  @override
  String get homeAnalysisAction => '건강 리포트';

  @override
  String get homeAnalysisPending => '최근 운동 영상을 분석하고 있어요. 완료되면 알려 드릴게요.';

  @override
  String get homeAnalysisNeedsConsent =>
      '운동 영상 촬영에 동의하면 AI 보행 분석 리포트를 받을 수 있어요.';

  @override
  String get homeAnalysisEmpty => '운동을 마치면 AI 보행 분석 리포트가 여기에 표시돼요.';

  @override
  String get homeAnalysisConsentAction => '동의하기';

  @override
  String get homeAnalysisSymmetry => '좌우 대칭성';

  @override
  String get homeAnalysisCadence => '분당 걸음 수';

  @override
  String get homeUnitSteps => '보';

  @override
  String get homeNoticesTitle => '공지사항';

  @override
  String get homeNoticesAll => '전체보기';

  @override
  String get bookingListTitle => '예약';

  @override
  String get bookingPaymentHistory => '결제·환불 내역';

  @override
  String get bookingTabUpcoming => '예정된 예약';

  @override
  String get bookingTabPast => '지난 예약';

  @override
  String get bookingEmptyUpcoming => '예정된 예약이 없어요';

  @override
  String get bookingEmptyPast => '지난 예약이 없어요';

  @override
  String get bookingEmptyUpcomingHint => '원하는 시간에 트레드밀을 예약해 보세요.';

  @override
  String get bookingUsablePasses => '사용 가능한 이용권';

  @override
  String bookingSessionsUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' 회',
    );
    return '$_temp0';
  }

  @override
  String get bookingNewWorkout => '새 운동 예약';

  @override
  String get bookingCheckInTitle => '체크인할까요?';

  @override
  String get bookingCheckInMessage => '매장에 도착했을 때 체크인해 주세요.';

  @override
  String bookingCheckInMessageWithMachine(String machine) {
    return '매장에 도착했을 때 체크인해 주세요.\n배정된 트레드밀: $machine';
  }

  @override
  String get bookingCheckInAction => '체크인';

  @override
  String get bookingCheckedIn => '체크인했어요.';

  @override
  String bookingCheckedInWithMachine(String machine) {
    return '체크인했어요. 트레드밀 $machine에서 운동을 시작해 주세요.';
  }

  @override
  String get bookingDefaultProgramName => '트레드밀 운동';

  @override
  String get bookingToday => '오늘';

  @override
  String bookingDateSemantics(String month, int day, String weekday) {
    return '$month $day일 $weekday요일';
  }

  @override
  String bookingDateSemanticsToday(String label) {
    return '$label, 오늘';
  }

  @override
  String get bookingSlotsEmpty => '선택한 날짜에 예약 가능한 시간이 없어요.';

  @override
  String get bookingPeriodDawn => '새벽';

  @override
  String get bookingPeriodMorning => '오전';

  @override
  String get bookingPeriodAfternoon => '오후';

  @override
  String get bookingPeriodEvening => '저녁';

  @override
  String bookingSlotSemanticsAvailable(String time, int count) {
    return '$time, 잔여 $count대';
  }

  @override
  String bookingSlotSemanticsFull(String time) {
    return '$time, 마감';
  }

  @override
  String bookingSlotLeft(int count) {
    return '잔여 $count';
  }

  @override
  String get bookingSlotFull => '마감';

  @override
  String get bookingDetailTitle => '예약 상세';

  @override
  String get bookingNoteCancelled => '취소된 예약이에요.';

  @override
  String get bookingNoteNoShow => '방문하지 않아 미방문 처리된 예약이에요.';

  @override
  String get bookingStepReceived => '접수';

  @override
  String get bookingStepConfirmed => '확정';

  @override
  String get bookingStepCheckedIn => '체크인';

  @override
  String get bookingStepCompleted => '이용 완료';

  @override
  String get bookingInfoDog => '반려견';

  @override
  String get bookingInfoLocation => '지점';

  @override
  String get bookingInfoTreadmill => '트레드밀';

  @override
  String get bookingInfoProgram => '프로그램';

  @override
  String get bookingInfoPayment => '결제';

  @override
  String get bookingInfoNote => '메모';

  @override
  String get bookingInfoCancellation => '취소';

  @override
  String bookingDurationMinutes(int minutes) {
    return '$minutes분';
  }

  @override
  String get bookingPayWithPass => '이용권 1회 사용';

  @override
  String get bookingPayOnSite => '현장 결제';

  @override
  String get bookingCancelledToast => '예약을 취소했어요.';

  @override
  String get bookingRescheduledToast => '예약 시간을 변경했어요.';

  @override
  String get bookingViewWorkoutHistory => '운동 기록 보기';

  @override
  String bookingAtMachine(String machine) {
    return '트레드밀 $machine에서';
  }

  @override
  String get bookingAtAssignedMachine => '배정된 트레드밀에서';

  @override
  String get bookingPayOnSiteNotice => '\n현장 결제 예약이라 이용 전에 매장에서 결제해 주세요.';

  @override
  String bookingGuideCheckedIn(String atMachine, String payOnSite) {
    return '체크인했어요. $atMachine 운동을 시작하고, 운동하는 동안 반려견 곁을 지켜 주세요. 운동이 시작되면 운동 탭에서 실시간으로 볼 수 있어요.$payOnSite';
  }

  @override
  String get bookingGuideEnded => '예약 시간이 지나 체크인할 수 없어요.';

  @override
  String bookingGuideCheckInOpen(String atMachine, String payOnSite) {
    return '매장에 도착하면 체크인하고 $atMachine 운동을 시작해 주세요.$payOnSite';
  }

  @override
  String bookingGuideModifiable(String time) {
    return '예약 시작 1시간 전까지 변경·취소할 수 있어요.\n이용 당일 $time부터 앱에서 체크인할 수 있어요.';
  }

  @override
  String bookingGuideModifiableWithPass(String time) {
    return '예약 시작 1시간 전까지 변경·취소할 수 있어요. 취소하면 이용권 횟수가 복구돼요.\n이용 당일 $time부터 앱에서 체크인할 수 있어요.';
  }

  @override
  String bookingGuideLocked(String time) {
    return '$time부터 앱에서 체크인할 수 있어요.\n예약 시작 1시간 전부터는 앱에서 변경·취소할 수 없어요.';
  }

  @override
  String get bookingCancelAction => '예약 취소';

  @override
  String get bookingRescheduleAction => '시간 변경';

  @override
  String get bookingInquiryAction => '1:1 문의하기';

  @override
  String get bookingCancelReasonSchedule => '일정이 변경되었어요';

  @override
  String get bookingCancelReasonCondition => '반려견 컨디션이 좋지 않아요';

  @override
  String get bookingCancelReasonRebook => '다른 시간으로 다시 예약할게요';

  @override
  String get bookingCancelReasonOther => '기타';

  @override
  String get bookingCancelSheetTitle => '예약을 취소할까요?';

  @override
  String get bookingCancelSheetSubtitle => '취소 사유를 선택해 주세요.';

  @override
  String get bookingCancelConfirmAction => '예약 취소하기';

  @override
  String get bookingRescheduleTitle => '예약 시간 변경';

  @override
  String bookingRescheduleCurrent(String when, String branch) {
    return '현재 $when · $branch';
  }

  @override
  String get bookingRescheduleNoProgram =>
      '프로그램 정보가 없어 시간을 변경할 수 없어요. 1:1 문의로 알려 주세요.';

  @override
  String get bookingReschedulePick => '변경할 시간을 선택해 주세요';

  @override
  String bookingRescheduleSubmit(String time) {
    return '$time 예약으로 변경';
  }

  @override
  String get bookingConfirmedToast => '예약이 확정되었어요.';

  @override
  String get bookingReceivedToast => '예약이 접수되었어요. 이용 당일 매장에서 결제해 주세요.';

  @override
  String get bookingNewTitle => '운동 예약';

  @override
  String get bookingStepDog => '반려견';

  @override
  String get bookingStepBranch => '지점';

  @override
  String get bookingStepProgram => '운동 프로그램';

  @override
  String get bookingStepDate => '날짜';

  @override
  String get bookingStepTime => '시간';

  @override
  String get bookingStepPayment => '결제';

  @override
  String get bookingStepNote => '메모 (선택)';

  @override
  String get bookingNeedDogMessage => '예약하려면 먼저 반려견을 등록해 주세요.';

  @override
  String get bookingNeedDogAction => '등록하기';

  @override
  String get bookingTimeHint => '지점과 운동 프로그램을 선택하면 예약 가능한 시간이 표시돼요.';

  @override
  String bookingPassValidUntil(String date) {
    return '~ $date까지';
  }

  @override
  String bookingPassRemaining(int count) {
    return '잔여 $count회';
  }

  @override
  String get bookingPayOnSiteBody => '예약 대기로 접수되고, 이용 당일 매장에서 결제해요.';

  @override
  String get bookingNoteHint => '반려견에 대해 남겨 둘 내용을 적어 주세요. (예: 낯선 소리에 예민해요)';

  @override
  String get bookingSelfServiceHint =>
      '무인 매장이에요. 이용 당일 예약 시작 15분 전부터 앱에서 체크인하고, 배정된 트레드밀에서 운동을 시작해 주세요.\n예약 시작 1시간 전까지 앱에서 변경·취소할 수 있어요. 이용권으로 예약한 경우 취소하면 횟수가 복구돼요.';

  @override
  String get bookingSummaryIncomplete => '반려견, 지점, 프로그램, 시간을 선택해 주세요.';

  @override
  String bookingSummary(String dog, String when, String program,
      String duration, String payment) {
    return '$dog · $when\n$program $duration · $payment';
  }

  @override
  String get bookingSummaryPayWithPass => '이용권 1회 차감';

  @override
  String get bookingAppPaymentTitle => '앱 결제';

  @override
  String get bookingAppPaymentBody => '카드·간편결제로 바로 결제하고 예약을 확정해요.';

  @override
  String get bookingComingSoon => '준비 중';

  @override
  String bookingRestrictionNotice(String restrictions) {
    return '운동 제한 사항: $restrictions\n무인 매장이라 보호자가 직접 확인해야 해요. 제한 사항에 맞는 프로그램을 고르고, 운동하는 동안 곁에서 지켜봐 주세요.';
  }

  @override
  String get bookingSubmit => '예약하기';

  @override
  String get membershipTitle => '이용권';

  @override
  String get membershipPaymentHistory => '결제 내역';

  @override
  String get membershipOwnedTitle => '보유 이용권';

  @override
  String get membershipOwnedEmpty =>
      '보유한 이용권이 없어요. 아래 상품을 구매하면 앱에서 바로 예약에 사용할 수 있어요.';

  @override
  String get membershipPlansTitle => '이용권 상품';

  @override
  String get membershipPurchaseNote =>
      '상품을 누르면 결제 방법을 볼 수 있어요. 앱 결제는 준비 중이라 지금은 매장에서 구매할 수 있고, 구매하면 바로 보유 이용권에 반영돼요.';

  @override
  String membershipDaysLeft(int days) {
    return 'D-$days';
  }

  @override
  String membershipSessionsLeft(int total) {
    return '/ $total회 남음';
  }

  @override
  String membershipPlanSessionsBadge(int count) {
    return '$count회';
  }

  @override
  String membershipValidDays(int days) {
    return '유효기간 $days일';
  }

  @override
  String membershipPricePerSession(String price) {
    return '회당 $price';
  }

  @override
  String membershipPurchaseSummary(String price, int count, int days) {
    return '$price · $count회 · 유효기간 $days일';
  }

  @override
  String get membershipAppPaymentTitle => '앱 결제';

  @override
  String get membershipAppPaymentBody => '카드·간편결제로 결제하면 바로 보유 이용권에 추가돼요.';

  @override
  String get membershipComingSoon => '준비 중';

  @override
  String get membershipStorePaymentTitle => '매장 결제';

  @override
  String get membershipStorePaymentBody =>
      '지금은 매장에서 구매할 수 있어요. 구매하면 바로 앱의 보유 이용권에 반영돼요.';

  @override
  String get membershipAppPaymentUnavailable => '앱 결제 준비 중';

  @override
  String get paymentHistoryTitle => '결제·환불 내역';

  @override
  String get paymentEmpty => '결제 내역이 없어요';

  @override
  String get paymentDefaultOrderName => '이용권 결제';

  @override
  String paymentRefunded(String amount) {
    return '환불 $amount';
  }

  @override
  String paymentRefundedOn(String amount, String date) {
    return '환불 $amount ($date)';
  }
}
