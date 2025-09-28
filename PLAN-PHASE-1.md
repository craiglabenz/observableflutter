## Progress Checklist

- [x] Step 1: Project Initialization and Dependency Setup
- [x] Step 2: Initial Setup Screen UI
- [x] Step 3: Credentials Storage and Logic
- [x] Step 4: Chat Screen UI and Navigation
- [x] Step 5: YouTube Service and Data Model
- [x] Step 6: State Management for Chat Screen
- [x] Step 7: Custom Paint Widgets for Chat Bubbles
- [x] Step 8: Final Touches and Error Handling

# Development Plan: YouTube Live Chat Viewer

This document outlines the incremental steps to build the YouTube Live Chat Viewer application, based on the `PRD.md`. Each step includes testing to ensure correctness before proceeding to the next.

### Step 1: Project Initialization and Dependency Setup

1.  **Action:** Create a new Flutter project named `youtube_watcher`.
2.  **Action:** Add the required dependencies to `pubspec.yaml`: `flutter_riverpod`, `riverpod_annotation`, `go_router`, `http`, `shared_preferences`.
3.  **Action:** Add development dependencies: `build_runner`, `custom_lint`, `riverpod_generator`, `riverpod_lint`.
4.  **Action:** Configure `analysis_options.yaml` to enable Riverpod linting rules.
5.  **Testing:**
    *   Create a simple "smoke test" (`widget_test.dart`) to ensure the test environment is working correctly.
    *   Run `flutter test` to verify.

### Step 2: Initial Setup Screen UI

1.  **Action:** Create the UI for the "Initial Setup" screen (`values_input_screen.dart`). This will be a stateless widget for now. It will contain two `TextField` widgets for the API Key and Video ID, and a "Save" `Button`.
2.  **Action:** Create a basic `router.dart` file to display this screen as the initial route.
3.  **Action:** Update `main.dart` to use `go_router`.
4.  **Testing:**
    *   Write a widget test to verify that the setup screen renders correctly with the required input fields and button.

### Step 3: Credentials Storage and Logic

1.  **Action:** Create a `CredentialsRepository` class that uses `shared_preferences` to save and retrieve the API Key and Video ID.
2.  **Action:** Create a Riverpod provider for the `CredentialsRepository`.
3.  **Action:** Implement the logic in the setup screen to use the repository when the "Save" button is pressed.
4.  **Testing:**
    *   Write unit tests for the `CredentialsRepository` to verify that saving and retrieving data works as expected. Use `SharedPreferences.setMockInitialValues` for testing.

### Step 4: Chat Screen UI and Navigation

1.  **Action:** Create the basic UI for the "Chat" screen (`chat_screen.dart`). It will contain an empty `ListView` for now.
2.  **Action:** Update the router to include a route for the chat screen.
3.  **Action:** Implement the navigation logic: after successfully saving credentials on the setup screen, navigate to the chat screen.
4.  **Testing:**
    *   Write a widget test for the chat screen to verify it renders a `ListView`.
    *   Write a test to verify that tapping the "Save" button on the setup screen navigates to the chat screen when credentials are valid.

### Step 5: YouTube Service and Data Model

1.  **Action:** Create a `ChatMessage` data model class.
2.  **Action:** Create a `YouTubeService` class responsible for fetching chat messages from the YouTube Data API. It will take the API key and video ID as parameters.
3.  **Action:** Implement the `_getLiveChatId` and `_getChatMessages` methods using the `http` package.
4.  **Testing:**
    *   Write unit tests for the `YouTubeService`. Use a mock `http.Client` to simulate API responses (both success and failure cases) and verify that the service parses the data correctly.

### Step 6: State Management for Chat Screen

1.  **Action:** Create a `ChatController` using a Riverpod `NotifierProvider`. This controller will:
    *   Use the `YouTubeService` to fetch new chat messages.
    *   Manage the state of the chat messages list (`List<ChatMessage>`).
    *   Handle the selection and deselection of a message.
    *   Expose the state to the UI.
2.  **Action:** Refactor the `ChatScreen` to be a `ConsumerWidget` and display the list of messages from the `ChatController`.
3.  **Testing:**
    *   Write unit tests for the `ChatController`, mocking the `YouTubeService` to test the logic of adding messages and handling selection.

### Step 7: Custom Paint Widgets for Chat Bubbles

1.  **Action:** Create a `ChatBubble` widget that uses `CustomPaint` to draw a unique chat bubble shape.
2.  **Action:** The widget will take a `ChatMessage` and display the author's name, message, and a placeholder for the profile picture.
3.  **Action:** Integrate the `ChatBubble` widget into the `ChatScreen`'s `ListView`.
4.  **Testing:**
    *   Write a widget test for the `ChatBubble` to ensure it renders correctly with the provided message data.
    *   Use `flutter_test`'s `matchesGoldenFile` to perform golden file testing on the custom-painted widget to prevent visual regressions.

### Step 8: Final Touches and Error Handling

1.  **Action:** Implement UI feedback for loading states (e.g., a `CircularProgressIndicator` while fetching messages).
2.  **Action:** Implement UI feedback for error states (e.g., displaying a `SnackBar` or an error message on the screen if the API call fails).
3.  **Action:** Polish the overall UI and user experience.
4.  **Testing:**
    *   Write widget tests to verify that loading and error states are displayed correctly in the UI.