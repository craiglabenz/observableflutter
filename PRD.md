
# Product Requirements Document: YouTube Live Chat Viewer

## 1. Introduction

The YouTube Live Chat Viewer is a desktop application that allows users to monitor and interact with the live chat of a YouTube stream. The app provides a clean, real-time interface for viewing chat messages, selecting individual comments, and securely managing API credentials.

## 2. User Stories

- **As a user, I want to:**
  - Securely enter my YouTube API key and the video ID of the live stream I want to watch.
  - View live chat messages in a real-time, scrollable list.
  - Select a specific chat message to highlight it for further action.
  - Be notified of any errors that occur while fetching chat messages.

## 3. Features

### 3.1. Initial Setup Screen

- A dedicated screen for users to input their YouTube API key and the video ID of the live stream.
- Input fields for both values, with the API key being obscured for security.
- A "Save" button to store the credentials and navigate to the chat screen.
- Credentials should be persisted locally and securely.

### 3.2. Live Chat Screen

- A real-time display of chat messages from the specified YouTube live stream.
- Each message should show the author's display name, a profile picture, and the message content.
- The chat should auto-scroll as new messages arrive.
- Users can select a message by tapping on it, which will highlight it visually.
- Tapping on a chat message will save an image of that message to a file.
- Tapping the same message again will deselect it.

### 3.3. Error Handling

- The app should gracefully handle errors, such as:
  - Invalid API key or video ID.
  - Network connectivity issues.
  - Failure to fetch chat messages from the YouTube API.
- Informative error messages should be displayed to the user.

## 4. Technical Requirements

### 4.1. Platform

- The application will be built using Flutter for cross-platform desktop support (macOS, Windows, Linux).

### 4.2. Architecture

- **State Management and Dependency Injection:** `riverpod` will be used for both state management and dependency injection, providing a reactive and scalable architecture.
- **Routing:** `go_router` will handle navigation between the setup and chat screens.
- **UI:** The UI will be built using custom paint widgets to create a unique and tailored look and feel.

### 4.3. API Integration

- The app will use the YouTube Data API v3 to fetch live chat messages.
- API requests will be made using the `http` package.
- The app will poll the API at a regular interval (e.g., every 5 seconds) to fetch new messages.

### 4.4. Security

- The YouTube API key will be stored securely on the user's device using `shared_preferences` or a more secure storage solution.
- The API key will not be hardcoded in the application.

## 5. Future Enhancements

- **Real-time Updates with WebSockets:** Explore using WebSockets or a more efficient real-time communication method to reduce API polling.
- **Message Actions:** Allow users to perform actions on selected messages, such as copying the message text or viewing the author's channel.
- **OAuth 2.0 Integration:** Implement OAuth 2.0 for authentication, so users don't have to manually provide an API key.
- **Multi-Stream Support:** Allow users to watch multiple live streams simultaneously.
- **Customizable UI:** Provide options for users to customize the look and feel of the chat display.
