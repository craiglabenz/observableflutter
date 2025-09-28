import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_watcher/src/features/chat/data/chat_message.dart';

/// A service that interacts with the YouTube Data API.
class YouTubeService {
  /// Creates a YouTube service.
  YouTubeService(this._apiKey, this._videoId, this._client);

  final String _apiKey;
  final String _videoId;
  final http.Client _client;

  static const String _youtubeApiBaseUrl =
      'https://www.googleapis.com/youtube/v3';

  Future<String?> _getLiveChatId() async {
    final url = Uri.parse(
      '$_youtubeApiBaseUrl/videos?part=liveStreamingDetails&id=$_videoId&key=$_apiKey',
    );
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>?;
      if (items != null && items.isNotEmpty) {
        final item = items[0] as Map<String, dynamic>;
        final details = item['liveStreamingDetails'] as Map<String, dynamic>?;
        return details?['activeLiveChatId'] as String?;
      }
    }
    return null;
  }

  /// Fetches the chat messages from the YouTube live stream.
  Future<List<ChatMessage>> getChatMessages() async {
    final liveChatId = await _getLiveChatId();
    if (liveChatId == null) {
      return [];
    }

    final url = Uri.parse(
      '$_youtubeApiBaseUrl/liveChat/messages?liveChatId=$liveChatId&part=snippet,authorDetails&key=$_apiKey',
    );
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final items = data['items'] as List<dynamic>?;
      if (items != null) {
        final messages = <ChatMessage>[];
        for (final item in items) {
          final itemMap = item as Map<String, dynamic>;
          final authorDetails =
              itemMap['authorDetails'] as Map<String, dynamic>;
          final snippet = itemMap['snippet'] as Map<String, dynamic>;
          messages.add(
            ChatMessage(
              id: itemMap['id'] as String,
              author: authorDetails['displayName'] as String,
              message: snippet['displayMessage'] as String,
              profileImageUrl: authorDetails['profileImageUrl'] as String,
            ),
          );
        }
        return messages;
      }
    }
    return [];
  }
}
