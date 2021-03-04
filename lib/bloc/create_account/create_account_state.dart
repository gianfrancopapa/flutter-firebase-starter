import 'package:firebasestarter/models/user.dart';

abstract class CreateAccountState {
  const CreateAccountState();
}

class AccountCreated extends CreateAccountState {
  final User user;
  const AccountCreated(this.user);
}

class Error extends CreateAccountState {
  final String message;
  const Error(this.message);
}

class Loading extends CreateAccountState {
  const Loading();
}

class NotDetermined extends CreateAccountState {
  const NotDetermined();
}
