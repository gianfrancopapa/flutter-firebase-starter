import 'package:equatable/equatable.dart';

class Email extends Equatable {
  const Email({this.value});

  factory Email.pure() => const Email(value: '');

  factory Email.dirty(String value) => Email(value: value);

  final String value;

  bool get valid => value.isNotEmpty;

  @override
  List<Object> get props => [value];
}
