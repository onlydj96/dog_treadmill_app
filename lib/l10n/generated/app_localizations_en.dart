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
}
