import 'package:auto_size_text/auto_size_text.dart';
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
  Widget build(BuildContext context) => OutlinedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return backgroundColor;
            },
          ),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
            (Set<MaterialState> states) {
              return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10));
            },
          ),
          elevation: MaterialStateProperty.resolveWith<double>(
            (Set<MaterialState> states) {
              return 0;
            },
          ),
          side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
              return const BorderSide(color: Colors.white);
            },
          ),
        ),
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(asset),
                height: height,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: AutoSizeText(
                  text,
                  maxFontSize: 20,
                  style: TextStyle(
                    color: textColor,
                    backgroundColor: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
