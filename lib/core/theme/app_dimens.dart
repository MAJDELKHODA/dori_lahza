import 'package:flutter/widgets.dart';

/// Spacing scale (4-pt grid).
abstract final class Gap {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  /// Horizontal page gutter.
  static const page = 20.0;
  static const pagePadding = EdgeInsetsDirectional.symmetric(horizontal: page);
}

abstract final class Radii {
  static const sm = 10.0;
  static const md = 14.0;
  static const lg = 20.0;
  static const xl = 28.0;
  static const pill = 999.0;

  static const card = BorderRadius.all(Radius.circular(lg));
  static const field = BorderRadius.all(Radius.circular(md));
  static const sheet = BorderRadius.vertical(top: Radius.circular(xl));
}

/// Height spacer / width spacer helpers, to keep layout code terse.
class VSpace extends SizedBox {
  const VSpace(double height, {super.key}) : super(height: height);
}

class HSpace extends SizedBox {
  const HSpace(double width, {super.key}) : super(width: width);
}
