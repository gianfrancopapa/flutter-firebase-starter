import 'package:firebasestarter/widgets/common/margin.dart';
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

  Widget _label() => Text(
        widget.labelText,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      );

  InputDecoration _decoration(AsyncSnapshot<String> snapshot) =>
      InputDecoration(
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
        errorText: snapshot.hasError ? snapshot.error : null,
      );

  TextField _textFieldWithoutInitialValue(AsyncSnapshot<String> snapshot) =>
      TextField(
        maxLines: widget.maxLines,
        keyboardType: widget.maxLines > 1 ? TextInputType.multiline : null,
        onChanged: widget.onChanged,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.black),
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
        style: const TextStyle(color: Colors.black),
        onChanged: widget.onChanged,
        obscureText: isPassword,
        decoration:
            snapshot != null ? _decoration(snapshot) : const InputDecoration(),
      );

  @override
  Widget build(BuildContext context) => StreamBuilder<String>(
        stream: widget.stream,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
            Container(
          alignment: Alignment.bottomCenter,
          height: 72.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label(),
              Margin(0, 15.0),
              Container(
                alignment: Alignment.bottomCenter,
                height: 40.0,
                child: widget.withInitialValue
                    ? _textFieldWithInitialValue(snapshot)
                    : _textFieldWithoutInitialValue(snapshot),
              ),
            ],
          ),
        ),
      );
}
