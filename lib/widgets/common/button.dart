import 'package:firebasestarter/utils/screen_size.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Widget child;
  final double height;
  final double width;
  final Function onTap;
  final Color backgroundColor;
  final Color textColor;

  Size _btnSize(BuildContext context) => ScreenSize().getSize(
        context: context,
        designHeight: 44.0,
        designWidth: 287.0,
      );

  const Button({
    this.child,
    this.text,
    this.onTap,
    this.height = 40.0,
    this.width,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0),
            color: backgroundColor,
          ),
          width: _btnSize(context).width,
          height: _btnSize(context).height,
          alignment: Alignment.center,
          child: child ??
              Text(
                text,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                ),
              ),
        ),
      );
}
