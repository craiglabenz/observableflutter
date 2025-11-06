import 'package:adaptive_explorations/ui_builder.dart';
import 'package:adaptive_explorations/widgets/app_text.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

// --- Theme and Colors ---
// Define a custom color scheme based on the image provided.
const Color _kBackgroundColor = Color(0xFF1E2833);
const Color _kPrimaryTextColor = Colors.white;
const Color _kSecondaryTextColor = Color(
  0xFFB0C4DE,
); // Light blue-gray for metadata

class BlogPostCard extends StatelessWidget {
  const BlogPostCard({super.key});

  @override
  Widget build(BuildContext context) {
    final uiBuilder = context.read<UIBuilder>();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Padding(
            padding: uiBuilder.elementVerticalPadding,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                uiBuilder.cardBorderRadius,
              ), // Rounded corners for the card
              child: Container(
                color: _kBackgroundColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Image and Overlay Content (Stacked)
                    Expanded(
                      child: _buildImageStack(constraints.maxWidth),
                    ),
                    // 2. Text Content (Below the image stack)
                    _buildTextContent(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageStack(double maxWidth) {
    // Pseudo-arbitrary number (about a smartphone's width) around which we
    // can scale text sizes
    const baseWidth = 300;
    final fontSizeMultiplier = maxWidth / baseWidth;
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // Background Image
        Image.network(
          // Placeholder URL for the serene meditation image
          'https://picsum.photos/200/300',
          width: double.infinity,
          fit: BoxFit.cover,
          // A simple fade to black/dark for better text contrast, similar to the original image
          color: Colors.black.withValues(alpha: 0.3),
          colorBlendMode: BlendMode.darken,
        ),

        // Metadata Overlay
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisAlignment: .end,
            children: [
              // Author and Date
              AppText.helpText(
                'By John Appleseed • Oct 24, 2023',
                style: TextStyle(
                  color: _kSecondaryTextColor,
                  fontWeight: .w400,
                ),
              ),
              const SizedBox(height: 8),

              // Title
              Text(
                'A Guide to Mindful Living',
                // style: TextStyle(
                //   color: _kPrimaryTextColor,
                //   fontWeight: FontWeight.w900, // Extra bold for prominence
                // ),
              ).h1,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextContent() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 16.0,
        bottom: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          const Text(
            'Learn simple techniques to bring more peace and presence into your daily life. A step-by-step guide to meditation and awareness.',
            maxLines: 3,
            style: TextStyle(
              color: _kSecondaryTextColor,
              fontSize: 16.0,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),

          // Read Time
          const Text(
            '8 min read',
            style: TextStyle(
              color: _kSecondaryTextColor,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
