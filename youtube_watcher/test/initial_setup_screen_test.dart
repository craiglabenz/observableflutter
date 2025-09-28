import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_watcher/src/features/initial_setup/data/credentials_repository.dart';
import 'package:youtube_watcher/src/features/initial_setup/data/initial_setup_providers.dart';
import 'package:youtube_watcher/src/features/initial_setup/presentation/initial_setup_screen.dart';

void main() {
  testWidgets('InitialSetupScreen renders correctly and navigates',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();

    // Set up a mock router for testing navigation
    final mockGoRouter = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const InitialSetupScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) =>
              const Scaffold(body: Text('Chat Screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider
              .overrideWith((ref) async => sharedPreferences),
        ],
        child: MaterialApp.router(
          routerConfig: mockGoRouter,
        ),
      ),
    );

    // The first pump is not enough to have the SharedPreferences loaded.
    await tester.pumpAndSettle();

    // Verify that the title is rendered.
    expect(find.text('YouTube Live Chat Viewer'), findsOneWidget);

    // Verify that the TextFields are rendered.
    expect(find.widgetWithText(TextField, 'API Key'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Video ID'), findsOneWidget);

    // Verify that the Save button is rendered.
    expect(find.widgetWithText(ElevatedButton, 'Save'), findsOneWidget);

    // Enter text into the fields
    await tester.enterText(
        find.widgetWithText(TextField, 'API Key'), 'test-key');
    await tester.enterText(
        find.widgetWithText(TextField, 'Video ID'), 'test-id');

    // Tap the save button
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Verify that we have navigated to the chat screen
    expect(find.text('Chat Screen'), findsOneWidget);

    // Verify that the credentials were saved
    final credentialsRepository = CredentialsRepository(sharedPreferences);
    expect(credentialsRepository.getApiKey(), 'test-key');
    expect(credentialsRepository.getVideoId(), 'test-id');
  });
}
