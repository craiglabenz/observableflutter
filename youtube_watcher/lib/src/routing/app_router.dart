import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_watcher/src/features/chat/presentation/chat_screen.dart';
import 'package:youtube_watcher/src/features/initial_setup/presentation/initial_setup_screen.dart';

/// The router for the application.
final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const InitialSetupScreen();
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (BuildContext context, GoRouterState state) {
        return const ChatScreen();
      },
    ),
  ],
);
