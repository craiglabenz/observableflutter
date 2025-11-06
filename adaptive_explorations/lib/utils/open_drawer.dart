// Open a drawer and optionally open another from within it.
import 'package:shadcn_flutter/shadcn_flutter.dart';

void open(BuildContext context) {
  openDrawer(
    context: context,
    expands: true,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(48),
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Drawer text',
              ),
              const Gap(16),
              PrimaryButton(
                onPressed: () {
                  // Open another drawer on top.
                  open(context);
                },
                child: const Text('Open Another Drawer'),
              ),
              const Gap(8),
              SecondaryButton(
                onPressed: () {
                  // Close the current top-most overlay.
                  closeOverlay(context);
                },
                child: const Text('Close Drawer'),
              ),
            ],
          ),
        ),
      );
    },
    position: OverlayPosition.start,
  );
}
