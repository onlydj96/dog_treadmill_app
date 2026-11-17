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
  String get bookingHours24 => '24 hours';

  @override
  String get bookingIntensityLow => 'Low intensity';

  @override
  String get bookingIntensityMedium => 'Moderate intensity';

  @override
  String get bookingIntensityHigh => 'High intensity';

  @override
  String get bookingStatusPending => 'Pending';

  @override
  String get bookingStatusConfirmed => 'Confirmed';

  @override
  String get bookingStatusCheckedIn => 'Checked in';

  @override
  String get bookingStatusCompleted => 'Completed';

  @override
  String get bookingStatusCancelled => 'Cancelled';

  @override
  String get bookingStatusNoShow => 'No-show';

  @override
  String get membershipStatusRefunded => 'Refunded';

  @override
  String get membershipStatusCancelled => 'Cancelled';

  @override
  String get membershipStatusExpired => 'Expired';

  @override
  String get membershipStatusUsedUp => 'Used up';

  @override
  String get membershipStatusAvailable => 'Available';

  @override
  String get paymentStatusPending => 'Payment pending';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusCancelled => 'Cancelled';

  @override
  String get paymentStatusRefunded => 'Refunded';

  @override
  String get paymentStatusPartialRefunded => 'Partially refunded';

  @override
  String get paymentStatusFailed => 'Failed';

  @override
  String get homeNotificationsTooltip => 'Notifications';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeGreetingNoDog => 'Add your dog to get started.';

  @override
  String homeGreetingWithDog(String dog) {
    return 'Another healthy walk with $dog today!';
  }

  @override
  String homeDogTapHint(String dog) {
    return 'View $dog\'s details';
  }

  @override
  String get homeProfileIncomplete => 'Complete your dog’s profile';

  @override
  String homeRankOverallThisMonth(int rank) {
    return '#$rank overall this month';
  }

  @override
  String get homeSwitchDog => 'Switch';

  @override
  String get homeStatMonthWorkouts => 'Workouts this month';

  @override
  String get homeUnitTimes => 'times';

  @override
  String get homeStatMonthDistance => 'Distance this month';

  @override
  String get homeStatLatestSymmetry => 'Latest symmetry';

  @override
  String get homeNoDogTitle => 'Add your dog';

  @override
  String get homeNoDogBody =>
      'Add health info and exercise limits too,\nand we\'ll flag what to watch for when you book.';

  @override
  String get homeNoDogAction => 'Add a dog';

  @override
  String get homeLiveTapHint => 'View live workout';

  @override
  String get homeQuickBook => 'Book a workout';

  @override
  String get homeQuickBookCaption => 'See open times';

  @override
  String get homeQuickReport => 'AI report';

  @override
  String get homeQuickReportCaption => 'Gait analysis';

  @override
  String get homeQuickHistory => 'Workout history';

  @override
  String get homeQuickHistoryCaption => 'All records';

  @override
  String get homeNextBookingTitle => 'Next booking';

  @override
  String get homeNextBookingAll => 'My bookings';

  @override
  String get homeNextBookingEmpty => 'No upcoming bookings.';

  @override
  String get homeNextBookingEmptyAction => 'Book';

  @override
  String homeRankingTitle(String month) {
    return '$month rankings';
  }

  @override
  String get homeRankingAll => 'All rankings';

  @override
  String get homeRankingWaitingTitle =>
      'Waiting for your first workout this month';

  @override
  String get homeRankingWaitingCaption =>
      'Finish a workout and your points go straight onto the rankings.';

  @override
  String homeRankingJoinTitle(int rank) {
    return 'Join and you\'ll be #$rank overall';
  }

  @override
  String homeRankingJoinCaption(String dog) {
    return 'Join the rankings and show off $dog.';
  }

  @override
  String homeRankingMineTitle(String dog, int rank) {
    return '$dog · #$rank overall';
  }

  @override
  String homeRankingHoldingFirst(String points) {
    return '$points · You\'re holding #1!';
  }

  @override
  String homeRankingPointsToNext(String points, int gap) {
    String _temp0 = intl.Intl.pluralLogic(
      gap,
      locale: localeName,
      other: '$gap more pts',
      one: '1 more pt',
    );
    return '$points · $_temp0 to move up';
  }

  @override
  String homeRankingStreak(int weeks) {
    return '$weeks-week workout streak';
  }

  @override
  String get homeRankingJoinAction => 'Join the rankings';

  @override
  String get homeRecentTitle => 'Recent workouts';

  @override
  String get homeRecentAll => 'All records';

  @override
  String get homeRecentEmpty => 'No workouts yet. Book your first one!';

  @override
  String get homeAnalysisTitle => 'AI gait analysis';

  @override
  String get homeAnalysisAction => 'Health reports';

  @override
  String get homeAnalysisPending =>
      'We\'re analyzing your latest workout video. We\'ll let you know when it\'s done.';

  @override
  String get homeAnalysisNeedsConsent =>
      'Agree to workout video recording to get AI gait analysis reports.';

  @override
  String get homeAnalysisEmpty =>
      'Your AI gait analysis report will show up here after a workout.';

  @override
  String get homeAnalysisConsentAction => 'Agree';

  @override
  String get homeAnalysisSymmetry => 'Left-right symmetry';

  @override
  String get homeAnalysisCadence => 'Steps per minute';

  @override
  String get homeUnitSteps => 'steps';

  @override
  String get homeNoticesTitle => 'Notices';

  @override
  String get homeNoticesAll => 'View all';

  @override
  String get bookingListTitle => 'Bookings';

  @override
  String get bookingPaymentHistory => 'Payments & refunds';

  @override
  String get bookingTabUpcoming => 'Upcoming';

  @override
  String get bookingTabPast => 'Past';

  @override
  String get bookingEmptyUpcoming => 'No upcoming bookings';

  @override
  String get bookingEmptyPast => 'No past bookings';

  @override
  String get bookingEmptyUpcomingHint =>
      'Book a treadmill at a time that works for you.';

  @override
  String get bookingUsablePasses => 'Available passes';

  @override
  String bookingSessionsUnit(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: ' sessions',
      one: ' session',
    );
    return '$_temp0';
  }

  @override
  String get bookingNewWorkout => 'Book a workout';

  @override
  String get bookingCheckInTitle => 'Check in now?';

  @override
  String get bookingCheckInMessage => 'Check in when you arrive at the store.';

  @override
  String bookingCheckInMessageWithMachine(String machine) {
    return 'Check in when you arrive at the store.\nAssigned treadmill: $machine';
  }

  @override
  String get bookingCheckInAction => 'Check in';

  @override
  String get bookingCheckedIn => 'You\'re checked in.';

  @override
  String bookingCheckedInWithMachine(String machine) {
    return 'You\'re checked in. Start your workout on treadmill $machine.';
  }

  @override
  String get bookingDefaultProgramName => 'Treadmill workout';

  @override
  String get bookingToday => 'Today';

  @override
  String bookingDateSemantics(String month, int day, String weekday) {
    return '$weekday, $month $day';
  }

  @override
  String bookingDateSemanticsToday(String label) {
    return '$label, today';
  }

  @override
  String get bookingSlotsEmpty => 'No open times on the selected date.';

  @override
  String get bookingPeriodDawn => 'Early morning';

  @override
  String get bookingPeriodMorning => 'Morning';

  @override
  String get bookingPeriodAfternoon => 'Afternoon';

  @override
  String get bookingPeriodEvening => 'Evening';

  @override
  String bookingSlotSemanticsAvailable(String time, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count treadmills',
      one: '1 treadmill',
    );
    return '$time, $_temp0 left';
  }

  @override
  String bookingSlotSemanticsFull(String time) {
    return '$time, full';
  }

  @override
  String bookingSlotLeft(int count) {
    return '$count left';
  }

  @override
  String get bookingSlotFull => 'Full';

  @override
  String get bookingDetailTitle => 'Booking details';

  @override
  String get bookingNoteCancelled => 'This booking was cancelled.';

  @override
  String get bookingNoteNoShow =>
      'You didn\'t show up, so this booking was marked as a no-show.';

  @override
  String get bookingStepReceived => 'Received';

  @override
  String get bookingStepConfirmed => 'Confirmed';

  @override
  String get bookingStepCheckedIn => 'Checked in';

  @override
  String get bookingStepCompleted => 'Completed';

  @override
  String get bookingInfoDog => 'Dog';

  @override
  String get bookingInfoLocation => 'Location';

  @override
  String get bookingInfoTreadmill => 'Treadmill';

  @override
  String get bookingInfoProgram => 'Program';

  @override
  String get bookingInfoPayment => 'Payment';

  @override
  String get bookingInfoNote => 'Note';

  @override
  String get bookingInfoCancellation => 'Cancellation';

  @override
  String bookingDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get bookingPayWithPass => 'Uses 1 pass session';

  @override
  String get bookingPayOnSite => 'Pay at the store';

  @override
  String get bookingCancelledToast => 'Booking cancelled.';

  @override
  String get bookingRescheduledToast => 'Booking time updated.';

  @override
  String get bookingViewWorkoutHistory => 'View workout history';

  @override
  String bookingAtMachine(String machine) {
    return 'on treadmill $machine';
  }

  @override
  String get bookingAtAssignedMachine => 'on your assigned treadmill';

  @override
  String get bookingPayOnSiteNotice =>
      '\nThis is a pay-at-the-store booking, so please pay at the store before your workout.';

  @override
  String bookingGuideCheckedIn(String atMachine, String payOnSite) {
    return 'You\'re checked in. Start your workout $atMachine, and stay with your dog the whole time. Once it starts, you can follow it live in the Workout tab.$payOnSite';
  }

  @override
  String get bookingGuideEnded =>
      'This booking\'s time has passed, so you can\'t check in.';

  @override
  String bookingGuideCheckInOpen(String atMachine, String payOnSite) {
    return 'When you arrive at the store, check in and start your workout $atMachine.$payOnSite';
  }

  @override
  String bookingGuideModifiable(String time) {
    return 'You can change or cancel until 1 hour before your booking starts.\nOn the day, you can check in from the app starting at $time.';
  }

  @override
  String bookingGuideModifiableWithPass(String time) {
    return 'You can change or cancel until 1 hour before your booking starts. Cancelling restores your pass session.\nOn the day, you can check in from the app starting at $time.';
  }

  @override
  String bookingGuideLocked(String time) {
    return 'You can check in from the app starting at $time.\nWithin 1 hour of the start time, bookings can\'t be changed or cancelled in the app.';
  }

  @override
  String get bookingCancelAction => 'Cancel booking';

  @override
  String get bookingRescheduleAction => 'Change time';

  @override
  String get bookingInquiryAction => 'Send a 1:1 inquiry';

  @override
  String get bookingCancelReasonSchedule => 'My plans changed';

  @override
  String get bookingCancelReasonCondition => 'My dog isn\'t feeling well';

  @override
  String get bookingCancelReasonRebook => 'I\'ll rebook for another time';

  @override
  String get bookingCancelReasonOther => 'Other';

  @override
  String get bookingCancelSheetTitle => 'Cancel this booking?';

  @override
  String get bookingCancelSheetSubtitle => 'Choose a reason.';

  @override
  String get bookingCancelConfirmAction => 'Cancel booking';

  @override
  String get bookingRescheduleTitle => 'Change booking time';

  @override
  String bookingRescheduleCurrent(String when, String branch) {
    return 'Current: $when · $branch';
  }

  @override
  String get bookingRescheduleNoProgram =>
      'This booking has no program info, so the time can\'t be changed. Please contact us through a 1:1 inquiry.';

  @override
  String get bookingReschedulePick => 'Choose a new time';

  @override
  String bookingRescheduleSubmit(String time) {
    return 'Change booking to $time';
  }

  @override
  String get bookingConfirmedToast => 'Your booking is confirmed.';

  @override
  String get bookingReceivedToast =>
      'Your booking is received. Please pay at the store on the day.';

  @override
  String get bookingNewTitle => 'Book a workout';

  @override
  String get bookingStepDog => 'Dog';

  @override
  String get bookingStepBranch => 'Location';

  @override
  String get bookingStepProgram => 'Workout program';

  @override
  String get bookingStepDate => 'Date';

  @override
  String get bookingStepTime => 'Time';

  @override
  String get bookingStepPayment => 'Payment';

  @override
  String get bookingStepNote => 'Note (optional)';

  @override
  String get bookingNeedDogMessage => 'Add a dog before you book.';

  @override
  String get bookingNeedDogAction => 'Add';

  @override
  String get bookingTimeHint =>
      'Choose a location and workout program to see open times.';

  @override
  String bookingPassValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String bookingPassRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions left',
      one: '1 session left',
    );
    return '$_temp0';
  }

  @override
  String get bookingPayOnSiteBody =>
      'Your booking is held as pending, and you pay at the store on the day.';

  @override
  String get bookingNoteHint =>
      'Leave any notes about your dog. (e.g. Sensitive to unfamiliar sounds)';

  @override
  String get bookingSelfServiceHint =>
      'This is a self-service store. On the day, check in from the app starting 15 minutes before your booking, then start your workout on your assigned treadmill.\nYou can change or cancel in the app until 1 hour before the start. If you booked with a pass, cancelling restores your session.';

  @override
  String get bookingSummaryIncomplete =>
      'Choose a dog, location, program, and time.';

  @override
  String bookingSummary(String dog, String when, String program,
      String duration, String payment) {
    return '$dog · $when\n$program $duration · $payment';
  }

  @override
  String get bookingSummaryPayWithPass => '1 pass session used';

  @override
  String get bookingAppPaymentTitle => 'Pay in app';

  @override
  String get bookingAppPaymentBody =>
      'Pay by card or mobile pay and confirm your booking right away.';

  @override
  String get bookingComingSoon => 'Coming soon';

  @override
  String bookingRestrictionNotice(String restrictions) {
    return 'Exercise limits: $restrictions\nThis is a self-service store, so you\'ll need to keep an eye on your dog yourself. Choose a program that fits these limits and stay with your dog during the workout.';
  }

  @override
  String get bookingSubmit => 'Book';

  @override
  String get membershipTitle => 'Passes';

  @override
  String get membershipPaymentHistory => 'Payment history';

  @override
  String get membershipOwnedTitle => 'Your passes';

  @override
  String get membershipOwnedEmpty =>
      'You don\'t have any passes yet. Buy one below and use it to book right in the app.';

  @override
  String get membershipPlansTitle => 'Pass options';

  @override
  String get membershipPurchaseNote =>
      'Tap a pass to see how to pay. In-app payment is coming soon, so for now you can buy at the store, and it shows up in your passes right away.';

  @override
  String membershipDaysLeft(int days) {
    return '${days}d left';
  }

  @override
  String membershipSessionsLeft(int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: '/ $total sessions left',
      one: '/ 1 session left',
    );
    return '$_temp0';
  }

  @override
  String membershipPlanSessionsBadge(int count) {
    return '$count×';
  }

  @override
  String membershipValidDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Valid for $days days',
      one: 'Valid for 1 day',
    );
    return '$_temp0';
  }

  @override
  String membershipPricePerSession(String price) {
    return '$price per session';
  }

  @override
  String membershipPurchaseSummary(String price, int count, int days) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'valid for $days days',
      one: 'valid for 1 day',
    );
    return '$price · $_temp0 · $_temp1';
  }

  @override
  String get membershipAppPaymentTitle => 'Pay in app';

  @override
  String get membershipAppPaymentBody =>
      'Pay by card or mobile pay and it\'s added to your passes right away.';

  @override
  String get membershipComingSoon => 'Coming soon';

  @override
  String get membershipStorePaymentTitle => 'Pay at the store';

  @override
  String get membershipStorePaymentBody =>
      'For now you can buy at the store. It shows up in your passes in the app right away.';

  @override
  String get membershipAppPaymentUnavailable => 'In-app payment coming soon';

  @override
  String get paymentHistoryTitle => 'Payments & refunds';

  @override
  String get paymentEmpty => 'No payments yet';

  @override
  String get paymentDefaultOrderName => 'Pass purchase';

  @override
  String paymentRefunded(String amount) {
    return 'Refunded $amount';
  }

  @override
  String paymentRefundedOn(String amount, String date) {
    return 'Refunded $amount ($date)';
  }
}
