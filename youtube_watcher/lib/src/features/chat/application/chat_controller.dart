import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:youtube_watcher/src/features/chat/application/chat_providers.dart';
import 'package:youtube_watcher/src/features/chat/application/screenshot_service.dart';
import 'package:youtube_watcher/src/features/chat/data/chat_message.dart';

part 'chat_controller.g.dart';

/// The state of the chat screen.
class ChatState {
  /// Creates the state of the chat screen.
  ChatState({
    this.messages = const AsyncValue.loading(),
    this.selectedMessageId,
  });

  /// The list of chat messages.
  final AsyncValue<List<ChatMessage>> messages;

  /// The ID of the selected message.
  final String? selectedMessageId;

  /// Creates a copy of the state with the given fields replaced with the new
  /// values.
  ChatState copyWith({
    AsyncValue<List<ChatMessage>>? messages,
    String? selectedMessageId,
    bool deselect = false,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      selectedMessageId:
          deselect ? null : selectedMessageId ?? this.selectedMessageId,
    );
  }
}

/// The controller for the chat screen.
@riverpod
class ChatController extends _$ChatController {
  Timer? _timer;

  @override
  ChatState build() {
    log('ChatController build()');
    // When the provider is destroyed, cancel the timer
    ref.onDispose(() {
      log('ChatController disposed, cancelling timer.');
      _timer?.cancel();
    });

    // Fetch initial messages
    _fetchChatMessages();

    // Start polling for messages
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      log('Timer fired! Fetching messages.');
      _fetchChatMessages();
    });

    return ChatState();
  }

  Future<void> _fetchChatMessages() async {
    log('Fetching chat messages...');
    // Reading the provider's future which will be handled by the UI.
    final youTubeService = await ref.read(youTubeServiceProvider.future);
    final newState = await AsyncValue.guard(youTubeService.getChatMessages);
    state = state.copyWith(messages: newState);
    log('State updated with new messages.');
  }

  /// Selects a message.
  Future<void> selectMessage(String messageId, GlobalKey key) async {
    final screenshotService = ref.read(screenshotServiceProvider);
    if (state.selectedMessageId == messageId) {
      // If the same message is tapped again, deselect it.
      state = state.copyWith(deselect: true);
      await screenshotService.deleteImage();
    } else {
      state = state.copyWith(selectedMessageId: messageId);
      await screenshotService.captureAndSave(key);
    }
  }
}
