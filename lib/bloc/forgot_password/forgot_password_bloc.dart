import 'package:firebasestarter/bloc/forgot_password/forgot_password_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:firebasestarter/bloc/forms/forgot_password_form.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  AuthService _authService;

  static const _errEvent =
      'Error: Invalid event in [forgot_password_bloc.dart]';
  static const _recoverPasswordErr =
      'Error: Something went wrong while trying to recover password';

  final form = ForgotPasswordFormBloc();

  ForgotPasswordBloc() : super(const NotDetermined()) {
    _authService = GetIt.I<AuthService>();
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    switch (event.runtimeType) {
      case ForgotPassword:
        yield* _forgotPassword();
        break;
      default:
        yield const Error(_errEvent);
    }
  }

  Stream<ForgotPasswordState> _forgotPassword() async* {
    yield const Loading();
    try {
      await _authService.sendPasswordResetEmail(form.emailValue);
      yield const EmailSent();
    } catch (e) {
      yield const Error(_recoverPasswordErr);
    }
  }
}
