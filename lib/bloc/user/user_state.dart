import 'package:firebasestarter/models/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserLoadSuccess extends UserState {
  final User user;
  const UserLoadSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoadFailure extends UserState {
  final String message;
  const UserLoadFailure(this.message);
  @override
  List<Object> get props => [message];
}

class UserLoadInProgress extends UserState {
  const UserLoadInProgress();
}
