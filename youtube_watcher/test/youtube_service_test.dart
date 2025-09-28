import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:youtube_watcher/src/features/chat/data/youtube_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri.parse(''));
  });

  group('YouTubeService', () {
    late MockClient client;
    late YouTubeService youTubeService;

    setUp(() {
      client = MockClient();
      youTubeService = YouTubeService('test_api_key', 'test_video_id', client);
    });

    test(
        'getChatMessages returns a list of chat messages on successful API call',
        () async {
      // Mock the API response for getting the live chat ID
      when(() => client.get(Uri.parse(
              'https://www.googleapis.com/youtube/v3/videos?part=liveStreamingDetails&id=test_video_id&key=test_api_key')))
          .thenAnswer((_) async => http.Response(
              json.encode({
                'items': [
                  {
                    'liveStreamingDetails': {
                      'activeLiveChatId': 'test_live_chat_id'
                    }
                  }
                ]
              }),
              200));

      // Mock the API response for getting the chat messages
      when(() => client.get(Uri.parse(
              'https://www.googleapis.com/youtube/v3/liveChat/messages?liveChatId=test_live_chat_id&part=snippet,authorDetails&key=test_api_key')))
          .thenAnswer((_) async => http.Response(
              json.encode({
                'items': [
                  {
                    'id': 'test_message_id',
                    'snippet': {'displayMessage': 'test_message'},
                    'authorDetails': {
                      'displayName': 'test_author',
                      'profileImageUrl': 'test_profile_image_url'
                    }
                  }
                ]
              }),
              200));

      final result = await youTubeService.getChatMessages();

      expect(result.length, 1);
      expect(result[0].id, 'test_message_id');
      expect(result[0].author, 'test_author');
      expect(result[0].message, 'test_message');
      expect(result[0].profileImageUrl, 'test_profile_image_url');
    });

    test('getChatMessages returns an empty list on failed API call', () async {
      // Mock the API response for getting the live chat ID
      when(() => client.get(any())).thenAnswer((_) async => http.Response('', 404));

      final result = await youTubeService.getChatMessages();

      expect(result.length, 0);
    });
  });
}
