import 'dart:math';

import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

import 'helpers/test_factories.dart';

void main() {
  group('Financial Invariants & Conservation of Money', () {
    test(
      'T02-21: Bất biến: Σ allowance (Spread, không tiêu vượt) = pool qua 1.000 cấu hình ngẫu nhiên (seed cố định)',
      () {
        final rng = Random(42); // Seed cố định để kết quả tất định

        for (var i = 0; i < 1000; i++) {
          // Sinh pool ngẫu nhiên từ 100 cents ($1.00) đến 1,000,000 cents ($10,000.00)
          final poolCents = rng.nextInt(999901) + 100;
          // Độ dài kỳ từ 1 đến 31 ngày
          final periodDays = rng.nextInt(31) + 1;

          final startDay = 31 - periodDays + 1;
          final trackingStart = LocalDate(2026, 1, startDay);

          final config = testBudgetConfig(
            incomeMode: IncomeMode.fixed,
            payFrequency: PayFrequency.monthly,
            payAnchorDate: const LocalDate(2026, 1, 1),
            firstPeriodBalance: Money(poolCents),
            trackingStartDate: trackingStart,
            bufferPercent: 0,
            rolloverMode: RolloverMode.spread,
          );

          var sumAllowances = const Money(0);
          final expenses = <Expense>[];

          for (var day = startDay; day <= 31; day++) {
            final today = LocalDate(2026, 1, day);
            final currentInput = testEngineInput(
              config: config,
              expenses: expenses,
            );
            final snapshot = computeSnapshot(currentInput, today);

            sumAllowances += snapshot.dailyAllowanceToday;
            expect(snapshot.safeToday, equals(snapshot.dailyAllowanceToday));

            // Chi tiêu đúng định mức của ngày hôm đó (không tiêu vượt)
            expenses.add(
              Expense(
                id: 'exp-$day',
                amount: snapshot.dailyAllowanceToday,
                spentOn: today,
              ),
            );
          }

          // Kiểm tra tổng hạn mức phân bổ cho mọi ngày chính xác tuyệt đối bằng pool
          // (Không mất hoặc thừa 1 cent nào)
          expect(
            sumAllowances.cents,
            equals(poolCents),
            reason:
                'Thất bại tại lần lặp $i: poolCents=$poolCents, periodDays=$periodDays, sumAllowances=${sumAllowances.cents}',
          );
        }
      },
    );

    test(
      'T02-21b: Bất biến: Σ allowance gốc + derivedGoalSaved = pool cho Save mode qua 500 cấu hình ngẫu nhiên',
      () {
        final rng = Random(123);
        const goal = Goal(
          id: 'g-invar-save',
          name: 'Emergency Fund',
          targetAmount: Money(10000000), // $100,000.00
          perPaycheckAmount: Money(0),
          createdOn: LocalDate(2026, 1, 1),
        );

        for (var i = 0; i < 500; i++) {
          final poolCents = rng.nextInt(999901) + 100;
          final periodDays = rng.nextInt(31) + 1;
          final startDay = 31 - periodDays + 1;
          final trackingStart = LocalDate(2026, 1, startDay);

          final config = testBudgetConfig(
            incomeMode: IncomeMode.fixed,
            payFrequency: PayFrequency.monthly,
            payAnchorDate: const LocalDate(2026, 1, 1),
            firstPeriodBalance: Money(poolCents),
            trackingStartDate: trackingStart,
            bufferPercent: 0,
            rolloverMode: RolloverMode.save,
          );

          // Trường hợp 1: Người dùng chi tiêu ngẫu nhiên một phần hạn mức (<= allowance)
          // Bất biến: tổng chi tiêu các ngày trước + derivedGoalSaved + allowance hôm nay = pool
          final expenses = <Expense>[];
          var sumPastSpent = const Money(0);

          for (var day = startDay; day <= 31; day++) {
            final today = LocalDate(2026, 1, day);
            final currentInput = testEngineInput(
              config: config,
              goal: goal,
              expenses: expenses,
            );
            final snapshot = computeSnapshot(currentInput, today);

            final derivedSaved =
                snapshot.goalProgress?.savedAmount ?? const Money(0);

            // Bất biến: Tiền đã tiêu quá khứ + Tiền đã tích lũy vào Goal + Hạn mức còn lại = Pool
            // (remainingInPeriod chính là tổng hạn mức còn lại từ hôm nay đến hết kỳ)
            expect(
              sumPastSpent + derivedSaved + snapshot.remainingInPeriod,
              equals(Money(poolCents)),
              reason:
                  'Lỗi bảo toàn tiền tại ngày $day trong kỳ $periodDays ngày',
            );

            // Chi tiêu ngẫu nhiên từ 0 đến dailyAllowanceToday
            final spendCents = snapshot.dailyAllowanceToday.cents > 0
                ? rng.nextInt(snapshot.dailyAllowanceToday.cents + 1)
                : 0;
            final spentAmount = Money(spendCents);
            sumPastSpent += spentAmount;

            expenses.add(
              Expense(id: 'exp-$day', amount: spentAmount, spentOn: today),
            );
          }
        }
      },
    );

    test('T02-22: divideEvenly không làm mất/thừa cent qua cả kỳ', () {
      // Kiểm thử các trường hợp số nguyên, số dư lẻ và số phần tử khác nhau
      final testCases = [
        (1000, 3, [334, 333, 333]),
        (1000, 7, [143, 143, 143, 143, 143, 143, 142]),
        (1, 5, [1, 0, 0, 0, 0]),
        (0, 10, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]),
        (99999999, 31, null), // Giá trị cực lớn
      ];

      for (final tc in testCases) {
        final total = Money(tc.$1);
        final parts = total.divideEvenly(tc.$2);

        // 1. Số phần bằng đúng parts
        expect(parts.length, equals(tc.$2));

        // 2. Tổng các phần bằng chính xác số tiền ban đầu
        final sum = parts.fold(const Money(0), (acc, m) => acc + m);
        expect(sum, equals(total));

        // 3. Nếu có mẫu cụ thể, kiểm tra từng phần tử
        if (tc.$3 != null) {
          expect(parts.map((m) => m.cents).toList(), equals(tc.$3));
        }
      }
    });
  });
}
