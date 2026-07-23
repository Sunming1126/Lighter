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

  /// No description provided for @learn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learn;

  /// No description provided for @me.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get me;

  /// No description provided for @learningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Understand fasting, and understand your body'**
  String get learningSubtitle;

  /// No description provided for @learningBeginHere.
  ///
  /// In en, this message translates to:
  /// **'Start here'**
  String get learningBeginHere;

  /// No description provided for @learningBeginnerGuide.
  ///
  /// In en, this message translates to:
  /// **'Beginner guide'**
  String get learningBeginnerGuide;

  /// No description provided for @learningBenefitsSection.
  ///
  /// In en, this message translates to:
  /// **'Benefits of fasting'**
  String get learningBenefitsSection;

  /// No description provided for @learningWomenSection.
  ///
  /// In en, this message translates to:
  /// **'Women and weight management'**
  String get learningWomenSection;

  /// No description provided for @learningFaqSection.
  ///
  /// In en, this message translates to:
  /// **'Common questions'**
  String get learningFaqSection;

  /// No description provided for @learningAttention.
  ///
  /// In en, this message translates to:
  /// **'What to keep in mind'**
  String get learningAttention;

  /// No description provided for @learningSources.
  ///
  /// In en, this message translates to:
  /// **'Medical sources'**
  String get learningSources;

  /// No description provided for @learningSourceFootnote.
  ///
  /// In en, this message translates to:
  /// **'Tap a source to copy its link. Educational information only; not diagnosis or medical advice.'**
  String get learningSourceFootnote;

  /// No description provided for @learningCopied.
  ///
  /// In en, this message translates to:
  /// **'Source link copied'**
  String get learningCopied;

  /// No description provided for @learningSourceNia.
  ///
  /// In en, this message translates to:
  /// **'National Institute on Aging · Fasting research review'**
  String get learningSourceNia;

  /// No description provided for @learningSourceReview.
  ///
  /// In en, this message translates to:
  /// **'Systematic review and network meta-analysis of randomized trials'**
  String get learningSourceReview;

  /// No description provided for @learningSourceWomenHormones.
  ///
  /// In en, this message translates to:
  /// **'Randomized trial of fasting and sex hormones'**
  String get learningSourceWomenHormones;

  /// No description provided for @learningSourceTreat.
  ///
  /// In en, this message translates to:
  /// **'TREAT randomized trial of time-restricted eating'**
  String get learningSourceTreat;

  /// No description provided for @learningSourceHopkins.
  ///
  /// In en, this message translates to:
  /// **'Johns Hopkins Medicine · Fasting safety guide'**
  String get learningSourceHopkins;

  /// No description provided for @learningSourceAda.
  ///
  /// In en, this message translates to:
  /// **'American Diabetes Association · Hypoglycemia risk'**
  String get learningSourceAda;

  /// No description provided for @learningTopicSafety.
  ///
  /// In en, this message translates to:
  /// **'Start safely'**
  String get learningTopicSafety;

  /// No description provided for @learningTopicBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginners'**
  String get learningTopicBeginner;

  /// No description provided for @learningTopicBenefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get learningTopicBenefits;

  /// No description provided for @learningTopicWomen.
  ///
  /// In en, this message translates to:
  /// **'For women'**
  String get learningTopicWomen;

  /// No description provided for @learningTopicFaq.
  ///
  /// In en, this message translates to:
  /// **'Questions'**
  String get learningTopicFaq;

  /// No description provided for @learningHeroSafetyTitle.
  ///
  /// In en, this message translates to:
  /// **'How can I start fasting safely?'**
  String get learningHeroSafetyTitle;

  /// No description provided for @learningHeroSafetySummary.
  ///
  /// In en, this message translates to:
  /// **'Begin gently with 12:12 and first check whether fasting suits you'**
  String get learningHeroSafetySummary;

  /// No description provided for @learningHeroBeginnerTitle.
  ///
  /// In en, this message translates to:
  /// **'Your first fast does not need to be longer'**
  String get learningHeroBeginnerTitle;

  /// No description provided for @learningHeroBeginnerSummary.
  ///
  /// In en, this message translates to:
  /// **'Set a steady eating rhythm and give life and body time to adapt'**
  String get learningHeroBeginnerSummary;

  /// No description provided for @learningHeroBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'What benefits might fasting offer?'**
  String get learningHeroBenefitsTitle;

  /// No description provided for @learningHeroBenefitsSummary.
  ///
  /// In en, this message translates to:
  /// **'Understand the possible gains and the limits of current evidence'**
  String get learningHeroBenefitsSummary;

  /// No description provided for @learningHeroWomenTitle.
  ///
  /// In en, this message translates to:
  /// **'For women, body signals matter more'**
  String get learningHeroWomenTitle;

  /// No description provided for @learningHeroWomenSummary.
  ///
  /// In en, this message translates to:
  /// **'Nutrition, life stage and wellbeing matter more than pushing through'**
  String get learningHeroWomenSummary;

  /// No description provided for @learningHeroFaqTitle.
  ///
  /// In en, this message translates to:
  /// **'Can I drink coffee or exercise while fasting?'**
  String get learningHeroFaqTitle;

  /// No description provided for @learningHeroFaqSummary.
  ///
  /// In en, this message translates to:
  /// **'Clear answers to the questions beginners ask most often'**
  String get learningHeroFaqSummary;

  /// No description provided for @learningArticleWhatTitle.
  ///
  /// In en, this message translates to:
  /// **'What is intermittent fasting?'**
  String get learningArticleWhatTitle;

  /// No description provided for @learningArticleWhatSummary.
  ///
  /// In en, this message translates to:
  /// **'It changes when you eat; it is not starvation or skipping nutrition.'**
  String get learningArticleWhatSummary;

  /// No description provided for @learningArticleWhatBody.
  ///
  /// In en, this message translates to:
  /// **'Intermittent fasting describes eating patterns that regularly alternate between eating and fasting periods. Common approaches include daily time-restricted eating, 5:2, and alternate-day fasting. Lighter starts with the gentler daily approach.\n\nFasting focuses on when you eat, but what you eat still matters. Your eating window should still provide enough protein, vegetables, fluids and overall energy. It is not a reason to compensate with one very large meal.'**
  String get learningArticleWhatBody;

  /// No description provided for @learningArticleWhatSafety.
  ///
  /// In en, this message translates to:
  /// **'Fasting is not an endurance contest. Stop and eat if you develop persistent dizziness, palpitations, nausea, unusual weakness or a clear drop in concentration.'**
  String get learningArticleWhatSafety;

  /// No description provided for @learningArticleStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start with 12:12'**
  String get learningArticleStartTitle;

  /// No description provided for @learningArticleStartSummary.
  ///
  /// In en, this message translates to:
  /// **'Including the hours after dinner makes this the easiest starting point.'**
  String get learningArticleStartSummary;

  /// No description provided for @learningArticleStartBody.
  ///
  /// In en, this message translates to:
  /// **'A 12:12 schedule means consuming no calories for 12 continuous hours and eating normally during the other 12. For example, finish dinner at 8 p.m. and eat breakfast at 8 a.m. Sleep already covers most of the fasting period, so you do not need to skip a whole meal.\n\nKeep the rhythm steady for one or two weeks before changing it. Use sleep, work, training and hunger as your guide. A gentle pattern you can sustain is more useful than completing one unusually long fast.'**
  String get learningArticleStartBody;

  /// No description provided for @learningArticleStartSafety.
  ///
  /// In en, this message translates to:
  /// **'Do not compensate for a missed target by extending the next fast. Ending early when you feel unwell is still a valid record.'**
  String get learningArticleStartSafety;

  /// No description provided for @learningArticleBenefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'What benefits might fasting offer?'**
  String get learningArticleBenefitsTitle;

  /// No description provided for @learningArticleBenefitsSummary.
  ///
  /// In en, this message translates to:
  /// **'Some people may find it easier to manage eating times, weight and certain metabolic markers.'**
  String get learningArticleBenefitsSummary;

  /// No description provided for @learningArticleBenefitsBody.
  ///
  /// In en, this message translates to:
  /// **'Some clinical studies suggest intermittent fasting may help adults with overweight or obesity lose weight and improve fasting glucose, blood pressure or other metabolic markers. Study plans and participants vary widely, so results are not consistent.\n\nIts practical benefit may come from less late-night eating, a shorter eating window and lower total energy intake rather than a magic switch. Short-term studies cannot yet prove that fasting extends human life or prevents every chronic disease.'**
  String get learningArticleBenefitsBody;

  /// No description provided for @learningArticleBenefitsSafety.
  ///
  /// In en, this message translates to:
  /// **'Treat fasting as an optional routine, not a disease treatment. Discuss it with a clinician first if you have a chronic condition or take medication.'**
  String get learningArticleBenefitsSafety;

  /// No description provided for @learningArticleComparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Fasting may not beat ordinary calorie control'**
  String get learningArticleComparisonTitle;

  /// No description provided for @learningArticleComparisonSummary.
  ///
  /// In en, this message translates to:
  /// **'Fat loss depends more on total energy, nutrition quality and long-term adherence.'**
  String get learningArticleComparisonSummary;

  /// No description provided for @learningArticleComparisonBody.
  ///
  /// In en, this message translates to:
  /// **'Randomized trials and systematic reviews show that intermittent fasting can produce some weight loss, but its average effect is not consistently greater than reducing calories each day. Some people find tracking time simpler; others find regular meals easier to sustain.\n\nSleep, activity, stress, medication and starting weight also affect progress. Using short-term scale changes as the only test of whether fasting works can create unnecessary anxiety.'**
  String get learningArticleComparisonBody;

  /// No description provided for @learningArticleComparisonSafety.
  ///
  /// In en, this message translates to:
  /// **'Avoid severe restriction during the eating window. Rapid weight loss may increase the risk of muscle loss, gallstones and nutrient deficiencies.'**
  String get learningArticleComparisonSafety;

  /// No description provided for @learningArticleWomenTitle.
  ///
  /// In en, this message translates to:
  /// **'What should women consider for weight loss?'**
  String get learningArticleWomenTitle;

  /// No description provided for @learningArticleWomenSummary.
  ///
  /// In en, this message translates to:
  /// **'No fasting length suits every woman, and cycle-based fasting rules are not required.'**
  String get learningArticleWomenSummary;

  /// No description provided for @learningArticleWomenBody.
  ///
  /// In en, this message translates to:
  /// **'Current research suggests time-restricted eating may help some women with overweight or obesity lose weight, but it has not shown a consistent advantage over other sustainable calorie-control approaches. Evidence on reproductive hormones, menstruation and different life stages remains limited.\n\nA practical approach is to start with a short window and observe your cycle, sleep, mood, training and hunger. Adequate protein, iron, calcium and total energy matter more than pursuing a longer fast.'**
  String get learningArticleWomenBody;

  /// No description provided for @learningArticleWomenSafety.
  ///
  /// In en, this message translates to:
  /// **'Do not start fasting on your own if your periods become clearly irregular, or while trying to conceive, pregnant or breastfeeding. Stop and seek advice if changes persist.'**
  String get learningArticleWomenSafety;

  /// No description provided for @learningArticleWhoTitle.
  ///
  /// In en, this message translates to:
  /// **'Who should not fast without guidance?'**
  String get learningArticleWhoTitle;

  /// No description provided for @learningArticleWhoSummary.
  ///
  /// In en, this message translates to:
  /// **'Certain life stages, eating-disorder history and medical conditions increase the risk.'**
  String get learningArticleWhoSummary;

  /// No description provided for @learningArticleWhoBody.
  ///
  /// In en, this message translates to:
  /// **'People under 18, anyone pregnant or breastfeeding, people with a history of eating disorders, those who are underweight, and people with type 1 diabetes should not try intermittent fasting without professional guidance.\n\nChanging meal times can cause hypoglycemia or interfere with treatment when using insulin, sulfonylureas or medicines that must be taken with food. Older adults, people with chronic illness, or those recovering from illness or surgery should also ask a clinician first.'**
  String get learningArticleWhoBody;

  /// No description provided for @learningArticleWhoSafety.
  ///
  /// In en, this message translates to:
  /// **'If you are unsure whether you are at higher risk, keep regular meals and ask a clinician. Do not use an app prompt as a medical decision.'**
  String get learningArticleWhoSafety;

  /// No description provided for @learningArticleCoffeeTitle.
  ///
  /// In en, this message translates to:
  /// **'Can I drink water or coffee while fasting?'**
  String get learningArticleCoffeeTitle;

  /// No description provided for @learningArticleCoffeeSummary.
  ///
  /// In en, this message translates to:
  /// **'Water is usually fine; unsweetened caffeinated drinks depend on your tolerance and goal.'**
  String get learningArticleCoffeeSummary;

  /// No description provided for @learningArticleCoffeeBody.
  ///
  /// In en, this message translates to:
  /// **'Stay hydrated while fasting. Water, unsweetened tea and black coffee contain little or no energy, but coffee is never required to complete a fast.\n\nCoffee on an empty stomach can cause stomach discomfort, palpitations, anxiety or worse sleep for some people. Sugar, cream or caloric drinks end a strict fast, but one choice does not erase your long-term habits.'**
  String get learningArticleCoffeeBody;

  /// No description provided for @learningArticleCoffeeSafety.
  ///
  /// In en, this message translates to:
  /// **'If you develop shaking, palpitations, reflux or clear discomfort, do not use coffee to suppress hunger. Stop drinking it and end the fast if needed.'**
  String get learningArticleCoffeeSafety;

  /// No description provided for @learningArticleExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Can I exercise while fasting?'**
  String get learningArticleExerciseTitle;

  /// No description provided for @learningArticleExerciseSummary.
  ///
  /// In en, this message translates to:
  /// **'Low-to-moderate activity is often easier to adapt to; plan intense training carefully.'**
  String get learningArticleExerciseSummary;

  /// No description provided for @learningArticleExerciseBody.
  ///
  /// In en, this message translates to:
  /// **'Healthy adults who already tolerate regular fasting can often walk, cycle easily or do routine strength work while fasted. Comfort and performance vary, so lower the intensity on your first attempts and keep water and food available.\n\nLong endurance sessions, high-intensity intervals and heavy lifting rely more on fuel and hydration. Scheduling important training near the eating window often makes recovery and protein intake easier.'**
  String get learningArticleExerciseBody;

  /// No description provided for @learningArticleExerciseSafety.
  ///
  /// In en, this message translates to:
  /// **'Stop immediately and refuel if exercise causes dizziness, visual changes, chills, weakness or palpitations. Do not push on simply to complete a timer.'**
  String get learningArticleExerciseSafety;

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
