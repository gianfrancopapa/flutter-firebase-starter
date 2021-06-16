import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TextFieldBuilder extends StatefulWidget {
  final String labelText;
  final void Function(String) onChanged;
  final String value;
  final Stream<String> stream;
  final bool isPassword;
  final EdgeInsets margin;
  final String prefix;
  final bool withInitialValue;
  final int maxLines;
  final bool showPasswordButton;
  final bool autoValidate;

  const TextFieldBuilder({
    this.labelText,
    this.onChanged,
    this.stream,
    this.value,
    this.isPassword = false,
    this.margin = const EdgeInsets.all(0),
    this.prefix,
    this.withInitialValue = false,
    this.maxLines = 1,
    this.showPasswordButton = false,
    this.autoValidate = false,
  });
  @override
  _TextFieldBuilderState createState() => _TextFieldBuilderState();
}

class _TextFieldBuilderState extends State<TextFieldBuilder> {
  bool isPassword;
  bool autoValidate;

  @override
  void initState() {
    isPassword = widget.isPassword;
    autoValidate = widget.autoValidate;
    super.initState();
  }

  Widget _showPasswordButton() => widget.showPasswordButton
      ? Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: InkWell(
            child: const Icon(FeatherIcons.eye),
            onTap: () => _toggle(),
          ),
        )
      : null;

  void _toggle() {
    setState(() {
      isPassword = !isPassword;
    });
  }

  void _setAutoValidation() {
    setState(() {
      autoValidate = true;
    });
  }

  Widget _label() => Text(
        widget.labelText,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      );

  InputDecoration _decoration() => InputDecoration(
        hintMaxLines: 1,
        helperText: '',
        suffixIcon: _showPasswordButton(),
        prefixText: widget.prefix,
        prefixStyle: const TextStyle(color: Colors.black, fontSize: 15.0),
        errorStyle: const TextStyle(fontSize: 12.0),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
        ),
        // errorText: autoValidate && snapshot.hasError ? snapshot.error : null,
      );

  TextFormField _textFieldWithInitialValue(String value) => TextFormField(
        maxLines: widget.maxLines,
        controller: TextEditingController.fromValue(
          TextEditingValue(
            text: value ?? '',
            selection: TextSelection.fromPosition(
              TextPosition(offset: value.length ?? 0),
            ),
          ),
        ),
        keyboardType: widget.maxLines > 1 ? TextInputType.multiline : null,
        style: const TextStyle(color: Colors.black),
        onChanged: widget.onChanged,
        onTap: _setAutoValidation,
        obscureText: isPassword,
        decoration: _decoration(),
      );

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.bottomCenter,
        height: 80.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label(),
            Margin(0, 15.0),
            Container(
              alignment: Alignment.bottomCenter,
              height: 40.0,
              child: _textFieldWithInitialValue(widget.value),
            ),
          ],
        ),
      );
}
