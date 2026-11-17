import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ko'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ko, this message translates to:
  /// **'PawFit'**
  String get appTitle;

  /// No description provided for @commonConfirm.
  ///
  /// In ko, this message translates to:
  /// **'확인'**
  String get commonConfirm;

  /// No description provided for @commonCancel.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get commonCancel;

  /// No description provided for @commonRetry.
  ///
  /// In ko, this message translates to:
  /// **'다시 시도'**
  String get commonRetry;

  /// No description provided for @commonSave.
  ///
  /// In ko, this message translates to:
  /// **'저장'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In ko, this message translates to:
  /// **'삭제'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In ko, this message translates to:
  /// **'수정'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In ko, this message translates to:
  /// **'닫기'**
  String get commonClose;

  /// No description provided for @commonDone.
  ///
  /// In ko, this message translates to:
  /// **'완료'**
  String get commonDone;

  /// No description provided for @commonNext.
  ///
  /// In ko, this message translates to:
  /// **'다음'**
  String get commonNext;

  /// No description provided for @commonPrevious.
  ///
  /// In ko, this message translates to:
  /// **'이전'**
  String get commonPrevious;

  /// No description provided for @commonAdd.
  ///
  /// In ko, this message translates to:
  /// **'추가'**
  String get commonAdd;

  /// No description provided for @commonManage.
  ///
  /// In ko, this message translates to:
  /// **'관리'**
  String get commonManage;

  /// No description provided for @commonViewAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 보기'**
  String get commonViewAll;

  /// No description provided for @commonYes.
  ///
  /// In ko, this message translates to:
  /// **'예'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In ko, this message translates to:
  /// **'아니요'**
  String get commonNo;

  /// No description provided for @commonNone.
  ///
  /// In ko, this message translates to:
  /// **'없음'**
  String get commonNone;

  /// No description provided for @commonOptional.
  ///
  /// In ko, this message translates to:
  /// **'선택'**
  String get commonOptional;

  /// No description provided for @commonRequired.
  ///
  /// In ko, this message translates to:
  /// **'필수'**
  String get commonRequired;

  /// 이름이 없는 보호자(사용자)를 부를 때
  ///
  /// In ko, this message translates to:
  /// **'보호자'**
  String get commonOwnerFallbackName;

  /// No description provided for @commonAiDisclaimer.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 결과는 보행 변화에 대한 참고 정보이며, 질병 진단이나 수의사의 진료를 대체하지 않습니다. 이상 징후가 의심되면 동물병원 진료를 받아 주세요.'**
  String get commonAiDisclaimer;

  /// No description provided for @navHome.
  ///
  /// In ko, this message translates to:
  /// **'홈'**
  String get navHome;

  /// No description provided for @navBooking.
  ///
  /// In ko, this message translates to:
  /// **'예약'**
  String get navBooking;

  /// No description provided for @navExercise.
  ///
  /// In ko, this message translates to:
  /// **'운동'**
  String get navExercise;

  /// No description provided for @navHealth.
  ///
  /// In ko, this message translates to:
  /// **'건강'**
  String get navHealth;

  /// No description provided for @navMyPage.
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get navMyPage;

  /// No description provided for @languageMenuTitle.
  ///
  /// In ko, this message translates to:
  /// **'언어 (Language)'**
  String get languageMenuTitle;

  /// No description provided for @languagePickerTitle.
  ///
  /// In ko, this message translates to:
  /// **'언어 / Language'**
  String get languagePickerTitle;

  /// No description provided for @videoDefaultTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상'**
  String get videoDefaultTitle;

  /// No description provided for @configMissingTitle.
  ///
  /// In ko, this message translates to:
  /// **'Supabase 설정이 필요해요'**
  String get configMissingTitle;

  /// No description provided for @configMissingBody.
  ///
  /// In ko, this message translates to:
  /// **'프로젝트 루트의 .env에 SUPABASE_URL과 SUPABASE_PUBLISHABLE_KEY를 넣고 아래와 같이 실행해 주세요.'**
  String get configMissingBody;

  /// intl DateFormat 패턴. 예) 11월 16일 (월)
  ///
  /// In ko, this message translates to:
  /// **'M월 d일 (E)'**
  String get fmtPatternDate;

  /// intl DateFormat 패턴. 예) 2026년 11월 16일 (월)
  ///
  /// In ko, this message translates to:
  /// **'yyyy년 M월 d일 (E)'**
  String get fmtPatternDateFull;

  /// intl DateFormat 패턴. 예) 2026.11.16
  ///
  /// In ko, this message translates to:
  /// **'yyyy.MM.dd'**
  String get fmtPatternDateShort;

  /// intl DateFormat 패턴. 예) 11.16
  ///
  /// In ko, this message translates to:
  /// **'M.d'**
  String get fmtPatternMonthDay;

  /// intl DateFormat 패턴. 예) 2026년 11월
  ///
  /// In ko, this message translates to:
  /// **'yyyy년 M월'**
  String get fmtPatternYearMonth;

  /// intl DateFormat 패턴. 예) 11월
  ///
  /// In ko, this message translates to:
  /// **'M월'**
  String get fmtPatternMonth;

  /// intl DateFormat 패턴. 예) 월
  ///
  /// In ko, this message translates to:
  /// **'E'**
  String get fmtPatternWeekday;

  /// No description provided for @fmtAm.
  ///
  /// In ko, this message translates to:
  /// **'오전'**
  String get fmtAm;

  /// No description provided for @fmtPm.
  ///
  /// In ko, this message translates to:
  /// **'오후'**
  String get fmtPm;

  /// 예) 오후 3:30
  ///
  /// In ko, this message translates to:
  /// **'{period} {time}'**
  String fmtTime(String period, String time);

  /// No description provided for @fmtDateTime.
  ///
  /// In ko, this message translates to:
  /// **'{date} {time}'**
  String fmtDateTime(String date, String time);

  /// No description provided for @fmtTimeRange.
  ///
  /// In ko, this message translates to:
  /// **'{start} ~ {end}'**
  String fmtTimeRange(String start, String end);

  /// No description provided for @fmtWon.
  ///
  /// In ko, this message translates to:
  /// **'{amount}원'**
  String fmtWon(String amount);

  /// 랭킹 점수. count는 복수형 판단용 숫자, formatted는 천 단위 구분이 들어간 숫자
  ///
  /// In ko, this message translates to:
  /// **'{formatted}점'**
  String fmtPoints(num count, String formatted);

  /// No description provided for @fmtDurationHourMinute.
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 {minutes}분'**
  String fmtDurationHourMinute(int hours, int minutes);

  /// No description provided for @fmtDurationHour.
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간'**
  String fmtDurationHour(int hours);

  /// No description provided for @fmtDurationMinuteSecond.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 {seconds}초'**
  String fmtDurationMinuteSecond(int minutes, int seconds);

  /// No description provided for @fmtDurationMinute.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분'**
  String fmtDurationMinute(int minutes);

  /// No description provided for @fmtDurationSecond.
  ///
  /// In ko, this message translates to:
  /// **'{seconds}초'**
  String fmtDurationSecond(int seconds);

  /// No description provided for @fmtJustNow.
  ///
  /// In ko, this message translates to:
  /// **'방금 전'**
  String get fmtJustNow;

  /// No description provided for @fmtMinutesAgo.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분 전'**
  String fmtMinutesAgo(int minutes);

  /// No description provided for @fmtHoursAgo.
  ///
  /// In ko, this message translates to:
  /// **'{hours}시간 전'**
  String fmtHoursAgo(int hours);

  /// No description provided for @fmtDaysAgo.
  ///
  /// In ko, this message translates to:
  /// **'{days}일 전'**
  String fmtDaysAgo(int days);

  /// No description provided for @fmtDogAgeUnderOneMonth.
  ///
  /// In ko, this message translates to:
  /// **'1개월 미만'**
  String get fmtDogAgeUnderOneMonth;

  /// No description provided for @fmtDogAgeMonths.
  ///
  /// In ko, this message translates to:
  /// **'{months}개월'**
  String fmtDogAgeMonths(int months);

  /// No description provided for @fmtDogAgeYears.
  ///
  /// In ko, this message translates to:
  /// **'{years}살'**
  String fmtDogAgeYears(int years);

  /// No description provided for @validationRequired.
  ///
  /// In ko, this message translates to:
  /// **'{label}을(를) 입력해 주세요.'**
  String validationRequired(String label);

  /// No description provided for @validationEmailRequired.
  ///
  /// In ko, this message translates to:
  /// **'이메일을 입력해 주세요.'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In ko, this message translates to:
  /// **'올바른 이메일 형식이 아니에요.'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 입력해 주세요.'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In ko, this message translates to:
  /// **'8자 이상 입력해 주세요.'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordLettersAndDigits.
  ///
  /// In ko, this message translates to:
  /// **'영문과 숫자를 함께 사용해 주세요.'**
  String get validationPasswordLettersAndDigits;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In ko, this message translates to:
  /// **'휴대전화 번호를 입력해 주세요.'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneInvalid.
  ///
  /// In ko, this message translates to:
  /// **'올바른 휴대전화 번호가 아니에요.'**
  String get validationPhoneInvalid;

  /// No description provided for @validationNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해 주세요.'**
  String get validationNameRequired;

  /// No description provided for @validationNameTooLong.
  ///
  /// In ko, this message translates to:
  /// **'20자 이내로 입력해 주세요.'**
  String get validationNameTooLong;

  /// No description provided for @validationNicknameRequired.
  ///
  /// In ko, this message translates to:
  /// **'닉네임을 입력해 주세요.'**
  String get validationNicknameRequired;

  /// No description provided for @validationNicknameLength.
  ///
  /// In ko, this message translates to:
  /// **'2~12자로 입력해 주세요.'**
  String get validationNicknameLength;

  /// No description provided for @validationNicknameCharacters.
  ///
  /// In ko, this message translates to:
  /// **'한글·영문·숫자·밑줄(_)만 쓸 수 있어요.'**
  String get validationNicknameCharacters;

  /// No description provided for @errorAuthRequired.
  ///
  /// In ko, this message translates to:
  /// **'로그인이 필요해요. 다시 로그인해 주세요.'**
  String get errorAuthRequired;

  /// No description provided for @errorDogNotFound.
  ///
  /// In ko, this message translates to:
  /// **'반려견 정보를 찾을 수 없어요.'**
  String get errorDogNotFound;

  /// No description provided for @errorBranchNotFound.
  ///
  /// In ko, this message translates to:
  /// **'지점 정보를 찾을 수 없어요.'**
  String get errorBranchNotFound;

  /// No description provided for @errorProgramNotFound.
  ///
  /// In ko, this message translates to:
  /// **'운동 프로그램 정보를 찾을 수 없어요.'**
  String get errorProgramNotFound;

  /// No description provided for @errorSlotInPast.
  ///
  /// In ko, this message translates to:
  /// **'이미 지난 시간이에요. 다른 시간을 선택해 주세요.'**
  String get errorSlotInPast;

  /// No description provided for @errorSlotNotAvailable.
  ///
  /// In ko, this message translates to:
  /// **'예약할 수 없는 시간이에요. 다른 시간을 선택해 주세요.'**
  String get errorSlotNotAvailable;

  /// No description provided for @errorSlotFull.
  ///
  /// In ko, this message translates to:
  /// **'선택한 시간의 트레드밀이 모두 예약되었어요. 다른 시간을 선택해 주세요.'**
  String get errorSlotFull;

  /// No description provided for @errorDogAlreadyBooked.
  ///
  /// In ko, this message translates to:
  /// **'같은 시간에 이미 이 반려견의 예약이 있어요.'**
  String get errorDogAlreadyBooked;

  /// No description provided for @errorMembershipNotFound.
  ///
  /// In ko, this message translates to:
  /// **'이용권을 찾을 수 없어요.'**
  String get errorMembershipNotFound;

  /// No description provided for @errorMembershipNotUsable.
  ///
  /// In ko, this message translates to:
  /// **'선택한 이용권은 이 시간에 사용할 수 없어요. 잔여 횟수와 유효기간을 확인해 주세요.'**
  String get errorMembershipNotUsable;

  /// No description provided for @errorBookingNotFound.
  ///
  /// In ko, this message translates to:
  /// **'예약 정보를 찾을 수 없어요.'**
  String get errorBookingNotFound;

  /// No description provided for @errorBookingNotCancellable.
  ///
  /// In ko, this message translates to:
  /// **'이미 진행되었거나 취소된 예약이에요.'**
  String get errorBookingNotCancellable;

  /// No description provided for @errorChangeDeadlinePassed.
  ///
  /// In ko, this message translates to:
  /// **'예약 시작 1시간 전부터는 앱에서 변경·취소할 수 없어요. 1:1 문의로 알려 주세요.'**
  String get errorChangeDeadlinePassed;

  /// No description provided for @errorInvalidBookingStatus.
  ///
  /// In ko, this message translates to:
  /// **'이미 체크인했거나 끝난 예약이에요.'**
  String get errorInvalidBookingStatus;

  /// No description provided for @errorCheckInTooEarly.
  ///
  /// In ko, this message translates to:
  /// **'체크인은 예약 시작 15분 전부터 할 수 있어요.'**
  String get errorCheckInTooEarly;

  /// No description provided for @errorCheckInClosed.
  ///
  /// In ko, this message translates to:
  /// **'예약 시간이 지나 체크인할 수 없어요.'**
  String get errorCheckInClosed;

  /// No description provided for @errorNicknameInvalid.
  ///
  /// In ko, this message translates to:
  /// **'닉네임은 2~12자의 한글·영문·숫자·밑줄(_)로 입력해 주세요.'**
  String get errorNicknameInvalid;

  /// No description provided for @errorNicknameForbidden.
  ///
  /// In ko, this message translates to:
  /// **'사용할 수 없는 단어가 들어 있어요. 다른 닉네임을 입력해 주세요.'**
  String get errorNicknameForbidden;

  /// No description provided for @errorNicknameTaken.
  ///
  /// In ko, this message translates to:
  /// **'이미 사용 중인 닉네임이에요.'**
  String get errorNicknameTaken;

  /// No description provided for @errorNicknameCooldown.
  ///
  /// In ko, this message translates to:
  /// **'닉네임은 30일에 한 번 바꿀 수 있어요.'**
  String get errorNicknameCooldown;

  /// No description provided for @errorCannotCheerOwnDog.
  ///
  /// In ko, this message translates to:
  /// **'내 반려견은 응원할 수 없어요.'**
  String get errorCannotCheerOwnDog;

  /// No description provided for @errorInvalidRankingScope.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 정보를 불러오지 못했어요. 다시 시도해 주세요.'**
  String get errorInvalidRankingScope;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In ko, this message translates to:
  /// **'이메일 또는 비밀번호가 올바르지 않아요.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In ko, this message translates to:
  /// **'이메일 인증을 완료한 뒤 로그인해 주세요.'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorUserAlreadyExists.
  ///
  /// In ko, this message translates to:
  /// **'이미 가입된 이메일이에요.'**
  String get errorUserAlreadyExists;

  /// No description provided for @errorWeakPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 너무 단순해요. 영문과 숫자를 섞어 8자 이상 입력해 주세요.'**
  String get errorWeakPassword;

  /// No description provided for @errorSamePassword.
  ///
  /// In ko, this message translates to:
  /// **'기존 비밀번호와 다른 비밀번호를 입력해 주세요.'**
  String get errorSamePassword;

  /// No description provided for @errorRateLimited.
  ///
  /// In ko, this message translates to:
  /// **'요청이 많아요. 잠시 후 다시 시도해 주세요.'**
  String get errorRateLimited;

  /// No description provided for @errorSignupDisabled.
  ///
  /// In ko, this message translates to:
  /// **'현재 회원가입을 받을 수 없어요.'**
  String get errorSignupDisabled;

  /// No description provided for @errorPermissionDenied.
  ///
  /// In ko, this message translates to:
  /// **'이 작업을 수행할 권한이 없어요.'**
  String get errorPermissionDenied;

  /// No description provided for @errorNotFound.
  ///
  /// In ko, this message translates to:
  /// **'요청한 정보를 찾을 수 없어요.'**
  String get errorNotFound;

  /// No description provided for @errorAuthGeneric.
  ///
  /// In ko, this message translates to:
  /// **'인증 처리 중 문제가 발생했어요. 다시 시도해 주세요.'**
  String get errorAuthGeneric;

  /// No description provided for @errorStorage.
  ///
  /// In ko, this message translates to:
  /// **'파일을 처리하지 못했어요. 사진 크기(5MB 이하)와 형식을 확인해 주세요.'**
  String get errorStorage;

  /// No description provided for @errorFunction.
  ///
  /// In ko, this message translates to:
  /// **'요청을 처리하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get errorFunction;

  /// No description provided for @errorNetwork.
  ///
  /// In ko, this message translates to:
  /// **'네트워크 연결을 확인한 뒤 다시 시도해 주세요.'**
  String get errorNetwork;

  /// No description provided for @errorGeneric.
  ///
  /// In ko, this message translates to:
  /// **'문제가 발생했어요. 잠시 후 다시 시도해 주세요.'**
  String get errorGeneric;

  /// DB가 사유 없이 중단된 운동에 저장하는 기본 사유 (exercise_sessions.stop_reason)
  ///
  /// In ko, this message translates to:
  /// **'운영자 판단에 의한 중단'**
  String get serverStopReasonByStaff;

  /// No description provided for @authTagline.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀 예약부터 AI 보행 분석까지,\n우리 아이의 건강한 걸음을 함께 기록해요.'**
  String get authTagline;

  /// No description provided for @authEmail.
  ///
  /// In ko, this message translates to:
  /// **'이메일'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호'**
  String get authPassword;

  /// No description provided for @authShowPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 보기'**
  String get authShowPassword;

  /// No description provided for @authHidePassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 숨기기'**
  String get authHidePassword;

  /// No description provided for @authLogIn.
  ///
  /// In ko, this message translates to:
  /// **'로그인'**
  String get authLogIn;

  /// No description provided for @authNoAccount.
  ///
  /// In ko, this message translates to:
  /// **'아직 회원이 아니신가요?'**
  String get authNoAccount;

  /// No description provided for @authSignUp.
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get authSignUp;

  /// No description provided for @signupTitle.
  ///
  /// In ko, this message translates to:
  /// **'회원가입'**
  String get signupTitle;

  /// No description provided for @signupOwnerSection.
  ///
  /// In ko, this message translates to:
  /// **'보호자 정보'**
  String get signupOwnerSection;

  /// No description provided for @signupName.
  ///
  /// In ko, this message translates to:
  /// **'이름'**
  String get signupName;

  /// No description provided for @signupPhone.
  ///
  /// In ko, this message translates to:
  /// **'휴대전화 번호'**
  String get signupPhone;

  /// No description provided for @signupLoginSection.
  ///
  /// In ko, this message translates to:
  /// **'로그인 정보'**
  String get signupLoginSection;

  /// No description provided for @signupPasswordHelper.
  ///
  /// In ko, this message translates to:
  /// **'영문과 숫자를 포함해 8자 이상'**
  String get signupPasswordHelper;

  /// No description provided for @signupConfirmPassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 확인'**
  String get signupConfirmPassword;

  /// No description provided for @signupPasswordMismatch.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호가 일치하지 않아요.'**
  String get signupPasswordMismatch;

  /// No description provided for @signupRequiredConsent.
  ///
  /// In ko, this message translates to:
  /// **'필수 약관에 동의해 주세요.'**
  String get signupRequiredConsent;

  /// No description provided for @signupVerifyTitle.
  ///
  /// In ko, this message translates to:
  /// **'인증 메일을 보냈어요'**
  String get signupVerifyTitle;

  /// No description provided for @signupVerifyBody.
  ///
  /// In ko, this message translates to:
  /// **'{email}으로 보낸 메일의 링크를 눌러 가입을 완료한 뒤 로그인해 주세요.'**
  String signupVerifyBody(String email);

  /// No description provided for @signupSubmit.
  ///
  /// In ko, this message translates to:
  /// **'가입하기'**
  String get signupSubmit;

  /// No description provided for @signupAgreeAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 동의'**
  String get signupAgreeAll;

  /// No description provided for @signupAgreeAllDesc.
  ///
  /// In ko, this message translates to:
  /// **'선택 항목을 포함한 모든 항목에 동의합니다.'**
  String get signupAgreeAllDesc;

  /// No description provided for @signupRequiredTag.
  ///
  /// In ko, this message translates to:
  /// **'[필수] '**
  String get signupRequiredTag;

  /// No description provided for @signupOptionalTag.
  ///
  /// In ko, this message translates to:
  /// **'[선택] '**
  String get signupOptionalTag;

  /// No description provided for @consentTermsTitle.
  ///
  /// In ko, this message translates to:
  /// **'서비스 이용약관'**
  String get consentTermsTitle;

  /// No description provided for @consentTermsDesc.
  ///
  /// In ko, this message translates to:
  /// **'PawFit 서비스 이용에 관한 약관입니다.'**
  String get consentTermsDesc;

  /// No description provided for @consentPrivacyTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 수집·이용'**
  String get consentPrivacyTitle;

  /// No description provided for @consentPrivacyDesc.
  ///
  /// In ko, this message translates to:
  /// **'회원 식별, 예약·결제 처리, 고객 상담을 위해 이름·연락처·이메일과 반려견 정보를 수집합니다.'**
  String get consentPrivacyDesc;

  /// No description provided for @consentVideoTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상 촬영 및 AI 분석'**
  String get consentVideoTitle;

  /// No description provided for @consentVideoDesc.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀 운동 중 반려견의 정면·측면 영상을 촬영해 관절·보행 분석 리포트를 만듭니다. 동의하지 않으면 AI 분석 리포트가 제공되지 않습니다.'**
  String get consentVideoDesc;

  /// No description provided for @consentAiTrainingTitle.
  ///
  /// In ko, this message translates to:
  /// **'AI 학습 데이터 활용'**
  String get consentAiTrainingTitle;

  /// No description provided for @consentAiTrainingDesc.
  ///
  /// In ko, this message translates to:
  /// **'촬영 영상과 관절 좌표를 비식별화해 AI 모델 개선에 활용합니다. 동의하지 않아도 서비스 이용에는 제한이 없습니다.'**
  String get consentAiTrainingDesc;

  /// No description provided for @consentRankingTitle.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 참여 (닉네임·반려견 공개)'**
  String get consentRankingTitle;

  /// No description provided for @consentRankingDesc.
  ///
  /// In ko, this message translates to:
  /// **'월간 랭킹과 명예의 전당에 닉네임, 반려견 이름·견종·사진, 운동 점수를 다른 회원에게 보여줍니다. 실명·이메일·연락처는 공개되지 않으며, 철회하면 바로 랭킹에서 빠집니다.'**
  String get consentRankingDesc;

  /// No description provided for @consentMarketingTitle.
  ///
  /// In ko, this message translates to:
  /// **'마케팅 정보 수신'**
  String get consentMarketingTitle;

  /// No description provided for @consentMarketingDesc.
  ///
  /// In ko, this message translates to:
  /// **'이벤트와 혜택 소식을 알림으로 받습니다.'**
  String get consentMarketingDesc;

  /// No description provided for @consentScreenTitle.
  ///
  /// In ko, this message translates to:
  /// **'개인정보 및 영상 이용 동의'**
  String get consentScreenTitle;

  /// No description provided for @consentIntro.
  ///
  /// In ko, this message translates to:
  /// **'동의 항목은 언제든 변경할 수 있으며, 변경 이력은 안전하게 보관됩니다.'**
  String get consentIntro;

  /// No description provided for @consentRequiredNote.
  ///
  /// In ko, this message translates to:
  /// **'필수 항목은 서비스 제공에 꼭 필요해 철회할 수 없어요. 철회를 원하면 회원 탈퇴를 진행해 주세요.'**
  String get consentRequiredNote;

  /// No description provided for @consentWithdrawVideoTitle.
  ///
  /// In ko, this message translates to:
  /// **'영상 촬영 동의를 철회할까요?'**
  String get consentWithdrawVideoTitle;

  /// No description provided for @consentWithdrawVideoMessage.
  ///
  /// In ko, this message translates to:
  /// **'철회하면 다음 운동부터 AI 보행 분석 리포트가 제공되지 않아요. 이미 받은 리포트는 그대로 볼 수 있어요.'**
  String get consentWithdrawVideoMessage;

  /// No description provided for @consentWithdrawVideoConfirm.
  ///
  /// In ko, this message translates to:
  /// **'철회'**
  String get consentWithdrawVideoConfirm;

  /// No description provided for @consentLeaveRankingTitle.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에서 나갈까요?'**
  String get consentLeaveRankingTitle;

  /// No description provided for @consentLeaveRankingMessage.
  ///
  /// In ko, this message translates to:
  /// **'순위표와 명예의 전당에서 닉네임과 반려견 정보가 바로 가려져요. 점수와 배지는 그대로 쌓여요.'**
  String get consentLeaveRankingMessage;

  /// No description provided for @consentLeaveRankingConfirm.
  ///
  /// In ko, this message translates to:
  /// **'나가기'**
  String get consentLeaveRankingConfirm;

  /// No description provided for @consentGranted.
  ///
  /// In ko, this message translates to:
  /// **'동의'**
  String get consentGranted;

  /// No description provided for @consentNotGranted.
  ///
  /// In ko, this message translates to:
  /// **'미동의'**
  String get consentNotGranted;

  /// No description provided for @consentStatusLine.
  ///
  /// In ko, this message translates to:
  /// **'{state} · {date} · v{version}'**
  String consentStatusLine(String state, String date, String version);

  /// No description provided for @myPageTitle.
  ///
  /// In ko, this message translates to:
  /// **'마이페이지'**
  String get myPageTitle;

  /// No description provided for @myPageGreeting.
  ///
  /// In ko, this message translates to:
  /// **'{name}님'**
  String myPageGreeting(String name);

  /// No description provided for @myPageMyDogs.
  ///
  /// In ko, this message translates to:
  /// **'내 반려견'**
  String get myPageMyDogs;

  /// No description provided for @myPageUsageGroup.
  ///
  /// In ko, this message translates to:
  /// **'이용 내역'**
  String get myPageUsageGroup;

  /// No description provided for @myPageMembership.
  ///
  /// In ko, this message translates to:
  /// **'이용권 및 멤버십'**
  String get myPageMembership;

  /// No description provided for @myPagePayments.
  ///
  /// In ko, this message translates to:
  /// **'결제·환불 내역'**
  String get myPagePayments;

  /// No description provided for @myPageBookings.
  ///
  /// In ko, this message translates to:
  /// **'예약 내역'**
  String get myPageBookings;

  /// No description provided for @myPageWorkoutHistory.
  ///
  /// In ko, this message translates to:
  /// **'운동 누적 기록'**
  String get myPageWorkoutHistory;

  /// No description provided for @myPageRankingGroup.
  ///
  /// In ko, this message translates to:
  /// **'랭킹'**
  String get myPageRankingGroup;

  /// No description provided for @myPageRankingHall.
  ///
  /// In ko, this message translates to:
  /// **'월간 랭킹·명예의 전당'**
  String get myPageRankingHall;

  /// No description provided for @myPageRankingSettings.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 참여·닉네임 설정'**
  String get myPageRankingSettings;

  /// No description provided for @myPageSettingsGroup.
  ///
  /// In ko, this message translates to:
  /// **'설정'**
  String get myPageSettingsGroup;

  /// No description provided for @myPageProfile.
  ///
  /// In ko, this message translates to:
  /// **'프로필 및 로그인 계정'**
  String get myPageProfile;

  /// No description provided for @myPageSupportGroup.
  ///
  /// In ko, this message translates to:
  /// **'고객지원'**
  String get myPageSupportGroup;

  /// No description provided for @myPageLogOut.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃'**
  String get myPageLogOut;

  /// No description provided for @myPageLogOutMessage.
  ///
  /// In ko, this message translates to:
  /// **'로그아웃할까요?'**
  String get myPageLogOutMessage;

  /// No description provided for @myPageDeleteAccount.
  ///
  /// In ko, this message translates to:
  /// **'회원 탈퇴'**
  String get myPageDeleteAccount;

  /// No description provided for @myPageDeleteMessage.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴하면 반려견 정보, 예약, 운동·분석 기록과 남은 이용권이 모두 삭제되며 복구할 수 없어요. 결제 기록은 관련 법령에 따라 일정 기간 보관됩니다.\n\n정말 탈퇴할까요?'**
  String get myPageDeleteMessage;

  /// No description provided for @myPageDeleteConfirm.
  ///
  /// In ko, this message translates to:
  /// **'탈퇴하기'**
  String get myPageDeleteConfirm;

  /// No description provided for @profileEditTitle.
  ///
  /// In ko, this message translates to:
  /// **'프로필 및 로그인 계정'**
  String get profileEditTitle;

  /// No description provided for @profileEditProfileSection.
  ///
  /// In ko, this message translates to:
  /// **'프로필'**
  String get profileEditProfileSection;

  /// No description provided for @profileEditSave.
  ///
  /// In ko, this message translates to:
  /// **'프로필 저장'**
  String get profileEditSave;

  /// No description provided for @profileEditSaved.
  ///
  /// In ko, this message translates to:
  /// **'프로필을 저장했어요.'**
  String get profileEditSaved;

  /// No description provided for @profileEditLoginSection.
  ///
  /// In ko, this message translates to:
  /// **'로그인 계정'**
  String get profileEditLoginSection;

  /// No description provided for @profileEditNewPassword.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호'**
  String get profileEditNewPassword;

  /// No description provided for @profileEditConfirmNewPassword.
  ///
  /// In ko, this message translates to:
  /// **'새 비밀번호 확인'**
  String get profileEditConfirmNewPassword;

  /// No description provided for @profileEditChangePassword.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호 변경'**
  String get profileEditChangePassword;

  /// No description provided for @profileEditPasswordChanged.
  ///
  /// In ko, this message translates to:
  /// **'비밀번호를 변경했어요.'**
  String get profileEditPasswordChanged;

  /// No description provided for @notificationSettingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림 설정'**
  String get notificationSettingsTitle;

  /// No description provided for @notificationSettingsBooking.
  ///
  /// In ko, this message translates to:
  /// **'예약 알림'**
  String get notificationSettingsBooking;

  /// No description provided for @notificationSettingsBookingDesc.
  ///
  /// In ko, this message translates to:
  /// **'예약 확정·취소, 미방문 처리'**
  String get notificationSettingsBookingDesc;

  /// No description provided for @notificationSettingsExercise.
  ///
  /// In ko, this message translates to:
  /// **'운동 알림'**
  String get notificationSettingsExercise;

  /// No description provided for @notificationSettingsExerciseDesc.
  ///
  /// In ko, this message translates to:
  /// **'운동 시작·완료·중단'**
  String get notificationSettingsExerciseDesc;

  /// No description provided for @notificationSettingsAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 알림'**
  String get notificationSettingsAnalysis;

  /// No description provided for @notificationSettingsAnalysisDesc.
  ///
  /// In ko, this message translates to:
  /// **'보행 분석 리포트 도착'**
  String get notificationSettingsAnalysisDesc;

  /// No description provided for @notificationSettingsRanking.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 알림'**
  String get notificationSettingsRanking;

  /// No description provided for @notificationSettingsRankingDesc.
  ///
  /// In ko, this message translates to:
  /// **'배지 획득, 응원, 월간 순위 확정'**
  String get notificationSettingsRankingDesc;

  /// No description provided for @notificationSettingsMarketing.
  ///
  /// In ko, this message translates to:
  /// **'이벤트·혜택 알림'**
  String get notificationSettingsMarketing;

  /// No description provided for @notificationSettingsMarketingDesc.
  ///
  /// In ko, this message translates to:
  /// **'마케팅 정보 수신 동의에서 설정할 수 있어요.'**
  String get notificationSettingsMarketingDesc;

  /// No description provided for @notificationTitle.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get notificationTitle;

  /// No description provided for @notificationMarkAllRead.
  ///
  /// In ko, this message translates to:
  /// **'모두 읽음'**
  String get notificationMarkAllRead;

  /// No description provided for @notificationEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'새 알림이 없어요'**
  String get notificationEmptyTitle;

  /// No description provided for @notificationEmptyMessage.
  ///
  /// In ko, this message translates to:
  /// **'예약 확정, 운동 시작·완료, AI 분석 결과, 배지·랭킹 소식을 알려 드려요.'**
  String get notificationEmptyMessage;

  /// No description provided for @notificationUnreadLabel.
  ///
  /// In ko, this message translates to:
  /// **'읽지 않은 알림'**
  String get notificationUnreadLabel;

  /// No description provided for @notificationBookingConfirmedTitle.
  ///
  /// In ko, this message translates to:
  /// **'예약이 확정되었어요'**
  String get notificationBookingConfirmedTitle;

  /// No description provided for @notificationBookingConfirmedBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog} · {when} 예약이 확정되었습니다.'**
  String notificationBookingConfirmedBody(String dog, String when);

  /// No description provided for @notificationBookingCancelledTitle.
  ///
  /// In ko, this message translates to:
  /// **'예약이 취소되었어요'**
  String get notificationBookingCancelledTitle;

  /// No description provided for @notificationBookingCancelledBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog} · {when} 예약이 헬스장 사정으로 취소되었습니다.'**
  String notificationBookingCancelledBody(String dog, String when);

  /// No description provided for @notificationBookingNoShowTitle.
  ///
  /// In ko, this message translates to:
  /// **'미방문 처리되었어요'**
  String get notificationBookingNoShowTitle;

  /// No description provided for @notificationBookingNoShowBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog} · {when} 예약이 미방문으로 처리되었습니다.'**
  String notificationBookingNoShowBody(String dog, String when);

  /// No description provided for @notificationExerciseStartedTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동을 시작했어요'**
  String get notificationExerciseStartedTitle;

  /// No description provided for @notificationExerciseStartedBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 트레드밀 운동이 시작되었습니다. 실시간 현황을 확인해 보세요.'**
  String notificationExerciseStartedBody(String dog);

  /// No description provided for @notificationExerciseCompletedTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동을 완료했어요'**
  String get notificationExerciseCompletedTitle;

  /// No description provided for @notificationExerciseCompletedBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 운동이 끝났어요. 운동 기록을 확인해 보세요.'**
  String notificationExerciseCompletedBody(String dog);

  /// No description provided for @notificationExerciseCompletedPointsBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 운동이 끝났어요. {points}을 받았어요! 운동 기록을 확인해 보세요.'**
  String notificationExerciseCompletedPointsBody(String dog, String points);

  /// No description provided for @notificationExerciseStoppedTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동이 중단되었어요'**
  String get notificationExerciseStoppedTitle;

  /// No description provided for @notificationExerciseStoppedBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 운동이 중단되었습니다. 사유: {reason}'**
  String notificationExerciseStoppedBody(String dog, String reason);

  /// No description provided for @notificationAnalysisCompletedTitle.
  ///
  /// In ko, this message translates to:
  /// **'AI 보행 분석 리포트가 도착했어요'**
  String get notificationAnalysisCompletedTitle;

  /// No description provided for @notificationAnalysisCompletedBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 운동 분석 결과를 확인해 보세요.'**
  String notificationAnalysisCompletedBody(String dog);

  /// No description provided for @notificationAnalysisFailedTitle.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석을 완료하지 못했어요'**
  String get notificationAnalysisFailedTitle;

  /// No description provided for @notificationAnalysisFailedBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 영상 분석 중 문제가 발생했습니다. 헬스장에서 확인 후 다시 분석합니다.'**
  String notificationAnalysisFailedBody(String dog);

  /// No description provided for @notificationBadgeEarnedTitle.
  ///
  /// In ko, this message translates to:
  /// **'새 배지를 받았어요'**
  String get notificationBadgeEarnedTitle;

  /// No description provided for @notificationBadgeEarnedBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 「{badge}」 배지가 도착했어요. 배지함에서 확인해 보세요.'**
  String notificationBadgeEarnedBody(String dog, String badge);

  /// No description provided for @notificationCheerReceivedTitle.
  ///
  /// In ko, this message translates to:
  /// **'응원이 도착했어요'**
  String get notificationCheerReceivedTitle;

  /// No description provided for @notificationCheerReceivedBody.
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님이 {dog} 응원했어요.'**
  String notificationCheerReceivedBody(String nickname, String dog);

  /// No description provided for @notificationCheerReceivedAnonymousBody.
  ///
  /// In ko, this message translates to:
  /// **'다른 보호자가 {dog} 응원했어요.'**
  String notificationCheerReceivedAnonymousBody(String dog);

  /// No description provided for @notificationMonthlyAwardTitle.
  ///
  /// In ko, this message translates to:
  /// **'{month} 랭킹 시상대에 올랐어요'**
  String notificationMonthlyAwardTitle(String month);

  /// No description provided for @notificationMonthlyAwardBody.
  ///
  /// In ko, this message translates to:
  /// **'{dog} {month} 랭킹 {summary}에 올랐어요. 명예의 전당에서 확인해 보세요.'**
  String notificationMonthlyAwardBody(String dog, String month, String summary);

  /// No description provided for @notificationMonthlyAwardItem.
  ///
  /// In ko, this message translates to:
  /// **'{label} {rank}위'**
  String notificationMonthlyAwardItem(String label, int rank);

  /// No description provided for @noticeTitle.
  ///
  /// In ko, this message translates to:
  /// **'공지사항'**
  String get noticeTitle;

  /// No description provided for @noticeEmpty.
  ///
  /// In ko, this message translates to:
  /// **'등록된 공지사항이 없어요'**
  String get noticeEmpty;

  /// No description provided for @faqTitle.
  ///
  /// In ko, this message translates to:
  /// **'자주 묻는 질문'**
  String get faqTitle;

  /// No description provided for @faqAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get faqAll;

  /// No description provided for @faqAskInquiry.
  ///
  /// In ko, this message translates to:
  /// **'원하는 답이 없나요? 1:1 문의하기'**
  String get faqAskInquiry;

  /// No description provided for @inquiryTitle.
  ///
  /// In ko, this message translates to:
  /// **'1:1 문의'**
  String get inquiryTitle;

  /// No description provided for @inquiryNew.
  ///
  /// In ko, this message translates to:
  /// **'문의하기'**
  String get inquiryNew;

  /// No description provided for @inquiryEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'문의 내역이 없어요'**
  String get inquiryEmptyTitle;

  /// No description provided for @inquiryEmptyMessage.
  ///
  /// In ko, this message translates to:
  /// **'궁금한 점을 남겨 주시면 확인 후 답변드릴게요.'**
  String get inquiryEmptyMessage;

  /// No description provided for @inquiryAnswerLabel.
  ///
  /// In ko, this message translates to:
  /// **'답변'**
  String get inquiryAnswerLabel;

  /// No description provided for @inquiryTypeLabel.
  ///
  /// In ko, this message translates to:
  /// **'문의 유형'**
  String get inquiryTypeLabel;

  /// No description provided for @inquiryCategoryBooking.
  ///
  /// In ko, this message translates to:
  /// **'예약'**
  String get inquiryCategoryBooking;

  /// No description provided for @inquiryCategoryPayment.
  ///
  /// In ko, this message translates to:
  /// **'결제·이용권'**
  String get inquiryCategoryPayment;

  /// No description provided for @inquiryCategoryExercise.
  ///
  /// In ko, this message translates to:
  /// **'운동'**
  String get inquiryCategoryExercise;

  /// No description provided for @inquiryCategoryAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석'**
  String get inquiryCategoryAnalysis;

  /// No description provided for @inquiryCategoryAccount.
  ///
  /// In ko, this message translates to:
  /// **'계정'**
  String get inquiryCategoryAccount;

  /// No description provided for @inquiryCategoryEtc.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get inquiryCategoryEtc;

  /// No description provided for @inquiryTitleLabel.
  ///
  /// In ko, this message translates to:
  /// **'제목'**
  String get inquiryTitleLabel;

  /// No description provided for @inquiryTitleRequired.
  ///
  /// In ko, this message translates to:
  /// **'제목을 입력해 주세요.'**
  String get inquiryTitleRequired;

  /// No description provided for @inquiryBodyLabel.
  ///
  /// In ko, this message translates to:
  /// **'내용'**
  String get inquiryBodyLabel;

  /// No description provided for @inquiryBodyRequired.
  ///
  /// In ko, this message translates to:
  /// **'내용을 입력해 주세요.'**
  String get inquiryBodyRequired;

  /// No description provided for @inquirySubmit.
  ///
  /// In ko, this message translates to:
  /// **'문의 접수'**
  String get inquirySubmit;

  /// No description provided for @inquiryCreated.
  ///
  /// In ko, this message translates to:
  /// **'문의를 접수했어요. 답변이 등록되면 문의 내역에서 확인할 수 있어요.'**
  String get inquiryCreated;

  /// No description provided for @inquiryStatusAnswered.
  ///
  /// In ko, this message translates to:
  /// **'답변 완료'**
  String get inquiryStatusAnswered;

  /// No description provided for @inquiryStatusClosed.
  ///
  /// In ko, this message translates to:
  /// **'종료'**
  String get inquiryStatusClosed;

  /// No description provided for @inquiryStatusPending.
  ///
  /// In ko, this message translates to:
  /// **'답변 대기'**
  String get inquiryStatusPending;

  /// No description provided for @bookingHours24.
  ///
  /// In ko, this message translates to:
  /// **'24시간'**
  String get bookingHours24;

  /// No description provided for @bookingIntensityLow.
  ///
  /// In ko, this message translates to:
  /// **'저강도'**
  String get bookingIntensityLow;

  /// No description provided for @bookingIntensityMedium.
  ///
  /// In ko, this message translates to:
  /// **'중강도'**
  String get bookingIntensityMedium;

  /// No description provided for @bookingIntensityHigh.
  ///
  /// In ko, this message translates to:
  /// **'고강도'**
  String get bookingIntensityHigh;

  /// No description provided for @bookingStatusPending.
  ///
  /// In ko, this message translates to:
  /// **'예약 대기'**
  String get bookingStatusPending;

  /// No description provided for @bookingStatusConfirmed.
  ///
  /// In ko, this message translates to:
  /// **'예약 확정'**
  String get bookingStatusConfirmed;

  /// No description provided for @bookingStatusCheckedIn.
  ///
  /// In ko, this message translates to:
  /// **'체크인 완료'**
  String get bookingStatusCheckedIn;

  /// No description provided for @bookingStatusCompleted.
  ///
  /// In ko, this message translates to:
  /// **'이용 완료'**
  String get bookingStatusCompleted;

  /// No description provided for @bookingStatusCancelled.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get bookingStatusCancelled;

  /// No description provided for @bookingStatusNoShow.
  ///
  /// In ko, this message translates to:
  /// **'미방문'**
  String get bookingStatusNoShow;

  /// No description provided for @membershipStatusRefunded.
  ///
  /// In ko, this message translates to:
  /// **'환불'**
  String get membershipStatusRefunded;

  /// No description provided for @membershipStatusCancelled.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get membershipStatusCancelled;

  /// No description provided for @membershipStatusExpired.
  ///
  /// In ko, this message translates to:
  /// **'만료'**
  String get membershipStatusExpired;

  /// No description provided for @membershipStatusUsedUp.
  ///
  /// In ko, this message translates to:
  /// **'소진'**
  String get membershipStatusUsedUp;

  /// No description provided for @membershipStatusAvailable.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능'**
  String get membershipStatusAvailable;

  /// No description provided for @paymentStatusPending.
  ///
  /// In ko, this message translates to:
  /// **'결제 대기'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusPaid.
  ///
  /// In ko, this message translates to:
  /// **'결제 완료'**
  String get paymentStatusPaid;

  /// No description provided for @paymentStatusCancelled.
  ///
  /// In ko, this message translates to:
  /// **'결제 취소'**
  String get paymentStatusCancelled;

  /// No description provided for @paymentStatusRefunded.
  ///
  /// In ko, this message translates to:
  /// **'환불 완료'**
  String get paymentStatusRefunded;

  /// No description provided for @paymentStatusPartialRefunded.
  ///
  /// In ko, this message translates to:
  /// **'부분 환불'**
  String get paymentStatusPartialRefunded;

  /// No description provided for @paymentStatusFailed.
  ///
  /// In ko, this message translates to:
  /// **'결제 실패'**
  String get paymentStatusFailed;

  /// No description provided for @homeNotificationsTooltip.
  ///
  /// In ko, this message translates to:
  /// **'알림'**
  String get homeNotificationsTooltip;

  /// No description provided for @homeGreeting.
  ///
  /// In ko, this message translates to:
  /// **'{name}님, 안녕하세요'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingNoDog.
  ///
  /// In ko, this message translates to:
  /// **'반려견을 등록하고 시작해 볼까요?'**
  String get homeGreetingNoDog;

  /// No description provided for @homeGreetingWithDog.
  ///
  /// In ko, this message translates to:
  /// **'오늘도 {dog} 건강하게 걸어요'**
  String homeGreetingWithDog(String dog);

  /// No description provided for @homeDogTapHint.
  ///
  /// In ko, this message translates to:
  /// **'{dog} 정보 보기'**
  String homeDogTapHint(String dog);

  /// No description provided for @homeProfileIncomplete.
  ///
  /// In ko, this message translates to:
  /// **'프로필을 완성해 주세요'**
  String get homeProfileIncomplete;

  /// No description provided for @homeRankOverallThisMonth.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 전체 {rank}위'**
  String homeRankOverallThisMonth(int rank);

  /// No description provided for @homeSwitchDog.
  ///
  /// In ko, this message translates to:
  /// **'전환'**
  String get homeSwitchDog;

  /// No description provided for @homeStatMonthWorkouts.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 운동'**
  String get homeStatMonthWorkouts;

  /// No description provided for @homeUnitTimes.
  ///
  /// In ko, this message translates to:
  /// **'회'**
  String get homeUnitTimes;

  /// No description provided for @homeStatMonthDistance.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 거리'**
  String get homeStatMonthDistance;

  /// No description provided for @homeStatLatestSymmetry.
  ///
  /// In ko, this message translates to:
  /// **'최근 좌우 대칭'**
  String get homeStatLatestSymmetry;

  /// No description provided for @homeNoDogTitle.
  ///
  /// In ko, this message translates to:
  /// **'반려견을 등록해 주세요'**
  String get homeNoDogTitle;

  /// No description provided for @homeNoDogBody.
  ///
  /// In ko, this message translates to:
  /// **'건강 정보와 운동 제한 사항을 함께 등록하면\n예약할 때 주의할 점을 알려 드려요.'**
  String get homeNoDogBody;

  /// No description provided for @homeNoDogAction.
  ///
  /// In ko, this message translates to:
  /// **'반려견 등록하기'**
  String get homeNoDogAction;

  /// No description provided for @homeLiveTapHint.
  ///
  /// In ko, this message translates to:
  /// **'실시간 운동 현황 보기'**
  String get homeLiveTapHint;

  /// No description provided for @homeQuickBook.
  ///
  /// In ko, this message translates to:
  /// **'운동 예약'**
  String get homeQuickBook;

  /// No description provided for @homeQuickBookCaption.
  ///
  /// In ko, this message translates to:
  /// **'빈 시간 확인'**
  String get homeQuickBookCaption;

  /// No description provided for @homeQuickReport.
  ///
  /// In ko, this message translates to:
  /// **'AI 리포트'**
  String get homeQuickReport;

  /// No description provided for @homeQuickReportCaption.
  ///
  /// In ko, this message translates to:
  /// **'보행 분석'**
  String get homeQuickReportCaption;

  /// No description provided for @homeQuickHistory.
  ///
  /// In ko, this message translates to:
  /// **'운동 기록'**
  String get homeQuickHistory;

  /// No description provided for @homeQuickHistoryCaption.
  ///
  /// In ko, this message translates to:
  /// **'전체 이력'**
  String get homeQuickHistoryCaption;

  /// No description provided for @homeNextBookingTitle.
  ///
  /// In ko, this message translates to:
  /// **'다음 예약'**
  String get homeNextBookingTitle;

  /// No description provided for @homeNextBookingAll.
  ///
  /// In ko, this message translates to:
  /// **'예약 내역'**
  String get homeNextBookingAll;

  /// No description provided for @homeNextBookingEmpty.
  ///
  /// In ko, this message translates to:
  /// **'예정된 예약이 없어요.'**
  String get homeNextBookingEmpty;

  /// No description provided for @homeNextBookingEmptyAction.
  ///
  /// In ko, this message translates to:
  /// **'예약하기'**
  String get homeNextBookingEmptyAction;

  /// No description provided for @homeRankingTitle.
  ///
  /// In ko, this message translates to:
  /// **'{month} 랭킹'**
  String homeRankingTitle(String month);

  /// No description provided for @homeRankingAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 랭킹'**
  String get homeRankingAll;

  /// No description provided for @homeRankingWaitingTitle.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 첫 운동을 기다리고 있어요'**
  String get homeRankingWaitingTitle;

  /// No description provided for @homeRankingWaitingCaption.
  ///
  /// In ko, this message translates to:
  /// **'운동을 마치면 점수가 쌓이고 바로 랭킹에 올라요.'**
  String get homeRankingWaitingCaption;

  /// No description provided for @homeRankingJoinTitle.
  ///
  /// In ko, this message translates to:
  /// **'참여하면 전체 {rank}위예요'**
  String homeRankingJoinTitle(int rank);

  /// No description provided for @homeRankingJoinCaption.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에 참여하고 {dog} 자랑해 보세요.'**
  String homeRankingJoinCaption(String dog);

  /// No description provided for @homeRankingMineTitle.
  ///
  /// In ko, this message translates to:
  /// **'{dog} · 전체 {rank}위'**
  String homeRankingMineTitle(String dog, int rank);

  /// No description provided for @homeRankingHoldingFirst.
  ///
  /// In ko, this message translates to:
  /// **'{points} · 1위를 지키고 있어요!'**
  String homeRankingHoldingFirst(String points);

  /// No description provided for @homeRankingPointsToNext.
  ///
  /// In ko, this message translates to:
  /// **'{points} · {gap}점 더 받으면 순위가 올라요'**
  String homeRankingPointsToNext(String points, int gap);

  /// No description provided for @homeRankingStreak.
  ///
  /// In ko, this message translates to:
  /// **'{weeks}주 연속 운동'**
  String homeRankingStreak(int weeks);

  /// No description provided for @homeRankingJoinAction.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 참여하기'**
  String get homeRankingJoinAction;

  /// No description provided for @homeRecentTitle.
  ///
  /// In ko, this message translates to:
  /// **'최근 운동'**
  String get homeRecentTitle;

  /// No description provided for @homeRecentAll.
  ///
  /// In ko, this message translates to:
  /// **'전체 기록'**
  String get homeRecentAll;

  /// No description provided for @homeRecentEmpty.
  ///
  /// In ko, this message translates to:
  /// **'아직 운동 기록이 없어요. 첫 운동을 예약해 보세요!'**
  String get homeRecentEmpty;

  /// No description provided for @homeAnalysisTitle.
  ///
  /// In ko, this message translates to:
  /// **'AI 보행 분석'**
  String get homeAnalysisTitle;

  /// No description provided for @homeAnalysisAction.
  ///
  /// In ko, this message translates to:
  /// **'건강 리포트'**
  String get homeAnalysisAction;

  /// No description provided for @homeAnalysisPending.
  ///
  /// In ko, this message translates to:
  /// **'최근 운동 영상을 분석하고 있어요. 완료되면 알려 드릴게요.'**
  String get homeAnalysisPending;

  /// No description provided for @homeAnalysisNeedsConsent.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상 촬영에 동의하면 AI 보행 분석 리포트를 받을 수 있어요.'**
  String get homeAnalysisNeedsConsent;

  /// No description provided for @homeAnalysisEmpty.
  ///
  /// In ko, this message translates to:
  /// **'운동을 마치면 AI 보행 분석 리포트가 여기에 표시돼요.'**
  String get homeAnalysisEmpty;

  /// No description provided for @homeAnalysisConsentAction.
  ///
  /// In ko, this message translates to:
  /// **'동의하기'**
  String get homeAnalysisConsentAction;

  /// No description provided for @homeAnalysisSymmetry.
  ///
  /// In ko, this message translates to:
  /// **'좌우 대칭성'**
  String get homeAnalysisSymmetry;

  /// No description provided for @homeAnalysisCadence.
  ///
  /// In ko, this message translates to:
  /// **'분당 걸음 수'**
  String get homeAnalysisCadence;

  /// No description provided for @homeUnitSteps.
  ///
  /// In ko, this message translates to:
  /// **'보'**
  String get homeUnitSteps;

  /// No description provided for @homeNoticesTitle.
  ///
  /// In ko, this message translates to:
  /// **'공지사항'**
  String get homeNoticesTitle;

  /// No description provided for @homeNoticesAll.
  ///
  /// In ko, this message translates to:
  /// **'전체보기'**
  String get homeNoticesAll;

  /// No description provided for @bookingListTitle.
  ///
  /// In ko, this message translates to:
  /// **'예약'**
  String get bookingListTitle;

  /// No description provided for @bookingPaymentHistory.
  ///
  /// In ko, this message translates to:
  /// **'결제·환불 내역'**
  String get bookingPaymentHistory;

  /// No description provided for @bookingTabUpcoming.
  ///
  /// In ko, this message translates to:
  /// **'예정된 예약'**
  String get bookingTabUpcoming;

  /// No description provided for @bookingTabPast.
  ///
  /// In ko, this message translates to:
  /// **'지난 예약'**
  String get bookingTabPast;

  /// No description provided for @bookingEmptyUpcoming.
  ///
  /// In ko, this message translates to:
  /// **'예정된 예약이 없어요'**
  String get bookingEmptyUpcoming;

  /// No description provided for @bookingEmptyPast.
  ///
  /// In ko, this message translates to:
  /// **'지난 예약이 없어요'**
  String get bookingEmptyPast;

  /// No description provided for @bookingEmptyUpcomingHint.
  ///
  /// In ko, this message translates to:
  /// **'원하는 시간에 트레드밀을 예약해 보세요.'**
  String get bookingEmptyUpcomingHint;

  /// No description provided for @bookingUsablePasses.
  ///
  /// In ko, this message translates to:
  /// **'사용 가능한 이용권'**
  String get bookingUsablePasses;

  /// No description provided for @bookingSessionsUnit.
  ///
  /// In ko, this message translates to:
  /// **'{count, plural, other{ 회}}'**
  String bookingSessionsUnit(int count);

  /// No description provided for @bookingNewWorkout.
  ///
  /// In ko, this message translates to:
  /// **'새 운동 예약'**
  String get bookingNewWorkout;

  /// No description provided for @bookingCheckInTitle.
  ///
  /// In ko, this message translates to:
  /// **'체크인할까요?'**
  String get bookingCheckInTitle;

  /// No description provided for @bookingCheckInMessage.
  ///
  /// In ko, this message translates to:
  /// **'매장에 도착했을 때 체크인해 주세요.'**
  String get bookingCheckInMessage;

  /// No description provided for @bookingCheckInMessageWithMachine.
  ///
  /// In ko, this message translates to:
  /// **'매장에 도착했을 때 체크인해 주세요.\n배정된 트레드밀: {machine}'**
  String bookingCheckInMessageWithMachine(String machine);

  /// No description provided for @bookingCheckInAction.
  ///
  /// In ko, this message translates to:
  /// **'체크인'**
  String get bookingCheckInAction;

  /// No description provided for @bookingCheckedIn.
  ///
  /// In ko, this message translates to:
  /// **'체크인했어요.'**
  String get bookingCheckedIn;

  /// No description provided for @bookingCheckedInWithMachine.
  ///
  /// In ko, this message translates to:
  /// **'체크인했어요. 트레드밀 {machine}에서 운동을 시작해 주세요.'**
  String bookingCheckedInWithMachine(String machine);

  /// No description provided for @bookingDefaultProgramName.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀 운동'**
  String get bookingDefaultProgramName;

  /// No description provided for @bookingToday.
  ///
  /// In ko, this message translates to:
  /// **'오늘'**
  String get bookingToday;

  /// No description provided for @bookingDateSemantics.
  ///
  /// In ko, this message translates to:
  /// **'{month} {day}일 {weekday}요일'**
  String bookingDateSemantics(String month, int day, String weekday);

  /// No description provided for @bookingDateSemanticsToday.
  ///
  /// In ko, this message translates to:
  /// **'{label}, 오늘'**
  String bookingDateSemanticsToday(String label);

  /// No description provided for @bookingSlotsEmpty.
  ///
  /// In ko, this message translates to:
  /// **'선택한 날짜에 예약 가능한 시간이 없어요.'**
  String get bookingSlotsEmpty;

  /// No description provided for @bookingPeriodDawn.
  ///
  /// In ko, this message translates to:
  /// **'새벽'**
  String get bookingPeriodDawn;

  /// No description provided for @bookingPeriodMorning.
  ///
  /// In ko, this message translates to:
  /// **'오전'**
  String get bookingPeriodMorning;

  /// No description provided for @bookingPeriodAfternoon.
  ///
  /// In ko, this message translates to:
  /// **'오후'**
  String get bookingPeriodAfternoon;

  /// No description provided for @bookingPeriodEvening.
  ///
  /// In ko, this message translates to:
  /// **'저녁'**
  String get bookingPeriodEvening;

  /// No description provided for @bookingSlotSemanticsAvailable.
  ///
  /// In ko, this message translates to:
  /// **'{time}, 잔여 {count}대'**
  String bookingSlotSemanticsAvailable(String time, int count);

  /// No description provided for @bookingSlotSemanticsFull.
  ///
  /// In ko, this message translates to:
  /// **'{time}, 마감'**
  String bookingSlotSemanticsFull(String time);

  /// No description provided for @bookingSlotLeft.
  ///
  /// In ko, this message translates to:
  /// **'잔여 {count}'**
  String bookingSlotLeft(int count);

  /// No description provided for @bookingSlotFull.
  ///
  /// In ko, this message translates to:
  /// **'마감'**
  String get bookingSlotFull;

  /// No description provided for @bookingDetailTitle.
  ///
  /// In ko, this message translates to:
  /// **'예약 상세'**
  String get bookingDetailTitle;

  /// No description provided for @bookingNoteCancelled.
  ///
  /// In ko, this message translates to:
  /// **'취소된 예약이에요.'**
  String get bookingNoteCancelled;

  /// No description provided for @bookingNoteNoShow.
  ///
  /// In ko, this message translates to:
  /// **'방문하지 않아 미방문 처리된 예약이에요.'**
  String get bookingNoteNoShow;

  /// No description provided for @bookingStepReceived.
  ///
  /// In ko, this message translates to:
  /// **'접수'**
  String get bookingStepReceived;

  /// No description provided for @bookingStepConfirmed.
  ///
  /// In ko, this message translates to:
  /// **'확정'**
  String get bookingStepConfirmed;

  /// No description provided for @bookingStepCheckedIn.
  ///
  /// In ko, this message translates to:
  /// **'체크인'**
  String get bookingStepCheckedIn;

  /// No description provided for @bookingStepCompleted.
  ///
  /// In ko, this message translates to:
  /// **'이용 완료'**
  String get bookingStepCompleted;

  /// No description provided for @bookingInfoDog.
  ///
  /// In ko, this message translates to:
  /// **'반려견'**
  String get bookingInfoDog;

  /// No description provided for @bookingInfoLocation.
  ///
  /// In ko, this message translates to:
  /// **'지점'**
  String get bookingInfoLocation;

  /// No description provided for @bookingInfoTreadmill.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀'**
  String get bookingInfoTreadmill;

  /// No description provided for @bookingInfoProgram.
  ///
  /// In ko, this message translates to:
  /// **'프로그램'**
  String get bookingInfoProgram;

  /// No description provided for @bookingInfoPayment.
  ///
  /// In ko, this message translates to:
  /// **'결제'**
  String get bookingInfoPayment;

  /// No description provided for @bookingInfoNote.
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get bookingInfoNote;

  /// No description provided for @bookingInfoCancellation.
  ///
  /// In ko, this message translates to:
  /// **'취소'**
  String get bookingInfoCancellation;

  /// No description provided for @bookingDurationMinutes.
  ///
  /// In ko, this message translates to:
  /// **'{minutes}분'**
  String bookingDurationMinutes(int minutes);

  /// No description provided for @bookingPayWithPass.
  ///
  /// In ko, this message translates to:
  /// **'이용권 1회 사용'**
  String get bookingPayWithPass;

  /// No description provided for @bookingPayOnSite.
  ///
  /// In ko, this message translates to:
  /// **'현장 결제'**
  String get bookingPayOnSite;

  /// No description provided for @bookingCancelledToast.
  ///
  /// In ko, this message translates to:
  /// **'예약을 취소했어요.'**
  String get bookingCancelledToast;

  /// No description provided for @bookingRescheduledToast.
  ///
  /// In ko, this message translates to:
  /// **'예약 시간을 변경했어요.'**
  String get bookingRescheduledToast;

  /// No description provided for @bookingViewWorkoutHistory.
  ///
  /// In ko, this message translates to:
  /// **'운동 기록 보기'**
  String get bookingViewWorkoutHistory;

  /// No description provided for @bookingAtMachine.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀 {machine}에서'**
  String bookingAtMachine(String machine);

  /// No description provided for @bookingAtAssignedMachine.
  ///
  /// In ko, this message translates to:
  /// **'배정된 트레드밀에서'**
  String get bookingAtAssignedMachine;

  /// No description provided for @bookingPayOnSiteNotice.
  ///
  /// In ko, this message translates to:
  /// **'\n현장 결제 예약이라 이용 전에 매장에서 결제해 주세요.'**
  String get bookingPayOnSiteNotice;

  /// No description provided for @bookingGuideCheckedIn.
  ///
  /// In ko, this message translates to:
  /// **'체크인했어요. {atMachine} 운동을 시작하고, 운동하는 동안 반려견 곁을 지켜 주세요. 운동이 시작되면 운동 탭에서 실시간으로 볼 수 있어요.{payOnSite}'**
  String bookingGuideCheckedIn(String atMachine, String payOnSite);

  /// No description provided for @bookingGuideEnded.
  ///
  /// In ko, this message translates to:
  /// **'예약 시간이 지나 체크인할 수 없어요.'**
  String get bookingGuideEnded;

  /// No description provided for @bookingGuideCheckInOpen.
  ///
  /// In ko, this message translates to:
  /// **'매장에 도착하면 체크인하고 {atMachine} 운동을 시작해 주세요.{payOnSite}'**
  String bookingGuideCheckInOpen(String atMachine, String payOnSite);

  /// No description provided for @bookingGuideModifiable.
  ///
  /// In ko, this message translates to:
  /// **'예약 시작 1시간 전까지 변경·취소할 수 있어요.\n이용 당일 {time}부터 앱에서 체크인할 수 있어요.'**
  String bookingGuideModifiable(String time);

  /// No description provided for @bookingGuideModifiableWithPass.
  ///
  /// In ko, this message translates to:
  /// **'예약 시작 1시간 전까지 변경·취소할 수 있어요. 취소하면 이용권 횟수가 복구돼요.\n이용 당일 {time}부터 앱에서 체크인할 수 있어요.'**
  String bookingGuideModifiableWithPass(String time);

  /// No description provided for @bookingGuideLocked.
  ///
  /// In ko, this message translates to:
  /// **'{time}부터 앱에서 체크인할 수 있어요.\n예약 시작 1시간 전부터는 앱에서 변경·취소할 수 없어요.'**
  String bookingGuideLocked(String time);

  /// No description provided for @bookingCancelAction.
  ///
  /// In ko, this message translates to:
  /// **'예약 취소'**
  String get bookingCancelAction;

  /// No description provided for @bookingRescheduleAction.
  ///
  /// In ko, this message translates to:
  /// **'시간 변경'**
  String get bookingRescheduleAction;

  /// No description provided for @bookingInquiryAction.
  ///
  /// In ko, this message translates to:
  /// **'1:1 문의하기'**
  String get bookingInquiryAction;

  /// No description provided for @bookingCancelReasonSchedule.
  ///
  /// In ko, this message translates to:
  /// **'일정이 변경되었어요'**
  String get bookingCancelReasonSchedule;

  /// No description provided for @bookingCancelReasonCondition.
  ///
  /// In ko, this message translates to:
  /// **'반려견 컨디션이 좋지 않아요'**
  String get bookingCancelReasonCondition;

  /// No description provided for @bookingCancelReasonRebook.
  ///
  /// In ko, this message translates to:
  /// **'다른 시간으로 다시 예약할게요'**
  String get bookingCancelReasonRebook;

  /// No description provided for @bookingCancelReasonOther.
  ///
  /// In ko, this message translates to:
  /// **'기타'**
  String get bookingCancelReasonOther;

  /// No description provided for @bookingCancelSheetTitle.
  ///
  /// In ko, this message translates to:
  /// **'예약을 취소할까요?'**
  String get bookingCancelSheetTitle;

  /// No description provided for @bookingCancelSheetSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'취소 사유를 선택해 주세요.'**
  String get bookingCancelSheetSubtitle;

  /// No description provided for @bookingCancelConfirmAction.
  ///
  /// In ko, this message translates to:
  /// **'예약 취소하기'**
  String get bookingCancelConfirmAction;

  /// No description provided for @bookingRescheduleTitle.
  ///
  /// In ko, this message translates to:
  /// **'예약 시간 변경'**
  String get bookingRescheduleTitle;

  /// No description provided for @bookingRescheduleCurrent.
  ///
  /// In ko, this message translates to:
  /// **'현재 {when} · {branch}'**
  String bookingRescheduleCurrent(String when, String branch);

  /// No description provided for @bookingRescheduleNoProgram.
  ///
  /// In ko, this message translates to:
  /// **'프로그램 정보가 없어 시간을 변경할 수 없어요. 1:1 문의로 알려 주세요.'**
  String get bookingRescheduleNoProgram;

  /// No description provided for @bookingReschedulePick.
  ///
  /// In ko, this message translates to:
  /// **'변경할 시간을 선택해 주세요'**
  String get bookingReschedulePick;

  /// No description provided for @bookingRescheduleSubmit.
  ///
  /// In ko, this message translates to:
  /// **'{time} 예약으로 변경'**
  String bookingRescheduleSubmit(String time);

  /// No description provided for @bookingConfirmedToast.
  ///
  /// In ko, this message translates to:
  /// **'예약이 확정되었어요.'**
  String get bookingConfirmedToast;

  /// No description provided for @bookingReceivedToast.
  ///
  /// In ko, this message translates to:
  /// **'예약이 접수되었어요. 이용 당일 매장에서 결제해 주세요.'**
  String get bookingReceivedToast;

  /// No description provided for @bookingNewTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동 예약'**
  String get bookingNewTitle;

  /// No description provided for @bookingStepDog.
  ///
  /// In ko, this message translates to:
  /// **'반려견'**
  String get bookingStepDog;

  /// No description provided for @bookingStepBranch.
  ///
  /// In ko, this message translates to:
  /// **'지점'**
  String get bookingStepBranch;

  /// No description provided for @bookingStepProgram.
  ///
  /// In ko, this message translates to:
  /// **'운동 프로그램'**
  String get bookingStepProgram;

  /// No description provided for @bookingStepDate.
  ///
  /// In ko, this message translates to:
  /// **'날짜'**
  String get bookingStepDate;

  /// No description provided for @bookingStepTime.
  ///
  /// In ko, this message translates to:
  /// **'시간'**
  String get bookingStepTime;

  /// No description provided for @bookingStepPayment.
  ///
  /// In ko, this message translates to:
  /// **'결제'**
  String get bookingStepPayment;

  /// No description provided for @bookingStepNote.
  ///
  /// In ko, this message translates to:
  /// **'메모 (선택)'**
  String get bookingStepNote;

  /// No description provided for @bookingNeedDogMessage.
  ///
  /// In ko, this message translates to:
  /// **'예약하려면 먼저 반려견을 등록해 주세요.'**
  String get bookingNeedDogMessage;

  /// No description provided for @bookingNeedDogAction.
  ///
  /// In ko, this message translates to:
  /// **'등록하기'**
  String get bookingNeedDogAction;

  /// No description provided for @bookingTimeHint.
  ///
  /// In ko, this message translates to:
  /// **'지점과 운동 프로그램을 선택하면 예약 가능한 시간이 표시돼요.'**
  String get bookingTimeHint;

  /// No description provided for @bookingPassValidUntil.
  ///
  /// In ko, this message translates to:
  /// **'~ {date}까지'**
  String bookingPassValidUntil(String date);

  /// No description provided for @bookingPassRemaining.
  ///
  /// In ko, this message translates to:
  /// **'잔여 {count}회'**
  String bookingPassRemaining(int count);

  /// No description provided for @bookingPayOnSiteBody.
  ///
  /// In ko, this message translates to:
  /// **'예약 대기로 접수되고, 이용 당일 매장에서 결제해요.'**
  String get bookingPayOnSiteBody;

  /// No description provided for @bookingNoteHint.
  ///
  /// In ko, this message translates to:
  /// **'반려견에 대해 남겨 둘 내용을 적어 주세요. (예: 낯선 소리에 예민해요)'**
  String get bookingNoteHint;

  /// No description provided for @bookingSelfServiceHint.
  ///
  /// In ko, this message translates to:
  /// **'무인 매장이에요. 이용 당일 예약 시작 15분 전부터 앱에서 체크인하고, 배정된 트레드밀에서 운동을 시작해 주세요.\n예약 시작 1시간 전까지 앱에서 변경·취소할 수 있어요. 이용권으로 예약한 경우 취소하면 횟수가 복구돼요.'**
  String get bookingSelfServiceHint;

  /// No description provided for @bookingSummaryIncomplete.
  ///
  /// In ko, this message translates to:
  /// **'반려견, 지점, 프로그램, 시간을 선택해 주세요.'**
  String get bookingSummaryIncomplete;

  /// No description provided for @bookingSummary.
  ///
  /// In ko, this message translates to:
  /// **'{dog} · {when}\n{program} {duration} · {payment}'**
  String bookingSummary(
      String dog, String when, String program, String duration, String payment);

  /// No description provided for @bookingSummaryPayWithPass.
  ///
  /// In ko, this message translates to:
  /// **'이용권 1회 차감'**
  String get bookingSummaryPayWithPass;

  /// No description provided for @bookingAppPaymentTitle.
  ///
  /// In ko, this message translates to:
  /// **'앱 결제'**
  String get bookingAppPaymentTitle;

  /// No description provided for @bookingAppPaymentBody.
  ///
  /// In ko, this message translates to:
  /// **'카드·간편결제로 바로 결제하고 예약을 확정해요.'**
  String get bookingAppPaymentBody;

  /// No description provided for @bookingComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'준비 중'**
  String get bookingComingSoon;

  /// No description provided for @bookingRestrictionNotice.
  ///
  /// In ko, this message translates to:
  /// **'운동 제한 사항: {restrictions}\n무인 매장이라 보호자가 직접 확인해야 해요. 제한 사항에 맞는 프로그램을 고르고, 운동하는 동안 곁에서 지켜봐 주세요.'**
  String bookingRestrictionNotice(String restrictions);

  /// No description provided for @bookingSubmit.
  ///
  /// In ko, this message translates to:
  /// **'예약하기'**
  String get bookingSubmit;

  /// No description provided for @membershipTitle.
  ///
  /// In ko, this message translates to:
  /// **'이용권'**
  String get membershipTitle;

  /// No description provided for @membershipPaymentHistory.
  ///
  /// In ko, this message translates to:
  /// **'결제 내역'**
  String get membershipPaymentHistory;

  /// No description provided for @membershipOwnedTitle.
  ///
  /// In ko, this message translates to:
  /// **'보유 이용권'**
  String get membershipOwnedTitle;

  /// No description provided for @membershipOwnedEmpty.
  ///
  /// In ko, this message translates to:
  /// **'보유한 이용권이 없어요. 아래 상품을 구매하면 앱에서 바로 예약에 사용할 수 있어요.'**
  String get membershipOwnedEmpty;

  /// No description provided for @membershipPlansTitle.
  ///
  /// In ko, this message translates to:
  /// **'이용권 상품'**
  String get membershipPlansTitle;

  /// No description provided for @membershipPurchaseNote.
  ///
  /// In ko, this message translates to:
  /// **'상품을 누르면 결제 방법을 볼 수 있어요. 앱 결제는 준비 중이라 지금은 매장에서 구매할 수 있고, 구매하면 바로 보유 이용권에 반영돼요.'**
  String get membershipPurchaseNote;

  /// No description provided for @membershipDaysLeft.
  ///
  /// In ko, this message translates to:
  /// **'D-{days}'**
  String membershipDaysLeft(int days);

  /// No description provided for @membershipSessionsLeft.
  ///
  /// In ko, this message translates to:
  /// **'/ {total}회 남음'**
  String membershipSessionsLeft(int total);

  /// No description provided for @membershipPlanSessionsBadge.
  ///
  /// In ko, this message translates to:
  /// **'{count}회'**
  String membershipPlanSessionsBadge(int count);

  /// No description provided for @membershipValidDays.
  ///
  /// In ko, this message translates to:
  /// **'유효기간 {days}일'**
  String membershipValidDays(int days);

  /// No description provided for @membershipPricePerSession.
  ///
  /// In ko, this message translates to:
  /// **'회당 {price}'**
  String membershipPricePerSession(String price);

  /// No description provided for @membershipPurchaseSummary.
  ///
  /// In ko, this message translates to:
  /// **'{price} · {count}회 · 유효기간 {days}일'**
  String membershipPurchaseSummary(String price, int count, int days);

  /// No description provided for @membershipAppPaymentTitle.
  ///
  /// In ko, this message translates to:
  /// **'앱 결제'**
  String get membershipAppPaymentTitle;

  /// No description provided for @membershipAppPaymentBody.
  ///
  /// In ko, this message translates to:
  /// **'카드·간편결제로 결제하면 바로 보유 이용권에 추가돼요.'**
  String get membershipAppPaymentBody;

  /// No description provided for @membershipComingSoon.
  ///
  /// In ko, this message translates to:
  /// **'준비 중'**
  String get membershipComingSoon;

  /// No description provided for @membershipStorePaymentTitle.
  ///
  /// In ko, this message translates to:
  /// **'매장 결제'**
  String get membershipStorePaymentTitle;

  /// No description provided for @membershipStorePaymentBody.
  ///
  /// In ko, this message translates to:
  /// **'지금은 매장에서 구매할 수 있어요. 구매하면 바로 앱의 보유 이용권에 반영돼요.'**
  String get membershipStorePaymentBody;

  /// No description provided for @membershipAppPaymentUnavailable.
  ///
  /// In ko, this message translates to:
  /// **'앱 결제 준비 중'**
  String get membershipAppPaymentUnavailable;

  /// No description provided for @paymentHistoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'결제·환불 내역'**
  String get paymentHistoryTitle;

  /// No description provided for @paymentEmpty.
  ///
  /// In ko, this message translates to:
  /// **'결제 내역이 없어요'**
  String get paymentEmpty;

  /// No description provided for @paymentDefaultOrderName.
  ///
  /// In ko, this message translates to:
  /// **'이용권 결제'**
  String get paymentDefaultOrderName;

  /// No description provided for @paymentRefunded.
  ///
  /// In ko, this message translates to:
  /// **'환불 {amount}'**
  String paymentRefunded(String amount);

  /// No description provided for @paymentRefundedOn.
  ///
  /// In ko, this message translates to:
  /// **'환불 {amount} ({date})'**
  String paymentRefundedOn(String amount, String date);

  /// No description provided for @dogSexMale.
  ///
  /// In ko, this message translates to:
  /// **'수컷'**
  String get dogSexMale;

  /// No description provided for @dogSexFemale.
  ///
  /// In ko, this message translates to:
  /// **'암컷'**
  String get dogSexFemale;

  /// No description provided for @dogSizeSmall.
  ///
  /// In ko, this message translates to:
  /// **'소형'**
  String get dogSizeSmall;

  /// No description provided for @dogSizeMedium.
  ///
  /// In ko, this message translates to:
  /// **'중형'**
  String get dogSizeMedium;

  /// No description provided for @dogSizeLarge.
  ///
  /// In ko, this message translates to:
  /// **'대형'**
  String get dogSizeLarge;

  /// No description provided for @dogWeightHintSmall.
  ///
  /// In ko, this message translates to:
  /// **'10kg 미만'**
  String get dogWeightHintSmall;

  /// No description provided for @dogWeightHintMedium.
  ///
  /// In ko, this message translates to:
  /// **'10~25kg'**
  String get dogWeightHintMedium;

  /// No description provided for @dogWeightHintLarge.
  ///
  /// In ko, this message translates to:
  /// **'25kg 이상'**
  String get dogWeightHintLarge;

  /// No description provided for @dogMixedLabel.
  ///
  /// In ko, this message translates to:
  /// **'믹스견({breed})'**
  String dogMixedLabel(String breed);

  /// No description provided for @dogMixedBreed.
  ///
  /// In ko, this message translates to:
  /// **'믹스견'**
  String get dogMixedBreed;

  /// No description provided for @dogAgeApprox.
  ///
  /// In ko, this message translates to:
  /// **'약 {age}'**
  String dogAgeApprox(String age);

  /// No description provided for @dogSizeDog.
  ///
  /// In ko, this message translates to:
  /// **'{size}견'**
  String dogSizeDog(String size);

  /// No description provided for @dogBrachycephalic.
  ///
  /// In ko, this message translates to:
  /// **'단두종'**
  String get dogBrachycephalic;

  /// No description provided for @dogRegisterTitle.
  ///
  /// In ko, this message translates to:
  /// **'반려견 등록'**
  String get dogRegisterTitle;

  /// No description provided for @dogEditTitle.
  ///
  /// In ko, this message translates to:
  /// **'반려견 정보 수정'**
  String get dogEditTitle;

  /// No description provided for @dogRegistered.
  ///
  /// In ko, this message translates to:
  /// **'{name} 등록되었어요.'**
  String dogRegistered(String name);

  /// No description provided for @dogUpdated.
  ///
  /// In ko, this message translates to:
  /// **'반려견 정보를 수정했어요.'**
  String get dogUpdated;

  /// No description provided for @dogSavedPhotoFailed.
  ///
  /// In ko, this message translates to:
  /// **'정보는 저장했지만 사진을 올리지 못했어요. {error}'**
  String dogSavedPhotoFailed(String error);

  /// No description provided for @dogPhotoLoadFailed.
  ///
  /// In ko, this message translates to:
  /// **'사진을 불러오지 못했어요. 권한을 확인해 주세요.'**
  String get dogPhotoLoadFailed;

  /// No description provided for @dogRequiredCheck.
  ///
  /// In ko, this message translates to:
  /// **'표시된 필수 항목을 확인해 주세요.'**
  String get dogRequiredCheck;

  /// No description provided for @dogPickGallery.
  ///
  /// In ko, this message translates to:
  /// **'앨범에서 선택'**
  String get dogPickGallery;

  /// No description provided for @dogPickCamera.
  ///
  /// In ko, this message translates to:
  /// **'사진 촬영'**
  String get dogPickCamera;

  /// No description provided for @dogBirthDatePickerHelp.
  ///
  /// In ko, this message translates to:
  /// **'생년월일 선택'**
  String get dogBirthDatePickerHelp;

  /// No description provided for @dogAgeRequired.
  ///
  /// In ko, this message translates to:
  /// **'나이를 입력해 주세요.'**
  String get dogAgeRequired;

  /// No description provided for @dogAgeMax.
  ///
  /// In ko, this message translates to:
  /// **'30살 이하로 입력해 주세요.'**
  String get dogAgeMax;

  /// No description provided for @dogAgeMin.
  ///
  /// In ko, this message translates to:
  /// **'1개월 이상으로 입력해 주세요.'**
  String get dogAgeMin;

  /// No description provided for @dogAgeMonthsRange.
  ///
  /// In ko, this message translates to:
  /// **'0~11개월'**
  String get dogAgeMonthsRange;

  /// No description provided for @dogSectionBasic.
  ///
  /// In ko, this message translates to:
  /// **'기본 정보'**
  String get dogSectionBasic;

  /// No description provided for @dogNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'이름 *'**
  String get dogNameLabel;

  /// No description provided for @dogNameRequired.
  ///
  /// In ko, this message translates to:
  /// **'이름을 입력해 주세요.'**
  String get dogNameRequired;

  /// No description provided for @dogMixedSwitch.
  ///
  /// In ko, this message translates to:
  /// **'믹스견이에요'**
  String get dogMixedSwitch;

  /// No description provided for @dogMixedSwitchHint.
  ///
  /// In ko, this message translates to:
  /// **'두 견종 이상이 섞였거나 견종을 잘 모르는 경우'**
  String get dogMixedSwitchHint;

  /// No description provided for @dogBreedLabelMixed.
  ///
  /// In ko, this message translates to:
  /// **'섞인 견종 (선택)'**
  String get dogBreedLabelMixed;

  /// No description provided for @dogBreedLabel.
  ///
  /// In ko, this message translates to:
  /// **'견종 *'**
  String get dogBreedLabel;

  /// No description provided for @dogBreedHintMixed.
  ///
  /// In ko, this message translates to:
  /// **'예: 말티즈, 푸들'**
  String get dogBreedHintMixed;

  /// No description provided for @dogBreedHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 말티즈'**
  String get dogBreedHint;

  /// No description provided for @dogBreedRequired.
  ///
  /// In ko, this message translates to:
  /// **'견종을 입력해 주세요. 잘 모르면 믹스견을 선택해 주세요.'**
  String get dogBreedRequired;

  /// No description provided for @dogBreedNotListed.
  ///
  /// In ko, this message translates to:
  /// **'목록에 없는 견종이에요. 아래에서 체구를 골라 주세요.'**
  String get dogBreedNotListed;

  /// No description provided for @dogSizeLabel.
  ///
  /// In ko, this message translates to:
  /// **'체구 *'**
  String get dogSizeLabel;

  /// No description provided for @dogSizeRequired.
  ///
  /// In ko, this message translates to:
  /// **'체구를 선택해 주세요.'**
  String get dogSizeRequired;

  /// No description provided for @dogSizeInfoHint.
  ///
  /// In ko, this message translates to:
  /// **'다 자란 몸무게 기준 · {options}'**
  String dogSizeInfoHint(String options);

  /// No description provided for @dogBrachySwitch.
  ///
  /// In ko, this message translates to:
  /// **'주둥이가 짧은 단두종이에요'**
  String get dogBrachySwitch;

  /// No description provided for @dogBrachySwitchHint.
  ///
  /// In ko, this message translates to:
  /// **'퍼그·시츄·불독처럼 코가 눌린 얼굴형'**
  String get dogBrachySwitchHint;

  /// No description provided for @dogAgeLabel.
  ///
  /// In ko, this message translates to:
  /// **'나이 *'**
  String get dogAgeLabel;

  /// No description provided for @dogBirthDate.
  ///
  /// In ko, this message translates to:
  /// **'생년월일'**
  String get dogBirthDate;

  /// No description provided for @dogAgeEstimate.
  ///
  /// In ko, this message translates to:
  /// **'추정 나이'**
  String get dogAgeEstimate;

  /// No description provided for @dogCurrentAge.
  ///
  /// In ko, this message translates to:
  /// **'현재 {age}'**
  String dogCurrentAge(String age);

  /// No description provided for @dogBirthDateRequired.
  ///
  /// In ko, this message translates to:
  /// **'생년월일을 선택해 주세요.'**
  String get dogBirthDateRequired;

  /// No description provided for @dogPleaseSelect.
  ///
  /// In ko, this message translates to:
  /// **'선택해 주세요'**
  String get dogPleaseSelect;

  /// No description provided for @dogAge.
  ///
  /// In ko, this message translates to:
  /// **'나이'**
  String get dogAge;

  /// No description provided for @dogAgeYearsSuffix.
  ///
  /// In ko, this message translates to:
  /// **'살'**
  String get dogAgeYearsSuffix;

  /// No description provided for @dogAgeMonthsLabel.
  ///
  /// In ko, this message translates to:
  /// **'개월 (선택)'**
  String get dogAgeMonthsLabel;

  /// No description provided for @dogAgeMonthsSuffix.
  ///
  /// In ko, this message translates to:
  /// **'개월'**
  String get dogAgeMonthsSuffix;

  /// No description provided for @dogSex.
  ///
  /// In ko, this message translates to:
  /// **'성별'**
  String get dogSex;

  /// No description provided for @dogNeutered.
  ///
  /// In ko, this message translates to:
  /// **'중성화'**
  String get dogNeutered;

  /// No description provided for @dogNeuteredLabel.
  ///
  /// In ko, this message translates to:
  /// **'중성화 *'**
  String get dogNeuteredLabel;

  /// No description provided for @dogNeuteredYes.
  ///
  /// In ko, this message translates to:
  /// **'했어요'**
  String get dogNeuteredYes;

  /// No description provided for @dogNeuteredNo.
  ///
  /// In ko, this message translates to:
  /// **'안 했어요'**
  String get dogNeuteredNo;

  /// No description provided for @dogNeuteredRequired.
  ///
  /// In ko, this message translates to:
  /// **'중성화 여부를 선택해 주세요.'**
  String get dogNeuteredRequired;

  /// No description provided for @dogWeight.
  ///
  /// In ko, this message translates to:
  /// **'체중'**
  String get dogWeight;

  /// No description provided for @dogWeightLabel.
  ///
  /// In ko, this message translates to:
  /// **'체중 *'**
  String get dogWeightLabel;

  /// No description provided for @dogWeightEnter.
  ///
  /// In ko, this message translates to:
  /// **'체중을 입력해 주세요.'**
  String get dogWeightEnter;

  /// No description provided for @dogWeightInvalid.
  ///
  /// In ko, this message translates to:
  /// **'올바른 체중을 입력해 주세요.'**
  String get dogWeightInvalid;

  /// No description provided for @dogSectionHealth.
  ///
  /// In ko, this message translates to:
  /// **'건강 정보'**
  String get dogSectionHealth;

  /// No description provided for @dogHealthIntro.
  ///
  /// In ko, this message translates to:
  /// **'운동 강도와 주의사항을 정하는 데 쓰여요. 정확하게 입력해 주세요.'**
  String get dogHealthIntro;

  /// No description provided for @dogConditionsRequired.
  ///
  /// In ko, this message translates to:
  /// **'해당하는 항목이나 \'해당 없음\'을 골라 주세요.'**
  String get dogConditionsRequired;

  /// No description provided for @dogConditionsTitleRequired.
  ///
  /// In ko, this message translates to:
  /// **'질병·주의사항 *'**
  String get dogConditionsTitleRequired;

  /// No description provided for @dogConditionsTitle.
  ///
  /// In ko, this message translates to:
  /// **'질병·주의사항'**
  String get dogConditionsTitle;

  /// No description provided for @dogConditionsHelp.
  ///
  /// In ko, this message translates to:
  /// **'진단받았거나 치료 중인 항목을 모두 골라 주세요.'**
  String get dogConditionsHelp;

  /// No description provided for @dogConditionNone.
  ///
  /// In ko, this message translates to:
  /// **'해당 없음'**
  String get dogConditionNone;

  /// No description provided for @dogDiseasesTitle.
  ///
  /// In ko, this message translates to:
  /// **'질환 상세'**
  String get dogDiseasesTitle;

  /// No description provided for @dogDiseasesEmpty.
  ///
  /// In ko, this message translates to:
  /// **'적어 둔 진단명이 없어요.'**
  String get dogDiseasesEmpty;

  /// No description provided for @dogDiseaseNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'진단명 (예: 슬개골 탈구)'**
  String get dogDiseaseNameLabel;

  /// No description provided for @dogDiseaseDetailLabel.
  ///
  /// In ko, this message translates to:
  /// **'상태·단계 (선택)'**
  String get dogDiseaseDetailLabel;

  /// No description provided for @dogSurgeriesTitle.
  ///
  /// In ko, this message translates to:
  /// **'수술 및 치료 이력'**
  String get dogSurgeriesTitle;

  /// No description provided for @dogSurgeriesEmpty.
  ///
  /// In ko, this message translates to:
  /// **'등록된 이력이 없어요.'**
  String get dogSurgeriesEmpty;

  /// No description provided for @dogSurgeryNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'수술·치료명'**
  String get dogSurgeryNameLabel;

  /// No description provided for @dogSurgeryDetailLabel.
  ///
  /// In ko, this message translates to:
  /// **'병원·메모 (선택)'**
  String get dogSurgeryDetailLabel;

  /// No description provided for @dogMedicationsTitle.
  ///
  /// In ko, this message translates to:
  /// **'복용 중인 약물'**
  String get dogMedicationsTitle;

  /// No description provided for @dogMedicationsEmpty.
  ///
  /// In ko, this message translates to:
  /// **'복용 중인 약물이 없어요.'**
  String get dogMedicationsEmpty;

  /// No description provided for @dogMedicationNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'약 이름'**
  String get dogMedicationNameLabel;

  /// No description provided for @dogMedicationDetailLabel.
  ///
  /// In ko, this message translates to:
  /// **'용량·복용 주기 (선택)'**
  String get dogMedicationDetailLabel;

  /// No description provided for @dogRestrictionsTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동 제한 사항'**
  String get dogRestrictionsTitle;

  /// No description provided for @dogRestrictionsEmpty.
  ///
  /// In ko, this message translates to:
  /// **'운동 제한 사항이 없어요.'**
  String get dogRestrictionsEmpty;

  /// No description provided for @dogRestrictionNameLabel.
  ///
  /// In ko, this message translates to:
  /// **'제한 내용 (예: 경사 운동 금지)'**
  String get dogRestrictionNameLabel;

  /// No description provided for @dogRestrictionDetailLabel.
  ///
  /// In ko, this message translates to:
  /// **'상세 설명 (선택)'**
  String get dogRestrictionDetailLabel;

  /// No description provided for @dogHealthItemAddTitle.
  ///
  /// In ko, this message translates to:
  /// **'{title} 추가'**
  String dogHealthItemAddTitle(String title);

  /// No description provided for @dogDatePickOptional.
  ///
  /// In ko, this message translates to:
  /// **'날짜 선택 (선택)'**
  String get dogDatePickOptional;

  /// No description provided for @dogVetNotes.
  ///
  /// In ko, this message translates to:
  /// **'수의사 권고사항'**
  String get dogVetNotes;

  /// No description provided for @dogVetNotesHint.
  ///
  /// In ko, this message translates to:
  /// **'예: 주 3회, 20분 이내 저속 보행 권장'**
  String get dogVetNotesHint;

  /// No description provided for @dogSubmitSave.
  ///
  /// In ko, this message translates to:
  /// **'저장하기'**
  String get dogSubmitSave;

  /// No description provided for @dogSubmitRegister.
  ///
  /// In ko, this message translates to:
  /// **'등록하기'**
  String get dogSubmitRegister;

  /// No description provided for @dogDeleteTitle.
  ///
  /// In ko, this message translates to:
  /// **'{name} 정보를 삭제할까요?'**
  String dogDeleteTitle(String name);

  /// No description provided for @dogDeleteMessage.
  ///
  /// In ko, this message translates to:
  /// **'목록에서 사라지며 새 예약을 할 수 없어요. 지금까지의 운동·분석 기록은 헬스장에 보관됩니다.'**
  String get dogDeleteMessage;

  /// No description provided for @dogDeleted.
  ///
  /// In ko, this message translates to:
  /// **'{name} 정보를 삭제했어요.'**
  String dogDeleted(String name);

  /// No description provided for @dogProfileTitle.
  ///
  /// In ko, this message translates to:
  /// **'반려견 정보'**
  String get dogProfileTitle;

  /// No description provided for @dogDeleteMenu.
  ///
  /// In ko, this message translates to:
  /// **'반려견 삭제'**
  String get dogDeleteMenu;

  /// No description provided for @dogBookWorkout.
  ///
  /// In ko, this message translates to:
  /// **'{name} 운동 예약하기'**
  String dogBookWorkout(String name);

  /// No description provided for @dogProfileEmptySummary.
  ///
  /// In ko, this message translates to:
  /// **'프로필 정보를 입력해 주세요'**
  String get dogProfileEmptySummary;

  /// No description provided for @dogTotalWorkouts.
  ///
  /// In ko, this message translates to:
  /// **'누적 운동'**
  String get dogTotalWorkouts;

  /// No description provided for @dogUnitTimes.
  ///
  /// In ko, this message translates to:
  /// **'회'**
  String get dogUnitTimes;

  /// No description provided for @dogTotalTime.
  ///
  /// In ko, this message translates to:
  /// **'누적 시간'**
  String get dogTotalTime;

  /// No description provided for @dogUnitMinutes.
  ///
  /// In ko, this message translates to:
  /// **'분'**
  String get dogUnitMinutes;

  /// No description provided for @dogTotalDistance.
  ///
  /// In ko, this message translates to:
  /// **'누적 거리'**
  String get dogTotalDistance;

  /// No description provided for @dogBreed.
  ///
  /// In ko, this message translates to:
  /// **'견종'**
  String get dogBreed;

  /// No description provided for @dogSize.
  ///
  /// In ko, this message translates to:
  /// **'체구'**
  String get dogSize;

  /// No description provided for @dogAgeEstimated.
  ///
  /// In ko, this message translates to:
  /// **'{age} (추정)'**
  String dogAgeEstimated(String age);

  /// No description provided for @dogNoHealthInfo.
  ///
  /// In ko, this message translates to:
  /// **'등록된 건강 정보가 없어요. 수정 화면에서 입력할 수 있어요.'**
  String get dogNoHealthInfo;

  /// No description provided for @dogBadgeSection.
  ///
  /// In ko, this message translates to:
  /// **'배지 {earned}/{total}'**
  String dogBadgeSection(int earned, int total);

  /// No description provided for @dogBadgeCollection.
  ///
  /// In ko, this message translates to:
  /// **'배지함'**
  String get dogBadgeCollection;

  /// No description provided for @dogFirstBadgeHint.
  ///
  /// In ko, this message translates to:
  /// **'첫 운동을 마치면 「첫 발걸음」 배지를 받아요.'**
  String get dogFirstBadgeHint;

  /// No description provided for @dogNextBadge.
  ///
  /// In ko, this message translates to:
  /// **'다음 배지 · {name}'**
  String dogNextBadge(String name);

  /// No description provided for @dogPlanSection.
  ///
  /// In ko, this message translates to:
  /// **'맞춤 운동 계획'**
  String get dogPlanSection;

  /// No description provided for @dogPlanProgram.
  ///
  /// In ko, this message translates to:
  /// **'프로그램'**
  String get dogPlanProgram;

  /// No description provided for @dogPlanTargetTime.
  ///
  /// In ko, this message translates to:
  /// **'목표 시간'**
  String get dogPlanTargetTime;

  /// No description provided for @dogPlanTargetSpeed.
  ///
  /// In ko, this message translates to:
  /// **'목표 속도'**
  String get dogPlanTargetSpeed;

  /// No description provided for @dogPlanNotes.
  ///
  /// In ko, this message translates to:
  /// **'메모'**
  String get dogPlanNotes;

  /// No description provided for @dogListTitle.
  ///
  /// In ko, this message translates to:
  /// **'반려견 관리'**
  String get dogListTitle;

  /// No description provided for @dogListRegister.
  ///
  /// In ko, this message translates to:
  /// **'반려견 등록'**
  String get dogListRegister;

  /// No description provided for @dogListEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'등록된 반려견이 없어요'**
  String get dogListEmptyTitle;

  /// No description provided for @dogListEmptyMessage.
  ///
  /// In ko, this message translates to:
  /// **'반려견을 등록하고 운동 예약과 AI 분석을 시작해 보세요.'**
  String get dogListEmptyMessage;

  /// No description provided for @dogShownOnHome.
  ///
  /// In ko, this message translates to:
  /// **'홈에 표시 중'**
  String get dogShownOnHome;

  /// No description provided for @dogSwitcherTitle.
  ///
  /// In ko, this message translates to:
  /// **'반려견 선택'**
  String get dogSwitcherTitle;

  /// No description provided for @dogSwitcherAdd.
  ///
  /// In ko, this message translates to:
  /// **'반려견 추가'**
  String get dogSwitcherAdd;

  /// No description provided for @exerciseStatusReady.
  ///
  /// In ko, this message translates to:
  /// **'준비 중'**
  String get exerciseStatusReady;

  /// No description provided for @exerciseStatusRunning.
  ///
  /// In ko, this message translates to:
  /// **'운동 중'**
  String get exerciseStatusRunning;

  /// No description provided for @exerciseStatusPaused.
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get exerciseStatusPaused;

  /// No description provided for @exerciseStatusCompleted.
  ///
  /// In ko, this message translates to:
  /// **'운동 완료'**
  String get exerciseStatusCompleted;

  /// No description provided for @exerciseStatusStopped.
  ///
  /// In ko, this message translates to:
  /// **'운동 중단'**
  String get exerciseStatusStopped;

  /// No description provided for @exerciseHistoryTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동 기록'**
  String get exerciseHistoryTitle;

  /// No description provided for @exerciseHistoryTitleDog.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 운동 기록'**
  String exerciseHistoryTitleDog(String dog);

  /// No description provided for @exerciseTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동'**
  String get exerciseTitle;

  /// No description provided for @exerciseTitleDog.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 운동'**
  String exerciseTitleDog(String dog);

  /// No description provided for @exerciseNoDogTitle.
  ///
  /// In ko, this message translates to:
  /// **'등록된 반려견이 없어요'**
  String get exerciseNoDogTitle;

  /// No description provided for @exerciseNoDogHistoryMessage.
  ///
  /// In ko, this message translates to:
  /// **'반려견을 등록하면 운동 기록을 볼 수 있어요.'**
  String get exerciseNoDogHistoryMessage;

  /// No description provided for @exerciseNoDogLiveMessage.
  ///
  /// In ko, this message translates to:
  /// **'반려견을 등록하면 운동 현황과 기록을 볼 수 있어요.'**
  String get exerciseNoDogLiveMessage;

  /// No description provided for @exerciseRegisterDog.
  ///
  /// In ko, this message translates to:
  /// **'반려견 등록'**
  String get exerciseRegisterDog;

  /// No description provided for @exerciseNoRecordsTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 운동 기록이 없어요'**
  String get exerciseNoRecordsTitle;

  /// No description provided for @exerciseNoRecordsHistoryMessage.
  ///
  /// In ko, this message translates to:
  /// **'운동을 마치면 날짜별 기록이 쌓여요.'**
  String get exerciseNoRecordsHistoryMessage;

  /// No description provided for @exerciseNoRecordsSummaryMessage.
  ///
  /// In ko, this message translates to:
  /// **'운동을 마치면 시간, 거리, 속도가 기록돼요.'**
  String get exerciseNoRecordsSummaryMessage;

  /// No description provided for @exerciseSessionCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}회'**
  String exerciseSessionCount(int count);

  /// No description provided for @exerciseTotalsTitle.
  ///
  /// In ko, this message translates to:
  /// **'누적 운동 기록'**
  String get exerciseTotalsTitle;

  /// No description provided for @exerciseStatTotalWorkouts.
  ///
  /// In ko, this message translates to:
  /// **'총 운동'**
  String get exerciseStatTotalWorkouts;

  /// No description provided for @exerciseStatTotalTime.
  ///
  /// In ko, this message translates to:
  /// **'총 시간'**
  String get exerciseStatTotalTime;

  /// No description provided for @exerciseStatTotalDistance.
  ///
  /// In ko, this message translates to:
  /// **'총 거리'**
  String get exerciseStatTotalDistance;

  /// No description provided for @exerciseStatBestSpeed.
  ///
  /// In ko, this message translates to:
  /// **'최고 속도'**
  String get exerciseStatBestSpeed;

  /// No description provided for @exerciseUnitTimes.
  ///
  /// In ko, this message translates to:
  /// **'회'**
  String get exerciseUnitTimes;

  /// No description provided for @exerciseUnitMinutes.
  ///
  /// In ko, this message translates to:
  /// **'분'**
  String get exerciseUnitMinutes;

  /// No description provided for @exerciseCompletedToast.
  ///
  /// In ko, this message translates to:
  /// **'운동을 완료했어요!'**
  String get exerciseCompletedToast;

  /// No description provided for @exerciseStoppedToast.
  ///
  /// In ko, this message translates to:
  /// **'운동이 중단되었어요.'**
  String get exerciseStoppedToast;

  /// No description provided for @exerciseLive.
  ///
  /// In ko, this message translates to:
  /// **'실시간'**
  String get exerciseLive;

  /// No description provided for @exerciseElapsed.
  ///
  /// In ko, this message translates to:
  /// **'경과 시간'**
  String get exerciseElapsed;

  /// No description provided for @exerciseTarget.
  ///
  /// In ko, this message translates to:
  /// **'목표 {duration}'**
  String exerciseTarget(String duration);

  /// No description provided for @exerciseCurrentSpeed.
  ///
  /// In ko, this message translates to:
  /// **'현재 속도'**
  String get exerciseCurrentSpeed;

  /// No description provided for @exerciseDistance.
  ///
  /// In ko, this message translates to:
  /// **'이동 거리'**
  String get exerciseDistance;

  /// No description provided for @exerciseStartTime.
  ///
  /// In ko, this message translates to:
  /// **'시작 시간'**
  String get exerciseStartTime;

  /// No description provided for @exerciseTreadmill.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀'**
  String get exerciseTreadmill;

  /// No description provided for @exerciseUnmannedNotice.
  ///
  /// In ko, this message translates to:
  /// **'무인 매장이에요. 운동하는 동안 반려견 곁을 지켜 주시고, 이상하면 트레드밀의 비상정지 버튼을 눌러 주세요.'**
  String get exerciseUnmannedNotice;

  /// No description provided for @exerciseNoLiveTitle.
  ///
  /// In ko, this message translates to:
  /// **'진행 중인 운동이 없어요'**
  String get exerciseNoLiveTitle;

  /// No description provided for @exerciseNoLiveMessage.
  ///
  /// In ko, this message translates to:
  /// **'운동이 시작되면 이곳에서 실시간으로 확인할 수 있어요.'**
  String get exerciseNoLiveMessage;

  /// No description provided for @exerciseBookWorkout.
  ///
  /// In ko, this message translates to:
  /// **'운동 예약하기'**
  String get exerciseBookWorkout;

  /// No description provided for @exerciseNextBooking.
  ///
  /// In ko, this message translates to:
  /// **'다음 예약'**
  String get exerciseNextBooking;

  /// No description provided for @exerciseMyBookings.
  ///
  /// In ko, this message translates to:
  /// **'예약 내역'**
  String get exerciseMyBookings;

  /// No description provided for @exerciseMonthSummary.
  ///
  /// In ko, this message translates to:
  /// **'{month}월 운동 요약'**
  String exerciseMonthSummary(int month);

  /// No description provided for @exerciseStatCount.
  ///
  /// In ko, this message translates to:
  /// **'운동 횟수'**
  String get exerciseStatCount;

  /// No description provided for @exerciseStatTotalWorkoutTime.
  ///
  /// In ko, this message translates to:
  /// **'총 운동 시간'**
  String get exerciseStatTotalWorkoutTime;

  /// No description provided for @exerciseRecentRecords.
  ///
  /// In ko, this message translates to:
  /// **'최근 운동 기록'**
  String get exerciseRecentRecords;

  /// No description provided for @exerciseAllRecords.
  ///
  /// In ko, this message translates to:
  /// **'전체 기록'**
  String get exerciseAllRecords;

  /// No description provided for @exerciseTreadmillName.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀 {name}'**
  String exerciseTreadmillName(String name);

  /// No description provided for @exerciseWorkoutTime.
  ///
  /// In ko, this message translates to:
  /// **'운동 시간'**
  String get exerciseWorkoutTime;

  /// No description provided for @exerciseAvgMax.
  ///
  /// In ko, this message translates to:
  /// **'평균 / 최고'**
  String get exerciseAvgMax;

  /// No description provided for @exerciseStopReason.
  ///
  /// In ko, this message translates to:
  /// **'중단 사유: {reason}'**
  String exerciseStopReason(String reason);

  /// No description provided for @exercisePointsVoided.
  ///
  /// In ko, this message translates to:
  /// **'운영자 확인 후 무효 처리된 기록이에요'**
  String get exercisePointsVoided;

  /// No description provided for @exercisePointsWeeklyBonus.
  ///
  /// In ko, this message translates to:
  /// **'주간 보너스 {points} 포함'**
  String exercisePointsWeeklyBonus(String points);

  /// No description provided for @exercisePointsDefault.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 점수'**
  String get exercisePointsDefault;

  /// No description provided for @exerciseReportAi.
  ///
  /// In ko, this message translates to:
  /// **'AI 리포트'**
  String get exerciseReportAi;

  /// No description provided for @exerciseReportFailed.
  ///
  /// In ko, this message translates to:
  /// **'분석 실패'**
  String get exerciseReportFailed;

  /// No description provided for @exerciseReportPending.
  ///
  /// In ko, this message translates to:
  /// **'분석 중'**
  String get exerciseReportPending;

  /// No description provided for @analysisStatusQueued.
  ///
  /// In ko, this message translates to:
  /// **'분석 대기'**
  String get analysisStatusQueued;

  /// No description provided for @analysisStatusProcessing.
  ///
  /// In ko, this message translates to:
  /// **'분석 중'**
  String get analysisStatusProcessing;

  /// No description provided for @analysisStatusCompleted.
  ///
  /// In ko, this message translates to:
  /// **'분석 완료'**
  String get analysisStatusCompleted;

  /// No description provided for @analysisStatusFailed.
  ///
  /// In ko, this message translates to:
  /// **'분석 실패'**
  String get analysisStatusFailed;

  /// No description provided for @analysisLevelNormal.
  ///
  /// In ko, this message translates to:
  /// **'특이사항 없음'**
  String get analysisLevelNormal;

  /// No description provided for @analysisLevelCaution.
  ///
  /// In ko, this message translates to:
  /// **'관찰 필요'**
  String get analysisLevelCaution;

  /// No description provided for @analysisLevelWarning.
  ///
  /// In ko, this message translates to:
  /// **'주의 필요'**
  String get analysisLevelWarning;

  /// No description provided for @analysisCameraFront.
  ///
  /// In ko, this message translates to:
  /// **'정면 영상'**
  String get analysisCameraFront;

  /// No description provided for @analysisCameraSide.
  ///
  /// In ko, this message translates to:
  /// **'측면 영상'**
  String get analysisCameraSide;

  /// No description provided for @healthTitle.
  ///
  /// In ko, this message translates to:
  /// **'건강'**
  String get healthTitle;

  /// No description provided for @healthTitleDog.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 건강 분석'**
  String healthTitleDog(String dog);

  /// No description provided for @healthNoDogMessage.
  ///
  /// In ko, this message translates to:
  /// **'반려견을 등록하고 운동하면 AI 보행 분석 결과를 볼 수 있어요.'**
  String get healthNoDogMessage;

  /// No description provided for @healthReports.
  ///
  /// In ko, this message translates to:
  /// **'분석 리포트'**
  String get healthReports;

  /// No description provided for @healthPendingBanner.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상 {count}건을 분석하고 있어요. 완료되면 알림으로 알려 드릴게요.'**
  String healthPendingBanner(int count);

  /// No description provided for @healthPreparingTitle.
  ///
  /// In ko, this message translates to:
  /// **'첫 분석 리포트를 준비하고 있어요'**
  String get healthPreparingTitle;

  /// No description provided for @healthPreparingMessage.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상으로 관절 움직임과 보행 패턴을 분석 중이에요. 완료되면 알림으로 알려 드릴게요.'**
  String get healthPreparingMessage;

  /// No description provided for @healthConsentTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상 촬영 동의가 필요해요'**
  String get healthConsentTitle;

  /// No description provided for @healthConsentMessage.
  ///
  /// In ko, this message translates to:
  /// **'AI 보행 분석 리포트는 운동 영상으로 만들어요. 동의하면 다음 운동부터 관절 움직임과 보행 패턴을 분석해 드려요.'**
  String get healthConsentMessage;

  /// No description provided for @healthConsentAction.
  ///
  /// In ko, this message translates to:
  /// **'동의하러 가기'**
  String get healthConsentAction;

  /// No description provided for @healthNoReportTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 분석 리포트가 없어요'**
  String get healthNoReportTitle;

  /// No description provided for @healthNoReportMessage.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀 운동을 마치면 촬영 영상으로 관절 움직임과 보행 패턴을 분석해 드려요.'**
  String get healthNoReportMessage;

  /// No description provided for @healthLatestAnalysis.
  ///
  /// In ko, this message translates to:
  /// **'최근 분석'**
  String get healthLatestAnalysis;

  /// No description provided for @healthSymmetry.
  ///
  /// In ko, this message translates to:
  /// **'좌우 대칭성'**
  String get healthSymmetry;

  /// No description provided for @healthCadence.
  ///
  /// In ko, this message translates to:
  /// **'분당 걸음 수'**
  String get healthCadence;

  /// No description provided for @healthRhythm.
  ///
  /// In ko, this message translates to:
  /// **'보행 리듬'**
  String get healthRhythm;

  /// No description provided for @healthUnitPoints.
  ///
  /// In ko, this message translates to:
  /// **'점'**
  String get healthUnitPoints;

  /// No description provided for @healthConfidence.
  ///
  /// In ko, this message translates to:
  /// **'분석 신뢰도'**
  String get healthConfidence;

  /// No description provided for @healthViewReport.
  ///
  /// In ko, this message translates to:
  /// **'리포트 자세히 보기 →'**
  String get healthViewReport;

  /// No description provided for @healthTrendSymmetryDesc.
  ///
  /// In ko, this message translates to:
  /// **'좌우 다리 움직임이 얼마나 비슷한지 보여줘요. 높을수록 균형 잡힌 보행이에요.'**
  String get healthTrendSymmetryDesc;

  /// No description provided for @healthTrendCadenceDesc.
  ///
  /// In ko, this message translates to:
  /// **'1분 동안의 걸음 수예요. 평소 기준선과 크게 달라지면 관찰이 필요해요.'**
  String get healthTrendCadenceDesc;

  /// No description provided for @healthTrendVariabilityDesc.
  ///
  /// In ko, this message translates to:
  /// **'걸음걸이 주기가 얼마나 일정한지 보여줘요. 낮을수록 리듬이 안정적이에요.'**
  String get healthTrendVariabilityDesc;

  /// No description provided for @healthTrendTitle.
  ///
  /// In ko, this message translates to:
  /// **'보행 변화 추이'**
  String get healthTrendTitle;

  /// No description provided for @healthTrendSegSymmetry.
  ///
  /// In ko, this message translates to:
  /// **'대칭성'**
  String get healthTrendSegSymmetry;

  /// No description provided for @healthTrendSegCadence.
  ///
  /// In ko, this message translates to:
  /// **'걸음 수'**
  String get healthTrendSegCadence;

  /// No description provided for @healthTrendSegVariability.
  ///
  /// In ko, this message translates to:
  /// **'변동성'**
  String get healthTrendSegVariability;

  /// No description provided for @healthTrendNeedMore.
  ///
  /// In ko, this message translates to:
  /// **'추이를 보려면 분석 결과가 2건 이상 필요해요.'**
  String get healthTrendNeedMore;

  /// No description provided for @healthJointRomTitle.
  ///
  /// In ko, this message translates to:
  /// **'관절 가동 범위 변화'**
  String get healthJointRomTitle;

  /// No description provided for @healthAllJoints.
  ///
  /// In ko, this message translates to:
  /// **'전체 관절'**
  String get healthAllJoints;

  /// No description provided for @healthPlanTitle.
  ///
  /// In ko, this message translates to:
  /// **'맞춤 운동 계획'**
  String get healthPlanTitle;

  /// No description provided for @healthPlanTargetTime.
  ///
  /// In ko, this message translates to:
  /// **'목표 시간'**
  String get healthPlanTargetTime;

  /// No description provided for @healthPlanTargetSpeed.
  ///
  /// In ko, this message translates to:
  /// **'목표 속도'**
  String get healthPlanTargetSpeed;

  /// No description provided for @healthVideoPause.
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get healthVideoPause;

  /// No description provided for @healthVideoPlay.
  ///
  /// In ko, this message translates to:
  /// **'재생'**
  String get healthVideoPlay;

  /// No description provided for @rankingScopeAll.
  ///
  /// In ko, this message translates to:
  /// **'전체'**
  String get rankingScopeAll;

  /// No description provided for @rankingScopeBranch.
  ///
  /// In ko, this message translates to:
  /// **'지점'**
  String get rankingScopeBranch;

  /// No description provided for @rankingScopeSize.
  ///
  /// In ko, this message translates to:
  /// **'체급'**
  String get rankingScopeSize;

  /// No description provided for @rankingSizeSmall.
  ///
  /// In ko, this message translates to:
  /// **'소형견'**
  String get rankingSizeSmall;

  /// No description provided for @rankingSizeMedium.
  ///
  /// In ko, this message translates to:
  /// **'중형견'**
  String get rankingSizeMedium;

  /// No description provided for @rankingSizeLarge.
  ///
  /// In ko, this message translates to:
  /// **'대형견'**
  String get rankingSizeLarge;

  /// No description provided for @rankingTitleText.
  ///
  /// In ko, this message translates to:
  /// **'{month} {scope} {rank}위'**
  String rankingTitleText(String month, String scope, int rank);

  /// No description provided for @rankingScopeRankShort.
  ///
  /// In ko, this message translates to:
  /// **'{scope} {rank}위'**
  String rankingScopeRankShort(String scope, int rank);

  /// No description provided for @badgeProgressSessions.
  ///
  /// In ko, this message translates to:
  /// **'{current} / {goal}회'**
  String badgeProgressSessions(int current, int goal);

  /// No description provided for @badgeProgressDistance.
  ///
  /// In ko, this message translates to:
  /// **'{current} / {goal}km'**
  String badgeProgressDistance(String current, String goal);

  /// No description provided for @badgeProgressWeeks.
  ///
  /// In ko, this message translates to:
  /// **'{current} / {goal}주'**
  String badgeProgressWeeks(int current, int goal);

  /// No description provided for @badgeProgressBranches.
  ///
  /// In ko, this message translates to:
  /// **'{current} / {goal}곳'**
  String badgeProgressBranches(int current, int goal);

  /// No description provided for @badgeProgressOpenRuns.
  ///
  /// In ko, this message translates to:
  /// **'{current} / {goal}번'**
  String badgeProgressOpenRuns(int current, int goal);

  /// No description provided for @rankingPointsNoteTooShort.
  ///
  /// In ko, this message translates to:
  /// **'5분 미만 운동은 점수에 들어가지 않아요'**
  String get rankingPointsNoteTooShort;

  /// No description provided for @rankingPointsNoteDailyLimit.
  ///
  /// In ko, this message translates to:
  /// **'하루에 한 번만 점수를 받아요'**
  String get rankingPointsNoteDailyLimit;

  /// No description provided for @badgeCollectionTitle.
  ///
  /// In ko, this message translates to:
  /// **'배지함'**
  String get badgeCollectionTitle;

  /// No description provided for @badgeCollectionTitleDog.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 배지함'**
  String badgeCollectionTitleDog(String dog);

  /// No description provided for @badgeEarnedHeading.
  ///
  /// In ko, this message translates to:
  /// **'받은 배지 '**
  String get badgeEarnedHeading;

  /// No description provided for @badgeStatSessions.
  ///
  /// In ko, this message translates to:
  /// **'운동'**
  String get badgeStatSessions;

  /// No description provided for @badgeStatDistance.
  ///
  /// In ko, this message translates to:
  /// **'누적 거리'**
  String get badgeStatDistance;

  /// No description provided for @badgeStatStreak.
  ///
  /// In ko, this message translates to:
  /// **'연속 운동'**
  String get badgeStatStreak;

  /// No description provided for @badgeStatBranches.
  ///
  /// In ko, this message translates to:
  /// **'방문 지점'**
  String get badgeStatBranches;

  /// No description provided for @badgeSectionAwards.
  ///
  /// In ko, this message translates to:
  /// **'수상 기록'**
  String get badgeSectionAwards;

  /// No description provided for @badgeSectionBadges.
  ///
  /// In ko, this message translates to:
  /// **'배지'**
  String get badgeSectionBadges;

  /// No description provided for @badgeEarnedOn.
  ///
  /// In ko, this message translates to:
  /// **'{date} 획득'**
  String badgeEarnedOn(String date);

  /// No description provided for @badgeAwardedAtMonthEnd.
  ///
  /// In ko, this message translates to:
  /// **'월간 랭킹 마감 때 받아요'**
  String get badgeAwardedAtMonthEnd;

  /// No description provided for @rankingUnitSessions.
  ///
  /// In ko, this message translates to:
  /// **'회'**
  String get rankingUnitSessions;

  /// No description provided for @rankingUnitPoints.
  ///
  /// In ko, this message translates to:
  /// **'점'**
  String get rankingUnitPoints;

  /// No description provided for @rankingUnitWeeks.
  ///
  /// In ko, this message translates to:
  /// **'주'**
  String rankingUnitWeeks(int count);

  /// No description provided for @rankingUnitBranches.
  ///
  /// In ko, this message translates to:
  /// **'곳'**
  String rankingUnitBranches(int count);

  /// No description provided for @rankingRankValue.
  ///
  /// In ko, this message translates to:
  /// **'{rank}'**
  String rankingRankValue(int rank);

  /// No description provided for @rankingRankUnit.
  ///
  /// In ko, this message translates to:
  /// **'위'**
  String get rankingRankUnit;

  /// No description provided for @rankingStatPoints.
  ///
  /// In ko, this message translates to:
  /// **'점수'**
  String get rankingStatPoints;

  /// No description provided for @rankingStatSessions.
  ///
  /// In ko, this message translates to:
  /// **'운동'**
  String get rankingStatSessions;

  /// No description provided for @rankingStatCheers.
  ///
  /// In ko, this message translates to:
  /// **'응원'**
  String get rankingStatCheers;

  /// No description provided for @rankingStatDistance.
  ///
  /// In ko, this message translates to:
  /// **'거리'**
  String get rankingStatDistance;

  /// No description provided for @rankingStatRank.
  ///
  /// In ko, this message translates to:
  /// **'{month} 순위'**
  String rankingStatRank(String month);

  /// No description provided for @rankingCheerSent.
  ///
  /// In ko, this message translates to:
  /// **'{dog}에게 응원을 보냈어요!'**
  String rankingCheerSent(String dog);

  /// No description provided for @rankingBadgesEarned.
  ///
  /// In ko, this message translates to:
  /// **'받은 배지 {count}개'**
  String rankingBadgesEarned(int count);

  /// No description provided for @rankingNoBadgesYet.
  ///
  /// In ko, this message translates to:
  /// **'아직 받은 배지가 없어요.'**
  String get rankingNoBadgesYet;

  /// No description provided for @rankingMyDogJoined.
  ///
  /// In ko, this message translates to:
  /// **'내 반려견이에요. 꾸준히 운동해서 순위를 올려 보세요!'**
  String get rankingMyDogJoined;

  /// No description provided for @rankingMyDogNotJoined.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에 참여하면 다른 회원도 볼 수 있어요.'**
  String get rankingMyDogNotJoined;

  /// No description provided for @rankingCheeredThisMonth.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 응원했어요'**
  String get rankingCheeredThisMonth;

  /// No description provided for @rankingCheerDog.
  ///
  /// In ko, this message translates to:
  /// **'{dog} 응원하기'**
  String rankingCheerDog(String dog);

  /// No description provided for @boardTitle.
  ///
  /// In ko, this message translates to:
  /// **'매장 랭킹 보드'**
  String get boardTitle;

  /// No description provided for @rankingTitle.
  ///
  /// In ko, this message translates to:
  /// **'랭킹'**
  String get rankingTitle;

  /// No description provided for @rankingShareTooltip.
  ///
  /// In ko, this message translates to:
  /// **'자랑하기'**
  String get rankingShareTooltip;

  /// No description provided for @rankingMenuTooltip.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 메뉴'**
  String get rankingMenuTooltip;

  /// No description provided for @rankingMenuSettings.
  ///
  /// In ko, this message translates to:
  /// **'참여·닉네임 설정'**
  String get rankingMenuSettings;

  /// No description provided for @rankingMenuRules.
  ///
  /// In ko, this message translates to:
  /// **'점수 규칙'**
  String get rankingMenuRules;

  /// No description provided for @rankingTabDogs.
  ///
  /// In ko, this message translates to:
  /// **'반려견 랭킹'**
  String get rankingTabDogs;

  /// No description provided for @rankingTabBattle.
  ///
  /// In ko, this message translates to:
  /// **'지점 대항전'**
  String get rankingTabBattle;

  /// No description provided for @rankingTabHall.
  ///
  /// In ko, this message translates to:
  /// **'명예의 전당'**
  String get rankingTabHall;

  /// No description provided for @rankingEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 순위에 오른 반려견이 없어요'**
  String get rankingEmptyTitle;

  /// No description provided for @rankingEmptyCurrent.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 첫 운동을 마치면 바로 랭킹에 올라요.'**
  String get rankingEmptyCurrent;

  /// No description provided for @rankingEmptyPast.
  ///
  /// In ko, this message translates to:
  /// **'이 달에는 운동 기록이 없어요.'**
  String get rankingEmptyPast;

  /// No description provided for @rankingParticipants.
  ///
  /// In ko, this message translates to:
  /// **'참여 반려견 {count}마리'**
  String rankingParticipants(int count);

  /// No description provided for @rankingParticipantsTop.
  ///
  /// In ko, this message translates to:
  /// **'참여 반려견 {count}마리 · 상위 {top}마리'**
  String rankingParticipantsTop(int count, int top);

  /// No description provided for @rankingPrevMonth.
  ///
  /// In ko, this message translates to:
  /// **'이전 달'**
  String get rankingPrevMonth;

  /// No description provided for @rankingNextMonth.
  ///
  /// In ko, this message translates to:
  /// **'다음 달'**
  String get rankingNextMonth;

  /// No description provided for @rankingMonthInProgress.
  ///
  /// In ko, this message translates to:
  /// **'진행 중 · 운동이 끝나면 바로 반영돼요'**
  String get rankingMonthInProgress;

  /// No description provided for @rankingMonthPast.
  ///
  /// In ko, this message translates to:
  /// **'지난 달 기록'**
  String get rankingMonthPast;

  /// No description provided for @rankingJoinPrompt.
  ///
  /// In ko, this message translates to:
  /// **'{dog}도 랭킹에 올려 보세요'**
  String rankingJoinPrompt(String dog);

  /// No description provided for @rankingJoinPromptRank.
  ///
  /// In ko, this message translates to:
  /// **'참여하면 {dog} 전체 {rank}위예요'**
  String rankingJoinPromptRank(String dog, int rank);

  /// No description provided for @rankingJoinPublicInfo.
  ///
  /// In ko, this message translates to:
  /// **'닉네임과 반려견 정보만 공개돼요.'**
  String get rankingJoinPublicInfo;

  /// No description provided for @rankingJoinButton.
  ///
  /// In ko, this message translates to:
  /// **'참여하기'**
  String get rankingJoinButton;

  /// No description provided for @rankingMyBarNoScore.
  ///
  /// In ko, this message translates to:
  /// **'{dog} · 이 랭킹에서는 아직 점수가 없어요'**
  String rankingMyBarNoScore(String dog);

  /// No description provided for @rankingMyBarRank.
  ///
  /// In ko, this message translates to:
  /// **'{dog} · {rank}위'**
  String rankingMyBarRank(String dog, int rank);

  /// No description provided for @rankingMyBarRankIfJoined.
  ///
  /// In ko, this message translates to:
  /// **'{dog} · 참여하면 {rank}위'**
  String rankingMyBarRankIfJoined(String dog, int rank);

  /// No description provided for @rankingMyBarNoPoints.
  ///
  /// In ko, this message translates to:
  /// **'운동을 마치면 점수가 쌓여요'**
  String get rankingMyBarNoPoints;

  /// No description provided for @rankingMyBarKeepFirst.
  ///
  /// In ko, this message translates to:
  /// **'{points} · 1위를 지키고 있어요!'**
  String rankingMyBarKeepFirst(String points);

  /// No description provided for @rankingMyBarPointsToNext.
  ///
  /// In ko, this message translates to:
  /// **'{points} · {gap}점 더 받으면 순위가 올라요'**
  String rankingMyBarPointsToNext(String points, int gap);

  /// No description provided for @rankingBattleIntro.
  ///
  /// In ko, this message translates to:
  /// **'지점에서 운동한 모든 반려견의 거리를 더해요. 우리 반려견이 걸은 만큼 우리 지점이 앞서요!'**
  String get rankingBattleIntro;

  /// No description provided for @rankingBattleMine.
  ///
  /// In ko, this message translates to:
  /// **'내 지점'**
  String get rankingBattleMine;

  /// No description provided for @rankingBattleStats.
  ///
  /// In ko, this message translates to:
  /// **'운동 {sessions}회 · 반려견 {dogs}마리'**
  String rankingBattleStats(int sessions, int dogs);

  /// No description provided for @rankingHallEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'아직 명예의 전당이 비어 있어요'**
  String get rankingHallEmptyTitle;

  /// No description provided for @rankingHallEmptyMessage.
  ///
  /// In ko, this message translates to:
  /// **'매달 1일에 지난달 부문별 1~3위가 이곳에 올라요.'**
  String get rankingHallEmptyMessage;

  /// No description provided for @rankingHallMonthTitle.
  ///
  /// In ko, this message translates to:
  /// **'{month} 명예의 전당'**
  String rankingHallMonthTitle(String month);

  /// No description provided for @rankingPrivateDog.
  ///
  /// In ko, this message translates to:
  /// **'비공개 반려견'**
  String get rankingPrivateDog;

  /// No description provided for @rankingHallChampions.
  ///
  /// In ko, this message translates to:
  /// **'부문별 1위'**
  String get rankingHallChampions;

  /// No description provided for @rankingSettingsSaved.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 설정을 저장했어요.'**
  String get rankingSettingsSaved;

  /// No description provided for @rankingJoined.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에 참여했어요! 이번 달 순위에 바로 반영돼요.'**
  String get rankingJoined;

  /// No description provided for @rankingLeaveTitle.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에서 나갈까요?'**
  String get rankingLeaveTitle;

  /// No description provided for @rankingLeaveMessage.
  ///
  /// In ko, this message translates to:
  /// **'순위표와 명예의 전당에서 닉네임과 반려견 정보가 바로 가려져요. 점수와 배지는 그대로 쌓이고, 다시 참여하면 이번 달 순위에 바로 반영돼요.'**
  String get rankingLeaveMessage;

  /// No description provided for @rankingLeaveConfirm.
  ///
  /// In ko, this message translates to:
  /// **'나가기'**
  String get rankingLeaveConfirm;

  /// No description provided for @rankingLeft.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에서 나갔어요.'**
  String get rankingLeft;

  /// No description provided for @rankingSettingsTitle.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 설정'**
  String get rankingSettingsTitle;

  /// No description provided for @rankingJoinTitle.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에 참여해 볼까요?'**
  String get rankingJoinTitle;

  /// No description provided for @rankingSettingsIntro.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 가장 꾸준한 반려견은 누구일까요? 운동할수록 점수가 쌓이고, 매달 1~3위는 명예의 전당에 올라요.'**
  String get rankingSettingsIntro;

  /// No description provided for @rankingVisibleInfoTitle.
  ///
  /// In ko, this message translates to:
  /// **'다른 회원에게 보이는 정보'**
  String get rankingVisibleInfoTitle;

  /// No description provided for @rankingVisibleInfoList.
  ///
  /// In ko, this message translates to:
  /// **'· 닉네임\n· 반려견 이름·견종·체구, 프로필 사진(선택)\n· 이번 달 점수·운동 횟수, 배지, 수상 기록'**
  String get rankingVisibleInfoList;

  /// No description provided for @rankingPrivateInfoNote.
  ///
  /// In ko, this message translates to:
  /// **'실명·이메일·연락처는 공개되지 않아요.'**
  String get rankingPrivateInfoNote;

  /// No description provided for @rankingNicknameLabel.
  ///
  /// In ko, this message translates to:
  /// **'닉네임'**
  String get rankingNicknameLabel;

  /// No description provided for @rankingNicknameHelp.
  ///
  /// In ko, this message translates to:
  /// **'2~12자 한글·영문·숫자·밑줄(_) · 30일에 한 번 바꿀 수 있어요'**
  String get rankingNicknameHelp;

  /// No description provided for @rankingNicknameChangeableAt.
  ///
  /// In ko, this message translates to:
  /// **'{date}부터 다시 바꿀 수 있어요'**
  String rankingNicknameChangeableAt(String date);

  /// No description provided for @rankingShowPhotoTitle.
  ///
  /// In ko, this message translates to:
  /// **'반려견 사진 공개'**
  String get rankingShowPhotoTitle;

  /// No description provided for @rankingShowPhotoSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'끄면 랭킹에 기본 아이콘으로 보여요'**
  String get rankingShowPhotoSubtitle;

  /// No description provided for @rankingJoinAction.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 참여하기'**
  String get rankingJoinAction;

  /// No description provided for @rankingLeaveAction.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에서 나가기'**
  String get rankingLeaveAction;

  /// No description provided for @rankingShareText.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 {month} PawFit 운동 기록이에요! #PawFit #강아지트레드밀'**
  String rankingShareText(String dog, String month);

  /// No description provided for @rankingShareFailed.
  ///
  /// In ko, this message translates to:
  /// **'공유하지 못했어요. 잠시 후 다시 시도해 주세요.'**
  String get rankingShareFailed;

  /// No description provided for @rankingShareTitle.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 기록 자랑하기'**
  String get rankingShareTitle;

  /// No description provided for @rankingShareHint.
  ///
  /// In ko, this message translates to:
  /// **'이미지로 저장해 인스타그램·카카오톡에 올려 보세요.'**
  String get rankingShareHint;

  /// No description provided for @rankingShareButton.
  ///
  /// In ko, this message translates to:
  /// **'이미지로 공유하기'**
  String get rankingShareButton;

  /// No description provided for @rankingShareOverall.
  ///
  /// In ko, this message translates to:
  /// **'전체 {rank}위'**
  String rankingShareOverall(int rank);

  /// No description provided for @rankingShareStreak.
  ///
  /// In ko, this message translates to:
  /// **'{weeks}주 연속 운동 중'**
  String rankingShareStreak(int weeks);

  /// No description provided for @boardHeadline.
  ///
  /// In ko, this message translates to:
  /// **'{branch} 이번 달 랭킹'**
  String boardHeadline(String branch);

  /// No description provided for @boardSubtitle.
  ///
  /// In ko, this message translates to:
  /// **'{month} · 운동이 끝나면 바로 반영돼요'**
  String boardSubtitle(String month);

  /// No description provided for @boardJoinHint.
  ///
  /// In ko, this message translates to:
  /// **'PawFit 앱에서 「랭킹 참여」를 켜면 우리 아이 이름이 여기에 올라와요!'**
  String get boardJoinHint;

  /// No description provided for @boardBattleRank.
  ///
  /// In ko, this message translates to:
  /// **'지점 대항전 {rank}위 · {distance}'**
  String boardBattleRank(int rank, String distance);

  /// No description provided for @boardEmptyTitle.
  ///
  /// In ko, this message translates to:
  /// **'이번 달 1등의 주인공이 되어 보세요!'**
  String get boardEmptyTitle;

  /// No description provided for @boardEmptyMessage.
  ///
  /// In ko, this message translates to:
  /// **'이 지점에서 운동을 마치면 바로 순위에 올라요.'**
  String get boardEmptyMessage;

  /// No description provided for @rankingEntrySemantics.
  ///
  /// In ko, this message translates to:
  /// **'{rank}위 {dog}, {points}'**
  String rankingEntrySemantics(int rank, String dog, String points);

  /// No description provided for @rankingMineBadge.
  ///
  /// In ko, this message translates to:
  /// **'내 반려견'**
  String get rankingMineBadge;

  /// No description provided for @badgeSemantics.
  ///
  /// In ko, this message translates to:
  /// **'{name} 배지'**
  String badgeSemantics(String name);

  /// No description provided for @badgeSemanticsLocked.
  ///
  /// In ko, this message translates to:
  /// **'{name} 배지 (아직 받지 않음)'**
  String badgeSemanticsLocked(String name);

  /// No description provided for @rankingPointsChipVoided.
  ///
  /// In ko, this message translates to:
  /// **'점수 무효'**
  String get rankingPointsChipVoided;

  /// No description provided for @rankingPointsChipZero.
  ///
  /// In ko, this message translates to:
  /// **'0점'**
  String get rankingPointsChipZero;

  /// No description provided for @rankingPointsChipSemantics.
  ///
  /// In ko, this message translates to:
  /// **'랭킹 점수 {label}'**
  String rankingPointsChipSemantics(String label);

  /// No description provided for @rankingBreakdownTitle.
  ///
  /// In ko, this message translates to:
  /// **'이번 운동 점수'**
  String get rankingBreakdownTitle;

  /// No description provided for @rankingBreakdownVoided.
  ///
  /// In ko, this message translates to:
  /// **'운영자 확인 결과 이 운동의 점수는 무효 처리되었어요.'**
  String get rankingBreakdownVoided;

  /// No description provided for @rankingBreakdownDefault.
  ///
  /// In ko, this message translates to:
  /// **'꾸준히 운동할수록 점수가 쌓여요.'**
  String get rankingBreakdownDefault;

  /// No description provided for @rankingBreakdownAttendance.
  ///
  /// In ko, this message translates to:
  /// **'출석'**
  String get rankingBreakdownAttendance;

  /// No description provided for @rankingBreakdownAttendanceCaption.
  ///
  /// In ko, this message translates to:
  /// **'5분 이상 운동 (하루 1회)'**
  String get rankingBreakdownAttendanceCaption;

  /// No description provided for @rankingBreakdownGoal.
  ///
  /// In ko, this message translates to:
  /// **'달성'**
  String get rankingBreakdownGoal;

  /// No description provided for @rankingBreakdownGoalCaption.
  ///
  /// In ko, this message translates to:
  /// **'프로그램 목표 시간 대비 (최대 10)'**
  String get rankingBreakdownGoalCaption;

  /// No description provided for @rankingBreakdownDistanceCaption.
  ///
  /// In ko, this message translates to:
  /// **'100m당 1점 (최대 20)'**
  String get rankingBreakdownDistanceCaption;

  /// No description provided for @rankingBreakdownWeeklyBonus.
  ///
  /// In ko, this message translates to:
  /// **'주간 보너스'**
  String get rankingBreakdownWeeklyBonus;

  /// No description provided for @rankingBreakdownWeeklyBonusCaption.
  ///
  /// In ko, this message translates to:
  /// **'이번 주 두 번째 운동'**
  String get rankingBreakdownWeeklyBonusCaption;

  /// No description provided for @rankingBreakdownTotal.
  ///
  /// In ko, this message translates to:
  /// **'합계'**
  String get rankingBreakdownTotal;

  /// No description provided for @rankingRulesTitle.
  ///
  /// In ko, this message translates to:
  /// **'점수는 이렇게 쌓여요'**
  String get rankingRulesTitle;

  /// No description provided for @rankingRulesIntro.
  ///
  /// In ko, this message translates to:
  /// **'많이보다 꾸준히! 무리한 운동은 점수에 도움이 되지 않아요.'**
  String get rankingRulesIntro;

  /// No description provided for @rankingRuleAttendanceTitle.
  ///
  /// In ko, this message translates to:
  /// **'출석 10점'**
  String get rankingRuleAttendanceTitle;

  /// No description provided for @rankingRuleAttendanceBody.
  ///
  /// In ko, this message translates to:
  /// **'5분 이상 운동하면 받아요. 반려견마다 하루 한 번만 점수를 받아요.'**
  String get rankingRuleAttendanceBody;

  /// No description provided for @rankingRuleGoalTitle.
  ///
  /// In ko, this message translates to:
  /// **'달성 최대 10점'**
  String get rankingRuleGoalTitle;

  /// No description provided for @rankingRuleGoalBody.
  ///
  /// In ko, this message translates to:
  /// **'프로그램 목표 시간을 채운 만큼 받아요. 중간에 멈춰도 감점은 없어요.'**
  String get rankingRuleGoalBody;

  /// No description provided for @rankingRuleDistanceTitle.
  ///
  /// In ko, this message translates to:
  /// **'거리 최대 20점'**
  String get rankingRuleDistanceTitle;

  /// No description provided for @rankingRuleDistanceBody.
  ///
  /// In ko, this message translates to:
  /// **'100m마다 1점이에요. 2km를 넘게 걸어도 20점까지만 받아요.'**
  String get rankingRuleDistanceBody;

  /// No description provided for @rankingRuleWeeklyTitle.
  ///
  /// In ko, this message translates to:
  /// **'주간 보너스 20점'**
  String get rankingRuleWeeklyTitle;

  /// No description provided for @rankingRuleWeeklyBody.
  ///
  /// In ko, this message translates to:
  /// **'한 주(월~일)에 두 번 이상 운동하면 받아요.'**
  String get rankingRuleWeeklyBody;

  /// No description provided for @rankingRuleMonthlyTitle.
  ///
  /// In ko, this message translates to:
  /// **'월간 랭킹'**
  String get rankingRuleMonthlyTitle;

  /// No description provided for @rankingRuleMonthlyBody.
  ///
  /// In ko, this message translates to:
  /// **'매달 1일에 새로 시작해요. 전체·지점·체급별로 순위를 매기고, 동점이면 먼저 도달한 반려견이 앞서요.'**
  String get rankingRuleMonthlyBody;

  /// No description provided for @rankingRuleHallTitle.
  ///
  /// In ko, this message translates to:
  /// **'명예의 전당'**
  String get rankingRuleHallTitle;

  /// No description provided for @rankingRuleHallBody.
  ///
  /// In ko, this message translates to:
  /// **'달이 끝나면 부문별 1~3위가 명예의 전당에 오르고 「시상대」 배지를 받아요.'**
  String get rankingRuleHallBody;

  /// No description provided for @rankingRulesSafety.
  ///
  /// In ko, this message translates to:
  /// **'반려견 컨디션이 좋지 않으면 운동을 쉬어 주세요. 이상이 보이면 트레드밀의 비상정지 버튼을 눌러 주세요.'**
  String get rankingRulesSafety;

  /// No description provided for @demoPillStart.
  ///
  /// In ko, this message translates to:
  /// **'DEMO · 데모 계정으로 시작'**
  String get demoPillStart;

  /// No description provided for @demoControlTitle.
  ///
  /// In ko, this message translates to:
  /// **'데모 컨트롤'**
  String get demoControlTitle;

  /// No description provided for @demoIntro.
  ///
  /// In ko, this message translates to:
  /// **'목업 서버로 동작하는 데모 앱이에요. 실제 서버·결제·트레드밀과 연결되지 않고, 앱을 다시 켜면 처음 상태로 돌아가요.'**
  String get demoIntro;

  /// No description provided for @demoSectionTreadmill.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀 기기'**
  String get demoSectionTreadmill;

  /// No description provided for @demoAddDogFirst.
  ///
  /// In ko, this message translates to:
  /// **'반려견을 먼저 등록해 주세요.'**
  String get demoAddDogFirst;

  /// No description provided for @demoTreadmillDetail.
  ///
  /// In ko, this message translates to:
  /// **'{dog} · 매장 기기가 보내는 운동 기록을 흉내 내요.'**
  String demoTreadmillDetail(String dog);

  /// No description provided for @demoStartWorkout.
  ///
  /// In ko, this message translates to:
  /// **'운동 시작'**
  String get demoStartWorkout;

  /// No description provided for @demoSpeedTitle.
  ///
  /// In ko, this message translates to:
  /// **'시뮬레이션 속도'**
  String get demoSpeedTitle;

  /// No description provided for @demoSpeedReal.
  ///
  /// In ko, this message translates to:
  /// **'실제 시간'**
  String get demoSpeedReal;

  /// No description provided for @demoSpeed10x.
  ///
  /// In ko, this message translates to:
  /// **'10배'**
  String get demoSpeed10x;

  /// No description provided for @demoSpeed30x.
  ///
  /// In ko, this message translates to:
  /// **'30배'**
  String get demoSpeed30x;

  /// No description provided for @demoSectionAi.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 서버'**
  String get demoSectionAi;

  /// No description provided for @demoAiDetail.
  ///
  /// In ko, this message translates to:
  /// **'운동이 끝나고 몇 초 뒤 보행 분석 리포트가 도착해요.'**
  String get demoAiDetail;

  /// No description provided for @demoAiFinished.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석이 끝났어요. 알림을 확인해 보세요.'**
  String get demoAiFinished;

  /// No description provided for @demoFinishPending.
  ///
  /// In ko, this message translates to:
  /// **'대기 중인 분석 바로 끝내기'**
  String get demoFinishPending;

  /// No description provided for @demoNoPending.
  ///
  /// In ko, this message translates to:
  /// **'대기 중인 분석 없음'**
  String get demoNoPending;

  /// No description provided for @demoSectionOwners.
  ///
  /// In ko, this message translates to:
  /// **'다른 보호자'**
  String get demoSectionOwners;

  /// No description provided for @demoOwnersDetail.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에 참여한 다른 보호자의 응원을 받아요.'**
  String get demoOwnersDetail;

  /// No description provided for @demoReceiveCheer.
  ///
  /// In ko, this message translates to:
  /// **'응원 받기'**
  String get demoReceiveCheer;

  /// No description provided for @demoSectionData.
  ///
  /// In ko, this message translates to:
  /// **'데이터'**
  String get demoSectionData;

  /// No description provided for @demoReset.
  ///
  /// In ko, this message translates to:
  /// **'처음 상태로 되돌리기'**
  String get demoReset;

  /// No description provided for @demoAccount.
  ///
  /// In ko, this message translates to:
  /// **'데모 계정 {email} · {password}'**
  String demoAccount(String email, String password);

  /// No description provided for @demoWorkoutStarted.
  ///
  /// In ko, this message translates to:
  /// **'{dog}의 운동이 시작됐어요. 실시간 기록이 운동 탭에 표시돼요.'**
  String demoWorkoutStarted(String dog);

  /// No description provided for @demoCheerNeedsConsent.
  ///
  /// In ko, this message translates to:
  /// **'랭킹에 참여해야 응원을 받을 수 있어요. 마이페이지 > 동의 관리에서 바꿀 수 있어요.'**
  String get demoCheerNeedsConsent;

  /// No description provided for @demoCheerAllDone.
  ///
  /// In ko, this message translates to:
  /// **'이번 달에는 다른 보호자가 모두 응원했어요.'**
  String get demoCheerAllDone;

  /// No description provided for @demoCheerReceived.
  ///
  /// In ko, this message translates to:
  /// **'{nickname}님이 {dog} 응원했어요. 알림을 확인해 보세요.'**
  String demoCheerReceived(String nickname, String dog);

  /// No description provided for @demoResetTitle.
  ///
  /// In ko, this message translates to:
  /// **'처음 상태로 되돌릴까요?'**
  String get demoResetTitle;

  /// No description provided for @demoResetMessage.
  ///
  /// In ko, this message translates to:
  /// **'데모에서 만든 예약·운동 기록·설정이 모두 지워지고 샘플 데이터로 다시 시작해요.'**
  String get demoResetMessage;

  /// No description provided for @demoResetConfirm.
  ///
  /// In ko, this message translates to:
  /// **'되돌리기'**
  String get demoResetConfirm;

  /// No description provided for @demoResumed.
  ///
  /// In ko, this message translates to:
  /// **'운동을 다시 시작했어요.'**
  String get demoResumed;

  /// No description provided for @demoPaused.
  ///
  /// In ko, this message translates to:
  /// **'트레드밀을 잠시 멈췄어요.'**
  String get demoPaused;

  /// No description provided for @demoResume.
  ///
  /// In ko, this message translates to:
  /// **'다시 시작'**
  String get demoResume;

  /// No description provided for @demoPause.
  ///
  /// In ko, this message translates to:
  /// **'일시정지'**
  String get demoPause;

  /// No description provided for @demoEmergencyDone.
  ///
  /// In ko, this message translates to:
  /// **'비상정지로 운동이 중단됐어요. 받은 만큼 점수가 쌓여요.'**
  String get demoEmergencyDone;

  /// No description provided for @demoEmergencyStop.
  ///
  /// In ko, this message translates to:
  /// **'비상정지'**
  String get demoEmergencyStop;

  /// No description provided for @demoFinishedDone.
  ///
  /// In ko, this message translates to:
  /// **'운동을 마쳤어요. 점수와 배지, AI 리포트를 확인해 보세요.'**
  String get demoFinishedDone;

  /// No description provided for @demoFinishNow.
  ///
  /// In ko, this message translates to:
  /// **'바로 완료'**
  String get demoFinishNow;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'카드'**
  String get serverPaymentMethodCard;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'신용카드'**
  String get serverPaymentMethodCreditCard;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'체크카드'**
  String get serverPaymentMethodDebitCard;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'간편결제'**
  String get serverPaymentMethodEasyPay;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'카카오페이'**
  String get serverPaymentMethodKakaoPay;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'네이버페이'**
  String get serverPaymentMethodNaverPay;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'토스페이'**
  String get serverPaymentMethodTossPay;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'페이코'**
  String get serverPaymentMethodPayco;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'삼성페이'**
  String get serverPaymentMethodSamsungPay;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'애플페이'**
  String get serverPaymentMethodApplePay;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'계좌이체'**
  String get serverPaymentMethodTransfer;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'가상계좌'**
  String get serverPaymentMethodVirtualAccount;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'휴대폰'**
  String get serverPaymentMethodMobile;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'현장 결제'**
  String get serverPaymentMethodOnsite;

  /// 결제 수단 표시 이름
  ///
  /// In ko, this message translates to:
  /// **'이용권'**
  String get serverPaymentMethodPass;

  /// No description provided for @keypointNose.
  ///
  /// In ko, this message translates to:
  /// **'코'**
  String get keypointNose;

  /// No description provided for @keypointWithers.
  ///
  /// In ko, this message translates to:
  /// **'기갑(어깨 위)'**
  String get keypointWithers;

  /// No description provided for @keypointTailBase.
  ///
  /// In ko, this message translates to:
  /// **'꼬리 시작점'**
  String get keypointTailBase;

  /// No description provided for @keypointLeftElbow.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 앞다리 팔꿈치'**
  String get keypointLeftElbow;

  /// No description provided for @keypointLeftCarpus.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 앞발목'**
  String get keypointLeftCarpus;

  /// No description provided for @keypointLeftFrontPaw.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 앞발'**
  String get keypointLeftFrontPaw;

  /// No description provided for @keypointRightElbow.
  ///
  /// In ko, this message translates to:
  /// **'오른쪽 앞다리 팔꿈치'**
  String get keypointRightElbow;

  /// No description provided for @keypointRightCarpus.
  ///
  /// In ko, this message translates to:
  /// **'오른쪽 앞발목'**
  String get keypointRightCarpus;

  /// No description provided for @keypointRightFrontPaw.
  ///
  /// In ko, this message translates to:
  /// **'오른쪽 앞발'**
  String get keypointRightFrontPaw;

  /// No description provided for @keypointLeftStifle.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 뒷다리 무릎'**
  String get keypointLeftStifle;

  /// No description provided for @keypointLeftHock.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 뒷발목(비절)'**
  String get keypointLeftHock;

  /// No description provided for @keypointLeftHindPaw.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 뒷발'**
  String get keypointLeftHindPaw;

  /// No description provided for @keypointRightStifle.
  ///
  /// In ko, this message translates to:
  /// **'오른쪽 뒷다리 무릎'**
  String get keypointRightStifle;

  /// No description provided for @keypointRightHock.
  ///
  /// In ko, this message translates to:
  /// **'오른쪽 뒷발목(비절)'**
  String get keypointRightHock;

  /// No description provided for @keypointRightHindPaw.
  ///
  /// In ko, this message translates to:
  /// **'오른쪽 뒷발'**
  String get keypointRightHindPaw;

  /// No description provided for @analysisReportTitle.
  ///
  /// In ko, this message translates to:
  /// **'AI 분석 리포트'**
  String get analysisReportTitle;

  /// No description provided for @analysisModelVersion.
  ///
  /// In ko, this message translates to:
  /// **'모델 {version}'**
  String analysisModelVersion(String version);

  /// No description provided for @analysisStatDuration.
  ///
  /// In ko, this message translates to:
  /// **'운동 시간'**
  String get analysisStatDuration;

  /// No description provided for @analysisStatDistance.
  ///
  /// In ko, this message translates to:
  /// **'이동 거리'**
  String get analysisStatDistance;

  /// No description provided for @analysisStatAvgSpeed.
  ///
  /// In ko, this message translates to:
  /// **'평균 속도'**
  String get analysisStatAvgSpeed;

  /// No description provided for @analysisPendingFailedTitle.
  ///
  /// In ko, this message translates to:
  /// **'분석을 완료하지 못했어요'**
  String get analysisPendingFailedTitle;

  /// No description provided for @analysisPendingTitle.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상을 분석하고 있어요'**
  String get analysisPendingTitle;

  /// No description provided for @analysisPendingFailedMessage.
  ///
  /// In ko, this message translates to:
  /// **'영상 품질이나 촬영 각도 문제로 분석하지 못했어요. 헬스장에서 확인 후 다시 분석해 드릴게요.'**
  String get analysisPendingFailedMessage;

  /// No description provided for @analysisPendingMessage.
  ///
  /// In ko, this message translates to:
  /// **'관절 움직임과 보행 패턴을 분석 중이에요. 완료되면 알림으로 알려 드릴게요.'**
  String get analysisPendingMessage;

  /// No description provided for @analysisSummaryTitle.
  ///
  /// In ko, this message translates to:
  /// **'분석 결과 요약'**
  String get analysisSummaryTitle;

  /// No description provided for @analysisAnomalySection.
  ///
  /// In ko, this message translates to:
  /// **'이상 움직임 탐지'**
  String get analysisAnomalySection;

  /// No description provided for @analysisConfidenceValue.
  ///
  /// In ko, this message translates to:
  /// **'분석 신뢰도 {percent}%'**
  String analysisConfidenceValue(String percent);

  /// No description provided for @analysisPatternDiffCaption.
  ///
  /// In ko, this message translates to:
  /// **'평소 보행 패턴과의 차이'**
  String get analysisPatternDiffCaption;

  /// No description provided for @analysisScaleSimilar.
  ///
  /// In ko, this message translates to:
  /// **'비슷함'**
  String get analysisScaleSimilar;

  /// No description provided for @analysisScaleDifferent.
  ///
  /// In ko, this message translates to:
  /// **'차이 큼'**
  String get analysisScaleDifferent;

  /// No description provided for @analysisNoAnomaly.
  ///
  /// In ko, this message translates to:
  /// **'평소와 다른 관절 패턴이 발견되지 않았어요.'**
  String get analysisNoAnomaly;

  /// No description provided for @analysisVsBaseline.
  ///
  /// In ko, this message translates to:
  /// **'기준선 대비 {value}'**
  String analysisVsBaseline(String value);

  /// No description provided for @analysisStepsCount.
  ///
  /// In ko, this message translates to:
  /// **'{count}보'**
  String analysisStepsCount(int count);

  /// No description provided for @analysisStrideTime.
  ///
  /// In ko, this message translates to:
  /// **'걸음걸이 주기'**
  String get analysisStrideTime;

  /// No description provided for @analysisUnitSeconds.
  ///
  /// In ko, this message translates to:
  /// **'초'**
  String get analysisUnitSeconds;

  /// No description provided for @analysisGaitVariability.
  ///
  /// In ko, this message translates to:
  /// **'보행 변동성'**
  String get analysisGaitVariability;

  /// No description provided for @analysisFrontSymmetry.
  ///
  /// In ko, this message translates to:
  /// **'앞다리 대칭'**
  String get analysisFrontSymmetry;

  /// No description provided for @analysisHindSymmetry.
  ///
  /// In ko, this message translates to:
  /// **'뒷다리 대칭'**
  String get analysisHindSymmetry;

  /// No description provided for @analysisGaitSection.
  ///
  /// In ko, this message translates to:
  /// **'보행 패턴 분석'**
  String get analysisGaitSection;

  /// No description provided for @analysisRhythmScore.
  ///
  /// In ko, this message translates to:
  /// **'보행 리듬 점수'**
  String get analysisRhythmScore;

  /// No description provided for @analysisJointSection.
  ///
  /// In ko, this message translates to:
  /// **'관절 움직임 분석 · {count}개 관절'**
  String analysisJointSection(int count);

  /// No description provided for @analysisLegendNear.
  ///
  /// In ko, this message translates to:
  /// **'왼쪽 다리 (카메라 쪽)'**
  String get analysisLegendNear;

  /// No description provided for @analysisLegendFar.
  ///
  /// In ko, this message translates to:
  /// **'오른쪽 다리'**
  String get analysisLegendFar;

  /// No description provided for @analysisColJoint.
  ///
  /// In ko, this message translates to:
  /// **'관절'**
  String get analysisColJoint;

  /// No description provided for @analysisColRom.
  ///
  /// In ko, this message translates to:
  /// **'가동 범위'**
  String get analysisColRom;

  /// No description provided for @analysisColVsBaseline.
  ///
  /// In ko, this message translates to:
  /// **'기준선 대비'**
  String get analysisColVsBaseline;

  /// No description provided for @analysisAngleRange.
  ///
  /// In ko, this message translates to:
  /// **'각도 {min}°~{max}°'**
  String analysisAngleRange(String min, String max);

  /// No description provided for @analysisPatternDiff.
  ///
  /// In ko, this message translates to:
  /// **'패턴 차이'**
  String get analysisPatternDiff;

  /// No description provided for @analysisCompareTitle.
  ///
  /// In ko, this message translates to:
  /// **'이전 운동 대비 변화 ({date})'**
  String analysisCompareTitle(String date);

  /// No description provided for @analysisVideoSkeleton.
  ///
  /// In ko, this message translates to:
  /// **'스켈레톤 영상'**
  String get analysisVideoSkeleton;

  /// No description provided for @analysisVideoSection.
  ///
  /// In ko, this message translates to:
  /// **'운동 영상'**
  String get analysisVideoSection;

  /// No description provided for @analysisCareNotes.
  ///
  /// In ko, this message translates to:
  /// **'운동 관리 참고사항'**
  String get analysisCareNotes;

  /// No description provided for @healthNoChange.
  ///
  /// In ko, this message translates to:
  /// **'변화 없음'**
  String get healthNoChange;

  /// No description provided for @healthBaselineLabel.
  ///
  /// In ko, this message translates to:
  /// **'기준선'**
  String get healthBaselineLabel;

  /// No description provided for @healthSkeletonSemantics.
  ///
  /// In ko, this message translates to:
  /// **'측면에서 본 반려견 관절 도식'**
  String get healthSkeletonSemantics;

  /// No description provided for @healthSkeletonSemanticsFlagged.
  ///
  /// In ko, this message translates to:
  /// **'측면에서 본 반려견 관절 도식, {details}'**
  String healthSkeletonSemanticsFlagged(String details);

  /// No description provided for @healthJointLevel.
  ///
  /// In ko, this message translates to:
  /// **'{joint} {level}'**
  String healthJointLevel(String joint, String level);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
