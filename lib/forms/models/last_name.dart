import 'package:equatable/equatable.dart';

class LastName extends Equatable {
  const LastName({this.value});

  factory LastName.pure() => const LastName(value: '');

  factory LastName.dirty(String? value) => LastName(value: value);

  final String? value;

  bool get valid => value!.isNotEmpty;

  @override
  List<Object?> get props => [value];
}
