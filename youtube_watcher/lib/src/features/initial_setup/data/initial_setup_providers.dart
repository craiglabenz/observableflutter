import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_watcher/src/features/initial_setup/data/credentials_repository.dart';

part 'initial_setup_providers.g.dart';

/// Provides a [SharedPreferences] instance.
@riverpod
Future<SharedPreferences> sharedPreferences(Ref ref) {
  return SharedPreferences.getInstance();
}

/// Provides a [CredentialsRepository] instance.
@riverpod
Future<CredentialsRepository> credentialsRepository(Ref ref) async {
  final prefs = await ref.watch(sharedPreferencesProvider.future);
  return CredentialsRepository(prefs);
}
