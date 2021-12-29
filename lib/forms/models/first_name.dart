import 'package:equatable/equatable.dart';

class FirstName extends Equatable {
  const FirstName({this.value});

  factory FirstName.pure() => const FirstName(value: '');

  factory FirstName.dirty(String? value) => FirstName(value: value);

  final String? value;

  bool get valid => value!.isNotEmpty;

  @override
  List<Object?> get props => [value];
}
