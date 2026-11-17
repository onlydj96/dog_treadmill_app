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
