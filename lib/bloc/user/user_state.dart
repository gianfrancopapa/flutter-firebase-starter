import 'package:firebasestarter/models/user.dart';

abstract class UserState {
  const UserState();
}

class UserLoadSuccess extends UserState {
  final User user;
  const UserLoadSuccess(this.user);
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoadFailure extends UserState {
  final String message;
  const UserLoadFailure(this.message);
}

class UserLoadInProgress extends UserState {
  const UserLoadInProgress();
}
