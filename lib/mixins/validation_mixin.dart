import 'dart:async';

class ValidationMixin {
  static const passwordLength = 6;
  static final _uppercaseRegExp = RegExp(r'[A-Z]');
  static final _digitsRegExp = RegExp(r'[0-9]');
  static final _lowercaseRegExp = RegExp(r'[a-z]');
  static final _alphabeticRegExp = RegExp('[a-zA-Z]');
  static final _alphaNumericRegExp = RegExp('[a-zA-Z0-9]');
  static final _emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final numericTransfomer = StreamTransformer<String, String>.fromHandlers(
    handleData: (number, sink) => _digitsRegExp.hasMatch(number)
        ? sink.add(number)
        : sink.addError('Insert a number please.'),
  );

  final alphabeticTransfomer = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) => _alphabeticRegExp.hasMatch(text)
        ? sink.add(text)
        : sink.addError('Insert a valid text please.'),
  );

  final alphaNumericTransfomer = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) => _alphaNumericRegExp.hasMatch(text)
        ? sink.add(text)
        : sink.addError('Insert a valid text please.'),
  );

  final emailTransfomer = StreamTransformer<String, String>.fromHandlers(
    handleData: (text, sink) => _emailRegExp.hasMatch(text)
        ? sink.add(text)
        : sink.addError('Insert a valid email please.'),
  );

  final passwordTransfomer = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) => password.contains(_uppercaseRegExp) &&
            password.contains(_lowercaseRegExp) &&
            password.contains(_digitsRegExp) &&
            password.length > passwordLength
        ? sink.add(password)
        : sink.addError('Insert a valid password.'),
  );
}
