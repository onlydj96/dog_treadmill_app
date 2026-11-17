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
}
