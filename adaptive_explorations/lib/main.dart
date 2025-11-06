import 'package:adaptive_explorations/ui_builder.dart';
import 'package:adaptive_explorations/widgets/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadcnApp(
      debugShowCheckedModeBanner: false,
      home: LayoutBuilder(
        builder: (context, constraints) {
          final uiBuilder = UIBuilder(constraints, Directionality.of(context));
          return Provider<UIBuilder>.value(
            value: uiBuilder,
            child: MainScreen(),
          );
        },
      ),
    );
  }
}
