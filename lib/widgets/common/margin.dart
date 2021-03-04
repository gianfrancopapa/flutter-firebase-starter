import 'package:firebasestarter/utils/screen_size.dart';
import 'package:flutter/material.dart';

class Margin extends StatelessWidget {
  final double designHeight;
  final double designWidth;
  final _screenSize = ScreenSize();

  Margin(this.designWidth, this.designHeight);

  Size _getSize(BuildContext context) => _screenSize.getSize(
        context: context,
        designHeight: designHeight,
        designWidth: designWidth,
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        height: _getSize(context).height,
        width: _getSize(context).width,
      );
}
