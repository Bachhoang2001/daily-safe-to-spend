// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Daily Safe-to-Spend';

  @override
  String get tabToday => 'Today';

  @override
  String get tabHistory => 'History';

  @override
  String get tabPlan => 'Plan';

  @override
  String get quickAdd => 'Quick Add';

  @override
  String get statusOnTrack => 'On Track';

  @override
  String get statusCaution => 'Caution';

  @override
  String get statusOver => 'Overspent';

  @override
  String get actionSave => 'Save';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get backspace => 'Backspace';

  @override
  String get doubleZero => 'Double zero';

  @override
  String get startupErrorTitle => 'Something went wrong';

  @override
  String get startupErrorMessage =>
      'We were unable to initialize your local database. Please try again or contact support if the issue persists.';

  @override
  String get actionTryAgain => 'Try again';

  @override
  String get actionContactSupport => 'Contact support';

  @override
  String get loadingApp => 'Loading Daily Safe-to-Spend...';

  @override
  String get onboardingWelcomeTitle => 'Know what\'s safe to spend today.';

  @override
  String get onboardingWelcomeSubtitle =>
      'One number every morning. No bank login. Your data stays on your phone.';

  @override
  String get onboardingSampleSafeToday => 'safe to spend today';

  @override
  String get onboardingFeaturePaycheck => 'Built around your paycheck';

  @override
  String get onboardingFeatureIrregular => 'Works with irregular income';

  @override
  String get onboardingFeaturePrivate => 'Private by design';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingPrivacyPolicy => 'Privacy Policy';

  @override
  String get onboardingTerms => 'Terms of Service';

  @override
  String onboardingStepProgress(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String get actionContinue => 'Continue';

  @override
  String get onboardingIncomeHowPaidTitle => 'How do you get paid?';

  @override
  String get onboardingIncomeModeFixedTitle => 'Same amount on a schedule';

  @override
  String get onboardingIncomeModeFixedSubtitle =>
      'Salary, hourly with predictable shifts, or regular pensions';

  @override
  String get onboardingIncomeModeIrregularTitle => 'My income varies';

  @override
  String get onboardingIncomeModeIrregularSubtitle =>
      'Freelance, gig worker, tips, or unpredictable commissions';

  @override
  String get onboardingIncomeFrequencyTitle => 'How often are you paid?';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyBiweekly => 'Every 2 weeks';

  @override
  String get frequencySemimonthly => 'Twice a month';

  @override
  String get frequencyMonthly => 'Monthly';

  @override
  String get onboardingIncomeNextPaydayTitle => 'When is your next payday?';

  @override
  String get onboardingIncomeSelectPaydayPlaceholder =>
      'Select upcoming payday';

  @override
  String get onboardingIncomeTakeHomeTitle =>
      'How much do you take home each paycheck?';

  @override
  String get onboardingIncomeNetIncomeLabel => 'Net income per paycheck';

  @override
  String get onboardingIncomeSpendUntilTitle =>
      'How much do you have to spend until then?';

  @override
  String get onboardingIncomeInitialBalanceLabel =>
      'Spending balance for initial period';

  @override
  String onboardingIncomeSuggestedBalance(String amount) {
    return 'Suggested: $amount based on remaining days';
  }

  @override
  String get onboardingIncomeCurrentMoneyTitle =>
      'How much money do you have right now?';

  @override
  String get onboardingIncomeAvailableSpendingMoneyLabel =>
      'Available spending money';

  @override
  String get onboardingIncomePlanDaysTitle => 'Plan ahead for how many days?';

  @override
  String daysCount(int count) {
    return '$count days';
  }

  @override
  String get recommendedBadge => 'Recommended';

  @override
  String semanticsCurrencyPicker(String currency) {
    return 'Select currency, currently $currency';
  }

  @override
  String semanticsSelectPayday(String date) {
    return 'Select upcoming payday date, currently $date';
  }

  @override
  String get onboardingBillsTitleFixed =>
      'Any regular bills before your next payday?';

  @override
  String onboardingBillsTitleIrregular(int days) {
    return 'Any regular bills in the next $days days?';
  }

  @override
  String get onboardingBillsSubtitle =>
      'Add upcoming recurring expenses to protect your daily limit.';

  @override
  String onboardingBillsTotalBeforePayday(String amount) {
    return 'Bills before payday: $amount';
  }

  @override
  String get onboardingBillsEmptyPrompt =>
      'No bills added yet. Tap a suggestion above or skip to continue.';

  @override
  String get onboardingBillsSkipForNow => 'Skip for now';

  @override
  String get addBill => 'Add Bill';

  @override
  String get editBill => 'Edit Bill';

  @override
  String get billNameLabel => 'Bill name';

  @override
  String get billAmountLabel => 'Amount';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get billDueDateLabel => 'First due date';

  @override
  String get billRecurrenceLabel => 'Repeats';

  @override
  String get recurrenceWeekly => 'Weekly';

  @override
  String get recurrenceMonthly => 'Monthly';

  @override
  String get recurrenceYearly => 'Yearly';

  @override
  String get validationBillNameRequired => 'Please enter a bill name';

  @override
  String get validationBillNameTooLong =>
      'Bill name cannot exceed 40 characters';

  @override
  String get validationBillAmountPositive => 'Amount must be greater than zero';

  @override
  String get validationBillDatePast =>
      'First due date must be on or after today';

  @override
  String get onboardingResultYouCanSpend => 'You can spend';

  @override
  String get onboardingResultToday => 'today';

  @override
  String onboardingResultSubtitleFixed(String date) {
    return 'That\'s your daily number until payday on $date.';
  }

  @override
  String onboardingResultSubtitleIrregular(int days) {
    return 'That\'s your daily number for the next $days days.';
  }

  @override
  String get onboardingResultDeficitMessage =>
      'Your bills are more than your money until payday — we\'ll help you track it.';

  @override
  String get onboardingResultNotificationTitle =>
      'Get your number every morning at 8:00?';

  @override
  String get onboardingResultNotificationSubtitle =>
      'A gentle daily reminder so you always know what\'s safe to spend.';

  @override
  String get onboardingResultNotificationTurnOn => 'Turn on';

  @override
  String get onboardingResultNotificationNotNow => 'Not now';

  @override
  String get onboardingResultGoToToday => 'Go to Today';

  @override
  String get onboardingResultSaveError =>
      'Failed to save profile. Please try again.';
}
