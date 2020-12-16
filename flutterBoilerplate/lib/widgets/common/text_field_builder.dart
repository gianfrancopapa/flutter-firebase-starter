import 'package:flutter/material.dart';

class TextFieldBuilder extends StatelessWidget {
  final String labelText;
  final void Function(String) onChanged;
  final Stream<String> stream;
  final bool isPassword;
  final EdgeInsets margin;

  const TextFieldBuilder({
    this.labelText,
    this.onChanged,
    this.stream,
    this.isPassword = false,
    this.margin = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) => Container(
        height: 75,
        margin: margin,
        child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) => TextField(
            onChanged: onChanged,
            obscureText: isPassword,
            decoration: InputDecoration(
              labelText: labelText,
              errorText: snapshot.hasError ? snapshot.error : null,
            ),
          ),
        ),
      );
}
