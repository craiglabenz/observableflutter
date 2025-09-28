import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:youtube_watcher/src/features/chat/application/screenshot_service.dart';

void main() {
  late ScreenshotService screenshotService;
  late GlobalKey key;

  setUp(() {
    screenshotService = ScreenshotService();
    key = GlobalKey();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('deleteImage deletes the saved image file',
      (WidgetTester tester) async {
    final tempDir = await Directory.systemTemp.createTemp();
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return tempDir.path;
        }
        return null;
      },
    );

    // First, create a file to delete.
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/image.png');
    await file.writeAsString('test');

    await screenshotService.deleteImage();

    expect(file.existsSync(), isFalse);
  });
}
