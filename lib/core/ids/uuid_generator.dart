import 'package:uuid/uuid.dart';

/// Contract for generating unique identifier strings across repositories and entities.
///
/// Example:
/// ```dart
/// class ExpenseRepository {
///   final UuidGenerator uuid;
///   ExpenseRepository({required this.uuid});
///
///   Expense createExpense(...) => Expense(id: uuid.generate(), ...);
/// }
/// ```
abstract class UuidGenerator {
  /// Generates and returns a new unique identifier string.
  String generate();
}

/// Production implementation generating standard UUID v4 strings.
///
/// Example:
/// ```dart
/// const generator = DefaultUuidGenerator();
/// final id = generator.generate(); // e.g. "9b1deb4d-3b7d-4bad-9bdd-2b0d7b3dcb6d"
/// ```
class DefaultUuidGenerator implements UuidGenerator {
  /// Creates a [DefaultUuidGenerator].
  const DefaultUuidGenerator();

  static const _uuid = Uuid();

  @override
  String generate() => _uuid.v4();
}
