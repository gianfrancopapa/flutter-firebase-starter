import 'package:equatable/equatable.dart';

class Password extends Equatable {
  const Password({this.value});

  factory Password.pure() => const Password(value: '');

  factory Password.dirty(String value) => Password(value: value);

  final String? value;

  bool get valid => value!.length > 4;

  @override
  List<Object?> get props => [value];
}
