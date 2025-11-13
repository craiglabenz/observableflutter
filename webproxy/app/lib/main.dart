import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const API_BASE_URL = String.fromEnvironment('API_BASE_URL');

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    final rawUrl = '$API_BASE_URL/api/users';
    print('rawUrl: $rawUrl');
    http.get(Uri.parse(rawUrl)).then((response) {
      print(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello Solar System!'))),
    );
  }
}
