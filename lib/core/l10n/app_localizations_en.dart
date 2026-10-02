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
}
