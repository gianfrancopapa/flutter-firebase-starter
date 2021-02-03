import 'package:flutter/material.dart';

class AuthServiceButton extends StatelessWidget {
  final String text;
  final double height;
  final Function onTap;
  final Color backgroundColor;
  final Color textColor;
  final String asset;

  const AuthServiceButton({
    this.text,
    this.onTap,
    this.height = 35.0,
    this.backgroundColor,
    this.textColor,
    this.asset,
  });

  @override
  Widget build(BuildContext context) => OutlineButton(
        splashColor: backgroundColor,
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: const BorderSide(color: Colors.grey),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(asset),
                height: height,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 20,
                    color: textColor,
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
