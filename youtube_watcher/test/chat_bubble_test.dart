import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:youtube_watcher/src/features/chat/data/chat_message.dart';
import 'package:youtube_watcher/src/features/chat/presentation/widgets/chat_bubble.dart';

void main() {
  testWidgets('ChatBubble renders correctly and matches golden file',
      (WidgetTester tester) async {
    const message = ChatMessage(
      id: '1',
      author: 'Randal',
      message: 'This is a test message!',
      profileImageUrl: 'http://test.com/image.png',
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ChatBubble(message: message),
            ),
          ),
        ),
      );

      // Verify that the author and message are rendered.
      expect(find.text('Randal'), findsOneWidget);
      expect(find.text('This is a test message!'), findsOneWidget);

      // Golden file testing
      await expectLater(
        find.byType(ChatBubble),
        matchesGoldenFile('goldens/chat_bubble.png'),
      );
    });
  });
}
