import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:safe_to_spend/data/services/deep_link_service.dart';
import 'package:safe_to_spend/domain/services/i_deep_link_service.dart';

import '../../helpers/mock_services.dart';

void main() {
  late MockProfileRepository mockProfileRepo;
  late MockAnalyticsService mockAnalyticsService;
  late StreamController<Uri> uriStreamController;
  late DeepLinkService deepLinkService;

  setUp(() {
    mockProfileRepo = MockProfileRepository();
    mockAnalyticsService = MockAnalyticsService();
    uriStreamController = StreamController<Uri>.broadcast();

    deepLinkService = DeepLinkService(
      profileRepo: mockProfileRepo,
      analytics: mockAnalyticsService,
      incomingUriStream: uriStreamController.stream,
    );
  });

  tearDown(() async {
    await uriStreamController.close();
  });

  group('DeepLinkService (T04-DOD)', () {
    test(
      'T04-DOD: parses safetospend://quick-add?source=widget and emits quick-add event with source',
      () async {
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => true);
        when(
          () => mockAnalyticsService.logEvent(
            any(),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async {});

        QuickAddTriggerEvent? receivedEvent;
        final subscription = deepLinkService.quickAddTriggerStream.listen((
          event,
        ) {
          receivedEvent = event;
        });

        deepLinkService.handleUri(
          Uri.parse('safetospend://quick-add?source=widget'),
        );

        await pumpEventQueue();

        expect(receivedEvent, isNotNull);
        expect(receivedEvent?.source, 'widget');

        await subscription.cancel();
      },
    );

    test(
      'T04-DOD: logs analytics event when quick-add deep link is handled',
      () async {
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => true);
        when(
          () => mockAnalyticsService.logEvent(
            any(),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async {});

        deepLinkService.handleUri(
          Uri.parse('safetospend://quick-add?source=widget'),
        );

        await pumpEventQueue();

        verify(
          () => mockAnalyticsService.logEvent(
            'deep_link_quick_add',
            parameters: {'source': 'widget'},
          ),
        ).called(1);
      },
    );

    test(
      'T04-DOD: does not trigger quick-add event if user has not completed onboarding',
      () async {
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => false);

        var triggered = false;
        final subscription = deepLinkService.quickAddTriggerStream.listen((_) {
          triggered = true;
        });

        deepLinkService.handleUri(
          Uri.parse('safetospend://quick-add?source=widget'),
        );

        await pumpEventQueue();

        expect(triggered, isFalse);

        await subscription.cancel();
      },
    );

    test(
      'T04-DOD: ignores unknown host or unsupported URI scheme gracefully',
      () async {
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => true);

        var triggered = false;
        final subscription = deepLinkService.quickAddTriggerStream.listen((_) {
          triggered = true;
        });

        // Wrong scheme & wrong host
        deepLinkService
          ..handleUri(Uri.parse('https://example.com/quick-add'))
          ..handleUri(Uri.parse('safetospend://unknown-host'));

        await pumpEventQueue();

        expect(triggered, isFalse);

        await subscription.cancel();
      },
    );

    test(
      'T04-DOD: listens to incoming URI stream and handles deep links automatically',
      () async {
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => true);
        when(
          () => mockAnalyticsService.logEvent(
            any(),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async {});

        QuickAddTriggerEvent? receivedEvent;
        final subscription = deepLinkService.quickAddTriggerStream.listen((
          event,
        ) {
          receivedEvent = event;
        });

        await deepLinkService.init();

        uriStreamController.add(
          Uri.parse('safetospend://quick-add?source=lockscreen'),
        );

        await pumpEventQueue();

        expect(receivedEvent, isNotNull);
        expect(receivedEvent?.source, 'lockscreen');

        await subscription.cancel();
      },
    );

    test(
      'T04-DOD: deduplicates identical deep link events within debounce window',
      () async {
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => true);
        when(
          () => mockAnalyticsService.logEvent(
            any(),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async {});

        var eventCount = 0;
        final subscription = deepLinkService.quickAddTriggerStream.listen((_) {
          eventCount++;
        });

        final uri = Uri.parse('safetospend://quick-add?source=widget');
        deepLinkService
          ..handleUri(uri)
          ..handleUri(uri);

        await pumpEventQueue();

        expect(eventCount, 1);

        await subscription.cancel();
      },
    );

    test(
      'T04-DOD: retrieves and processes cold start initial deep link on init',
      () async {
        final mockAppLinks = MockAppLinks();
        when(
          () => mockProfileRepo.hasCompletedOnboarding(),
        ).thenAnswer((_) async => true);
        when(
          () => mockAnalyticsService.logEvent(
            any(),
            parameters: any(named: 'parameters'),
          ),
        ).thenAnswer((_) async {});
        when(mockAppLinks.getInitialLink).thenAnswer(
          (_) async => Uri.parse('safetospend://quick-add?source=cold_start'),
        );
        when(
          () => mockAppLinks.uriLinkStream,
        ).thenAnswer((_) => const Stream<Uri>.empty());

        final coldStartService = DeepLinkService(
          profileRepo: mockProfileRepo,
          analytics: mockAnalyticsService,
          appLinks: mockAppLinks,
        );

        QuickAddTriggerEvent? receivedEvent;
        final subscription = coldStartService.quickAddTriggerStream.listen((
          event,
        ) {
          receivedEvent = event;
        });

        await coldStartService.init();
        await pumpEventQueue();

        expect(receivedEvent, isNotNull);
        expect(receivedEvent?.source, 'cold_start');

        await subscription.cancel();
        await coldStartService.dispose();
      },
    );
  });
}
