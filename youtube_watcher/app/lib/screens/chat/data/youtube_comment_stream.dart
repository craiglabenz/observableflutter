import 'dart:async';
import 'dart:convert';
import 'package:app/screens/values_input/values_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

class YouTubeCommentStream {
  YouTubeCommentStream()
    : _controller = StreamController<ChatMessage>(),
      _valuesRepo = GetIt.I<ValuesRepository>();

  final ValuesRepository _valuesRepo;

  void initialize() {
    if (_valuesRepo.videoId != null) {
      _getLiveChatId(_valuesRepo.videoId!).then(
        (String? liveChatId) {
          if (liveChatId != null) {
            Timer.periodic(const Duration(seconds: 5), (timer) async {
              await _getChatMessages(liveChatId);
            });
          }
        },
      );
    } else {
      print('No videoId in the repo');
    }
  }

  /// Retrieves the liveChatId for a given video ID.
  Future<String?> _getLiveChatId(String videoId) async {
    final url = Uri.parse(
      '$youtubeApiBaseUrl/videos?part=liveStreamingDetails&id=$videoId&key=${_valuesRepo.apiKey}',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null && data['items'].isNotEmpty) {
        return data['items'][0]['liveStreamingDetails']['activeLiveChatId'];
      }
    }
    return null;
  }

  /// Fetches and prints new chat messages for the given liveChatId.
  Future<void> _getChatMessages(String liveChatId) async {
    final url = Uri.parse(
      '$youtubeApiBaseUrl/liveChat/messages?liveChatId=$liveChatId&part=snippet,authorDetails&key=${_valuesRepo.apiKey}',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['items'] != null) {
        for (final item in data['items']) {
          final messageId = item['id'];
          if (!_processedMessageIds.contains(messageId)) {
            final author = item['authorDetails']['displayName'];
            final profileImage = item['authorDetails']['profileImageUrl'];
            final message = item['snippet']['displayMessage'];
            final chatMessage = ChatMessage(
              id: messageId,
              username: author,
              photo: profileImage,
              message: message,
            );
            _controller.add(chatMessage);
            _processedMessageIds.add(messageId);
          }
        }
      }
    } else {
      // ignore: avoid_print
      print('Failed to fetch chat messages: ${response.body}');
    }
  }

  final StreamController<ChatMessage> _controller;

  Stream<ChatMessage> get stream => _controller.stream;

  close() {
    _controller.close();
  }
}

class ChatMessage {
  const ChatMessage({
    required this.username,
    required this.photo,
    required this.message,
    required this.id,
  });

  final String id;
  final String username;
  final String photo;
  final String message;
}

// The base URL for the YouTube Data API.
const String youtubeApiBaseUrl = 'https://www.googleapis.com/youtube/v3';

// A set to store the IDs of messages we've already processed.
final Set<String> _processedMessageIds = <String>{};
