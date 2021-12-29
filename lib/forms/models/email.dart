import 'package:equatable/equatable.dart';

class Email extends Equatable {
  const Email({this.value});

  static final _validationRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  factory Email.pure() => const Email(value: '');

  factory Email.dirty(String value) => Email(value: value);

  final String? value;

  bool get valid => _validationRegExp.hasMatch(value!);

  @override
  List<Object?> get props => [value];
}
