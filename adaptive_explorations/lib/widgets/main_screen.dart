import 'package:adaptive_explorations/ui_builder.dart';
import 'package:adaptive_explorations/utils/utils.dart';
import 'package:adaptive_explorations/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uiBuilder = context.read<UIBuilder>();
    return Scaffold(
      headers: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: uiBuilder.drawerIconPadding,
              child: SizedBox.square(
                dimension: uiBuilder.drawerIconSize,
                child: IconButton.ghost(
                  onPressed: () => open(context),
                  density: ButtonDensity.icon,
                  icon: const Icon(RadixIcons.hamburgerMenu),
                ),
              ),
            ),
            Text('Header').h1,
          ],
        ),
      ],
      footers: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            '${uiBuilder.constraints.maxWidth} x ${uiBuilder.constraints.maxHeight}',
          ),
        ),
      ],
      child: Padding(
        padding: uiBuilder.mainContentPadding,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [MyBanner()],
              ),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    uiBuilder.gridCrossAxisCount, // Two items per row
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                // childAspectRatio: 0.75, // Height / Width ratio for card size
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return BlogPostCard();
                },
                childCount: 3, // Create 10 cards for the grid
              ),
            ),
            SliverFillRemaining(child: Text('Footer')),
          ],
        ),
      ),
    );
  }
}
