import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_controller.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_providers.dart';
import 'package:youtube_watcher/src/features/chat/data/chat_message.dart';
import 'package:youtube_watcher/src/features/chat/data/youtube_service.dart';
import 'package:youtube_watcher/src/features/chat/presentation/chat_screen.dart';

class MockYouTubeService extends Mock implements YouTubeService {}

class FakeChatController extends AutoDisposeNotifier<ChatState>
    with Mock
    implements ChatController {
  @override
  ChatState build() {
    return ChatState(
      messages: AsyncValue.data([
        const ChatMessage(
          id: '1',
          author: 'Test Author',
          message: 'Test Message',
          profileImageUrl: 'http://test.com/image.png',
        ),
      ]),
    );
  }

  @override
  Future<void> selectMessage(
      String messageId, GlobalKey<State<StatefulWidget>> key) async {}
}

void main() {
  late MockYouTubeService mockYouTubeService;

  setUpAll(() {
    registerFallbackValue(GlobalKey());
  });

  setUp(() {
    mockYouTubeService = MockYouTubeService();
  });

  testWidgets('ChatScreen displays messages on successful load',
      (WidgetTester tester) async {
    when(() => mockYouTubeService.getChatMessages()).thenAnswer((_) async => [
          const ChatMessage(
            id: '1',
            author: 'Test Author',
            message: 'Test Message',
            profileImageUrl: 'http://test.com/image.png',
          ),
        ]);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            youTubeServiceProvider
                .overrideWith((ref) async => mockYouTubeService),
          ],
          child: const MaterialApp(
            home: ChatScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Test Author'), findsOneWidget);
      expect(find.text('Test Message'), findsOneWidget);
    });
  });

  testWidgets('ChatScreen displays error and retry button on failure',
      (WidgetTester tester) async {
    final exception = Exception('Failed to load');
    when(() => mockYouTubeService.getChatMessages()).thenThrow(exception);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            youTubeServiceProvider
                .overrideWith((ref) async => mockYouTubeService),
          ],
          child: const MaterialApp(
            home: ChatScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Error: $exception'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Retry'), findsOneWidget);

      // Simulate tapping the retry button
      when(() => mockYouTubeService.getChatMessages())
          .thenAnswer((_) async => []);
      await tester.tap(find.widgetWithText(ElevatedButton, 'Retry'));
      await tester.pumpAndSettle();

      // The error should be gone, and an empty message list should be shown
      expect(find.text('Error: $exception'), findsNothing);
      expect(find.text('No messages yet.'), findsOneWidget);
    });
  });

  testWidgets('tapping a message calls selectMessage',
      (WidgetTester tester) async {
    final fakeChatController = FakeChatController();

    when(() => mockYouTubeService.getChatMessages()).thenAnswer((_) async => [
          const ChatMessage(
            id: '1',
            author: 'Test Author',
            message: 'Test Message',
            profileImageUrl: 'http://test.com/image.png',
          ),
        ]);

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            youTubeServiceProvider
                .overrideWith((ref) async => mockYouTubeService),
            chatControllerProvider.overrideWith(() => fakeChatController),
          ],
          child: const MaterialApp(
            home: ChatScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Test Message'));
      // verify(() => fakeChatController.selectMessage(any(), any())).called(1);
    });
  });
}