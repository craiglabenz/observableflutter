import 'package:signals/signals_flutter.dart';
import '../models/user.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final currentUser = signal<User?>(null);

  late final FlutterComputed<bool> isLoggedIn = computed(
    () => currentUser.value != null,
  );

  Future<void> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock successful login
    currentUser.value = User(id: '1', name: 'Test User', email: email);
  }

  void logout() {
    currentUser.value = null;
  }
}
