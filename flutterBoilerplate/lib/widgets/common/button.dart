import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final Function onTap;
  final Color backgroundColor;
  final Color textColor;

  const Button({
    this.text,
    this.onTap,
    this.height = 40.0,
    this.width,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width ?? MediaQuery.of(context).size.width / 1.5,
        height: height,
        child: RaisedButton(
          color: backgroundColor ?? Colors.blueGrey,
          onPressed: onTap,
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      );
}
