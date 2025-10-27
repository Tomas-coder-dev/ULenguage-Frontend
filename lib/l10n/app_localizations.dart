import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_qu.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
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
    Locale('es'),
    Locale('qu')
  ];

  /// No description provided for @packageQuechua.
  ///
  /// In en, this message translates to:
  /// **'Quechua Language Package'**
  String get packageQuechua;

  /// No description provided for @packageCuscoGuide.
  ///
  /// In en, this message translates to:
  /// **'Cusco Guide'**
  String get packageCuscoGuide;

  /// No description provided for @navbarHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navbarHome;

  /// No description provided for @navbarTranslate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get navbarTranslate;

  /// No description provided for @navbarExplore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get navbarExplore;

  /// No description provided for @navbarProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navbarProfile;

  /// No description provided for @ocrTitle.
  ///
  /// In en, this message translates to:
  /// **'OCR Scan'**
  String get ocrTitle;

  /// No description provided for @ocrScanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get ocrScanning;

  /// No description provided for @ocrSelectImage.
  ///
  /// In en, this message translates to:
  /// **'Select an image to analyze and detect cultural objects.'**
  String get ocrSelectImage;

  /// No description provided for @ocrScanImage.
  ///
  /// In en, this message translates to:
  /// **'Scan Image'**
  String get ocrScanImage;

  /// No description provided for @ocrScanError.
  ///
  /// In en, this message translates to:
  /// **'OCR scan error'**
  String get ocrScanError;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning...'**
  String get scanning;

  /// No description provided for @scanAndSelectLang.
  ///
  /// In en, this message translates to:
  /// **'Scan an image and select the language for cultural information.'**
  String get scanAndSelectLang;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @photo.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get photo;

  /// No description provided for @noObjectsDetected.
  ///
  /// In en, this message translates to:
  /// **'No objects detected.'**
  String get noObjectsDetected;

  /// No description provided for @newScan.
  ///
  /// In en, this message translates to:
  /// **'New Scan'**
  String get newScan;

  /// No description provided for @culturalScan.
  ///
  /// In en, this message translates to:
  /// **'Cultural Scan'**
  String get culturalScan;

  /// No description provided for @detectedLang.
  ///
  /// In en, this message translates to:
  /// **'Detected language: {lang}'**
  String detectedLang(Object lang);

  /// No description provided for @culturalAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Cultural Analysis'**
  String get culturalAnalysis;

  /// No description provided for @identification.
  ///
  /// In en, this message translates to:
  /// **'Identification'**
  String get identification;

  /// No description provided for @culturalExplanation.
  ///
  /// In en, this message translates to:
  /// **'Cultural Explanation'**
  String get culturalExplanation;

  /// No description provided for @translation.
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// No description provided for @searchSitesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search sites or routes...'**
  String get searchSitesPlaceholder;

  /// No description provided for @errorOpenMaps.
  ///
  /// In en, this message translates to:
  /// **'Could not open Google Maps'**
  String get errorOpenMaps;

  /// No description provided for @culturalUser.
  ///
  /// In en, this message translates to:
  /// **'Cultural user'**
  String get culturalUser;

  /// No description provided for @achievementsActivity.
  ///
  /// In en, this message translates to:
  /// **'Achievements & Activity'**
  String get achievementsActivity;

  /// No description provided for @culturalAchievements.
  ///
  /// In en, this message translates to:
  /// **'8 Cultural achievements'**
  String get culturalAchievements;

  /// No description provided for @keepLearning.
  ///
  /// In en, this message translates to:
  /// **'Keep learning languages and exploring!'**
  String get keepLearning;

  /// No description provided for @translations.
  ///
  /// In en, this message translates to:
  /// **'248 Translations'**
  String get translations;

  /// No description provided for @translationsToday.
  ///
  /// In en, this message translates to:
  /// **'+12 translations today'**
  String get translationsToday;

  /// No description provided for @placesExplored.
  ///
  /// In en, this message translates to:
  /// **'4 Places explored'**
  String get placesExplored;

  /// No description provided for @culturalRoutes.
  ///
  /// In en, this message translates to:
  /// **'3 cultural routes'**
  String get culturalRoutes;

  /// No description provided for @accountPreferences.
  ///
  /// In en, this message translates to:
  /// **'Account & Preferences'**
  String get accountPreferences;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @accountSettings.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get accountSettings;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & support'**
  String get helpSupport;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logout;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'v1.0.0 • ULenguage'**
  String get version;

  /// No description provided for @connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get connected;

  /// No description provided for @packagesCount.
  ///
  /// In en, this message translates to:
  /// **'3 packages'**
  String get packagesCount;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {user}!'**
  String welcomeUser(Object user);

  /// No description provided for @culturalAdventure.
  ///
  /// In en, this message translates to:
  /// **'Your cultural adventure continues'**
  String get culturalAdventure;

  /// No description provided for @culturalProgress.
  ///
  /// In en, this message translates to:
  /// **'Cultural Progress'**
  String get culturalProgress;

  /// No description provided for @exploringAndeanCultures.
  ///
  /// In en, this message translates to:
  /// **'Exploring Andean cultures'**
  String get exploringAndeanCultures;

  /// No description provided for @keepExploring.
  ///
  /// In en, this message translates to:
  /// **'Keep exploring to unlock new horizons'**
  String get keepExploring;

  /// No description provided for @languageWindowQuote.
  ///
  /// In en, this message translates to:
  /// **'Each language is a window to the soul of a people'**
  String get languageWindowQuote;

  /// No description provided for @enjoyLearning.
  ///
  /// In en, this message translates to:
  /// **'Enjoy learning and exploring new cultures. Your connection with Andean cultures grows every day.'**
  String get enjoyLearning;

  /// No description provided for @availablePackages.
  ///
  /// In en, this message translates to:
  /// **'Available Packages:'**
  String get availablePackages;

  /// No description provided for @downloadOffline.
  ///
  /// In en, this message translates to:
  /// **'Download content to use the app offline.'**
  String get downloadOffline;

  /// No description provided for @quechuaPackage.
  ///
  /// In en, this message translates to:
  /// **'Quechua Language Package'**
  String get quechuaPackage;

  /// No description provided for @cuscoGuide.
  ///
  /// In en, this message translates to:
  /// **'Cusco Guide'**
  String get cuscoGuide;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'ULenguage'**
  String get appName;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Learn, translate and connect\nwith the Andean world.'**
  String get welcomeSubtitle;

  /// No description provided for @startAdventure.
  ///
  /// In en, this message translates to:
  /// **'Start your adventure!'**
  String get startAdventure;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get login;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPassword;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get continueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get register;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @translate.
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @scanText.
  ///
  /// In en, this message translates to:
  /// **'Scan text'**
  String get scanText;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get takePhoto;

  /// No description provided for @selectFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Select from gallery'**
  String get selectFromGallery;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @quechua.
  ///
  /// In en, this message translates to:
  /// **'Cusco Quechua'**
  String get quechua;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @authErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication error'**
  String get authErrorTitle;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'es', 'qu'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'qu': return AppLocalizationsQu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
