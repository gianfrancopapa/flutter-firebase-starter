part of 'delete_account_bloc.dart';

abstract class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object> get props => [];
}

class DeleteAccountRequested extends DeleteAccountEvent {
  const DeleteAccountRequested();
}

class DeleteAccountRequestedSocialMedia extends DeleteAccountEvent {
  final AuthenticationMethod method;
  const DeleteAccountRequestedSocialMedia(this.method);
}

class DeleteAccountPasswordReauthentication extends DeleteAccountEvent {
  final String password;
  const DeleteAccountPasswordReauthentication(this.password);
}
