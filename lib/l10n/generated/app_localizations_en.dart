// ignore: unused_import
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
      'Add SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY to config/supabase.env, then run the app again. You can start from a copy of config/supabase.env.example.';

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
  String get errorQrInvalid =>
      'This isn\'t a PawFit treadmill QR code. Scan the QR code on the treadmill.';

  @override
  String get errorQrOtherBranch =>
      'This treadmill is at a different location. Scan a treadmill QR code at the location you booked.';

  @override
  String get errorTreadmillUnavailable =>
      'This treadmill is under maintenance. Scan another treadmill\'s QR code.';

  @override
  String get errorTreadmillBusy =>
      'This treadmill is booked by someone else at this time. Scan your assigned treadmill or another free one.';

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
  String get authTagline =>
      'From treadmill bookings to AI gait analysis,\nwe\'ll track your dog\'s healthy steps together.';

  @override
  String get authEmail => 'Email';

  @override
  String get authPassword => 'Password';

  @override
  String get authShowPassword => 'Show password';

  @override
  String get authHidePassword => 'Hide password';

  @override
  String get authLogIn => 'Log in';

  @override
  String get authNoAccount => 'Don\'t have an account yet?';

  @override
  String get authSignUp => 'Sign up';

  @override
  String get signupTitle => 'Sign up';

  @override
  String get signupOwnerSection => 'Your info';

  @override
  String get signupName => 'Name';

  @override
  String get signupPhone => 'Mobile number';

  @override
  String get signupLoginSection => 'Login details';

  @override
  String get signupPasswordHelper =>
      'At least 8 characters, with letters and numbers';

  @override
  String get signupConfirmPassword => 'Confirm password';

  @override
  String get signupPasswordMismatch => 'Passwords don\'t match.';

  @override
  String get signupRequiredConsent => 'Please agree to the required terms.';

  @override
  String get signupVerifyTitle => 'Verification email sent';

  @override
  String signupVerifyBody(String email) {
    return 'Tap the link in the email we sent to $email to finish signing up, then log in.';
  }

  @override
  String get signupSubmit => 'Create account';

  @override
  String get signupAgreeAll => 'Agree to all';

  @override
  String get signupAgreeAllDesc =>
      'I agree to all items, including optional ones.';

  @override
  String get signupRequiredTag => '[Required] ';

  @override
  String get signupOptionalTag => '[Optional] ';

  @override
  String get consentTermsTitle => 'Terms of service';

  @override
  String get consentTermsDesc => 'The terms that apply to using PawFit.';

  @override
  String get consentPrivacyTitle =>
      'Collection and use of personal information';

  @override
  String get consentPrivacyDesc =>
      'We collect your name, contact details, email, and your dog\'s information to identify members, process bookings and payments, and provide support.';

  @override
  String get consentVideoTitle => 'Workout video recording and AI analysis';

  @override
  String get consentVideoDesc =>
      'We record front and side video of your dog during treadmill workouts to create joint and gait analysis reports. If you don\'t agree, AI analysis reports won\'t be provided.';

  @override
  String get consentAiTrainingTitle => 'Use of data for AI training';

  @override
  String get consentAiTrainingDesc =>
      'We de-identify recorded video and joint coordinates and use them to improve our AI models. Not agreeing doesn\'t limit your use of the service.';

  @override
  String get consentRankingTitle => 'Join rankings (nickname and dog shown)';

  @override
  String get consentRankingDesc =>
      'Your nickname, your dog\'s name, breed, and photo, and workout points are shown to other members in the monthly rankings and Hall of Fame. Your real name, email, and phone number are never shown, and you\'re removed from the rankings as soon as you withdraw.';

  @override
  String get consentMarketingTitle => 'Marketing messages';

  @override
  String get consentMarketingDesc =>
      'Get news about events and offers as notifications.';

  @override
  String get consentScreenTitle => 'Privacy and video consent';

  @override
  String get consentIntro =>
      'You can change your choices at any time. Your change history is kept securely.';

  @override
  String get consentRequiredNote =>
      'Required items are essential to the service and can\'t be withdrawn. To withdraw them, please delete your account.';

  @override
  String get consentWithdrawVideoTitle => 'Withdraw video recording consent?';

  @override
  String get consentWithdrawVideoMessage =>
      'From your next workout, AI gait analysis reports won\'t be provided. You can still view reports you\'ve already received.';

  @override
  String get consentWithdrawVideoConfirm => 'Withdraw';

  @override
  String get consentLeaveRankingTitle => 'Leave the rankings?';

  @override
  String get consentLeaveRankingMessage =>
      'Your nickname and dog\'s info will be hidden right away on the leaderboards and Hall of Fame. Your points and badges will keep adding up.';

  @override
  String get consentLeaveRankingConfirm => 'Leave';

  @override
  String get consentGranted => 'Agreed';

  @override
  String get consentNotGranted => 'Not agreed';

  @override
  String consentStatusLine(String state, String date, String version) {
    return '$state · $date · v$version';
  }

  @override
  String get myPageTitle => 'Account';

  @override
  String myPageGreeting(String name) {
    return '$name';
  }

  @override
  String get myPageMyDogs => 'My dogs';

  @override
  String get myPageUsageGroup => 'Activity';

  @override
  String get myPageMembership => 'Passes and membership';

  @override
  String get myPagePayments => 'Payments and refunds';

  @override
  String get myPageBookings => 'My bookings';

  @override
  String get myPageWorkoutHistory => 'Workout history';

  @override
  String get myPageRankingGroup => 'Rankings';

  @override
  String get myPageRankingHall => 'Monthly rankings and Hall of Fame';

  @override
  String get myPageRankingSettings => 'Ranking and nickname settings';

  @override
  String get myPageSettingsGroup => 'Settings';

  @override
  String get myPageProfile => 'Profile and login';

  @override
  String get myPageSupportGroup => 'Support';

  @override
  String get myPageLogOut => 'Log out';

  @override
  String get myPageLogOutMessage => 'Log out of PawFit?';

  @override
  String get myPageDeleteAccount => 'Delete account';

  @override
  String get myPageDeleteMessage =>
      'Deleting your account permanently removes your dogs\' info, bookings, workout and analysis records, and any remaining passes. This can\'t be undone. Payment records are kept for a period required by law.\n\nAre you sure you want to delete your account?';

  @override
  String get myPageDeleteConfirm => 'Delete account';

  @override
  String get profileEditTitle => 'Profile and login';

  @override
  String get profileEditProfileSection => 'Profile';

  @override
  String get profileEditSave => 'Save profile';

  @override
  String get profileEditSaved => 'Profile saved.';

  @override
  String get profileEditLoginSection => 'Login account';

  @override
  String get profileEditNewPassword => 'New password';

  @override
  String get profileEditConfirmNewPassword => 'Confirm new password';

  @override
  String get profileEditChangePassword => 'Change password';

  @override
  String get profileEditPasswordChanged => 'Password changed.';

  @override
  String get notificationSettingsTitle => 'Notification settings';

  @override
  String get notificationSettingsBooking => 'Booking alerts';

  @override
  String get notificationSettingsBookingDesc =>
      'Booking confirmed or cancelled, no-show';

  @override
  String get notificationSettingsExercise => 'Workout alerts';

  @override
  String get notificationSettingsExerciseDesc =>
      'Workout started, finished, or stopped';

  @override
  String get notificationSettingsAnalysis => 'AI analysis alerts';

  @override
  String get notificationSettingsAnalysisDesc => 'Gait analysis report ready';

  @override
  String get notificationSettingsRanking => 'Ranking alerts';

  @override
  String get notificationSettingsRankingDesc =>
      'Badges, cheers, and monthly results';

  @override
  String get notificationSettingsMarketing => 'Event and offer alerts';

  @override
  String get notificationSettingsMarketingDesc =>
      'You can change this in the marketing consent setting.';

  @override
  String get notificationTitle => 'Notifications';

  @override
  String get notificationMarkAllRead => 'Mark all read';

  @override
  String get notificationEmptyTitle => 'No new notifications';

  @override
  String get notificationEmptyMessage =>
      'We\'ll let you know about confirmed bookings, workouts, AI analysis results, and badge and ranking news.';

  @override
  String get notificationUnreadLabel => 'Unread notification';

  @override
  String get notificationBookingConfirmedTitle => 'Booking confirmed';

  @override
  String notificationBookingConfirmedBody(String dog, String when) {
    return 'Your booking for $dog on $when is confirmed.';
  }

  @override
  String get notificationBookingCancelledTitle => 'Booking cancelled';

  @override
  String notificationBookingCancelledBody(String dog, String when) {
    return 'Your booking for $dog on $when was cancelled by the gym.';
  }

  @override
  String get notificationBookingNoShowTitle => 'Marked as no-show';

  @override
  String notificationBookingNoShowBody(String dog, String when) {
    return 'Your booking for $dog on $when was marked as a no-show.';
  }

  @override
  String get notificationExerciseStartedTitle => 'Workout started';

  @override
  String notificationExerciseStartedBody(String dog) {
    return '$dog has started a treadmill workout. Check the live status.';
  }

  @override
  String get notificationExerciseCompletedTitle => 'Workout finished';

  @override
  String notificationExerciseCompletedBody(String dog) {
    return '$dog\'s workout is done. Check your workout history.';
  }

  @override
  String notificationExerciseCompletedPointsBody(String dog, String points) {
    return '$dog\'s workout is done. You earned $points! Check your workout history.';
  }

  @override
  String get notificationExerciseStoppedTitle => 'Workout stopped';

  @override
  String notificationExerciseStoppedBody(String dog, String reason) {
    return '$dog\'s workout was stopped. Reason: $reason';
  }

  @override
  String get notificationAnalysisCompletedTitle =>
      'Your AI gait analysis report is ready';

  @override
  String notificationAnalysisCompletedBody(String dog) {
    return 'Check the workout analysis results for $dog.';
  }

  @override
  String get notificationAnalysisFailedTitle =>
      'AI analysis couldn\'t be completed';

  @override
  String notificationAnalysisFailedBody(String dog) {
    return 'There was a problem analyzing $dog\'s video. We\'ll check at the gym and run the analysis again.';
  }

  @override
  String get notificationBadgeEarnedTitle => 'New badge earned';

  @override
  String notificationBadgeEarnedBody(String dog, String badge) {
    return '$dog earned the \"$badge\" badge. Check it in your badge collection.';
  }

  @override
  String get notificationCheerReceivedTitle => 'Cheer received';

  @override
  String notificationCheerReceivedBody(String nickname, String dog) {
    return '$nickname cheered for $dog.';
  }

  @override
  String notificationCheerReceivedAnonymousBody(String dog) {
    return 'Another owner cheered for $dog.';
  }

  @override
  String notificationMonthlyAwardTitle(String month) {
    return 'Podium finish in $month rankings';
  }

  @override
  String notificationMonthlyAwardBody(
      String dog, String month, String summary) {
    return '$dog placed in the $month rankings: $summary. Check the Hall of Fame to see it.';
  }

  @override
  String notificationMonthlyAwardItem(String label, int rank) {
    return '#$rank $label';
  }

  @override
  String get noticeTitle => 'Notices';

  @override
  String get noticeEmpty => 'No notices yet';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get faqAll => 'All';

  @override
  String get faqAskInquiry => 'Can\'t find your answer? Send a 1:1 inquiry';

  @override
  String get inquiryTitle => '1:1 inquiry';

  @override
  String get inquiryNew => 'New inquiry';

  @override
  String get inquiryEmptyTitle => 'No inquiries yet';

  @override
  String get inquiryEmptyMessage =>
      'Leave your question and we\'ll get back to you.';

  @override
  String get inquiryAnswerLabel => 'Answer';

  @override
  String get inquiryTypeLabel => 'Inquiry type';

  @override
  String get inquiryCategoryBooking => 'Booking';

  @override
  String get inquiryCategoryPayment => 'Payment and passes';

  @override
  String get inquiryCategoryExercise => 'Workout';

  @override
  String get inquiryCategoryAnalysis => 'AI analysis';

  @override
  String get inquiryCategoryAccount => 'Account';

  @override
  String get inquiryCategoryEtc => 'Other';

  @override
  String get inquiryTitleLabel => 'Title';

  @override
  String get inquiryTitleRequired => 'Please enter a title.';

  @override
  String get inquiryBodyLabel => 'Message';

  @override
  String get inquiryBodyRequired => 'Please enter your message.';

  @override
  String get inquirySubmit => 'Submit inquiry';

  @override
  String get inquiryCreated =>
      'We\'ve received your inquiry. Once it\'s answered, you can see the reply in your inquiry history.';

  @override
  String get inquiryStatusAnswered => 'Answered';

  @override
  String get inquiryStatusClosed => 'Closed';

  @override
  String get inquiryStatusPending => 'Awaiting answer';

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
  String get bookingCheckInAction => 'QR check-in';

  @override
  String get bookingCheckedIn =>
      'You\'re checked in. Press Start on the treadmill to begin your workout.';

  @override
  String bookingCheckedInWithMachine(String machine) {
    return 'You\'re checked in on treadmill $machine. Press Start on the treadmill to begin your workout.';
  }

  @override
  String get bookingQrScanTitle => 'Scan treadmill QR';

  @override
  String get bookingQrScanHint =>
      'Fit the QR code on the treadmill you\'ll use inside the frame.';

  @override
  String bookingQrScanAssigned(String machine) {
    return 'Your assigned treadmill is $machine. If another treadmill is free, you can scan that one instead.';
  }

  @override
  String get bookingQrCameraDenied =>
      'Camera access is needed to scan the QR code. Allow camera access in Settings.';

  @override
  String get bookingQrCameraError =>
      'Couldn\'t open the camera. Please try again in a moment.';

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
    return 'You\'re checked in. Press Start $atMachine to begin your workout, and stay with your dog the whole time. Once it starts, you can follow it live in the Workout tab.$payOnSite';
  }

  @override
  String get bookingGuideEnded =>
      'This booking\'s time has passed, so you can\'t check in.';

  @override
  String bookingGuideCheckInOpen(String payOnSite) {
    return 'When you arrive, scan the QR code on the treadmill you\'ll use to check in. It doesn\'t have to be your assigned treadmill as long as it\'s free. After checking in, press Start on the treadmill to begin.$payOnSite';
  }

  @override
  String bookingGuideModifiable(String time) {
    return 'You can change or cancel until 1 hour before your booking starts.\nOn the day, you can check in from $time by scanning the treadmill QR code at the store.';
  }

  @override
  String bookingGuideModifiableWithPass(String time) {
    return 'You can change or cancel until 1 hour before your booking starts. Cancelling restores your pass session.\nOn the day, you can check in from $time by scanning the treadmill QR code at the store.';
  }

  @override
  String bookingGuideLocked(String time) {
    return 'You can check in from $time by scanning the treadmill QR code at the store.\nWithin 1 hour of the start time, bookings can\'t be changed or cancelled in the app.';
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
      'Your booking is confirmed right away, and you pay at the store on the day.';

  @override
  String get bookingNoteHint =>
      'Leave any notes about your dog. (e.g. Sensitive to unfamiliar sounds)';

  @override
  String get bookingSelfServiceHint =>
      'This is a self-service store. On the day, starting 15 minutes before your booking, scan the treadmill\'s QR code with the app to check in, then press Start on the treadmill.\nYou can change or cancel in the app until 1 hour before the start. If you booked with a pass, cancelling restores your session.';

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

  @override
  String get dogSexMale => 'Male';

  @override
  String get dogSexFemale => 'Female';

  @override
  String get dogSizeSmall => 'Small';

  @override
  String get dogSizeMedium => 'Medium';

  @override
  String get dogSizeLarge => 'Large';

  @override
  String get dogWeightHintSmall => 'Under 10kg';

  @override
  String get dogWeightHintMedium => '10–25kg';

  @override
  String get dogWeightHintLarge => '25kg and up';

  @override
  String dogMixedLabel(String breed) {
    return 'Mixed ($breed)';
  }

  @override
  String get dogMixedBreed => 'Mixed breed';

  @override
  String dogAgeApprox(String age) {
    return '~$age';
  }

  @override
  String dogSizeDog(String size) {
    return '$size dog';
  }

  @override
  String get dogBrachycephalic => 'Brachycephalic (flat-faced)';

  @override
  String get dogRegisterTitle => 'Add your dog';

  @override
  String get dogEditTitle => 'Edit dog info';

  @override
  String dogRegistered(String name) {
    return '$name has been added.';
  }

  @override
  String get dogUpdated => 'Dog info updated.';

  @override
  String dogSavedPhotoFailed(String error) {
    return 'Info saved, but the photo couldn\'t be uploaded. $error';
  }

  @override
  String get dogPhotoLoadFailed =>
      'Couldn\'t load the photo. Check your permissions.';

  @override
  String get dogRequiredCheck =>
      'Please check the required fields marked below.';

  @override
  String get dogPickGallery => 'Choose from library';

  @override
  String get dogPickCamera => 'Take a photo';

  @override
  String get dogBirthDatePickerHelp => 'Select birth date';

  @override
  String get dogAgeRequired => 'Enter your dog\'s age.';

  @override
  String get dogAgeMax => 'Enter an age of 30 or under.';

  @override
  String get dogAgeMin => 'Enter at least 1 month.';

  @override
  String get dogAgeMonthsRange => '0–11 months';

  @override
  String get dogSectionBasic => 'Basic info';

  @override
  String get dogNameLabel => 'Name *';

  @override
  String get dogNameRequired => 'Enter a name.';

  @override
  String get dogMixedSwitch => 'Mixed breed';

  @override
  String get dogMixedSwitchHint =>
      'Two or more breeds, or you\'re not sure of the breed';

  @override
  String get dogBreedLabelMixed => 'Mixed with (optional)';

  @override
  String get dogBreedLabel => 'Breed *';

  @override
  String get dogBreedHintMixed => 'e.g. Maltese, Poodle';

  @override
  String get dogBreedHint => 'e.g. Maltese';

  @override
  String get dogBreedRequired =>
      'Enter a breed. If you\'re not sure, choose Mixed breed.';

  @override
  String get dogBreedNotListed =>
      'This breed isn\'t on the list. Pick a size below.';

  @override
  String get dogSizeLabel => 'Size *';

  @override
  String get dogSizeRequired => 'Select a size.';

  @override
  String dogSizeInfoHint(String options) {
    return 'Based on adult weight · $options';
  }

  @override
  String get dogBrachySwitch => 'Brachycephalic (flat-faced)';

  @override
  String get dogBrachySwitchHint =>
      'Short, flat faces like pugs, shih tzus and bulldogs';

  @override
  String get dogAgeLabel => 'Age *';

  @override
  String get dogBirthDate => 'Birth date';

  @override
  String get dogAgeEstimate => 'Estimated age';

  @override
  String dogCurrentAge(String age) {
    return 'Currently $age';
  }

  @override
  String get dogBirthDateRequired => 'Select a birth date.';

  @override
  String get dogPleaseSelect => 'Select';

  @override
  String get dogAge => 'Age';

  @override
  String get dogAgeYearsSuffix => 'yrs';

  @override
  String get dogAgeMonthsLabel => 'Months (optional)';

  @override
  String get dogAgeMonthsSuffix => 'mo';

  @override
  String get dogSex => 'Sex';

  @override
  String get dogNeutered => 'Neutered';

  @override
  String get dogNeuteredLabel => 'Neutered *';

  @override
  String get dogNeuteredYes => 'Yes';

  @override
  String get dogNeuteredNo => 'No';

  @override
  String get dogNeuteredRequired => 'Select whether your dog is neutered.';

  @override
  String get dogWeight => 'Weight';

  @override
  String get dogWeightLabel => 'Weight *';

  @override
  String get dogWeightEnter => 'Enter a weight.';

  @override
  String get dogWeightInvalid => 'Enter a valid weight.';

  @override
  String get dogSectionHealth => 'Health info';

  @override
  String get dogHealthIntro =>
      'Used to set workout intensity and precautions. Please be accurate.';

  @override
  String get dogConditionsRequired => 'Pick any that apply, or \"None\".';

  @override
  String get dogConditionsTitleRequired => 'Conditions & precautions *';

  @override
  String get dogConditionsTitle => 'Conditions & precautions';

  @override
  String get dogConditionsHelp =>
      'Select everything your dog has been diagnosed with or is being treated for.';

  @override
  String get dogConditionNone => 'None';

  @override
  String get dogDiseasesTitle => 'Condition details';

  @override
  String get dogDiseasesEmpty => 'No diagnoses recorded.';

  @override
  String get dogDiseaseNameLabel => 'Diagnosis (e.g. patellar luxation)';

  @override
  String get dogDiseaseDetailLabel => 'Status or stage (optional)';

  @override
  String get dogSurgeriesTitle => 'Surgeries & treatments';

  @override
  String get dogSurgeriesEmpty => 'No history recorded.';

  @override
  String get dogSurgeryNameLabel => 'Surgery or treatment';

  @override
  String get dogSurgeryDetailLabel => 'Clinic or notes (optional)';

  @override
  String get dogMedicationsTitle => 'Current medications';

  @override
  String get dogMedicationsEmpty => 'No current medications.';

  @override
  String get dogMedicationNameLabel => 'Medication name';

  @override
  String get dogMedicationDetailLabel => 'Dose and schedule (optional)';

  @override
  String get dogRestrictionsTitle => 'Workout restrictions';

  @override
  String get dogRestrictionsEmpty => 'No workout restrictions.';

  @override
  String get dogRestrictionNameLabel =>
      'Restriction (e.g. no incline workouts)';

  @override
  String get dogRestrictionDetailLabel => 'Details (optional)';

  @override
  String dogHealthItemAddTitle(String title) {
    return 'Add: $title';
  }

  @override
  String get dogDatePickOptional => 'Select date (optional)';

  @override
  String get dogVetNotes => 'Vet recommendations';

  @override
  String get dogVetNotesHint =>
      'e.g. 3 times a week, slow walks under 20 minutes';

  @override
  String get dogSubmitSave => 'Save';

  @override
  String get dogSubmitRegister => 'Add dog';

  @override
  String dogDeleteTitle(String name) {
    return 'Delete $name\'s info?';
  }

  @override
  String get dogDeleteMessage =>
      'It\'ll be removed from your list and you won\'t be able to make new bookings. Past workout and analysis records are kept by the gym.';

  @override
  String dogDeleted(String name) {
    return '$name\'s info was deleted.';
  }

  @override
  String get dogProfileTitle => 'Dog info';

  @override
  String get dogDeleteMenu => 'Delete dog';

  @override
  String dogBookWorkout(String name) {
    return 'Book a workout for $name';
  }

  @override
  String get dogProfileEmptySummary => 'Add your dog\'s profile info';

  @override
  String get dogTotalWorkouts => 'Total workouts';

  @override
  String get dogUnitTimes => '';

  @override
  String get dogTotalTime => 'Total time';

  @override
  String get dogUnitMinutes => 'min';

  @override
  String get dogTotalDistance => 'Total distance';

  @override
  String get dogBreed => 'Breed';

  @override
  String get dogSize => 'Size';

  @override
  String dogAgeEstimated(String age) {
    return '$age (estimated)';
  }

  @override
  String get dogNoHealthInfo =>
      'No health info yet. You can add it from the edit screen.';

  @override
  String dogBadgeSection(int earned, int total) {
    return 'Badges $earned/$total';
  }

  @override
  String get dogBadgeCollection => 'Badge collection';

  @override
  String get dogFirstBadgeHint =>
      'Finish your first workout to earn the \"First Steps\" badge.';

  @override
  String dogNextBadge(String name) {
    return 'Next badge · $name';
  }

  @override
  String get dogPlanSection => 'Custom workout plan';

  @override
  String get dogPlanProgram => 'Program';

  @override
  String get dogPlanTargetTime => 'Target time';

  @override
  String get dogPlanTargetSpeed => 'Target speed';

  @override
  String get dogPlanNotes => 'Notes';

  @override
  String get dogListTitle => 'My dogs';

  @override
  String get dogListRegister => 'Add dog';

  @override
  String get dogListEmptyTitle => 'No dogs yet';

  @override
  String get dogListEmptyMessage =>
      'Add your dog to start booking workouts and AI analysis.';

  @override
  String get dogShownOnHome => 'Shown on Home';

  @override
  String get dogSwitcherTitle => 'Choose a dog';

  @override
  String get dogSwitcherAdd => 'Add a dog';

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
      '2–12 characters: Korean or English letters, numbers, or underscore (_) · You can change it once every 30 days';

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

  @override
  String get demoPillStart => 'DEMO · Start with demo account';

  @override
  String get demoControlTitle => 'Demo controls';

  @override
  String get demoIntro =>
      'This demo app runs on a mock server. It isn\'t connected to a real server, payments, or treadmills, and it goes back to its starting state when you restart the app.';

  @override
  String get demoSectionTreadmill => 'Treadmill device';

  @override
  String get demoAddDogFirst => 'Add a dog first.';

  @override
  String demoTreadmillDetail(String dog) {
    return '$dog · Simulates the workout data sent by the store\'s treadmill.';
  }

  @override
  String get demoStartWorkout => 'Start workout';

  @override
  String get demoSpeedTitle => 'Simulation speed';

  @override
  String get demoSpeedReal => 'Real time';

  @override
  String get demoSpeed10x => '10x';

  @override
  String get demoSpeed30x => '30x';

  @override
  String get demoSectionAi => 'AI analysis server';

  @override
  String get demoAiDetail =>
      'A gait analysis report arrives a few seconds after a workout ends.';

  @override
  String get demoAiFinished => 'AI analysis is done. Check your notifications.';

  @override
  String get demoFinishPending => 'Finish pending analysis now';

  @override
  String get demoNoPending => 'No pending analysis';

  @override
  String get demoQrPickerTitle => 'Scan QR (demo)';

  @override
  String get demoQrPickerBody =>
      'In the demo, pick a treadmill to scan instead of using the camera. If it\'s free, you\'ll be checked in on it even if it isn\'t your assigned one.';

  @override
  String get demoQrAssigned => 'Assigned';

  @override
  String get demoQrBusy => 'Booked at this time';

  @override
  String get demoSectionOwners => 'Other owners';

  @override
  String get demoOwnersDetail =>
      'Get a cheer from another owner in the rankings.';

  @override
  String get demoReceiveCheer => 'Get a cheer';

  @override
  String get demoSectionData => 'Data';

  @override
  String get demoReset => 'Reset to starting state';

  @override
  String demoAccount(String email, String password) {
    return 'Demo account $email · $password';
  }

  @override
  String demoWorkoutStarted(String dog) {
    return '$dog\'s workout has started. Live data shows on the Workout tab.';
  }

  @override
  String get demoCheerNeedsConsent =>
      'Join the rankings to get cheers. You can change this under Account > Consent settings.';

  @override
  String get demoCheerAllDone =>
      'Every other owner has already cheered this month.';

  @override
  String demoCheerReceived(String nickname, String dog) {
    return '$nickname cheered $dog. Check your notifications.';
  }

  @override
  String get demoResetTitle => 'Reset to the starting state?';

  @override
  String get demoResetMessage =>
      'Bookings, workout history, and settings you made in the demo will be erased and the sample data will start over.';

  @override
  String get demoResetConfirm => 'Reset';

  @override
  String get demoResumed => 'Workout resumed.';

  @override
  String get demoPaused => 'Treadmill paused.';

  @override
  String get demoResume => 'Resume';

  @override
  String get demoPause => 'Pause';

  @override
  String get demoEmergencyDone =>
      'The workout was stopped with the emergency stop. You keep the points you\'ve earned so far.';

  @override
  String get demoEmergencyStop => 'Emergency stop';

  @override
  String get demoFinishedDone =>
      'Workout finished. Check your points, badges, and AI report.';

  @override
  String get demoFinishNow => 'Finish now';

  @override
  String get serverPaymentMethodCard => 'Card';

  @override
  String get serverPaymentMethodCreditCard => 'Credit card';

  @override
  String get serverPaymentMethodDebitCard => 'Debit card';

  @override
  String get serverPaymentMethodEasyPay => 'Easy pay';

  @override
  String get serverPaymentMethodKakaoPay => 'Kakao Pay';

  @override
  String get serverPaymentMethodNaverPay => 'Naver Pay';

  @override
  String get serverPaymentMethodTossPay => 'Toss Pay';

  @override
  String get serverPaymentMethodPayco => 'PAYCO';

  @override
  String get serverPaymentMethodSamsungPay => 'Samsung Pay';

  @override
  String get serverPaymentMethodApplePay => 'Apple Pay';

  @override
  String get serverPaymentMethodTransfer => 'Bank transfer';

  @override
  String get serverPaymentMethodVirtualAccount => 'Virtual account';

  @override
  String get serverPaymentMethodMobile => 'Mobile phone';

  @override
  String get serverPaymentMethodOnsite => 'Pay at store';

  @override
  String get serverPaymentMethodPass => 'Pass';

  @override
  String get keypointNose => 'Nose';

  @override
  String get keypointWithers => 'Withers (top of shoulders)';

  @override
  String get keypointTailBase => 'Base of tail';

  @override
  String get keypointLeftElbow => 'Left front elbow';

  @override
  String get keypointLeftCarpus => 'Left front wrist (carpus)';

  @override
  String get keypointLeftFrontPaw => 'Left front paw';

  @override
  String get keypointRightElbow => 'Right front elbow';

  @override
  String get keypointRightCarpus => 'Right front wrist (carpus)';

  @override
  String get keypointRightFrontPaw => 'Right front paw';

  @override
  String get keypointLeftStifle => 'Left hind knee (stifle)';

  @override
  String get keypointLeftHock => 'Left hind ankle (hock)';

  @override
  String get keypointLeftHindPaw => 'Left hind paw';

  @override
  String get keypointRightStifle => 'Right hind knee (stifle)';

  @override
  String get keypointRightHock => 'Right hind ankle (hock)';

  @override
  String get keypointRightHindPaw => 'Right hind paw';

  @override
  String get analysisReportTitle => 'AI analysis report';

  @override
  String get analysisStatDuration => 'Workout time';

  @override
  String get analysisStatDistance => 'Distance';

  @override
  String get analysisStatAvgSpeed => 'Avg speed';

  @override
  String get analysisPendingFailedTitle => 'We couldn\'t finish the analysis';

  @override
  String get analysisPendingTitle => 'We\'re analyzing your workout video';

  @override
  String get analysisPendingFailedMessage =>
      'The video quality or camera angle got in the way. The gym will check it and run the analysis again.';

  @override
  String get analysisPendingMessage =>
      'We\'re analyzing joint movement and gait patterns. We\'ll notify you when it\'s done.';

  @override
  String get analysisSummaryTitle => 'Analysis summary';

  @override
  String get analysisAnomalySection => 'Unusual movement check';

  @override
  String analysisConfidenceValue(String percent) {
    return 'Confidence $percent%';
  }

  @override
  String get analysisPatternDiffCaption =>
      'Difference from the usual gait pattern';

  @override
  String get analysisScaleSimilar => 'Similar';

  @override
  String get analysisScaleDifferent => 'Very different';

  @override
  String get analysisNoAnomaly => 'No movement different from usual was found.';

  @override
  String analysisVsBaseline(String value) {
    return '$value vs baseline';
  }

  @override
  String analysisStepsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps',
      one: '1 step',
    );
    return '$_temp0';
  }

  @override
  String get analysisStrideTime => 'Stride time';

  @override
  String get analysisUnitSeconds => 's';

  @override
  String get analysisGaitVariability => 'Gait variability';

  @override
  String get analysisFrontSymmetry => 'Front leg symmetry';

  @override
  String get analysisHindSymmetry => 'Hind leg symmetry';

  @override
  String get analysisGaitSection => 'Gait pattern analysis';

  @override
  String get analysisRhythmScore => 'Gait rhythm score';

  @override
  String analysisJointSection(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joints',
      one: '1 joint',
    );
    return 'Joint movement analysis · $_temp0';
  }

  @override
  String get analysisLegendNear => 'Left legs (camera side)';

  @override
  String get analysisLegendFar => 'Right legs';

  @override
  String get analysisColJoint => 'Joint';

  @override
  String get analysisColRom => 'Range';

  @override
  String get analysisColVsBaseline => 'vs baseline';

  @override
  String analysisAngleRange(String min, String max) {
    return 'Angle $min°–$max°';
  }

  @override
  String get analysisPatternDiff => 'Pattern difference';

  @override
  String analysisCompareTitle(String date) {
    return 'Change since your last workout ($date)';
  }

  @override
  String get analysisVideoSkeleton => 'Skeleton video';

  @override
  String get analysisVideoSection => 'Workout videos';

  @override
  String get analysisCareNotes => 'Workout care notes';

  @override
  String get healthNoChange => 'No change';

  @override
  String get healthBaselineLabel => 'Baseline';

  @override
  String get healthSkeletonSemantics =>
      'Side-view diagram of your dog\'s joints';

  @override
  String healthSkeletonSemanticsFlagged(String details) {
    return 'Side-view diagram of your dog\'s joints, $details';
  }

  @override
  String healthJointLevel(String joint, String level) {
    return '$joint: $level';
  }
}
