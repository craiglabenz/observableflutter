import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_watcher/src/features/initial_setup/data/credentials_repository.dart';

void main() {
  group('CredentialsRepository', () {
    late CredentialsRepository credentialsRepository;
    late SharedPreferences sharedPreferences;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      credentialsRepository = CredentialsRepository(sharedPreferences);
    });

    test('setApiKey and getApiKey', () async {
      const apiKey = 'test_api_key';
      await credentialsRepository.setApiKey(apiKey);
      expect(credentialsRepository.getApiKey(), apiKey);
    });

    test('setVideoId and getVideoId', () async {
      const videoId = 'test_video_id';
      await credentialsRepository.setVideoId(videoId);
      expect(credentialsRepository.getVideoId(), videoId);
    });
  });
}
