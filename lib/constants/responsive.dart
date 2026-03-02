import 'package:flutter/material.dart';

/// Responsive utility class for scaling UI elements across different screen sizes.
/// Based on a reference design of 390x844 (iPhone 14 / standard mobile).
class Responsive {
  static const double _designWidth = 390.0;
  static const double _designHeight = 844.0;

  late double _screenWidth;
  late double _screenHeight;
  late double _scaleFactor;
  late double _textScaleFactor;

  Responsive(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _screenWidth = size.width;
    _screenHeight = size.height;
    _scaleFactor = (_screenWidth / _designWidth).clamp(0.7, 1.4);
    _textScaleFactor = _scaleFactor.clamp(0.8, 1.3);
  }

  /// Scale a width value proportionally
  double w(double value) => value * (_screenWidth / _designWidth);

  /// Scale a height value proportionally
  double h(double value) => value * (_screenHeight / _designHeight);

  /// Scale a value using the general scale factor (good for padding/margins)
  double s(double value) => value * _scaleFactor;

  /// Scale a font size
  double sp(double value) => value * _textScaleFactor;

  /// Raw screen width
  double get screenWidth => _screenWidth;

  /// Raw screen height
  double get screenHeight => _screenHeight;

  /// Whether this is a small phone (width < 360)
  bool get isSmallPhone => _screenWidth < 360;

  /// Whether this is a large phone or tablet (width >= 600)
  bool get isTablet => _screenWidth >= 600;

  /// Whether this is a very large tablet or desktop (width >= 900)
  bool get isDesktop => _screenWidth >= 900;
}

/// Extension for easy access to Responsive from BuildContext
extension ResponsiveExtension on BuildContext {
  Responsive get r => Responsive(this);

  /// Quick shorthand for screen width
  double get sw => MediaQuery.of(this).size.width;

  /// Quick shorthand for screen height
  double get sh => MediaQuery.of(this).size.height;
}
