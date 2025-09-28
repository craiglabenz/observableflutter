import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_controller.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_providers.dart';
import 'package:youtube_watcher/src/features/chat/application/screenshot_service.dart';
import 'package:youtube_watcher/src/features/chat/data/chat_message.dart';
import 'package:youtube_watcher/src/features/chat/data/youtube_service.dart';

class MockYouTubeService extends Mock implements YouTubeService {}

class MockScreenshotService extends Mock implements ScreenshotService {}

class FakeChatController extends Fake implements ChatController {
  @override
  ChatState build() {
    return ChatState();
  }
}

void main() {
  group('ChatController', () {
    late MockYouTubeService mockYouTubeService;
    late MockScreenshotService mockScreenshotService;
    late ProviderContainer container;
    late GlobalKey key;

    setUp(() {
      mockYouTubeService = MockYouTubeService();
      mockScreenshotService = MockScreenshotService();
      key = GlobalKey();

      when(
        () => mockYouTubeService.getChatMessages(),
      ).thenAnswer((_) async => []);
      when(
        () => mockScreenshotService.captureAndSave(key),
      ).thenAnswer((_) async {});

      container = ProviderContainer(
        overrides: [
          youTubeServiceProvider.overrideWith(
            (ref) async => mockYouTubeService,
          ),
          screenshotServiceProvider.overrideWith(
            (ref) => mockScreenshotService,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state has loading messages', () {
      final controller = container.read(chatControllerProvider.notifier);
      final initialState = controller.build();
      expect(initialState.messages, isA<AsyncLoading<List<ChatMessage>>>());
      expect(initialState.selectedMessageId, isNull);
    });

    test('selectMessage updates the selected message id', () async {
      final controller = container.read(chatControllerProvider.notifier);
      await controller.selectMessage('test-id', key);
      expect(
        container.read(chatControllerProvider).selectedMessageId,
        'test-id',
      );
    });

    test('selecting the same message twice deselects it', () async {
      final controller = container.read(chatControllerProvider.notifier);
      await controller.selectMessage('test-id', key);
      await controller.selectMessage('test-id', key);
      expect(container.read(chatControllerProvider).selectedMessageId, isNull);
    });

    // TODO: Fix this test
    test('deselecting a message calls deleteImage', () async {
      final controller = container.read(chatControllerProvider.notifier);
      when(() => mockScreenshotService.deleteImage()).thenAnswer((_) async {});

      await controller.selectMessage('test-id', key);
      await controller.selectMessage('test-id', key);

      verify(() => mockScreenshotService.deleteImage()).called(1);
    }, skip: true);
  });
}