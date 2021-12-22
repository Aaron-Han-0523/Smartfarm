
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations returned
/// by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
/// import 'gen_l10n/app_localizations.dart';
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
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es')
  ];

  /// The conventional newborn programmer greeting
  ///
  /// In en, this message translates to:
  /// **'Hello World!'**
  String get helloWorld;

  /// Login ID.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get loginID;

  /// Login Password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPW;

  /// Login Fail Text.
  ///
  /// In en, this message translates to:
  /// **'Check your ID or Password'**
  String get loginDialogText;

  /// Login Fail Button.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get loginDialogButton;

  /// Login Button.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up Button.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Explain Sign up Button.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your Username or Password?'**
  String get signUpText;

  /// signUpHeader
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpHeader;

  /// check page1 title
  ///
  /// In en, this message translates to:
  /// **'프로그램 서비스 이용약관'**
  String get signUpcheckPage1;

  /// checkpage2 title
  ///
  /// In en, this message translates to:
  /// **'개인정보 수집 및 활동 동의'**
  String get signUpcheckPage2;

  /// botton button1 title
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get signUpbottomButton1;

  /// botton button2 title
  ///
  /// In en, this message translates to:
  /// **'Registation'**
  String get signUpbottomButton2;

  /// first page texttitle
  ///
  /// In en, this message translates to:
  /// **'User ID'**
  String get signUpID;

  /// first page texttitle
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get signUpPW;

  /// first page texttitle
  ///
  /// In en, this message translates to:
  /// **'Retry Pasword'**
  String get signUprepw;

  /// first page texttitle
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get signUpmail;

  /// first page texttitle
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get signUpcom;

  /// first page texttitle
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get signUpname;

  /// first page texttitle
  ///
  /// In en, this message translates to:
  /// **'Personal ID'**
  String get signUppersonal;

  /// first page texttitle
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get signUpdept;

  /// first page texttitle
  ///
  /// In en, this message translates to:
  /// **'Select Department'**
  String get signUpdeptselect;

  /// signUpcheckbox text
  ///
  /// In en, this message translates to:
  /// **'Yes, I agree'**
  String get signUpcheckbox;

  /// signUpAllcheckbox text
  ///
  /// In en, this message translates to:
  /// **'Yes, I agree all'**
  String get signUpAllcheckbox;

  /// signUppwForm1
  ///
  /// In en, this message translates to:
  /// **'비밀번호'**
  String get signUppwForm1;

  /// signUppwForm2
  ///
  /// In en, this message translates to:
  /// **'특수문자, 대소문자, 숫자 포함 8자 이상 15자 이내로 입력하세요.'**
  String get signUppwForm2;

  /// signUpmailForm1
  ///
  /// In en, this message translates to:
  /// **'이메일'**
  String get signUpmailForm1;

  /// signUpmailForm2
  ///
  /// In en, this message translates to:
  /// **'이메일을 입력해주세요'**
  String get signUpmailForm2;

  /// This is app title and some texts.
  ///
  /// In en, this message translates to:
  /// **'My Punch List'**
  String get appTitle;

  /// one of the state of the punch list.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tile1;

  /// one of the state of the punch list.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get tile2;

  /// one of the state of the punch list.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get tile3;

  /// one of the state of the punch list.
  ///
  /// In en, this message translates to:
  /// **'Req for\nClose'**
  String get tile41;

  /// one of the state of the punch list.
  ///
  /// In en, this message translates to:
  /// **'Req for Close'**
  String get tile4;

  /// one of the state of the punch list.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get tile5;

  /// punch list bottom button.
  ///
  /// In en, this message translates to:
  /// **'Add Punch Issue'**
  String get pListbutton1;

  /// punch list bottom button.
  ///
  /// In en, this message translates to:
  /// **'Upload Photos'**
  String get pListbutton2;

  /// Complete button.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get completeButton;

  /// Complete title.
  ///
  /// In en, this message translates to:
  /// **'Punch Complete'**
  String get completeTitle;

  /// Complete text.
  ///
  /// In en, this message translates to:
  /// **'Comment of Not Accepted'**
  String get completeText;

  /// Complete page title.
  ///
  /// In en, this message translates to:
  /// **'Attachment'**
  String get completePageTitle;

  /// Complete Page button1.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get completePageButton1;

  /// Complete Page button2.
  ///
  /// In en, this message translates to:
  /// **'Complete Punch'**
  String get completePageButton2;

  /// Complete Page Description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get completePageDescription;

  /// Complete Page Description Label.
  ///
  /// In en, this message translates to:
  /// **'Valve changed'**
  String get completePageDescriptionLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
