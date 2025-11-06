import 'package:shadcn_flutter/shadcn_flutter.dart'
    show BoxConstraints, EdgeInsets, TextDirection;

class UIBuilder {
  UIBuilder(this.constraints, this.textDirection);

  final BoxConstraints constraints;
  final TextDirection textDirection;

  /// Minimum padding around individual UI elements from which we may scale up
  /// for larger screens.
  static const double basePadding = 12;

  int get gridCrossAxisCount => switch (constraints.maxWidth) {
    < 600 => 1,
    < 1200 => 2,
    _ => 3,
  };

  EdgeInsets get mainContentPadding => EdgeInsets.symmetric(
    horizontal: (constraints.maxWidth * 0.03).clamp(
      basePadding,
      double.infinity,
    ),
  );

  /// Provided by Simon Lightfoot in the chat. Guaranteed to be good. Take it up
  /// with him if it is not. It is literally not my problem. Leave me alone. I
  /// swear to god.
  double get minimumFontSize => 12;

  /// Provided by Simon Lightfoot in the chat. Guaranteed to be good. Take it up
  /// with him if it is not. It is literally not my problem. Leave me alone. I
  /// swear to god.
  double get fontDelta => 4;

  EdgeInsets get elementVerticalPadding => EdgeInsets.only(
    bottom: (constraints.maxHeight * 0.03).clamp(basePadding, double.infinity),
  );

  double get cardBorderRadius => (constraints.maxWidth * 0.02).clamp(16, 24);

  EdgeInsets get drawerIconPadding => textDirection == .ltr
      ? EdgeInsets.only(right: drawerIconHorizontalPadding)
      : EdgeInsets.only(left: drawerIconHorizontalPadding);

  double get drawerIconHorizontalPadding =>
      _drawerIconHorizontalPadding ??= constraints.maxWidth * 0.02;
  double? _drawerIconHorizontalPadding;

  double get drawerIconSize => 40;
}
