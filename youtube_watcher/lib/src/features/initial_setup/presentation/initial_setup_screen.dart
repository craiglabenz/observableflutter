import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_watcher/src/features/initial_setup/data/initial_setup_providers.dart';

/// The screen where the user can enter their YouTube API key and video ID.
class InitialSetupScreen extends ConsumerWidget {
  /// Creates the initial setup screen.
  const InitialSetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credentialsProvider = ref.watch(credentialsRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('YouTube Live Chat Viewer'),
      ),
      body: credentialsProvider.when(
        data: (credentialsRepository) {
          final apiKeyController =
              TextEditingController(text: credentialsRepository.getApiKey());
          final videoIdController =
              TextEditingController(text: credentialsRepository.getVideoId());
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: apiKeyController,
                  decoration: const InputDecoration(
                    labelText: 'API Key',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: videoIdController,
                  decoration: const InputDecoration(
                    labelText: 'Video ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    credentialsRepository
                      ..setApiKey(apiKeyController.text)
                      ..setVideoId(videoIdController.text);
                    context.go('/chat');
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
