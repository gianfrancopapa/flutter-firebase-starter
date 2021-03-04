import 'package:firebasestarter/constants/colors.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final double height;
  final bool goBack;
  final String title;
  final Widget suffixWidget;

  const CustomAppBar({
    this.height = kToolbarHeight,
    this.title,
    this.goBack = true,
    this.suffixWidget,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) => AppBar(
        backgroundColor: AppColor.blue,
        leading: goBack
            ? InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 30.0,
                ),
              )
            : const SizedBox(),
        title: Text(
          title,
          style: const TextStyle(
            color: AppColor.white,
            fontSize: 18.0,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [suffixWidget ?? const SizedBox()],
      );
}
