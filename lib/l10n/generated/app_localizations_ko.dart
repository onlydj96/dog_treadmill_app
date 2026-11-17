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
  String get authTagline => '트레드밀 예약부터 AI 보행 분석까지,\n우리 아이의 건강한 걸음을 함께 기록해요.';

  @override
  String get authEmail => '이메일';

  @override
  String get authPassword => '비밀번호';

  @override
  String get authShowPassword => '비밀번호 보기';

  @override
  String get authHidePassword => '비밀번호 숨기기';

  @override
  String get authLogIn => '로그인';

  @override
  String get authNoAccount => '아직 회원이 아니신가요?';

  @override
  String get authSignUp => '회원가입';

  @override
  String get signupTitle => '회원가입';

  @override
  String get signupOwnerSection => '보호자 정보';

  @override
  String get signupName => '이름';

  @override
  String get signupPhone => '휴대전화 번호';

  @override
  String get signupLoginSection => '로그인 정보';

  @override
  String get signupPasswordHelper => '영문과 숫자를 포함해 8자 이상';

  @override
  String get signupConfirmPassword => '비밀번호 확인';

  @override
  String get signupPasswordMismatch => '비밀번호가 일치하지 않아요.';

  @override
  String get signupRequiredConsent => '필수 약관에 동의해 주세요.';

  @override
  String get signupVerifyTitle => '인증 메일을 보냈어요';

  @override
  String signupVerifyBody(String email) {
    return '$email으로 보낸 메일의 링크를 눌러 가입을 완료한 뒤 로그인해 주세요.';
  }

  @override
  String get signupSubmit => '가입하기';

  @override
  String get signupAgreeAll => '전체 동의';

  @override
  String get signupAgreeAllDesc => '선택 항목을 포함한 모든 항목에 동의합니다.';

  @override
  String get signupRequiredTag => '[필수] ';

  @override
  String get signupOptionalTag => '[선택] ';

  @override
  String get consentTermsTitle => '서비스 이용약관';

  @override
  String get consentTermsDesc => 'PawFit 서비스 이용에 관한 약관입니다.';

  @override
  String get consentPrivacyTitle => '개인정보 수집·이용';

  @override
  String get consentPrivacyDesc =>
      '회원 식별, 예약·결제 처리, 고객 상담을 위해 이름·연락처·이메일과 반려견 정보를 수집합니다.';

  @override
  String get consentVideoTitle => '운동 영상 촬영 및 AI 분석';

  @override
  String get consentVideoDesc =>
      '트레드밀 운동 중 반려견의 정면·측면 영상을 촬영해 관절·보행 분석 리포트를 만듭니다. 동의하지 않으면 AI 분석 리포트가 제공되지 않습니다.';

  @override
  String get consentAiTrainingTitle => 'AI 학습 데이터 활용';

  @override
  String get consentAiTrainingDesc =>
      '촬영 영상과 관절 좌표를 비식별화해 AI 모델 개선에 활용합니다. 동의하지 않아도 서비스 이용에는 제한이 없습니다.';

  @override
  String get consentRankingTitle => '랭킹 참여 (닉네임·반려견 공개)';

  @override
  String get consentRankingDesc =>
      '월간 랭킹과 명예의 전당에 닉네임, 반려견 이름·견종·사진, 운동 점수를 다른 회원에게 보여줍니다. 실명·이메일·연락처는 공개되지 않으며, 철회하면 바로 랭킹에서 빠집니다.';

  @override
  String get consentMarketingTitle => '마케팅 정보 수신';

  @override
  String get consentMarketingDesc => '이벤트와 혜택 소식을 알림으로 받습니다.';

  @override
  String get consentScreenTitle => '개인정보 및 영상 이용 동의';

  @override
  String get consentIntro => '동의 항목은 언제든 변경할 수 있으며, 변경 이력은 안전하게 보관됩니다.';

  @override
  String get consentRequiredNote =>
      '필수 항목은 서비스 제공에 꼭 필요해 철회할 수 없어요. 철회를 원하면 회원 탈퇴를 진행해 주세요.';

  @override
  String get consentWithdrawVideoTitle => '영상 촬영 동의를 철회할까요?';

  @override
  String get consentWithdrawVideoMessage =>
      '철회하면 다음 운동부터 AI 보행 분석 리포트가 제공되지 않아요. 이미 받은 리포트는 그대로 볼 수 있어요.';

  @override
  String get consentWithdrawVideoConfirm => '철회';

  @override
  String get consentLeaveRankingTitle => '랭킹에서 나갈까요?';

  @override
  String get consentLeaveRankingMessage =>
      '순위표와 명예의 전당에서 닉네임과 반려견 정보가 바로 가려져요. 점수와 배지는 그대로 쌓여요.';

  @override
  String get consentLeaveRankingConfirm => '나가기';

  @override
  String get consentGranted => '동의';

  @override
  String get consentNotGranted => '미동의';

  @override
  String consentStatusLine(String state, String date, String version) {
    return '$state · $date · v$version';
  }

  @override
  String get myPageTitle => '마이페이지';

  @override
  String myPageGreeting(String name) {
    return '$name님';
  }

  @override
  String get myPageMyDogs => '내 반려견';

  @override
  String get myPageUsageGroup => '이용 내역';

  @override
  String get myPageMembership => '이용권 및 멤버십';

  @override
  String get myPagePayments => '결제·환불 내역';

  @override
  String get myPageBookings => '예약 내역';

  @override
  String get myPageWorkoutHistory => '운동 누적 기록';

  @override
  String get myPageRankingGroup => '랭킹';

  @override
  String get myPageRankingHall => '월간 랭킹·명예의 전당';

  @override
  String get myPageRankingSettings => '랭킹 참여·닉네임 설정';

  @override
  String get myPageSettingsGroup => '설정';

  @override
  String get myPageProfile => '프로필 및 로그인 계정';

  @override
  String get myPageSupportGroup => '고객지원';

  @override
  String get myPageLogOut => '로그아웃';

  @override
  String get myPageLogOutMessage => '로그아웃할까요?';

  @override
  String get myPageDeleteAccount => '회원 탈퇴';

  @override
  String get myPageDeleteMessage =>
      '탈퇴하면 반려견 정보, 예약, 운동·분석 기록과 남은 이용권이 모두 삭제되며 복구할 수 없어요. 결제 기록은 관련 법령에 따라 일정 기간 보관됩니다.\n\n정말 탈퇴할까요?';

  @override
  String get myPageDeleteConfirm => '탈퇴하기';

  @override
  String get profileEditTitle => '프로필 및 로그인 계정';

  @override
  String get profileEditProfileSection => '프로필';

  @override
  String get profileEditSave => '프로필 저장';

  @override
  String get profileEditSaved => '프로필을 저장했어요.';

  @override
  String get profileEditLoginSection => '로그인 계정';

  @override
  String get profileEditNewPassword => '새 비밀번호';

  @override
  String get profileEditConfirmNewPassword => '새 비밀번호 확인';

  @override
  String get profileEditChangePassword => '비밀번호 변경';

  @override
  String get profileEditPasswordChanged => '비밀번호를 변경했어요.';

  @override
  String get notificationSettingsTitle => '알림 설정';

  @override
  String get notificationSettingsBooking => '예약 알림';

  @override
  String get notificationSettingsBookingDesc => '예약 확정·취소, 미방문 처리';

  @override
  String get notificationSettingsExercise => '운동 알림';

  @override
  String get notificationSettingsExerciseDesc => '운동 시작·완료·중단';

  @override
  String get notificationSettingsAnalysis => 'AI 분석 알림';

  @override
  String get notificationSettingsAnalysisDesc => '보행 분석 리포트 도착';

  @override
  String get notificationSettingsRanking => '랭킹 알림';

  @override
  String get notificationSettingsRankingDesc => '배지 획득, 응원, 월간 순위 확정';

  @override
  String get notificationSettingsMarketing => '이벤트·혜택 알림';

  @override
  String get notificationSettingsMarketingDesc => '마케팅 정보 수신 동의에서 설정할 수 있어요.';

  @override
  String get notificationTitle => '알림';

  @override
  String get notificationMarkAllRead => '모두 읽음';

  @override
  String get notificationEmptyTitle => '새 알림이 없어요';

  @override
  String get notificationEmptyMessage =>
      '예약 확정, 운동 시작·완료, AI 분석 결과, 배지·랭킹 소식을 알려 드려요.';

  @override
  String get notificationUnreadLabel => '읽지 않은 알림';

  @override
  String get notificationBookingConfirmedTitle => '예약이 확정되었어요';

  @override
  String notificationBookingConfirmedBody(String dog, String when) {
    return '$dog · $when 예약이 확정되었습니다.';
  }

  @override
  String get notificationBookingCancelledTitle => '예약이 취소되었어요';

  @override
  String notificationBookingCancelledBody(String dog, String when) {
    return '$dog · $when 예약이 헬스장 사정으로 취소되었습니다.';
  }

  @override
  String get notificationBookingNoShowTitle => '미방문 처리되었어요';

  @override
  String notificationBookingNoShowBody(String dog, String when) {
    return '$dog · $when 예약이 미방문으로 처리되었습니다.';
  }

  @override
  String get notificationExerciseStartedTitle => '운동을 시작했어요';

  @override
  String notificationExerciseStartedBody(String dog) {
    return '$dog의 트레드밀 운동이 시작되었습니다. 실시간 현황을 확인해 보세요.';
  }

  @override
  String get notificationExerciseCompletedTitle => '운동을 완료했어요';

  @override
  String notificationExerciseCompletedBody(String dog) {
    return '$dog의 운동이 끝났어요. 운동 기록을 확인해 보세요.';
  }

  @override
  String notificationExerciseCompletedPointsBody(String dog, String points) {
    return '$dog의 운동이 끝났어요. $points을 받았어요! 운동 기록을 확인해 보세요.';
  }

  @override
  String get notificationExerciseStoppedTitle => '운동이 중단되었어요';

  @override
  String notificationExerciseStoppedBody(String dog, String reason) {
    return '$dog의 운동이 중단되었습니다. 사유: $reason';
  }

  @override
  String get notificationAnalysisCompletedTitle => 'AI 보행 분석 리포트가 도착했어요';

  @override
  String notificationAnalysisCompletedBody(String dog) {
    return '$dog의 운동 분석 결과를 확인해 보세요.';
  }

  @override
  String get notificationAnalysisFailedTitle => 'AI 분석을 완료하지 못했어요';

  @override
  String notificationAnalysisFailedBody(String dog) {
    return '$dog의 영상 분석 중 문제가 발생했습니다. 헬스장에서 확인 후 다시 분석합니다.';
  }

  @override
  String get notificationBadgeEarnedTitle => '새 배지를 받았어요';

  @override
  String notificationBadgeEarnedBody(String dog, String badge) {
    return '$dog의 「$badge」 배지가 도착했어요. 배지함에서 확인해 보세요.';
  }

  @override
  String get notificationCheerReceivedTitle => '응원이 도착했어요';

  @override
  String notificationCheerReceivedBody(String nickname, String dog) {
    return '$nickname님이 $dog 응원했어요.';
  }

  @override
  String notificationCheerReceivedAnonymousBody(String dog) {
    return '다른 보호자가 $dog 응원했어요.';
  }

  @override
  String notificationMonthlyAwardTitle(String month) {
    return '$month 랭킹 시상대에 올랐어요';
  }

  @override
  String notificationMonthlyAwardBody(
      String dog, String month, String summary) {
    return '$dog $month 랭킹 $summary에 올랐어요. 명예의 전당에서 확인해 보세요.';
  }

  @override
  String notificationMonthlyAwardItem(String label, int rank) {
    return '$label $rank위';
  }

  @override
  String get noticeTitle => '공지사항';

  @override
  String get noticeEmpty => '등록된 공지사항이 없어요';

  @override
  String get faqTitle => '자주 묻는 질문';

  @override
  String get faqAll => '전체';

  @override
  String get faqAskInquiry => '원하는 답이 없나요? 1:1 문의하기';

  @override
  String get inquiryTitle => '1:1 문의';

  @override
  String get inquiryNew => '문의하기';

  @override
  String get inquiryEmptyTitle => '문의 내역이 없어요';

  @override
  String get inquiryEmptyMessage => '궁금한 점을 남겨 주시면 확인 후 답변드릴게요.';

  @override
  String get inquiryAnswerLabel => '답변';

  @override
  String get inquiryTypeLabel => '문의 유형';

  @override
  String get inquiryCategoryBooking => '예약';

  @override
  String get inquiryCategoryPayment => '결제·이용권';

  @override
  String get inquiryCategoryExercise => '운동';

  @override
  String get inquiryCategoryAnalysis => 'AI 분석';

  @override
  String get inquiryCategoryAccount => '계정';

  @override
  String get inquiryCategoryEtc => '기타';

  @override
  String get inquiryTitleLabel => '제목';

  @override
  String get inquiryTitleRequired => '제목을 입력해 주세요.';

  @override
  String get inquiryBodyLabel => '내용';

  @override
  String get inquiryBodyRequired => '내용을 입력해 주세요.';

  @override
  String get inquirySubmit => '문의 접수';

  @override
  String get inquiryCreated => '문의를 접수했어요. 답변이 등록되면 문의 내역에서 확인할 수 있어요.';

  @override
  String get inquiryStatusAnswered => '답변 완료';

  @override
  String get inquiryStatusClosed => '종료';

  @override
  String get inquiryStatusPending => '답변 대기';

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

  @override
  String get dogSexMale => '수컷';

  @override
  String get dogSexFemale => '암컷';

  @override
  String get dogSizeSmall => '소형';

  @override
  String get dogSizeMedium => '중형';

  @override
  String get dogSizeLarge => '대형';

  @override
  String get dogWeightHintSmall => '10kg 미만';

  @override
  String get dogWeightHintMedium => '10~25kg';

  @override
  String get dogWeightHintLarge => '25kg 이상';

  @override
  String dogMixedLabel(String breed) {
    return '믹스견($breed)';
  }

  @override
  String get dogMixedBreed => '믹스견';

  @override
  String dogAgeApprox(String age) {
    return '약 $age';
  }

  @override
  String dogSizeDog(String size) {
    return '$size견';
  }

  @override
  String get dogBrachycephalic => '단두종';

  @override
  String get dogRegisterTitle => '반려견 등록';

  @override
  String get dogEditTitle => '반려견 정보 수정';

  @override
  String dogRegistered(String name) {
    return '$name 등록되었어요.';
  }

  @override
  String get dogUpdated => '반려견 정보를 수정했어요.';

  @override
  String dogSavedPhotoFailed(String error) {
    return '정보는 저장했지만 사진을 올리지 못했어요. $error';
  }

  @override
  String get dogPhotoLoadFailed => '사진을 불러오지 못했어요. 권한을 확인해 주세요.';

  @override
  String get dogRequiredCheck => '표시된 필수 항목을 확인해 주세요.';

  @override
  String get dogPickGallery => '앨범에서 선택';

  @override
  String get dogPickCamera => '사진 촬영';

  @override
  String get dogBirthDatePickerHelp => '생년월일 선택';

  @override
  String get dogAgeRequired => '나이를 입력해 주세요.';

  @override
  String get dogAgeMax => '30살 이하로 입력해 주세요.';

  @override
  String get dogAgeMin => '1개월 이상으로 입력해 주세요.';

  @override
  String get dogAgeMonthsRange => '0~11개월';

  @override
  String get dogSectionBasic => '기본 정보';

  @override
  String get dogNameLabel => '이름 *';

  @override
  String get dogNameRequired => '이름을 입력해 주세요.';

  @override
  String get dogMixedSwitch => '믹스견이에요';

  @override
  String get dogMixedSwitchHint => '두 견종 이상이 섞였거나 견종을 잘 모르는 경우';

  @override
  String get dogBreedLabelMixed => '섞인 견종 (선택)';

  @override
  String get dogBreedLabel => '견종 *';

  @override
  String get dogBreedHintMixed => '예: 말티즈, 푸들';

  @override
  String get dogBreedHint => '예: 말티즈';

  @override
  String get dogBreedRequired => '견종을 입력해 주세요. 잘 모르면 믹스견을 선택해 주세요.';

  @override
  String get dogBreedNotListed => '목록에 없는 견종이에요. 아래에서 체구를 골라 주세요.';

  @override
  String get dogSizeLabel => '체구 *';

  @override
  String get dogSizeRequired => '체구를 선택해 주세요.';

  @override
  String dogSizeInfoHint(String options) {
    return '다 자란 몸무게 기준 · $options';
  }

  @override
  String get dogBrachySwitch => '주둥이가 짧은 단두종이에요';

  @override
  String get dogBrachySwitchHint => '퍼그·시츄·불독처럼 코가 눌린 얼굴형';

  @override
  String get dogAgeLabel => '나이 *';

  @override
  String get dogBirthDate => '생년월일';

  @override
  String get dogAgeEstimate => '추정 나이';

  @override
  String dogCurrentAge(String age) {
    return '현재 $age';
  }

  @override
  String get dogBirthDateRequired => '생년월일을 선택해 주세요.';

  @override
  String get dogPleaseSelect => '선택해 주세요';

  @override
  String get dogAge => '나이';

  @override
  String get dogAgeYearsSuffix => '살';

  @override
  String get dogAgeMonthsLabel => '개월 (선택)';

  @override
  String get dogAgeMonthsSuffix => '개월';

  @override
  String get dogSex => '성별';

  @override
  String get dogNeutered => '중성화';

  @override
  String get dogNeuteredLabel => '중성화 *';

  @override
  String get dogNeuteredYes => '했어요';

  @override
  String get dogNeuteredNo => '안 했어요';

  @override
  String get dogNeuteredRequired => '중성화 여부를 선택해 주세요.';

  @override
  String get dogWeight => '체중';

  @override
  String get dogWeightLabel => '체중 *';

  @override
  String get dogWeightEnter => '체중을 입력해 주세요.';

  @override
  String get dogWeightInvalid => '올바른 체중을 입력해 주세요.';

  @override
  String get dogSectionHealth => '건강 정보';

  @override
  String get dogHealthIntro => '운동 강도와 주의사항을 정하는 데 쓰여요. 정확하게 입력해 주세요.';

  @override
  String get dogConditionsRequired => '해당하는 항목이나 \'해당 없음\'을 골라 주세요.';

  @override
  String get dogConditionsTitleRequired => '질병·주의사항 *';

  @override
  String get dogConditionsTitle => '질병·주의사항';

  @override
  String get dogConditionsHelp => '진단받았거나 치료 중인 항목을 모두 골라 주세요.';

  @override
  String get dogConditionNone => '해당 없음';

  @override
  String get dogDiseasesTitle => '질환 상세';

  @override
  String get dogDiseasesEmpty => '적어 둔 진단명이 없어요.';

  @override
  String get dogDiseaseNameLabel => '진단명 (예: 슬개골 탈구)';

  @override
  String get dogDiseaseDetailLabel => '상태·단계 (선택)';

  @override
  String get dogSurgeriesTitle => '수술 및 치료 이력';

  @override
  String get dogSurgeriesEmpty => '등록된 이력이 없어요.';

  @override
  String get dogSurgeryNameLabel => '수술·치료명';

  @override
  String get dogSurgeryDetailLabel => '병원·메모 (선택)';

  @override
  String get dogMedicationsTitle => '복용 중인 약물';

  @override
  String get dogMedicationsEmpty => '복용 중인 약물이 없어요.';

  @override
  String get dogMedicationNameLabel => '약 이름';

  @override
  String get dogMedicationDetailLabel => '용량·복용 주기 (선택)';

  @override
  String get dogRestrictionsTitle => '운동 제한 사항';

  @override
  String get dogRestrictionsEmpty => '운동 제한 사항이 없어요.';

  @override
  String get dogRestrictionNameLabel => '제한 내용 (예: 경사 운동 금지)';

  @override
  String get dogRestrictionDetailLabel => '상세 설명 (선택)';

  @override
  String dogHealthItemAddTitle(String title) {
    return '$title 추가';
  }

  @override
  String get dogDatePickOptional => '날짜 선택 (선택)';

  @override
  String get dogVetNotes => '수의사 권고사항';

  @override
  String get dogVetNotesHint => '예: 주 3회, 20분 이내 저속 보행 권장';

  @override
  String get dogSubmitSave => '저장하기';

  @override
  String get dogSubmitRegister => '등록하기';

  @override
  String dogDeleteTitle(String name) {
    return '$name 정보를 삭제할까요?';
  }

  @override
  String get dogDeleteMessage =>
      '목록에서 사라지며 새 예약을 할 수 없어요. 지금까지의 운동·분석 기록은 헬스장에 보관됩니다.';

  @override
  String dogDeleted(String name) {
    return '$name 정보를 삭제했어요.';
  }

  @override
  String get dogProfileTitle => '반려견 정보';

  @override
  String get dogDeleteMenu => '반려견 삭제';

  @override
  String dogBookWorkout(String name) {
    return '$name 운동 예약하기';
  }

  @override
  String get dogProfileEmptySummary => '프로필 정보를 입력해 주세요';

  @override
  String get dogTotalWorkouts => '누적 운동';

  @override
  String get dogUnitTimes => '회';

  @override
  String get dogTotalTime => '누적 시간';

  @override
  String get dogUnitMinutes => '분';

  @override
  String get dogTotalDistance => '누적 거리';

  @override
  String get dogBreed => '견종';

  @override
  String get dogSize => '체구';

  @override
  String dogAgeEstimated(String age) {
    return '$age (추정)';
  }

  @override
  String get dogNoHealthInfo => '등록된 건강 정보가 없어요. 수정 화면에서 입력할 수 있어요.';

  @override
  String dogBadgeSection(int earned, int total) {
    return '배지 $earned/$total';
  }

  @override
  String get dogBadgeCollection => '배지함';

  @override
  String get dogFirstBadgeHint => '첫 운동을 마치면 「첫 발걸음」 배지를 받아요.';

  @override
  String dogNextBadge(String name) {
    return '다음 배지 · $name';
  }

  @override
  String get dogPlanSection => '맞춤 운동 계획';

  @override
  String get dogPlanProgram => '프로그램';

  @override
  String get dogPlanTargetTime => '목표 시간';

  @override
  String get dogPlanTargetSpeed => '목표 속도';

  @override
  String get dogPlanNotes => '메모';

  @override
  String get dogListTitle => '반려견 관리';

  @override
  String get dogListRegister => '반려견 등록';

  @override
  String get dogListEmptyTitle => '등록된 반려견이 없어요';

  @override
  String get dogListEmptyMessage => '반려견을 등록하고 운동 예약과 AI 분석을 시작해 보세요.';

  @override
  String get dogShownOnHome => '홈에 표시 중';

  @override
  String get dogSwitcherTitle => '반려견 선택';

  @override
  String get dogSwitcherAdd => '반려견 추가';

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

  @override
  String get rankingScopeAll => '전체';

  @override
  String get rankingScopeBranch => '지점';

  @override
  String get rankingScopeSize => '체급';

  @override
  String get rankingSizeSmall => '소형견';

  @override
  String get rankingSizeMedium => '중형견';

  @override
  String get rankingSizeLarge => '대형견';

  @override
  String rankingTitleText(String month, String scope, int rank) {
    return '$month $scope $rank위';
  }

  @override
  String rankingScopeRankShort(String scope, int rank) {
    return '$scope $rank위';
  }

  @override
  String badgeProgressSessions(int current, int goal) {
    return '$current / $goal회';
  }

  @override
  String badgeProgressDistance(String current, String goal) {
    return '$current / ${goal}km';
  }

  @override
  String badgeProgressWeeks(int current, int goal) {
    return '$current / $goal주';
  }

  @override
  String badgeProgressBranches(int current, int goal) {
    return '$current / $goal곳';
  }

  @override
  String badgeProgressOpenRuns(int current, int goal) {
    return '$current / $goal번';
  }

  @override
  String get rankingPointsNoteTooShort => '5분 미만 운동은 점수에 들어가지 않아요';

  @override
  String get rankingPointsNoteDailyLimit => '하루에 한 번만 점수를 받아요';

  @override
  String get badgeCollectionTitle => '배지함';

  @override
  String badgeCollectionTitleDog(String dog) {
    return '$dog의 배지함';
  }

  @override
  String get badgeEarnedHeading => '받은 배지 ';

  @override
  String get badgeStatSessions => '운동';

  @override
  String get badgeStatDistance => '누적 거리';

  @override
  String get badgeStatStreak => '연속 운동';

  @override
  String get badgeStatBranches => '방문 지점';

  @override
  String get badgeSectionAwards => '수상 기록';

  @override
  String get badgeSectionBadges => '배지';

  @override
  String badgeEarnedOn(String date) {
    return '$date 획득';
  }

  @override
  String get badgeAwardedAtMonthEnd => '월간 랭킹 마감 때 받아요';

  @override
  String get rankingUnitSessions => '회';

  @override
  String get rankingUnitPoints => '점';

  @override
  String rankingUnitWeeks(int count) {
    return '주';
  }

  @override
  String rankingUnitBranches(int count) {
    return '곳';
  }

  @override
  String rankingRankValue(int rank) {
    return '$rank';
  }

  @override
  String get rankingRankUnit => '위';

  @override
  String get rankingStatPoints => '점수';

  @override
  String get rankingStatSessions => '운동';

  @override
  String get rankingStatCheers => '응원';

  @override
  String get rankingStatDistance => '거리';

  @override
  String rankingStatRank(String month) {
    return '$month 순위';
  }

  @override
  String rankingCheerSent(String dog) {
    return '$dog에게 응원을 보냈어요!';
  }

  @override
  String rankingBadgesEarned(int count) {
    return '받은 배지 $count개';
  }

  @override
  String get rankingNoBadgesYet => '아직 받은 배지가 없어요.';

  @override
  String get rankingMyDogJoined => '내 반려견이에요. 꾸준히 운동해서 순위를 올려 보세요!';

  @override
  String get rankingMyDogNotJoined => '랭킹에 참여하면 다른 회원도 볼 수 있어요.';

  @override
  String get rankingCheeredThisMonth => '이번 달 응원했어요';

  @override
  String rankingCheerDog(String dog) {
    return '$dog 응원하기';
  }

  @override
  String get boardTitle => '매장 랭킹 보드';

  @override
  String get rankingTitle => '랭킹';

  @override
  String get rankingShareTooltip => '자랑하기';

  @override
  String get rankingMenuTooltip => '랭킹 메뉴';

  @override
  String get rankingMenuSettings => '참여·닉네임 설정';

  @override
  String get rankingMenuRules => '점수 규칙';

  @override
  String get rankingTabDogs => '반려견 랭킹';

  @override
  String get rankingTabBattle => '지점 대항전';

  @override
  String get rankingTabHall => '명예의 전당';

  @override
  String get rankingEmptyTitle => '아직 순위에 오른 반려견이 없어요';

  @override
  String get rankingEmptyCurrent => '이번 달 첫 운동을 마치면 바로 랭킹에 올라요.';

  @override
  String get rankingEmptyPast => '이 달에는 운동 기록이 없어요.';

  @override
  String rankingParticipants(int count) {
    return '참여 반려견 $count마리';
  }

  @override
  String rankingParticipantsTop(int count, int top) {
    return '참여 반려견 $count마리 · 상위 $top마리';
  }

  @override
  String get rankingPrevMonth => '이전 달';

  @override
  String get rankingNextMonth => '다음 달';

  @override
  String get rankingMonthInProgress => '진행 중 · 운동이 끝나면 바로 반영돼요';

  @override
  String get rankingMonthPast => '지난 달 기록';

  @override
  String rankingJoinPrompt(String dog) {
    return '$dog도 랭킹에 올려 보세요';
  }

  @override
  String rankingJoinPromptRank(String dog, int rank) {
    return '참여하면 $dog 전체 $rank위예요';
  }

  @override
  String get rankingJoinPublicInfo => '닉네임과 반려견 정보만 공개돼요.';

  @override
  String get rankingJoinButton => '참여하기';

  @override
  String rankingMyBarNoScore(String dog) {
    return '$dog · 이 랭킹에서는 아직 점수가 없어요';
  }

  @override
  String rankingMyBarRank(String dog, int rank) {
    return '$dog · $rank위';
  }

  @override
  String rankingMyBarRankIfJoined(String dog, int rank) {
    return '$dog · 참여하면 $rank위';
  }

  @override
  String get rankingMyBarNoPoints => '운동을 마치면 점수가 쌓여요';

  @override
  String rankingMyBarKeepFirst(String points) {
    return '$points · 1위를 지키고 있어요!';
  }

  @override
  String rankingMyBarPointsToNext(String points, int gap) {
    return '$points · $gap점 더 받으면 순위가 올라요';
  }

  @override
  String get rankingBattleIntro =>
      '지점에서 운동한 모든 반려견의 거리를 더해요. 우리 반려견이 걸은 만큼 우리 지점이 앞서요!';

  @override
  String get rankingBattleMine => '내 지점';

  @override
  String rankingBattleStats(int sessions, int dogs) {
    return '운동 $sessions회 · 반려견 $dogs마리';
  }

  @override
  String get rankingHallEmptyTitle => '아직 명예의 전당이 비어 있어요';

  @override
  String get rankingHallEmptyMessage => '매달 1일에 지난달 부문별 1~3위가 이곳에 올라요.';

  @override
  String rankingHallMonthTitle(String month) {
    return '$month 명예의 전당';
  }

  @override
  String get rankingPrivateDog => '비공개 반려견';

  @override
  String get rankingHallChampions => '부문별 1위';

  @override
  String get rankingSettingsSaved => '랭킹 설정을 저장했어요.';

  @override
  String get rankingJoined => '랭킹에 참여했어요! 이번 달 순위에 바로 반영돼요.';

  @override
  String get rankingLeaveTitle => '랭킹에서 나갈까요?';

  @override
  String get rankingLeaveMessage =>
      '순위표와 명예의 전당에서 닉네임과 반려견 정보가 바로 가려져요. 점수와 배지는 그대로 쌓이고, 다시 참여하면 이번 달 순위에 바로 반영돼요.';

  @override
  String get rankingLeaveConfirm => '나가기';

  @override
  String get rankingLeft => '랭킹에서 나갔어요.';

  @override
  String get rankingSettingsTitle => '랭킹 설정';

  @override
  String get rankingJoinTitle => '랭킹에 참여해 볼까요?';

  @override
  String get rankingSettingsIntro =>
      '이번 달 가장 꾸준한 반려견은 누구일까요? 운동할수록 점수가 쌓이고, 매달 1~3위는 명예의 전당에 올라요.';

  @override
  String get rankingVisibleInfoTitle => '다른 회원에게 보이는 정보';

  @override
  String get rankingVisibleInfoList =>
      '· 닉네임\n· 반려견 이름·견종·체구, 프로필 사진(선택)\n· 이번 달 점수·운동 횟수, 배지, 수상 기록';

  @override
  String get rankingPrivateInfoNote => '실명·이메일·연락처는 공개되지 않아요.';

  @override
  String get rankingNicknameLabel => '닉네임';

  @override
  String get rankingNicknameHelp => '2~12자 한글·영문·숫자·밑줄(_) · 30일에 한 번 바꿀 수 있어요';

  @override
  String rankingNicknameChangeableAt(String date) {
    return '$date부터 다시 바꿀 수 있어요';
  }

  @override
  String get rankingShowPhotoTitle => '반려견 사진 공개';

  @override
  String get rankingShowPhotoSubtitle => '끄면 랭킹에 기본 아이콘으로 보여요';

  @override
  String get rankingJoinAction => '랭킹 참여하기';

  @override
  String get rankingLeaveAction => '랭킹에서 나가기';

  @override
  String rankingShareText(String dog, String month) {
    return '$dog의 $month PawFit 운동 기록이에요! #PawFit #강아지트레드밀';
  }

  @override
  String get rankingShareFailed => '공유하지 못했어요. 잠시 후 다시 시도해 주세요.';

  @override
  String get rankingShareTitle => '이번 달 기록 자랑하기';

  @override
  String get rankingShareHint => '이미지로 저장해 인스타그램·카카오톡에 올려 보세요.';

  @override
  String get rankingShareButton => '이미지로 공유하기';

  @override
  String rankingShareOverall(int rank) {
    return '전체 $rank위';
  }

  @override
  String rankingShareStreak(int weeks) {
    return '$weeks주 연속 운동 중';
  }

  @override
  String boardHeadline(String branch) {
    return '$branch 이번 달 랭킹';
  }

  @override
  String boardSubtitle(String month) {
    return '$month · 운동이 끝나면 바로 반영돼요';
  }

  @override
  String get boardJoinHint => 'PawFit 앱에서 「랭킹 참여」를 켜면 우리 아이 이름이 여기에 올라와요!';

  @override
  String boardBattleRank(int rank, String distance) {
    return '지점 대항전 $rank위 · $distance';
  }

  @override
  String get boardEmptyTitle => '이번 달 1등의 주인공이 되어 보세요!';

  @override
  String get boardEmptyMessage => '이 지점에서 운동을 마치면 바로 순위에 올라요.';

  @override
  String rankingEntrySemantics(int rank, String dog, String points) {
    return '$rank위 $dog, $points';
  }

  @override
  String get rankingMineBadge => '내 반려견';

  @override
  String badgeSemantics(String name) {
    return '$name 배지';
  }

  @override
  String badgeSemanticsLocked(String name) {
    return '$name 배지 (아직 받지 않음)';
  }

  @override
  String get rankingPointsChipVoided => '점수 무효';

  @override
  String get rankingPointsChipZero => '0점';

  @override
  String rankingPointsChipSemantics(String label) {
    return '랭킹 점수 $label';
  }

  @override
  String get rankingBreakdownTitle => '이번 운동 점수';

  @override
  String get rankingBreakdownVoided => '운영자 확인 결과 이 운동의 점수는 무효 처리되었어요.';

  @override
  String get rankingBreakdownDefault => '꾸준히 운동할수록 점수가 쌓여요.';

  @override
  String get rankingBreakdownAttendance => '출석';

  @override
  String get rankingBreakdownAttendanceCaption => '5분 이상 운동 (하루 1회)';

  @override
  String get rankingBreakdownGoal => '달성';

  @override
  String get rankingBreakdownGoalCaption => '프로그램 목표 시간 대비 (최대 10)';

  @override
  String get rankingBreakdownDistanceCaption => '100m당 1점 (최대 20)';

  @override
  String get rankingBreakdownWeeklyBonus => '주간 보너스';

  @override
  String get rankingBreakdownWeeklyBonusCaption => '이번 주 두 번째 운동';

  @override
  String get rankingBreakdownTotal => '합계';

  @override
  String get rankingRulesTitle => '점수는 이렇게 쌓여요';

  @override
  String get rankingRulesIntro => '많이보다 꾸준히! 무리한 운동은 점수에 도움이 되지 않아요.';

  @override
  String get rankingRuleAttendanceTitle => '출석 10점';

  @override
  String get rankingRuleAttendanceBody =>
      '5분 이상 운동하면 받아요. 반려견마다 하루 한 번만 점수를 받아요.';

  @override
  String get rankingRuleGoalTitle => '달성 최대 10점';

  @override
  String get rankingRuleGoalBody => '프로그램 목표 시간을 채운 만큼 받아요. 중간에 멈춰도 감점은 없어요.';

  @override
  String get rankingRuleDistanceTitle => '거리 최대 20점';

  @override
  String get rankingRuleDistanceBody => '100m마다 1점이에요. 2km를 넘게 걸어도 20점까지만 받아요.';

  @override
  String get rankingRuleWeeklyTitle => '주간 보너스 20점';

  @override
  String get rankingRuleWeeklyBody => '한 주(월~일)에 두 번 이상 운동하면 받아요.';

  @override
  String get rankingRuleMonthlyTitle => '월간 랭킹';

  @override
  String get rankingRuleMonthlyBody =>
      '매달 1일에 새로 시작해요. 전체·지점·체급별로 순위를 매기고, 동점이면 먼저 도달한 반려견이 앞서요.';

  @override
  String get rankingRuleHallTitle => '명예의 전당';

  @override
  String get rankingRuleHallBody =>
      '달이 끝나면 부문별 1~3위가 명예의 전당에 오르고 「시상대」 배지를 받아요.';

  @override
  String get rankingRulesSafety =>
      '반려견 컨디션이 좋지 않으면 운동을 쉬어 주세요. 이상이 보이면 트레드밀의 비상정지 버튼을 눌러 주세요.';

  @override
  String get demoPillStart => 'DEMO · 데모 계정으로 시작';

  @override
  String get demoControlTitle => '데모 컨트롤';

  @override
  String get demoIntro =>
      '목업 서버로 동작하는 데모 앱이에요. 실제 서버·결제·트레드밀과 연결되지 않고, 앱을 다시 켜면 처음 상태로 돌아가요.';

  @override
  String get demoSectionTreadmill => '트레드밀 기기';

  @override
  String get demoAddDogFirst => '반려견을 먼저 등록해 주세요.';

  @override
  String demoTreadmillDetail(String dog) {
    return '$dog · 매장 기기가 보내는 운동 기록을 흉내 내요.';
  }

  @override
  String get demoStartWorkout => '운동 시작';

  @override
  String get demoSpeedTitle => '시뮬레이션 속도';

  @override
  String get demoSpeedReal => '실제 시간';

  @override
  String get demoSpeed10x => '10배';

  @override
  String get demoSpeed30x => '30배';

  @override
  String get demoSectionAi => 'AI 분석 서버';

  @override
  String get demoAiDetail => '운동이 끝나고 몇 초 뒤 보행 분석 리포트가 도착해요.';

  @override
  String get demoAiFinished => 'AI 분석이 끝났어요. 알림을 확인해 보세요.';

  @override
  String get demoFinishPending => '대기 중인 분석 바로 끝내기';

  @override
  String get demoNoPending => '대기 중인 분석 없음';

  @override
  String get demoSectionOwners => '다른 보호자';

  @override
  String get demoOwnersDetail => '랭킹에 참여한 다른 보호자의 응원을 받아요.';

  @override
  String get demoReceiveCheer => '응원 받기';

  @override
  String get demoSectionData => '데이터';

  @override
  String get demoReset => '처음 상태로 되돌리기';

  @override
  String demoAccount(String email, String password) {
    return '데모 계정 $email · $password';
  }

  @override
  String demoWorkoutStarted(String dog) {
    return '$dog의 운동이 시작됐어요. 실시간 기록이 운동 탭에 표시돼요.';
  }

  @override
  String get demoCheerNeedsConsent =>
      '랭킹에 참여해야 응원을 받을 수 있어요. 마이페이지 > 동의 관리에서 바꿀 수 있어요.';

  @override
  String get demoCheerAllDone => '이번 달에는 다른 보호자가 모두 응원했어요.';

  @override
  String demoCheerReceived(String nickname, String dog) {
    return '$nickname님이 $dog 응원했어요. 알림을 확인해 보세요.';
  }

  @override
  String get demoResetTitle => '처음 상태로 되돌릴까요?';

  @override
  String get demoResetMessage =>
      '데모에서 만든 예약·운동 기록·설정이 모두 지워지고 샘플 데이터로 다시 시작해요.';

  @override
  String get demoResetConfirm => '되돌리기';

  @override
  String get demoResumed => '운동을 다시 시작했어요.';

  @override
  String get demoPaused => '트레드밀을 잠시 멈췄어요.';

  @override
  String get demoResume => '다시 시작';

  @override
  String get demoPause => '일시정지';

  @override
  String get demoEmergencyDone => '비상정지로 운동이 중단됐어요. 받은 만큼 점수가 쌓여요.';

  @override
  String get demoEmergencyStop => '비상정지';

  @override
  String get demoFinishedDone => '운동을 마쳤어요. 점수와 배지, AI 리포트를 확인해 보세요.';

  @override
  String get demoFinishNow => '바로 완료';

  @override
  String get serverPaymentMethodCard => '카드';

  @override
  String get serverPaymentMethodCreditCard => '신용카드';

  @override
  String get serverPaymentMethodDebitCard => '체크카드';

  @override
  String get serverPaymentMethodEasyPay => '간편결제';

  @override
  String get serverPaymentMethodKakaoPay => '카카오페이';

  @override
  String get serverPaymentMethodNaverPay => '네이버페이';

  @override
  String get serverPaymentMethodTossPay => '토스페이';

  @override
  String get serverPaymentMethodPayco => '페이코';

  @override
  String get serverPaymentMethodSamsungPay => '삼성페이';

  @override
  String get serverPaymentMethodApplePay => '애플페이';

  @override
  String get serverPaymentMethodTransfer => '계좌이체';

  @override
  String get serverPaymentMethodVirtualAccount => '가상계좌';

  @override
  String get serverPaymentMethodMobile => '휴대폰';

  @override
  String get serverPaymentMethodOnsite => '현장 결제';

  @override
  String get serverPaymentMethodPass => '이용권';

  @override
  String get keypointNose => '코';

  @override
  String get keypointWithers => '기갑(어깨 위)';

  @override
  String get keypointTailBase => '꼬리 시작점';

  @override
  String get keypointLeftElbow => '왼쪽 앞다리 팔꿈치';

  @override
  String get keypointLeftCarpus => '왼쪽 앞발목';

  @override
  String get keypointLeftFrontPaw => '왼쪽 앞발';

  @override
  String get keypointRightElbow => '오른쪽 앞다리 팔꿈치';

  @override
  String get keypointRightCarpus => '오른쪽 앞발목';

  @override
  String get keypointRightFrontPaw => '오른쪽 앞발';

  @override
  String get keypointLeftStifle => '왼쪽 뒷다리 무릎';

  @override
  String get keypointLeftHock => '왼쪽 뒷발목(비절)';

  @override
  String get keypointLeftHindPaw => '왼쪽 뒷발';

  @override
  String get keypointRightStifle => '오른쪽 뒷다리 무릎';

  @override
  String get keypointRightHock => '오른쪽 뒷발목(비절)';

  @override
  String get keypointRightHindPaw => '오른쪽 뒷발';

  @override
  String get analysisReportTitle => 'AI 분석 리포트';

  @override
  String analysisModelVersion(String version) {
    return '모델 $version';
  }

  @override
  String get analysisStatDuration => '운동 시간';

  @override
  String get analysisStatDistance => '이동 거리';

  @override
  String get analysisStatAvgSpeed => '평균 속도';

  @override
  String get analysisPendingFailedTitle => '분석을 완료하지 못했어요';

  @override
  String get analysisPendingTitle => '운동 영상을 분석하고 있어요';

  @override
  String get analysisPendingFailedMessage =>
      '영상 품질이나 촬영 각도 문제로 분석하지 못했어요. 헬스장에서 확인 후 다시 분석해 드릴게요.';

  @override
  String get analysisPendingMessage =>
      '관절 움직임과 보행 패턴을 분석 중이에요. 완료되면 알림으로 알려 드릴게요.';

  @override
  String get analysisSummaryTitle => '분석 결과 요약';

  @override
  String get analysisAnomalySection => '이상 움직임 탐지';

  @override
  String analysisConfidenceValue(String percent) {
    return '분석 신뢰도 $percent%';
  }

  @override
  String get analysisPatternDiffCaption => '평소 보행 패턴과의 차이';

  @override
  String get analysisScaleSimilar => '비슷함';

  @override
  String get analysisScaleDifferent => '차이 큼';

  @override
  String get analysisNoAnomaly => '평소와 다른 관절 패턴이 발견되지 않았어요.';

  @override
  String analysisVsBaseline(String value) {
    return '기준선 대비 $value';
  }

  @override
  String analysisStepsCount(int count) {
    return '$count보';
  }

  @override
  String get analysisStrideTime => '걸음걸이 주기';

  @override
  String get analysisUnitSeconds => '초';

  @override
  String get analysisGaitVariability => '보행 변동성';

  @override
  String get analysisFrontSymmetry => '앞다리 대칭';

  @override
  String get analysisHindSymmetry => '뒷다리 대칭';

  @override
  String get analysisGaitSection => '보행 패턴 분석';

  @override
  String get analysisRhythmScore => '보행 리듬 점수';

  @override
  String analysisJointSection(int count) {
    return '관절 움직임 분석 · $count개 관절';
  }

  @override
  String get analysisLegendNear => '왼쪽 다리 (카메라 쪽)';

  @override
  String get analysisLegendFar => '오른쪽 다리';

  @override
  String get analysisColJoint => '관절';

  @override
  String get analysisColRom => '가동 범위';

  @override
  String get analysisColVsBaseline => '기준선 대비';

  @override
  String analysisAngleRange(String min, String max) {
    return '각도 $min°~$max°';
  }

  @override
  String get analysisPatternDiff => '패턴 차이';

  @override
  String analysisCompareTitle(String date) {
    return '이전 운동 대비 변화 ($date)';
  }

  @override
  String get analysisVideoSkeleton => '스켈레톤 영상';

  @override
  String get analysisVideoSection => '운동 영상';

  @override
  String get analysisCareNotes => '운동 관리 참고사항';

  @override
  String get healthNoChange => '변화 없음';

  @override
  String get healthBaselineLabel => '기준선';

  @override
  String get healthSkeletonSemantics => '측면에서 본 반려견 관절 도식';

  @override
  String healthSkeletonSemanticsFlagged(String details) {
    return '측면에서 본 반려견 관절 도식, $details';
  }

  @override
  String healthJointLevel(String joint, String level) {
    return '$joint $level';
  }
}
