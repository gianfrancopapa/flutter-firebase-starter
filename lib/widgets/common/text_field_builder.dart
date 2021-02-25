import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TextFieldBuilder extends StatefulWidget {
  final String labelText;
  final void Function(String) onChanged;
  final Stream<String> stream;
  final bool isPassword;
  final EdgeInsets margin;
  final String prefix;
  final bool withInitialValue;
  final int maxLines;
  final bool showPasswordButton;

  const TextFieldBuilder({
    this.labelText,
    this.onChanged,
    this.stream,
    this.isPassword = false,
    this.margin = const EdgeInsets.all(0),
    this.prefix,
    this.withInitialValue = false,
    this.maxLines = 1,
    this.showPasswordButton = false,
  });
  @override
  _TextFieldBuilderState createState() => _TextFieldBuilderState();
}

class _TextFieldBuilderState extends State<TextFieldBuilder> {
  bool isPassword;

  @override
  void initState() {
    isPassword = widget.isPassword;
    super.initState();
  }

  Widget _showPasswordButton() {
    if (widget.showPasswordButton) {
      return IconButton(
          icon: const Icon(FeatherIcons.eye), onPressed: () => _toggle());
    }
    return null;
  }

  void _toggle() {
    isPassword = !isPassword;
  }

  InputDecoration _decoration(AsyncSnapshot<String> snapshot) =>
      InputDecoration(
        suffixIcon: _showPasswordButton(),
        prefixText: widget.prefix,
        prefixStyle: const TextStyle(color: Colors.white, fontSize: 15.0),
        contentPadding: const EdgeInsets.only(bottom: -5, top: 2),
        errorStyle: const TextStyle(height: 0.6),
        labelText: widget.labelText,
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
        maxLines: widget.maxLines,
        keyboardType: widget.maxLines > 1 ? TextInputType.multiline : null,
        onChanged: widget.onChanged,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: _decoration(snapshot),
      );

  TextFormField _textFieldWithInitialValue(AsyncSnapshot<String> snapshot) =>
      TextFormField(
        maxLines: widget.maxLines,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: snapshot.data ?? '',
            selection: TextSelection.fromPosition(
              TextPosition(offset: snapshot.data?.length ?? 0),
            ),
          ),
        ),
        keyboardType: widget.maxLines > 1 ? TextInputType.multiline : null,
        style: const TextStyle(color: Colors.white),
        onChanged: widget.onChanged,
        obscureText: isPassword,
        decoration:
            snapshot != null ? _decoration(snapshot) : const InputDecoration(),
      );

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 75,
        child: StreamBuilder<String>(
          stream: widget.stream,
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
              widget.withInitialValue
                  ? _textFieldWithInitialValue(snapshot)
                  : _textFieldWithoutInitialValue(snapshot),
        ),
      );
}
