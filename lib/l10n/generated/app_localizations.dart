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
