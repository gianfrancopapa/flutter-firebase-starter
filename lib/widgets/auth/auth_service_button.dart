import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:flutter/material.dart';

class AuthServiceButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final Function onTap;
  final Color backgroundColor;
  final Color textColor;
  final String asset;

  const AuthServiceButton({
    this.text,
    this.onTap,
    this.height = 30.0,
    this.width = 30.0,
    this.backgroundColor,
    this.textColor,
    this.asset,
  });

  @override
  Widget build(BuildContext context) => Button(
        onTap: onTap,
        backgroundColor: AppColor.white,
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
            ),
            Image(
              image: AssetImage(asset),
              height: height,
              width: width,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
            ),
            Text(
              text,
              style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey),
            ),
          ],
        ),
      );
}
