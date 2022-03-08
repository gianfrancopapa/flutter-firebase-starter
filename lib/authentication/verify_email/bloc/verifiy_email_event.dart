part of 'verifiy_email_bloc.dart';

abstract class VerifiyEmailEvent extends Equatable {
  const VerifiyEmailEvent();

  @override
  List<Object> get props => [];
}

class VerifyEmailButtonEvent extends VerifiyEmailEvent {
  const VerifyEmailButtonEvent();
}
