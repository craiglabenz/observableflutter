## Progress Checklist

- [x] Step 1: Add Dependencies for Image Rendering and File System Access
- [x] Step 2: Create a Service to Handle Image Conversion and Saving
- [x] Step 3: Integrate the Service with the Chat Controller
- [ ] Step 4: Update the UI to Trigger Image Saving
- [ ] Step 5: Add Error Handling and User Feedback

# Development Plan: Save Chat Message as Image

This document outlines the steps to implement the feature of saving a chat message as an image file when a user taps on it.

### Step 1: Add Dependencies for Image Rendering and File System Access

1.  **Action:** Add the `path_provider` package to `pubspec.yaml` to get the application's documents directory.
2.  **Action:** Add the `image` package to `pubspec.yaml` for image manipulation and encoding.
3.  **Action:** Add the `file` package for file system operations.
4.  **Action:** Run `flutter pub get` to install the new dependencies.
5.  **Testing:**
    *   Ensure the project still builds and runs without errors after adding the new dependencies.

### Step 2: Create a Service to Handle Image Conversion and Saving

1.  **Action:** Create a `ScreenshotService` class responsible for:
    *   Taking a `ChatMessage` as input.
    *   Using a `RepaintBoundary` to capture the `ChatBubble` widget as an image.
    *   Converting the captured image to a PNG format using the `image` package.
    *   Saving the PNG file to the application's documents directory using `path_provider` and `file`.
2.  **Action:** Create a Riverpod provider for the `ScreenshotService`.
3.  **Testing:**
    *   Write unit tests for the `ScreenshotService` to verify that it correctly converts a widget to an image and saves it to the file system. Use a mock file system for testing.

### Step 3: Integrate the Service with the Chat Controller

1.  **Action:** Update the `ChatController` to have a dependency on the `ScreenshotService`.
2.  **Action:** Modify the `selectMessage` method in `ChatController` to call the `ScreenshotService` to save the chat message as an image when a message is tapped.
3.  **Testing:**
    *   Write unit tests for the `ChatController` to verify that it calls the `ScreenshotService` when a message is selected.

### Step 4: Update the UI to Trigger Image Saving and Deleting

1.  **Action:** Wrap the `ChatBubble` widget in the `ChatScreen` with a `RepaintBoundary` and a `GlobalKey`.
2.  **Action:** Pass the `GlobalKey` to the `ChatController` when a message is tapped, so the `ScreenshotService` can use it to capture the correct widget.
3.  **Action:** Update the `ChatController` to delete the saved image when the message is deselected.
4.  **Testing:**
    *   Write widget tests to ensure that tapping a `ChatBubble` triggers the image saving logic.
    *   Write unit tests to ensure that deselecting a message deletes the image file.

### Step 5: Add Error Handling and User Feedback

1.  **Action:** Implement error handling in the `ScreenshotService` to catch potential exceptions during file I/O.
2.  **Action:** In the `ChatController`, handle any errors from the `ScreenshotService` and update the UI to show a `SnackBar` or other notification to the user, indicating whether the image was saved successfully or if an error occurred.
3.  **Testing:**
    *   Write widget tests to verify that success and error notifications are displayed correctly to the user.
