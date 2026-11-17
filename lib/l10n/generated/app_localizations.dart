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
