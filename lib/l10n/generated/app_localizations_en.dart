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
}
