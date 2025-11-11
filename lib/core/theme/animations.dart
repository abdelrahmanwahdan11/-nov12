import 'package:flutter/animation.dart';

class AppAnimations {
  const AppAnimations._();

  static const Duration fast = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 220);
  static const Duration slow = Duration(milliseconds: 260);

  static const Curve defaultCurve = Cubic(0.2, 0.8, 0.2, 1);
}
