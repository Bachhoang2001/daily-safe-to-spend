import 'package:flutter/widgets.dart';
import 'package:safe_to_spend/app.dart';

/// Initializes core services and starts the application.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Async initialization (DB, shared preferences, etc.) will occur here.

  runApp(const SafeToSpendApp());
}
