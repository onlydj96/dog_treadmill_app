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
}
