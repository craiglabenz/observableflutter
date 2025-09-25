import 'package:flutter/widgets.dart';

class Position {
  Position({
    this.height,
    this.width,
    this.left,
    this.right,
    this.top,
    this.bottom,
  });

  final double? height;
  final double? width;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;

  Widget toWidget(Widget child) => Positioned(
    height: height,
    width: width,
    left: left,
    right: right,
    top: top,
    bottom: bottom,
    child: child,
  );
}
