import 'package:flutter/widgets.dart';
import 'package:safe_to_spend/core/l10n/app_localizations.dart';

/// Extension providing convenient access to localized strings via [BuildContext].
extension L10nExtension on BuildContext {
  /// Returns the nearest [AppLocalizations] instance.
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}
