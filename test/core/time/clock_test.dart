import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/time/clock.dart';
import '../../helpers/fake_clock.dart';

void main() {
  group('Clock', () {
    test(
      'T01-EXT-1: SystemClock returns current time and FakeClock can advance',
      () {
        const systemClock = SystemClock();
        final now1 = systemClock.now();
        expect(
          now1.isBefore(DateTime.now().add(const Duration(seconds: 1))),
          isTrue,
        );

        final fakeClock = FakeClock(DateTime.utc(2026, 1, 1, 8));
        expect(fakeClock.now(), equals(DateTime.utc(2026, 1, 1, 8)));

        fakeClock.advance(const Duration(hours: 4));
        expect(fakeClock.now(), equals(DateTime.utc(2026, 1, 1, 12)));

        fakeClock.time = DateTime.utc(2026, 5, 20);
        expect(fakeClock.now(), equals(DateTime.utc(2026, 5, 20)));
      },
    );
  });
}
