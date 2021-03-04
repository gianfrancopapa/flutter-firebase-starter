import 'package:flutter/material.dart';

class ScreenSize {
  static const _designsHeightSize = 812.0;
  static const _designWidthSize = 375.0;
  static final ScreenSize _singleton = ScreenSize.internal();

  factory ScreenSize() => _singleton;

  ScreenSize.internal();

  double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

  double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

  double _getPercentage(double number) => number / 100;

  Size getSize({
    BuildContext context,
    double designHeight = 0,
    double designWidth = 0,
  }) {
    final _height = getHeight(context) *
        _getPercentage(
          (designHeight * 100) / _designsHeightSize,
        );
    final _width = getWidth(context) *
        _getPercentage(
          (designWidth * 100) / _designWidthSize,
        );
    return Size(_width, _height);
  }

  double calculateTextScaleFactor(BuildContext context, double designSize) {
    final percentageToAdjust = getHeight(context) / _designsHeightSize;
    if (percentageToAdjust * designSize < designSize - 1) {
      return _getPercentage(((designSize - 1) * 100) / designSize);
    } else if (percentageToAdjust * designSize > designSize + 1) {
      return _getPercentage(((designSize + 1) * 100) / designSize);
    } else
      return percentageToAdjust;
  }
}
