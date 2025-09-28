import 'package:shared_preferences/shared_preferences.dart';

/// A repository that stores the user's credentials.
class CredentialsRepository {
  /// Creates a credentials repository.
  CredentialsRepository(this._prefs);

  final SharedPreferences _prefs;

  static const String _apiKeyKey = 'api_key';
  static const String _videoIdKey = 'video_id';

  /// Sets the API key.
  Future<void> setApiKey(String apiKey) async {
    await _prefs.setString(_apiKeyKey, apiKey);
  }

  /// Gets the API key.
  String? getApiKey() {
    return _prefs.getString(_apiKeyKey);
  }

  /// Sets the video ID.
  Future<void> setVideoId(String videoId) async {
    await _prefs.setString(_videoIdKey, videoId);
  }

  /// Gets the video ID.
  String? getVideoId() {
    return _prefs.getString(_videoIdKey);
  }
}
