import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';

class ResponsiveButton extends StatelessWidget {
  final Stream<bool> stream;
  final String title;
  final Color activeColorButton;
  final Color disabledColorButton;
  final Color activeColorText;
  final Color disabledColorText;
  final Function action;
  final double width;
  final double height;

  const ResponsiveButton({
    this.stream,
    this.title,
    this.activeColorButton,
    this.activeColorText,
    this.disabledColorButton,
    this.disabledColorText,
    this.action,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
        initialData: false,
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) => Button(
          text: title,
          textColor: snapshot.hasError ? disabledColorText : activeColorText,
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? 45,
          onTap: snapshot.hasError
              ? () {}
              : snapshot.data
                  ? action
                  : null,
          backgroundColor:
              snapshot.hasError ? disabledColorButton : activeColorButton,
        ),
      );
}
