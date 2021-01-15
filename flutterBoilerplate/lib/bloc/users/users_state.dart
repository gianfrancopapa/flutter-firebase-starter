import 'package:flutterBoilerplate/models/user.dart';

abstract class UsersState {
  const UsersState();
}

class NotDetermined extends UsersState {
  const NotDetermined();
}

class Loading extends UsersState {
  const Loading();
}

class Error extends UsersState {
  final String message;
  const Error(this.message);
}

class Users extends UsersState {
  final List<User> users;
  const Users(this.users);
}

class UserCreated extends UsersState {
  const UserCreated();
}
