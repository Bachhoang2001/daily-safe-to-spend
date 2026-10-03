import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'Daily Safe-to-Spend'**
  String get appTitle;

  /// Label for the Today tab in navigation bar
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// Label for the History tab in navigation bar
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get tabHistory;

  /// Label for the Plan tab in navigation bar
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get tabPlan;

  /// Title and action for quick expense entry
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickAdd;

  /// Budget health status indicating healthy spending
  ///
  /// In en, this message translates to:
  /// **'On Track'**
  String get statusOnTrack;

  /// Budget health status indicating under 20% remaining
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get statusCaution;

  /// Budget health status indicating negative remaining allowance
  ///
  /// In en, this message translates to:
  /// **'Overspent'**
  String get statusOver;

  /// Standard save button label
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// Standard cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// Standard confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// Standard delete button label
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// Standard edit button label
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// Semantics label for keypad backspace button
  ///
  /// In en, this message translates to:
  /// **'Backspace'**
  String get backspace;

  /// Semantics label for keypad 00 button
  ///
  /// In en, this message translates to:
  /// **'Double zero'**
  String get doubleZero;

  /// Title displayed when application bootstrap fails
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get startupErrorTitle;

  /// Explanation message displayed when application bootstrap fails
  ///
  /// In en, this message translates to:
  /// **'We were unable to initialize your local database. Please try again or contact support if the issue persists.'**
  String get startupErrorMessage;

  /// Action button label to retry a failed operation
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionTryAgain;

  /// Action button label to email customer support
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get actionContactSupport;

  /// Accessibility label for loading splash screen
  ///
  /// In en, this message translates to:
  /// **'Loading Daily Safe-to-Spend...'**
  String get loadingApp;

  /// Headline on the onboarding welcome screen
  ///
  /// In en, this message translates to:
  /// **'Know what\'s safe to spend today.'**
  String get onboardingWelcomeTitle;

  /// Subheading explaining local-first and zero-bank-connection value
  ///
  /// In en, this message translates to:
  /// **'One number every morning. No bank login. Your data stays on your phone.'**
  String get onboardingWelcomeSubtitle;

  /// Label on sample Safe-to-Spend card
  ///
  /// In en, this message translates to:
  /// **'safe to spend today'**
  String get onboardingSampleSafeToday;

  /// Highlight feature bullet 1
  ///
  /// In en, this message translates to:
  /// **'Built around your paycheck'**
  String get onboardingFeaturePaycheck;

  /// Highlight feature bullet 2
  ///
  /// In en, this message translates to:
  /// **'Works with irregular income'**
  String get onboardingFeatureIrregular;

  /// Highlight feature bullet 3
  ///
  /// In en, this message translates to:
  /// **'Private by design'**
  String get onboardingFeaturePrivate;

  /// Primary call to action on welcome screen
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// Link text for Privacy Policy
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get onboardingPrivacyPolicy;

  /// Link text for Terms of Service
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get onboardingTerms;

  /// Indicator of active onboarding step
  ///
  /// In en, this message translates to:
  /// **'Step {current} of {total}'**
  String onboardingStepProgress(int current, int total);

  /// Continue button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get actionContinue;

  /// Income question headline
  ///
  /// In en, this message translates to:
  /// **'How do you get paid?'**
  String get onboardingIncomeHowPaidTitle;

  /// Fixed income card title
  ///
  /// In en, this message translates to:
  /// **'Same amount on a schedule'**
  String get onboardingIncomeModeFixedTitle;

  /// Fixed income card subtitle
  ///
  /// In en, this message translates to:
  /// **'Salary, hourly with predictable shifts, or regular pensions'**
  String get onboardingIncomeModeFixedSubtitle;

  /// Irregular income card title
  ///
  /// In en, this message translates to:
  /// **'My income varies'**
  String get onboardingIncomeModeIrregularTitle;

  /// Irregular income card subtitle
  ///
  /// In en, this message translates to:
  /// **'Freelance, gig worker, tips, or unpredictable commissions'**
  String get onboardingIncomeModeIrregularSubtitle;

  /// Paycheck frequency question headline
  ///
  /// In en, this message translates to:
  /// **'How often are you paid?'**
  String get onboardingIncomeFrequencyTitle;

  /// Weekly pay frequency label
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get frequencyWeekly;

  /// Bi-weekly pay frequency label
  ///
  /// In en, this message translates to:
  /// **'Every 2 weeks'**
  String get frequencyBiweekly;

  /// Semi-monthly pay frequency label
  ///
  /// In en, this message translates to:
  /// **'Twice a month'**
  String get frequencySemimonthly;

  /// Monthly pay frequency label
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get frequencyMonthly;

  /// Next payday question headline
  ///
  /// In en, this message translates to:
  /// **'When is your next payday?'**
  String get onboardingIncomeNextPaydayTitle;

  /// Placeholder when no payday date has been chosen
  ///
  /// In en, this message translates to:
  /// **'Select upcoming payday'**
  String get onboardingIncomeSelectPaydayPlaceholder;

  /// Income per paycheck question headline
  ///
  /// In en, this message translates to:
  /// **'How much do you take home each paycheck?'**
  String get onboardingIncomeTakeHomeTitle;

  /// Net income display tile label
  ///
  /// In en, this message translates to:
  /// **'Net income per paycheck'**
  String get onboardingIncomeNetIncomeLabel;

  /// Initial spending balance question headline
  ///
  /// In en, this message translates to:
  /// **'How much do you have to spend until then?'**
  String get onboardingIncomeSpendUntilTitle;

  /// Initial spending balance display tile label
  ///
  /// In en, this message translates to:
  /// **'Spending balance for initial period'**
  String get onboardingIncomeInitialBalanceLabel;

  /// Helper text showing suggested initial balance based on days left
  ///
  /// In en, this message translates to:
  /// **'Suggested: {amount} based on remaining days'**
  String onboardingIncomeSuggestedBalance(String amount);

  /// Current balance question headline for irregular income
  ///
  /// In en, this message translates to:
  /// **'How much money do you have right now?'**
  String get onboardingIncomeCurrentMoneyTitle;

  /// Current balance display tile label
  ///
  /// In en, this message translates to:
  /// **'Available spending money'**
  String get onboardingIncomeAvailableSpendingMoneyLabel;

  /// Safety horizon question headline for irregular income
  ///
  /// In en, this message translates to:
  /// **'Plan ahead for how many days?'**
  String get onboardingIncomePlanDaysTitle;

  /// Days option label
  ///
  /// In en, this message translates to:
  /// **'{count} days'**
  String daysCount(int count);

  /// Badge indicator for recommended option
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get recommendedBadge;

  /// Semantics label for currency picker dropdown
  ///
  /// In en, this message translates to:
  /// **'Select currency, currently {currency}'**
  String semanticsCurrencyPicker(String currency);

  /// Semantics label for payday date picker button
  ///
  /// In en, this message translates to:
  /// **'Select upcoming payday date, currently {date}'**
  String semanticsSelectPayday(String date);

  /// Headline on bills setup page for fixed income
  ///
  /// In en, this message translates to:
  /// **'Any regular bills before your next payday?'**
  String get onboardingBillsTitleFixed;

  /// Headline on bills setup page for irregular income
  ///
  /// In en, this message translates to:
  /// **'Any regular bills in the next {days} days?'**
  String onboardingBillsTitleIrregular(int days);

  /// Subheading explaining recurring bills protection
  ///
  /// In en, this message translates to:
  /// **'Add upcoming recurring expenses to protect your daily limit.'**
  String get onboardingBillsSubtitle;

  /// Summary line showing total bill occurrences before next payday
  ///
  /// In en, this message translates to:
  /// **'Bills before payday: {amount}'**
  String onboardingBillsTotalBeforePayday(String amount);

  /// Empty state prompt when no bills have been added
  ///
  /// In en, this message translates to:
  /// **'No bills added yet. Tap a suggestion above or skip to continue.'**
  String get onboardingBillsEmptyPrompt;

  /// Skip button label on bills step
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingBillsSkipForNow;

  /// Button or title for adding a bill
  ///
  /// In en, this message translates to:
  /// **'Add Bill'**
  String get addBill;

  /// Title for editing a bill
  ///
  /// In en, this message translates to:
  /// **'Edit Bill'**
  String get editBill;

  /// Label for bill name input
  ///
  /// In en, this message translates to:
  /// **'Bill name'**
  String get billNameLabel;

  /// Label for bill amount input
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get billAmountLabel;

  /// Button label for saving changes to an existing bill
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Label for bill first due date
  ///
  /// In en, this message translates to:
  /// **'First due date'**
  String get billDueDateLabel;

  /// Label for bill recurrence selector
  ///
  /// In en, this message translates to:
  /// **'Repeats'**
  String get billRecurrenceLabel;

  /// Weekly recurrence option
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get recurrenceWeekly;

  /// Monthly recurrence option
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get recurrenceMonthly;

  /// Yearly recurrence option
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get recurrenceYearly;

  /// Validation message when bill name is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a bill name'**
  String get validationBillNameRequired;

  /// Validation message when bill name exceeds 40 characters
  ///
  /// In en, this message translates to:
  /// **'Bill name cannot exceed 40 characters'**
  String get validationBillNameTooLong;

  /// Validation message when bill amount is zero or negative
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get validationBillAmountPositive;

  /// Validation message when bill first due date is in the past
  ///
  /// In en, this message translates to:
  /// **'First due date must be on or after today'**
  String get validationBillDatePast;
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
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
