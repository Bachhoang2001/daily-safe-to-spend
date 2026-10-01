import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

import 'helpers/test_factories.dart';

void main() {
  group('Engine Performance', () {
    test(
      'T02-23: Hiệu năng: 5.000 giao dịch, kỳ 31 ngày -> computeSnapshot < 10 ms trên máy dev',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 1, 1),
          incomePerPaycheck: const Money(1000000), // $10,000.00
          rolloverMode: RolloverMode.spread,
        );

        // Tạo 5.000 giao dịch rải đều qua 31 ngày của tháng 1
        final expenses = List.generate(5000, (i) {
          final day = (i % 31) + 1;
          return Expense(
            id: 'exp-$i',
            amount: const Money(100), // $1.00 mỗi giao dịch
            spentOn: LocalDate(2026, 1, day),
          );
        });

        final input = testEngineInput(config: config, expenses: expenses);

        // Warm-up JIT
        for (var i = 0; i < 5; i++) {
          computeSnapshot(input, const LocalDate(2026, 1, 15));
        }

        // Đo đạc thời gian chạy thực tế
        final stopwatch = Stopwatch()..start();
        final snapshot = computeSnapshot(input, const LocalDate(2026, 1, 15));
        stopwatch.stop();

        expect(snapshot, isNotNull);
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(10),
          reason:
              'computeSnapshot mất ${stopwatch.elapsedMilliseconds} ms (vượt ngưỡng 10 ms)',
        );
      },
    );
  });
}
