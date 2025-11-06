import 'package:adaptive_explorations/ui_builder.dart';
import 'package:adaptive_explorations/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MyBanner extends StatelessWidget {
  const MyBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final uiBuilder = context.read<UIBuilder>();
    return Padding(
      padding: uiBuilder.elementVerticalPadding,
      child: Column(
        crossAxisAlignment: .start,
        children: <Widget>[
          Text('This is a header').bold,
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
          ).p,
        ],
      ),
    );
  }
}
