/// Error thrown when an arithmetic or comparison operation is attempted on two
/// [Money] instances with different currencies.
///
/// Example:
/// ```dart
/// const usd = Money(1000, 'USD');
/// const eur = Money(1000, 'EUR');
/// usd + eur; // Throws CurrencyMismatchError
/// ```
class CurrencyMismatchError extends Error {
  /// Expected currency ISO 4217 code.
  final String expectedCurrency;

  /// Actual currency ISO 4217 code found in the other operand.
  final String actualCurrency;

  /// Creates a [CurrencyMismatchError] noting the [expectedCurrency] and [actualCurrency].
  CurrencyMismatchError(this.expectedCurrency, this.actualCurrency);

  @override
  String toString() =>
      'CurrencyMismatchError: Cannot operate on $expectedCurrency and $actualCurrency';
}

/// An immutable representation of a monetary value in an integer number of cents
/// (or the lowest denominational unit of currency).
///
/// Floats and doubles are strictly forbidden for financial calculations to prevent
/// IEEE-754 precision loss.
///
/// Example:
/// ```dart
/// const price = Money(1250); // $12.50
/// const tax = price.percent(10); // $1.25 (125 cents)
/// final total = price + tax; // $13.75 (1375 cents)
/// ```
class Money implements Comparable<Money> {
  /// Default currency code used across the application ('USD').
  static const String defaultCurrency = 'USD';

  /// The amount in cents (e.g. 1250 cents = $12.50).
  final int cents;

  /// ISO 4217 three-letter currency code (e.g. 'USD', 'EUR', 'GBP').
  final String currency;

  /// Creates a [Money] instance with the specified [cents] and optional [currency].
  ///
  /// Example:
  /// ```dart
  /// const m1 = Money(500); // 500 cents ($5.00) in USD
  /// const m2 = Money(500, 'EUR'); // 500 cents (€5.00) in EUR
  /// ```
  const Money(this.cents, [this.currency = defaultCurrency]);

  /// Creates a zero-value [Money] instance for the given [currency].
  ///
  /// Example:
  /// ```dart
  /// const zeroUsd = Money.zero(); // 0 cents in USD
  /// const zeroEur = Money.zero('EUR'); // 0 cents in EUR
  /// ```
  const Money.zero([String currency = defaultCurrency]) : this(0, currency);

  /// Whether the amount is strictly less than zero.
  ///
  /// Example:
  /// ```dart
  /// const deficit = Money(-150);
  /// print(deficit.isNegative); // true
  /// ```
  bool get isNegative => cents < 0;

  /// Whether the amount is strictly greater than zero.
  ///
  /// Example:
  /// ```dart
  /// const surplus = Money(250);
  /// print(surplus.isPositive); // true
  /// ```
  bool get isPositive => cents > 0;

  /// Whether the amount is exactly zero.
  ///
  /// Example:
  /// ```dart
  /// const balanced = Money(0);
  /// print(balanced.isZero); // true
  /// ```
  bool get isZero => cents == 0;

  /// Returns the absolute value of this [Money].
  ///
  /// Example:
  /// ```dart
  /// const debt = Money(-500);
  /// print(debt.abs); // Money(500, USD)
  /// ```
  Money get abs => Money(cents.abs(), currency);

  void _checkCurrency(Money other) {
    if (currency != other.currency) {
      throw CurrencyMismatchError(currency, other.currency);
    }
  }

  /// Adds [other] to this [Money].
  ///
  /// Throws [CurrencyMismatchError] if currencies differ.
  ///
  /// Example:
  /// ```dart
  /// const a = Money(1000);
  /// const b = Money(250);
  /// print(a + b); // Money(1250, USD)
  /// ```
  Money operator +(Money other) {
    _checkCurrency(other);
    return Money(cents + other.cents, currency);
  }

  /// Subtracts [other] from this [Money].
  ///
  /// Throws [CurrencyMismatchError] if currencies differ.
  ///
  /// Example:
  /// ```dart
  /// const a = Money(1000);
  /// const b = Money(250);
  /// print(a - b); // Money(750, USD)
  /// ```
  Money operator -(Money other) {
    _checkCurrency(other);
    return Money(cents - other.cents, currency);
  }

  /// Negates this monetary amount.
  ///
  /// Example:
  /// ```dart
  /// const positive = Money(100);
  /// print(-positive); // Money(-100, USD)
  /// ```
  Money operator -() => Money(-cents, currency);

  /// Whether this amount is strictly less than [other].
  ///
  /// Throws [CurrencyMismatchError] if currencies differ.
  bool operator <(Money other) {
    _checkCurrency(other);
    return cents < other.cents;
  }

  /// Whether this amount is less than or equal to [other].
  ///
  /// Throws [CurrencyMismatchError] if currencies differ.
  bool operator <=(Money other) {
    _checkCurrency(other);
    return cents <= other.cents;
  }

  /// Whether this amount is strictly greater than [other].
  ///
  /// Throws [CurrencyMismatchError] if currencies differ.
  bool operator >(Money other) {
    _checkCurrency(other);
    return cents > other.cents;
  }

  /// Whether this amount is greater than or equal to [other].
  ///
  /// Throws [CurrencyMismatchError] if currencies differ.
  bool operator >=(Money other) {
    _checkCurrency(other);
    return cents >= other.cents;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Money && other.cents == cents && other.currency == currency);

  @override
  int get hashCode => Object.hash(cents, currency);

  @override
  int compareTo(Money other) {
    _checkCurrency(other);
    return cents.compareTo(other.cents);
  }

  /// Divides this [Money] evenly into [parts] parts.
  ///
  /// Any remaining cents are distributed one-by-one to the earliest parts,
  /// ensuring that the sum of the returned list always exactly equals [cents].
  ///
  /// Example:
  /// ```dart
  /// const total = Money(1000); // $10.00
  /// final split = total.divideEvenly(3);
  /// // split == [Money(334), Money(333), Money(333)]
  /// // 334 + 333 + 333 == 1000
  /// ```
  List<Money> divideEvenly(int parts) {
    if (parts <= 0) {
      throw ArgumentError.value(parts, 'parts', 'Must be greater than 0');
    }

    final base = cents ~/ parts;
    final remainder = cents - (base * parts);
    final step = cents >= 0 ? 1 : -1;
    final absRem = remainder.abs();

    return List<Money>.generate(parts, (i) {
      final allocated = i < absRem ? base + step : base;
      return Money(allocated, currency);
    });
  }

  /// Computes [p] percent of this [Money].
  ///
  /// The result is always rounded **down** (integer floor / truncation) to the
  /// nearest cent, prioritizing financial conservatism (e.g. Safety Buffer).
  ///
  /// Example:
  /// ```dart
  /// const amount = Money(999); // $9.99
  /// final buffer = amount.percent(10);
  /// // 999 * 10% = 99.9 cents -> rounds down to 99 cents (Money(99))
  /// ```
  Money percent(int p) {
    return Money((cents * p) ~/ 100, currency);
  }

  @override
  String toString() => 'Money($cents, $currency)';
}
