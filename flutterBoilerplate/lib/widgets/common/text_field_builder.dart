import 'package:flutter/material.dart';

class TextFieldBuilder extends StatelessWidget {
  final String labelText;
  final void Function(String) onChanged;
  final Stream<String> stream;
  final bool isPassword;
  final EdgeInsets margin;
  final String prefix;
  final bool withInitialValue;
  final int maxLines;

  const TextFieldBuilder({
    this.labelText,
    this.onChanged,
    this.stream,
    this.isPassword = false,
    this.margin = const EdgeInsets.all(0),
    this.prefix,
    this.withInitialValue = false,
    this.maxLines = 1,
  });

  InputDecoration _decoration(AsyncSnapshot<String> snapshot) =>
      InputDecoration(
        prefixText: prefix,
        prefixStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
        contentPadding: const EdgeInsets.only(bottom: -5, top: 2),
        errorStyle: const TextStyle(height: 0.6),
        labelText: labelText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        labelStyle: const TextStyle(fontSize: 15, color: Colors.white),
        errorText: snapshot.hasError ? snapshot.error : null,
      );

  TextField _textFieldWithoutInitialValue(AsyncSnapshot<String> snapshot) =>
      TextField(
        maxLines: maxLines,
        keyboardType: maxLines > 1 ? TextInputType.multiline : null,
        onChanged: onChanged,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: _decoration(snapshot),
      );

  TextFormField _textFieldWithInitialValue(AsyncSnapshot<String> snapshot) =>
      TextFormField(
        maxLines: maxLines,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: snapshot.data ?? '',
            selection: TextSelection.fromPosition(
              TextPosition(offset: snapshot.data?.length ?? 0),
            ),
          ),
        ),
        keyboardType: maxLines > 1 ? TextInputType.multiline : null,
        style: const TextStyle(color: Colors.white),
        onChanged: onChanged,
        obscureText: isPassword,
        decoration:
            snapshot != null ? _decoration(snapshot) : const InputDecoration(),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 75,
        child: StreamBuilder<String>(
          stream: stream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
              withInitialValue
                  ? _textFieldWithInitialValue(snapshot)
                  : _textFieldWithoutInitialValue(snapshot),
        ),
      );
}
