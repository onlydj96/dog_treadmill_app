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
}
