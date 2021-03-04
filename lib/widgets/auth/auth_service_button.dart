import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/button.dart';
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
    this.height = 20.0,
    this.backgroundColor,
    this.textColor,
    this.asset,
  });

  @override
  Widget build(BuildContext context) => Button(
        onTap: onTap,
        backgroundColor: AppColor.white,
        child: Image(
          image: AssetImage(asset),
          height: height,
        ),
      );
}
