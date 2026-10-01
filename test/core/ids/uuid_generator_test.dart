import 'package:flutter_test/flutter_test.dart';
import 'package:safe_to_spend/core/ids/uuid_generator.dart';
import '../../helpers/fake_uuid_generator.dart';

void main() {
  group('UuidGenerator', () {
    test(
      'T01-EXT-2: DefaultUuidGenerator produces valid v4 UUIDs and Fake produces sequential IDs',
      () {
        const generator = DefaultUuidGenerator();
        final id1 = generator.generate();
        final id2 = generator.generate();

        expect(id1, isNot(equals(id2)));
        // Standard UUID v4 format: 8-4-4-4-12 hex characters
        final v4Regex = RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
          caseSensitive: false,
        );
        expect(v4Regex.hasMatch(id1), isTrue);
        expect(v4Regex.hasMatch(id2), isTrue);

        final fake = FakeUuidGenerator(prefix: 'test-id');
        expect(fake.generate(), equals('test-id-0001'));
        expect(fake.generate(), equals('test-id-0002'));

        fake.reset();
        expect(fake.generate(), equals('test-id-0001'));
      },
    );
  });
}
