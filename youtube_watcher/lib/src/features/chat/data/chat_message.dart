/// A chat message from a YouTube live stream.
class ChatMessage {
  /// Creates a chat message.
  const ChatMessage({
    required this.id,
    required this.author,
    required this.message,
    required this.profileImageUrl,
  });

  /// The ID of the message.
  final String id;

  /// The author of the message.
  final String author;

  /// The message content.
  final String message;

  /// The URL of the author's profile image.
  final String profileImageUrl;
}
