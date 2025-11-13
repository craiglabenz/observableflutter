import 'package:dart_frog/dart_frog.dart';

Handler get onRequest =>
    createStaticFileHandler(path: 'public', defaultDocument: 'index.html');
