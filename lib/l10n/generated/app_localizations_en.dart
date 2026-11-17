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
  String get exerciseStatusReady => 'Getting ready';

  @override
  String get exerciseStatusRunning => 'Working out';

  @override
  String get exerciseStatusPaused => 'Paused';

  @override
  String get exerciseStatusCompleted => 'Workout complete';

  @override
  String get exerciseStatusStopped => 'Workout stopped';

  @override
  String get exerciseHistoryTitle => 'Workout history';

  @override
  String exerciseHistoryTitleDog(String dog) {
    return '$dog\'s workout history';
  }

  @override
  String get exerciseTitle => 'Workout';

  @override
  String exerciseTitleDog(String dog) {
    return '$dog\'s workout';
  }

  @override
  String get exerciseNoDogTitle => 'You haven\'t added a dog yet';

  @override
  String get exerciseNoDogHistoryMessage =>
      'Add your dog to see workout history.';

  @override
  String get exerciseNoDogLiveMessage =>
      'Add your dog to see live workouts and history.';

  @override
  String get exerciseRegisterDog => 'Add your dog';

  @override
  String get exerciseNoRecordsTitle => 'No workouts yet';

  @override
  String get exerciseNoRecordsHistoryMessage =>
      'Your workouts will be listed here by date.';

  @override
  String get exerciseNoRecordsSummaryMessage =>
      'Time, distance and speed are recorded after each workout.';

  @override
  String exerciseSessionCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count workouts',
      one: '1 workout',
    );
    return '$_temp0';
  }

  @override
  String get exerciseTotalsTitle => 'Workout totals';

  @override
  String get exerciseStatTotalWorkouts => 'Total workouts';

  @override
  String get exerciseStatTotalTime => 'Total time';

  @override
  String get exerciseStatTotalDistance => 'Total distance';

  @override
  String get exerciseStatBestSpeed => 'Top speed';

  @override
  String get exerciseUnitTimes => '';

  @override
  String get exerciseUnitMinutes => 'min';

  @override
  String get exerciseCompletedToast => 'Workout complete!';

  @override
  String get exerciseStoppedToast => 'Your workout was stopped.';

  @override
  String get exerciseLive => 'Live';

  @override
  String get exerciseElapsed => 'Elapsed time';

  @override
  String exerciseTarget(String duration) {
    return 'Goal: $duration';
  }

  @override
  String get exerciseCurrentSpeed => 'Current speed';

  @override
  String get exerciseDistance => 'Distance';

  @override
  String get exerciseStartTime => 'Start time';

  @override
  String get exerciseTreadmill => 'Treadmill';

  @override
  String get exerciseUnmannedNotice =>
      'This is a self-service store. Please stay with your dog during the workout, and press the treadmill\'s emergency stop button if anything seems off.';

  @override
  String get exerciseNoLiveTitle => 'No workout in progress';

  @override
  String get exerciseNoLiveMessage =>
      'Once a workout starts, you\'ll see it live here.';

  @override
  String get exerciseBookWorkout => 'Book a workout';

  @override
  String get exerciseNextBooking => 'Next booking';

  @override
  String get exerciseMyBookings => 'My bookings';

  @override
  String exerciseMonthSummary(int month) {
    return 'This month\'s workouts';
  }

  @override
  String get exerciseStatCount => 'Workouts';

  @override
  String get exerciseStatTotalWorkoutTime => 'Total workout time';

  @override
  String get exerciseRecentRecords => 'Recent workouts';

  @override
  String get exerciseAllRecords => 'See all';

  @override
  String exerciseTreadmillName(String name) {
    return 'Treadmill $name';
  }

  @override
  String get exerciseWorkoutTime => 'Workout time';

  @override
  String get exerciseAvgMax => 'Avg / max';

  @override
  String exerciseStopReason(String reason) {
    return 'Stopped: $reason';
  }

  @override
  String get exercisePointsVoided => 'Voided after a staff review';

  @override
  String exercisePointsWeeklyBonus(String points) {
    return 'Includes $points weekly bonus';
  }

  @override
  String get exercisePointsDefault => 'Ranking points';

  @override
  String get exerciseReportAi => 'AI report';

  @override
  String get exerciseReportFailed => 'Analysis failed';

  @override
  String get exerciseReportPending => 'Analyzing';

  @override
  String get analysisStatusQueued => 'Queued';

  @override
  String get analysisStatusProcessing => 'Analyzing';

  @override
  String get analysisStatusCompleted => 'Analysis complete';

  @override
  String get analysisStatusFailed => 'Analysis failed';

  @override
  String get analysisLevelNormal => 'No concerns';

  @override
  String get analysisLevelCaution => 'Monitor';

  @override
  String get analysisLevelWarning => 'Needs attention';

  @override
  String get analysisCameraFront => 'Front view';

  @override
  String get analysisCameraSide => 'Side view';

  @override
  String get healthTitle => 'Health';

  @override
  String healthTitleDog(String dog) {
    return '$dog\'s health analysis';
  }

  @override
  String get healthNoDogMessage =>
      'Add your dog and start working out to see AI gait analysis results.';

  @override
  String get healthReports => 'Analysis reports';

  @override
  String healthPendingBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count workout videos',
      one: '1 workout video',
    );
    return 'We\'re analyzing $_temp0. We\'ll notify you when it\'s done.';
  }

  @override
  String get healthPreparingTitle => 'We\'re preparing your first report';

  @override
  String get healthPreparingMessage =>
      'We\'re analyzing joint movement and gait patterns from your workout video. We\'ll notify you when it\'s done.';

  @override
  String get healthConsentTitle => 'Workout video consent needed';

  @override
  String get healthConsentMessage =>
      'AI gait analysis reports are made from workout videos. If you agree, we\'ll analyze joint movement and gait patterns starting with your next workout.';

  @override
  String get healthConsentAction => 'Go to consent';

  @override
  String get healthNoReportTitle => 'No analysis reports yet';

  @override
  String get healthNoReportMessage =>
      'After a treadmill workout, we\'ll analyze joint movement and gait patterns from the video.';

  @override
  String get healthLatestAnalysis => 'Latest analysis';

  @override
  String get healthSymmetry => 'Left-right symmetry';

  @override
  String get healthCadence => 'Steps per minute';

  @override
  String get healthRhythm => 'Gait rhythm';

  @override
  String get healthUnitPoints => 'pts';

  @override
  String get healthConfidence => 'Confidence';

  @override
  String get healthViewReport => 'View full report →';

  @override
  String get healthTrendSymmetryDesc =>
      'Shows how similar the left and right leg movements are. Higher means a more balanced gait.';

  @override
  String get healthTrendCadenceDesc =>
      'Steps taken in one minute. A big change from the usual baseline is worth monitoring.';

  @override
  String get healthTrendVariabilityDesc =>
      'Shows how consistent the stride timing is. Lower means a steadier rhythm.';

  @override
  String get healthTrendTitle => 'Gait trends';

  @override
  String get healthTrendSegSymmetry => 'Symmetry';

  @override
  String get healthTrendSegCadence => 'Steps';

  @override
  String get healthTrendSegVariability => 'Variability';

  @override
  String get healthTrendNeedMore =>
      'You need at least 2 analysis results to see a trend.';

  @override
  String get healthJointRomTitle => 'Joint range of motion changes';

  @override
  String get healthAllJoints => 'All joints';

  @override
  String get healthPlanTitle => 'Custom workout plan';

  @override
  String get healthPlanTargetTime => 'Target time';

  @override
  String get healthPlanTargetSpeed => 'Target speed';

  @override
  String get healthVideoPause => 'Pause';

  @override
  String get healthVideoPlay => 'Play';
}
