import 'package:app/dependency_injection.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setUpDI();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp.router(
      theme: ThemeData(
        colorScheme: ColorSchemes.darkGreen,
        radius: 0.5,
      ),
      routerConfig: GetIt.I<GoRouter>(),
    );
  }
}
