import 'package:shadcn_flutter/shadcn_flutter.dart';

const Color _kSecondaryTextColor = Color(
  0xFFB0C4DE,
); // Light blue-gray

class AppText extends StatelessWidget {
  const AppText._(
    this.text, {
    required this.baseSize,
    required this.sizeDelta,
    this.style,
  });

  factory AppText.headline(String text, {TextStyle? style}) => AppText._(
    text,
    baseSize: 16,
    sizeDelta: 8,
    style: style,
  );

  /// Also used for bylines.
  factory AppText.helpText(String text, {TextStyle? style}) => AppText._(
    text,
    baseSize: 12,
    sizeDelta: 4,
    style: style,
  );

  final String text;
  final double baseSize;
  final double sizeDelta;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = constraints.maxWidth / 400;
        TextStyle baseStyle = Theme.of(context).typography.base;
        if (style != null) {
          baseStyle = baseStyle.merge(style);
        }
        return Text(
          'By John Appleseed • Oct 24, 2023',
          style: baseStyle.copyWith(
            fontSize: baseSize + (sizeDelta * scale),
          ),
        );
      },
    );
  }
}
