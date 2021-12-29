import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends PreferredSize {
  final double height;
  final bool goBack;
  final String? title;
  final Widget? suffixWidget;

  CustomAppBar({
    Key? key,
    this.height = kToolbarHeight,
    this.title,
    this.goBack = true,
    this.suffixWidget,
  }) : super(
            key: key,
            child: Container(),
            preferredSize: const Size.fromHeight(kToolbarHeight));

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: FSColors.blue,
      leading: goBack
          ? InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.keyboard_arrow_left,
                size: 30.0,
              ),
            )
          : const SizedBox(),
      title: Text(
        title!,
        style: const TextStyle(
          color: FSColors.white,
          fontSize: 23.0,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [suffixWidget ?? const SizedBox()],
    );
  }
}
