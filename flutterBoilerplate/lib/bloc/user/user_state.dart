import 'package:flutterBoilerplate/models/user.dart';

abstract class UserState {
  const UserState();
}

class CurrentUser extends UserState {
  final User user;
  const CurrentUser(this.user);
}

class NotDetermined extends UserState {
  const NotDetermined();
}

class Error extends UserState {
  final String message;
  const Error(this.message);
}

class Loading extends UserState {
  const Loading();
}
