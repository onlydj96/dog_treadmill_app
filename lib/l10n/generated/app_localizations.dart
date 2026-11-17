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
