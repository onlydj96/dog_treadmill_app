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
