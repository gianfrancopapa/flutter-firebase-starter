import 'package:firebasestarter/models/user.dart';

abstract class CreateAccountState {
  const CreateAccountState();
}

class CreateAccountSuccess extends CreateAccountState {
  final User user;
  const CreateAccountSuccess(this.user);
}

class CreateAccountFailure extends CreateAccountState {
  final String message;
  const CreateAccountFailure(this.message);
}

class CreateAccountInProgress extends CreateAccountState {
  const CreateAccountInProgress();
}

class CreateAccountInitial extends CreateAccountState {
  const CreateAccountInitial();
}
