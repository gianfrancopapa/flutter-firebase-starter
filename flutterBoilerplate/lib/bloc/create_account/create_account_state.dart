abstract class CreateAccountState {
  const CreateAccountState();
}

class AccountCreated extends CreateAccountState {
  const AccountCreated();
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
