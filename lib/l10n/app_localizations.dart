import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
    Locale('en'),
    Locale('zh'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Lighter'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Start gently. Fast consistently.'**
  String get tagline;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @onboardingWelcome.
  ///
  /// In en, this message translates to:
  /// **'A lighter way to start fasting'**
  String get onboardingWelcome;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In en, this message translates to:
  /// **'Build a gentle rhythm around your real life. No extremes and no shame.'**
  String get onboardingWelcomeBody;

  /// No description provided for @safetyTitle.
  ///
  /// In en, this message translates to:
  /// **'How you feel matters most'**
  String get safetyTitle;

  /// No description provided for @safetyBody.
  ///
  /// In en, this message translates to:
  /// **'Start gently, stop when unwell, and ask a professional when you are unsure.'**
  String get safetyBody;

  /// No description provided for @safetyConsent.
  ///
  /// In en, this message translates to:
  /// **'I understand Lighter does not provide diagnosis or medical advice'**
  String get safetyConsent;

  /// No description provided for @screeningTitle.
  ///
  /// In en, this message translates to:
  /// **'Before we make a plan'**
  String get screeningTitle;

  /// No description provided for @screeningQuestion.
  ///
  /// In en, this message translates to:
  /// **'Does any of the following apply to you?'**
  String get screeningQuestion;

  /// No description provided for @screeningBlocked.
  ///
  /// In en, this message translates to:
  /// **'Fasting may not be right for you'**
  String get screeningBlocked;

  /// No description provided for @screeningBlockedBody.
  ///
  /// In en, this message translates to:
  /// **'For your safety, Lighter cannot create a fasting plan. Your health matters more than a plan.'**
  String get screeningBlockedBody;

  /// No description provided for @goalTitle.
  ///
  /// In en, this message translates to:
  /// **'What would you most like to improve?'**
  String get goalTitle;

  /// No description provided for @routineTitle.
  ///
  /// In en, this message translates to:
  /// **'Make the plan fit your life'**
  String get routineTitle;

  /// No description provided for @experienceTitle.
  ///
  /// In en, this message translates to:
  /// **'How familiar are you with fasting?'**
  String get experienceTitle;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders and units'**
  String get remindersTitle;

  /// No description provided for @planTitle.
  ///
  /// In en, this message translates to:
  /// **'Your gentle starter plan'**
  String get planTitle;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'No need to watch the clock'**
  String get notificationTitle;

  /// No description provided for @readyTitle.
  ///
  /// In en, this message translates to:
  /// **'You are all set'**
  String get readyTitle;

  /// No description provided for @startFast.
  ///
  /// In en, this message translates to:
  /// **'Start fasting'**
  String get startFast;

  /// No description provided for @fastingNow.
  ///
  /// In en, this message translates to:
  /// **'Fasting in progress'**
  String get fastingNow;

  /// No description provided for @endFast.
  ///
  /// In en, this message translates to:
  /// **'End fast'**
  String get endFast;

  /// No description provided for @adjustTime.
  ///
  /// In en, this message translates to:
  /// **'Adjust this fast'**
  String get adjustTime;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @addWater.
  ///
  /// In en, this message translates to:
  /// **'Add a cup'**
  String get addWater;

  /// No description provided for @discomfort.
  ///
  /// In en, this message translates to:
  /// **'Feeling unwell?'**
  String get discomfort;

  /// No description provided for @idleTitle.
  ///
  /// In en, this message translates to:
  /// **'Start when you are ready'**
  String get idleTitle;

  /// No description provided for @idleBody.
  ///
  /// In en, this message translates to:
  /// **'Begin after your last meal tonight and let a new day open naturally 12 hours later. Start now or come back when it suits you.'**
  String get idleBody;

  /// No description provided for @endedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recorded — well done'**
  String get endedTitle;

  /// No description provided for @endedBody.
  ///
  /// In en, this message translates to:
  /// **'Ending early still counts as a complete record. It is not a failure.'**
  String get endedBody;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current plan'**
  String get currentPlan;

  /// No description provided for @weeklyOverview.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get weeklyOverview;

  /// No description provided for @fastingCalendar.
  ///
  /// In en, this message translates to:
  /// **'Fasting calendar'**
  String get fastingCalendar;

  /// No description provided for @weightTrend.
  ///
  /// In en, this message translates to:
  /// **'Weight trend'**
  String get weightTrend;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @recordWeight.
  ///
  /// In en, this message translates to:
  /// **'Log weight'**
  String get recordWeight;

  /// No description provided for @weeklyInsight.
  ///
  /// In en, this message translates to:
  /// **'Weekly insight'**
  String get weeklyInsight;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @planAndPreferences.
  ///
  /// In en, this message translates to:
  /// **'Plan and preferences'**
  String get planAndPreferences;

  /// No description provided for @reminderSettings.
  ///
  /// In en, this message translates to:
  /// **'Reminder settings'**
  String get reminderSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units and display'**
  String get units;

  /// No description provided for @accountAndSync.
  ///
  /// In en, this message translates to:
  /// **'Account and sync'**
  String get accountAndSync;

  /// No description provided for @learnAndSafety.
  ///
  /// In en, this message translates to:
  /// **'Learn and safety'**
  String get learnAndSafety;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get exportData;

  /// No description provided for @deleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete data or account'**
  String get deleteData;

  /// No description provided for @pausePlan.
  ///
  /// In en, this message translates to:
  /// **'Pause my plan'**
  String get pausePlan;

  /// No description provided for @mockMode.
  ///
  /// In en, this message translates to:
  /// **'Test mode — no server connection'**
  String get mockMode;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get register;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

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

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @notMedicalDevice.
  ///
  /// In en, this message translates to:
  /// **'Not a medical device. No diagnosis or medical advice.'**
  String get notMedicalDevice;
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
