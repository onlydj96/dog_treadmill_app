import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PawFit';

  @override
  String get commonConfirm => 'OK';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonDone => 'Done';

  @override
  String get commonNext => 'Next';

  @override
  String get commonPrevious => 'Back';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonManage => 'Manage';

  @override
  String get commonViewAll => 'View all';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonNone => 'None';

  @override
  String get commonOptional => 'Optional';

  @override
  String get commonRequired => 'Required';

  @override
  String get commonOwnerFallbackName => 'PawFit member';

  @override
  String get commonAiDisclaimer =>
      'AI analysis results are reference information about changes in your dog\'s gait. They do not replace a diagnosis or veterinary care. If you notice anything unusual, please see a veterinarian.';

  @override
  String get navHome => 'Home';

  @override
  String get navBooking => 'Bookings';

  @override
  String get navExercise => 'Workout';

  @override
  String get navHealth => 'Health';

  @override
  String get navMyPage => 'Account';

  @override
  String get languageMenuTitle => 'Language';

  @override
  String get languagePickerTitle => 'Language';

  @override
  String get videoDefaultTitle => 'Workout video';

  @override
  String get configMissingTitle => 'Supabase setup required';

  @override
  String get configMissingBody =>
      'Add SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY to the .env file in the project root, then run the app as shown below.';

  @override
  String get fmtPatternDate => 'EEE, MMM d';

  @override
  String get fmtPatternDateFull => 'EEE, MMM d, yyyy';

  @override
  String get fmtPatternDateShort => 'MMM d, yyyy';

  @override
  String get fmtPatternMonthDay => 'M/d';

  @override
  String get fmtPatternYearMonth => 'MMMM yyyy';

  @override
  String get fmtPatternMonth => 'MMM';

  @override
  String get fmtPatternWeekday => 'EEE';

  @override
  String get fmtAm => 'AM';

  @override
  String get fmtPm => 'PM';

  @override
  String fmtTime(String period, String time) {
    return '$time $period';
  }

  @override
  String fmtDateTime(String date, String time) {
    return '$date, $time';
  }

  @override
  String fmtTimeRange(String start, String end) {
    return '$start – $end';
  }

  @override
  String fmtWon(String amount) {
    return '₩$amount';
  }

  @override
  String fmtPoints(num count, String formatted) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$formatted pts',
      one: '$formatted pt',
    );
    return '$_temp0';
  }

  @override
  String fmtDurationHourMinute(int hours, int minutes) {
    return '$hours hr $minutes min';
  }

  @override
  String fmtDurationHour(int hours) {
    return '$hours hr';
  }

  @override
  String fmtDurationMinuteSecond(int minutes, int seconds) {
    return '$minutes min $seconds sec';
  }

  @override
  String fmtDurationMinute(int minutes) {
    return '$minutes min';
  }

  @override
  String fmtDurationSecond(int seconds) {
    return '$seconds sec';
  }

  @override
  String get fmtJustNow => 'Just now';

  @override
  String fmtMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String fmtHoursAgo(int hours) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: '$hours hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String fmtDaysAgo(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get fmtDogAgeUnderOneMonth => 'Under 1 month';

  @override
  String fmtDogAgeMonths(int months) {
    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: '$months months',
      one: '1 month',
    );
    return '$_temp0';
  }

  @override
  String fmtDogAgeYears(int years) {
    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: '$years years',
      one: '1 year',
    );
    return '$_temp0';
  }

  @override
  String validationRequired(String label) {
    return '$label is required.';
  }

  @override
  String get validationEmailRequired => 'Please enter your email.';

  @override
  String get validationEmailInvalid => 'Please enter a valid email address.';

  @override
  String get validationPasswordRequired => 'Please enter your password.';

  @override
  String get validationPasswordTooShort => 'Use at least 8 characters.';

  @override
  String get validationPasswordLettersAndDigits =>
      'Use both letters and numbers.';

  @override
  String get validationPhoneRequired => 'Please enter your mobile number.';

  @override
  String get validationPhoneInvalid => 'Please enter a valid mobile number.';

  @override
  String get validationNameRequired => 'Please enter your name.';

  @override
  String get validationNameTooLong => 'Use 20 characters or fewer.';

  @override
  String get validationNicknameRequired => 'Please enter a nickname.';

  @override
  String get validationNicknameLength => 'Use 2–12 characters.';

  @override
  String get validationNicknameCharacters =>
      'Use only Korean or English letters, numbers, and underscores (_).';

  @override
  String get errorAuthRequired => 'Please log in again.';

  @override
  String get errorDogNotFound => 'We couldn\'t find this dog\'s information.';

  @override
  String get errorBranchNotFound => 'We couldn\'t find this location.';

  @override
  String get errorProgramNotFound => 'We couldn\'t find this workout program.';

  @override
  String get errorSlotInPast =>
      'That time has already passed. Please choose another time.';

  @override
  String get errorSlotNotAvailable =>
      'That time can\'t be booked. Please choose another time.';

  @override
  String get errorSlotFull =>
      'All treadmills are booked at that time. Please choose another time.';

  @override
  String get errorDogAlreadyBooked =>
      'This dog already has a booking at the same time.';

  @override
  String get errorMembershipNotFound => 'We couldn\'t find this pass.';

  @override
  String get errorMembershipNotUsable =>
      'This pass can\'t be used for this time. Please check the sessions left and the expiry date.';

  @override
  String get errorBookingNotFound => 'We couldn\'t find this booking.';

  @override
  String get errorBookingNotCancellable =>
      'This booking has already started or been cancelled.';

  @override
  String get errorChangeDeadlinePassed =>
      'Bookings can\'t be changed or cancelled in the app within 1 hour of the start time. Please let us know through a 1:1 inquiry.';

  @override
  String get errorInvalidBookingStatus =>
      'This booking is already checked in or finished.';

  @override
  String get errorCheckInTooEarly =>
      'Check-in opens 15 minutes before your booking starts.';

  @override
  String get errorCheckInClosed =>
      'Your booking time has passed, so you can\'t check in.';

  @override
  String get errorNicknameInvalid =>
      'Nicknames must be 2–12 characters using Korean or English letters, numbers, or underscores (_).';

  @override
  String get errorNicknameForbidden =>
      'That nickname contains a word that isn\'t allowed. Please try another one.';

  @override
  String get errorNicknameTaken => 'That nickname is already taken.';

  @override
  String get errorNicknameCooldown =>
      'You can change your nickname once every 30 days.';

  @override
  String get errorCannotCheerOwnDog => 'You can\'t cheer for your own dog.';

  @override
  String get errorInvalidRankingScope =>
      'Couldn\'t load the rankings. Please try again.';

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorEmailNotConfirmed =>
      'Please verify your email before logging in.';

  @override
  String get errorUserAlreadyExists => 'This email is already registered.';

  @override
  String get errorWeakPassword =>
      'Your password is too simple. Use at least 8 characters with both letters and numbers.';

  @override
  String get errorSamePassword =>
      'Please enter a password different from your current one.';

  @override
  String get errorRateLimited =>
      'Too many requests. Please try again in a moment.';

  @override
  String get errorSignupDisabled => 'Sign-ups are currently unavailable.';

  @override
  String get errorPermissionDenied => 'You don\'t have permission to do this.';

  @override
  String get errorNotFound => 'We couldn\'t find what you were looking for.';

  @override
  String get errorAuthGeneric =>
      'Something went wrong while verifying your account. Please try again.';

  @override
  String get errorStorage =>
      'Couldn\'t process the file. Please check the photo size (5MB or less) and format.';

  @override
  String get errorFunction =>
      'Couldn\'t process your request. Please try again in a moment.';

  @override
  String get errorNetwork =>
      'Please check your network connection and try again.';

  @override
  String get errorGeneric =>
      'Something went wrong. Please try again in a moment.';

  @override
  String get serverStopReasonByStaff => 'Stopped by staff';

  @override
  String get rankingScopeAll => 'Overall';

  @override
  String get rankingScopeBranch => 'Location';

  @override
  String get rankingScopeSize => 'Size class';

  @override
  String get rankingSizeSmall => 'Small dogs';

  @override
  String get rankingSizeMedium => 'Medium dogs';

  @override
  String get rankingSizeLarge => 'Large dogs';

  @override
  String rankingTitleText(String month, String scope, int rank) {
    return '$month #$rank $scope';
  }

  @override
  String rankingScopeRankShort(String scope, int rank) {
    return '#$rank $scope';
  }

  @override
  String badgeProgressSessions(int current, int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: '$goal workouts',
      one: '1 workout',
    );
    return '$current / $_temp0';
  }

  @override
  String badgeProgressDistance(String current, String goal) {
    return '$current / ${goal}km';
  }

  @override
  String badgeProgressWeeks(int current, int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: '$goal weeks',
      one: '1 week',
    );
    return '$current / $_temp0';
  }

  @override
  String badgeProgressBranches(int current, int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: '$goal locations',
      one: '1 location',
    );
    return '$current / $_temp0';
  }

  @override
  String badgeProgressOpenRuns(int current, int goal) {
    String _temp0 = intl.Intl.pluralLogic(
      goal,
      locale: localeName,
      other: '$goal open runs',
      one: '1 open run',
    );
    return '$current / $_temp0';
  }

  @override
  String get rankingPointsNoteTooShort =>
      'Workouts under 5 minutes don\'t count toward points.';

  @override
  String get rankingPointsNoteDailyLimit => 'You can earn points once a day.';

  @override
  String get badgeCollectionTitle => 'Badge collection';

  @override
  String badgeCollectionTitleDog(String dog) {
    return '$dog\'s badge collection';
  }

  @override
  String get badgeEarnedHeading => 'Badges earned ';

  @override
  String get badgeStatSessions => 'Workouts';

  @override
  String get badgeStatDistance => 'Total distance';

  @override
  String get badgeStatStreak => 'Workout streak';

  @override
  String get badgeStatBranches => 'Locations visited';

  @override
  String get badgeSectionAwards => 'Awards';

  @override
  String get badgeSectionBadges => 'Badges';

  @override
  String badgeEarnedOn(String date) {
    return 'Earned $date';
  }

  @override
  String get badgeAwardedAtMonthEnd =>
      'Awarded when the monthly ranking closes';

  @override
  String get rankingUnitSessions => '';

  @override
  String get rankingUnitPoints => 'pts';

  @override
  String rankingUnitWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'wks',
      one: 'wk',
    );
    return '$_temp0';
  }

  @override
  String rankingUnitBranches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'locations',
      one: 'location',
    );
    return '$_temp0';
  }

  @override
  String rankingRankValue(int rank) {
    return '#$rank';
  }

  @override
  String get rankingRankUnit => '';

  @override
  String get rankingStatPoints => 'Points';

  @override
  String get rankingStatSessions => 'Workouts';

  @override
  String get rankingStatCheers => 'Cheers';

  @override
  String get rankingStatDistance => 'Distance';

  @override
  String rankingStatRank(String month) {
    return '$month rank';
  }

  @override
  String rankingCheerSent(String dog) {
    return 'You cheered $dog!';
  }

  @override
  String rankingBadgesEarned(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count badges earned',
      one: '1 badge earned',
    );
    return '$_temp0';
  }

  @override
  String get rankingNoBadgesYet => 'No badges yet.';

  @override
  String get rankingMyDogJoined =>
      'This is your dog. Keep working out to climb the ranks!';

  @override
  String get rankingMyDogNotJoined =>
      'Other members can see your dog once you join the rankings.';

  @override
  String get rankingCheeredThisMonth => 'Cheered this month';

  @override
  String rankingCheerDog(String dog) {
    return 'Cheer for $dog';
  }

  @override
  String get boardTitle => 'Store ranking board';

  @override
  String get rankingTitle => 'Rankings';

  @override
  String get rankingShareTooltip => 'Share';

  @override
  String get rankingMenuTooltip => 'Rankings menu';

  @override
  String get rankingMenuSettings => 'Participation & nickname';

  @override
  String get rankingMenuRules => 'Scoring rules';

  @override
  String get rankingTabDogs => 'Dog rankings';

  @override
  String get rankingTabBattle => 'Location battle';

  @override
  String get rankingTabHall => 'Hall of Fame';

  @override
  String get rankingEmptyTitle => 'No dogs on the board yet';

  @override
  String get rankingEmptyCurrent =>
      'Finish your first workout this month to get on the board.';

  @override
  String get rankingEmptyPast => 'There are no workouts for this month.';

  @override
  String rankingParticipants(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dogs competing',
      one: '1 dog competing',
    );
    return '$_temp0';
  }

  @override
  String rankingParticipantsTop(int count, int top) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dogs competing',
      one: '1 dog competing',
    );
    return '$_temp0 · top $top';
  }

  @override
  String get rankingPrevMonth => 'Previous month';

  @override
  String get rankingNextMonth => 'Next month';

  @override
  String get rankingMonthInProgress =>
      'In progress · updates as soon as a workout ends';

  @override
  String get rankingMonthPast => 'Past month';

  @override
  String rankingJoinPrompt(String dog) {
    return 'Put $dog on the rankings';
  }

  @override
  String rankingJoinPromptRank(String dog, int rank) {
    return 'Join and $dog will be #$rank overall';
  }

  @override
  String get rankingJoinPublicInfo =>
      'Only your nickname and dog info are shown.';

  @override
  String get rankingJoinButton => 'Join';

  @override
  String rankingMyBarNoScore(String dog) {
    return '$dog · No points on this board yet';
  }

  @override
  String rankingMyBarRank(String dog, int rank) {
    return '$dog · #$rank';
  }

  @override
  String rankingMyBarRankIfJoined(String dog, int rank) {
    return '$dog · #$rank if you join';
  }

  @override
  String get rankingMyBarNoPoints => 'Finish a workout to earn points';

  @override
  String rankingMyBarKeepFirst(String points) {
    return '$points · You\'re in 1st place!';
  }

  @override
  String rankingMyBarPointsToNext(String points, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap more pts',
      one: '1 more pt',
    );
    return '$points · $_temp0 to move up';
  }

  @override
  String get rankingBattleIntro =>
      'We add up the distance of every dog that works out at each location. The more your dog walks, the further your location climbs!';

  @override
  String get rankingBattleMine => 'Your location';

  @override
  String rankingBattleStats(int sessions, int dogs) {
    String _temp0 = intl.Intl.pluralLogic(
      sessions,
      locale: localeName,
      other: '$sessions workouts',
      one: '1 workout',
    );
    String _temp1 = intl.Intl.pluralLogic(
      dogs,
      locale: localeName,
      other: '$dogs dogs',
      one: '1 dog',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String get rankingHallEmptyTitle => 'The Hall of Fame is empty so far';

  @override
  String get rankingHallEmptyMessage =>
      'On the 1st of each month, last month\'s top 3 in each category are added here.';

  @override
  String rankingHallMonthTitle(String month) {
    return '$month Hall of Fame';
  }

  @override
  String get rankingPrivateDog => 'Private dog';

  @override
  String get rankingHallChampions => 'Category winners';

  @override
  String get rankingSettingsSaved => 'Ranking settings saved.';

  @override
  String get rankingJoined =>
      'You\'ve joined the rankings! This month\'s board updates right away.';

  @override
  String get rankingLeaveTitle => 'Leave the rankings?';

  @override
  String get rankingLeaveMessage =>
      'Your nickname and dog info will be hidden from the board and the Hall of Fame right away. Points and badges keep adding up, and rejoining brings you back to this month\'s board.';

  @override
  String get rankingLeaveConfirm => 'Leave';

  @override
  String get rankingLeft => 'You\'ve left the rankings.';

  @override
  String get rankingSettingsTitle => 'Ranking settings';

  @override
  String get rankingJoinTitle => 'Want to join the rankings?';

  @override
  String get rankingSettingsIntro =>
      'Which dog is the most consistent this month? You earn points with every workout, and the top 3 each month go into the Hall of Fame.';

  @override
  String get rankingVisibleInfoTitle => 'What other members can see';

  @override
  String get rankingVisibleInfoList =>
      '· Your nickname\n· Your dog\'s name, breed, and size, plus a profile photo (optional)\n· This month\'s points and workouts, badges, and awards';

  @override
  String get rankingPrivateInfoNote =>
      'Your real name, email, and phone number are never shown.';

  @override
  String get rankingNicknameLabel => 'Nickname';

  @override
  String get rankingNicknameHelp =>
      '2–12 characters: letters, numbers, or underscore (_) · You can change it once every 30 days';

  @override
  String rankingNicknameChangeableAt(String date) {
    return 'You can change it again from $date';
  }

  @override
  String get rankingShowPhotoTitle => 'Show dog photo';

  @override
  String get rankingShowPhotoSubtitle =>
      'If off, a default icon is shown on the board';

  @override
  String get rankingJoinAction => 'Join the rankings';

  @override
  String get rankingLeaveAction => 'Leave the rankings';

  @override
  String rankingShareText(String dog, String month) {
    return '$dog\'s $month PawFit workout record! #PawFit #DogTreadmill';
  }

  @override
  String get rankingShareFailed =>
      'Couldn\'t share. Please try again in a moment.';

  @override
  String get rankingShareTitle => 'Share this month\'s record';

  @override
  String get rankingShareHint =>
      'Save it as an image and post it on Instagram or in a chat.';

  @override
  String get rankingShareButton => 'Share as image';

  @override
  String rankingShareOverall(int rank) {
    return '#$rank Overall';
  }

  @override
  String rankingShareStreak(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: '$weeks-week workout streak',
      one: '1-week workout streak',
    );
    return '$_temp0';
  }

  @override
  String boardHeadline(String branch) {
    return '$branch rankings this month';
  }

  @override
  String boardSubtitle(String month) {
    return '$month · Updates as soon as a workout ends';
  }

  @override
  String get boardJoinHint =>
      'Turn on \"Join the rankings\" in the PawFit app to see your dog\'s name here!';

  @override
  String boardBattleRank(int rank, String distance) {
    return 'Location battle #$rank · $distance';
  }

  @override
  String get boardEmptyTitle => 'Be this month\'s number one!';

  @override
  String get boardEmptyMessage =>
      'Finish a workout at this location to get on the board.';

  @override
  String rankingEntrySemantics(int rank, String dog, String points) {
    return '#$rank $dog, $points';
  }

  @override
  String get rankingMineBadge => 'Your dog';

  @override
  String badgeSemantics(String name) {
    return '$name badge';
  }

  @override
  String badgeSemanticsLocked(String name) {
    return '$name badge (not earned yet)';
  }

  @override
  String get rankingPointsChipVoided => 'Points voided';

  @override
  String get rankingPointsChipZero => '0 pts';

  @override
  String rankingPointsChipSemantics(String label) {
    return 'Ranking points $label';
  }

  @override
  String get rankingBreakdownTitle => 'Points for this workout';

  @override
  String get rankingBreakdownVoided =>
      'After a staff review, the points for this workout were voided.';

  @override
  String get rankingBreakdownDefault =>
      'The more consistently you work out, the more points you earn.';

  @override
  String get rankingBreakdownAttendance => 'Attendance';

  @override
  String get rankingBreakdownAttendanceCaption =>
      '5+ minutes of exercise (once a day)';

  @override
  String get rankingBreakdownGoal => 'Goal';

  @override
  String get rankingBreakdownGoalCaption =>
      'Based on the program\'s goal time (max 10)';

  @override
  String get rankingBreakdownDistanceCaption => '1 pt per 100 m (max 20)';

  @override
  String get rankingBreakdownWeeklyBonus => 'Weekly bonus';

  @override
  String get rankingBreakdownWeeklyBonusCaption => 'Your 2nd workout this week';

  @override
  String get rankingBreakdownTotal => 'Total';

  @override
  String get rankingRulesTitle => 'How points add up';

  @override
  String get rankingRulesIntro =>
      'Consistency over quantity! Overdoing it won\'t earn you more points.';

  @override
  String get rankingRuleAttendanceTitle => 'Attendance: 10 pts';

  @override
  String get rankingRuleAttendanceBody =>
      'Earned for working out 5+ minutes. Each dog earns points once a day.';

  @override
  String get rankingRuleGoalTitle => 'Goal: up to 10 pts';

  @override
  String get rankingRuleGoalBody =>
      'Based on how much of the program\'s goal time you complete. Stopping early never costs you points.';

  @override
  String get rankingRuleDistanceTitle => 'Distance: up to 20 pts';

  @override
  String get rankingRuleDistanceBody =>
      '1 pt for every 100 m. Points stop at 20, even past 2 km.';

  @override
  String get rankingRuleWeeklyTitle => 'Weekly bonus: 20 pts';

  @override
  String get rankingRuleWeeklyBody =>
      'Earned when you work out twice or more in a week (Mon–Sun).';

  @override
  String get rankingRuleMonthlyTitle => 'Monthly rankings';

  @override
  String get rankingRuleMonthlyBody =>
      'A fresh start on the 1st of every month. Dogs are ranked overall, by location, and by size class. Ties go to the dog that got there first.';

  @override
  String get rankingRuleHallTitle => 'Hall of Fame';

  @override
  String get rankingRuleHallBody =>
      'When the month ends, the top 3 in each category join the Hall of Fame and earn the \"Podium\" badge.';

  @override
  String get rankingRulesSafety =>
      'If your dog isn\'t feeling well, skip the workout. If anything looks wrong, press the treadmill\'s emergency stop button.';
}
