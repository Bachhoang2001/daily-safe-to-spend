import 'package:budget_engine/budget_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/money/money_formatter.dart';

void main() {
  group('MoneyFormatter', () {
    test(
      'T01-7: formats according to locale, currency and handles negative amounts',
      () {
        // USD in en_US
        const usd = Money(1250);
        final formattedUsd = MoneyFormatter.format(usd, locale: 'en_US');
        expect(formattedUsd, equals(r'$12.50'));

        // EUR in de_DE
        const eur = Money(1250, 'EUR');
        final formattedEur = MoneyFormatter.format(eur, locale: 'de_DE');
        // de_DE format usually uses comma and non-breaking space before euro sign: 12,50 €
        expect(formattedEur.replaceAll('\u00A0', ' '), equals('12,50 €'));

        // GBP in en_GB
        const gbp = Money(1250, 'GBP');
        final formattedGbp = MoneyFormatter.format(gbp, locale: 'en_GB');
        expect(formattedGbp, equals('£12.50'));

        // Negative USD in en_US
        const negUsd = Money(-1250);
        final formattedNegUsd = MoneyFormatter.format(negUsd, locale: 'en_US');
        expect(formattedNegUsd, contains(r'-$12.50'));
      },
    );
  });
}
