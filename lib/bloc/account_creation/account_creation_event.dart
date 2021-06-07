import 'package:equatable/equatable.dart';

abstract class AccountCreationEvent extends Equatable {
  const AccountCreationEvent();
}

class AccountCreationRequested extends AccountCreationEvent {
  const AccountCreationRequested();

  @override
  List<Object> get props => [];
}
