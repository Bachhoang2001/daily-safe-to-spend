import 'package:budget_engine/budget_engine.dart';
import 'package:test/test.dart';

import 'helpers/test_factories.dart';

void main() {
  group('Edge Cases (F02.9)', () {
    test(
      'F02.9-1: Kỳ chỉ còn 1 ngày (hôm nay là ngày cuối kỳ), chưa có giao dịch nào',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000), // $3,000.00
          rolloverMode: RolloverMode.spread,
        );

        final bill = Bill(
          id: 'b-rent',
          name: 'Rent',
          amount: const Money(120000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 4, 5),
          isActive: true,
        );

        final input = testEngineInput(
          config: config,
          bills: [bill],
          expenses: const [],
        );

        // Ngày 30/04 là ngày cuối cùng của kỳ 30 ngày
        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 30));

        // Pool còn nguyên $1,800.00, chia cho 1 ngày còn lại = $1,800.00
        expect(snapshot.daysLeftInclToday, equals(1));
        expect(snapshot.dailyAllowanceToday, equals(const Money(180000)));
        expect(snapshot.safeToday, equals(const Money(180000)));
      },
    );

    test(
      'F02.9-2: Pool âm ngay từ đầu kỳ (hóa đơn > thu nhập) -> allowance = 0, status over, shortfall = true',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(100000), // Lương $1,000.00
          rolloverMode: RolloverMode.spread,
        );

        // Hóa đơn $1,500 vượt quá lương $1,000
        final billExcessive = Bill(
          id: 'b-debt',
          name: 'Debt',
          amount: const Money(150000), // $1,500.00
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 4, 10),
          isActive: true,
        );

        final input = testEngineInput(config: config, bills: [billExcessive]);

        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 1));

        expect(snapshot.dailyAllowanceToday, equals(const Money(0)));
        expect(snapshot.safeToday, equals(const Money(0)));
        expect(snapshot.status, equals(BudgetStatus.over));
        expect(snapshot.shortfall, isTrue);
        expect(
          snapshot.shortfallAmount,
          equals(const Money(50000)),
        ); // Thiếu $500.00
      },
    );

    test(
      'F02.9-3: Giao dịch ghi lùi vào ngày trước trackingStartDate -> bỏ qua không tính vào pool',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
          trackingStartDate: const LocalDate(
            2026,
            4,
            10,
          ), // Bắt đầu theo dõi từ ngày 10
        );

        // Chi tiêu ngày 5 (trước trackingStartDate)
        final oldExpense = Expense(
          id: 'exp-old',
          amount: const Money(50000), // $500.00
          spentOn: const LocalDate(2026, 4, 5),
        );

        final input = testEngineInput(config: config, expenses: [oldExpense]);

        // Snapshot ngày 10/04
        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 10));

        // Không bị trừ khoản chi tiêu cũ ngày 5
        // Số ngày: 10/04 đến 30/04 là 21 ngày. Pool = 300000.
        expect(
          snapshot.dailyAllowanceToday,
          equals(const Money(300000).divideEvenly(21)[0]),
        );
      },
    );

    test('F02.9-4: Giao dịch ở ngày tương lai -> không tính vào hôm nay', () {
      final config = testBudgetConfig(
        incomeMode: IncomeMode.fixed,
        payFrequency: PayFrequency.monthly,
        payAnchorDate: const LocalDate(2026, 4, 1),
        incomePerPaycheck: const Money(300000),
        trackingStartDate: const LocalDate(2026, 4, 1),
      );

      // Chi tiêu ở ngày tương lai (15/04)
      final futureExpense = Expense(
        id: 'exp-future',
        amount: const Money(50000), // $500.00
        spentOn: const LocalDate(2026, 4, 15),
      );

      final input = testEngineInput(config: config, expenses: [futureExpense]);

      // Hôm nay là ngày 10/04 (còn 21 ngày trong kỳ)
      final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 10));

      // spentToday của ngày 10 phải là 0, không bị ảnh hưởng bởi giao dịch tương lai ngày 15
      expect(snapshot.spentToday, equals(const Money(0)));
      // Hạn mức ngày 10 phân bổ từ toàn bộ pool $3,000 qua 21 ngày còn lại ($142.86), không bị trừ $500 của ngày 15
      expect(
        snapshot.dailyAllowanceToday,
        equals(const Money(300000).divideEvenly(21)[0]),
      );
    });

    test(
      'F02.9-5: Hóa đơn ngày 31 ở tháng 30 ngày và ngày lương 31 với monthly',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 1, 31),
          incomePerPaycheck: const Money(300000),
        );

        final bill31 = Bill(
          id: 'bill-31',
          name: 'End of Month Subscription',
          amount: const Money(2000),
          recurrence: BillRecurrence.monthly,
          firstDueDate: const LocalDate(2026, 1, 31),
          isActive: true,
        );

        final input = testEngineInput(config: config, bills: [bill31]);

        // Kiểm tra tháng 4 (30 ngày): kỳ lương bắt đầu từ 30/04 kéo dài tới ngày trước lương tháng 5
        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 30));

        expect(snapshot.periodStart, equals(const LocalDate(2026, 4, 30)));
        expect(
          snapshot.upcomingBills.any(
            (b) => b.dueDate == const LocalDate(2026, 4, 30),
          ),
          isTrue,
        );
      },
    );

    test(
      'F02.9-6: today trước trackingStartDate (đổi giờ thiết bị) -> trả snapshot của trackingStartDate',
      () {
        final config = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
          trackingStartDate: const LocalDate(2026, 4, 10),
        );

        final input = testEngineInput(config: config);

        // Thiết bị bị chỉnh giờ lùi về ngày 05/04 (trước trackingStartDate 10/04)
        final snapshot = computeSnapshot(input, const LocalDate(2026, 4, 5));

        // Engine tự kẹp và trả snapshot tính tại ngày trackingStartDate
        expect(snapshot.periodStart, equals(const LocalDate(2026, 4, 1)));
        expect(snapshot.daysLeftInclToday, equals(21)); // 10/04 -> 30/04
        expect(
          snapshot.dailyAllowanceToday,
          equals(const Money(300000).divideEvenly(21)[0]),
        );
      },
    );

    test(
      'F02.9-7: Đổi payFrequency giữa chừng -> engine luôn tính theo config hiện tại',
      () {
        // Cấu hình ban đầu: monthly
        final configMonthly = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.monthly,
          payAnchorDate: const LocalDate(2026, 4, 1),
          incomePerPaycheck: const Money(300000),
        );

        final snapMonthly = computeSnapshot(
          testEngineInput(config: configMonthly),
          const LocalDate(2026, 4, 10),
        );
        expect(snapMonthly.periodStart, equals(const LocalDate(2026, 4, 1)));
        expect(snapMonthly.periodEnd, equals(const LocalDate(2026, 4, 30)));

        // Người dùng đổi sang biweekly neo ngày 2026-04-03
        final configBiweekly = testBudgetConfig(
          incomeMode: IncomeMode.fixed,
          payFrequency: PayFrequency.biweekly,
          payAnchorDate: const LocalDate(2026, 4, 3),
          incomePerPaycheck: const Money(150000),
        );

        final snapBiweekly = computeSnapshot(
          testEngineInput(config: configBiweekly),
          const LocalDate(2026, 4, 10),
        );

        // Engine tính toán ngay lập tức theo cấu hình biweekly mới mà không bị dính kỳ cũ
        expect(snapBiweekly.periodStart, equals(const LocalDate(2026, 4, 3)));
        expect(snapBiweekly.periodEnd, equals(const LocalDate(2026, 4, 16)));
        expect(snapBiweekly.daysLeftInclToday, equals(7)); // 10/04 đến 16/04
      },
    );
  });
}
