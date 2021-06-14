import 'package:firebasestarter/bloc/forgot_password/forgot_password_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:firebasestarter/bloc/forms/forgot_password_form.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  AuthService _authService;

  static const _recoverPasswordErr =
      'Error: Something went wrong while trying to recover password';

  ForgotPasswordFormBloc form;

  ForgotPasswordBloc({
    AuthService authService,
    ForgotPasswordFormBloc form,
  }) : super(const ForgotPasswordState()) {
    _authService = authService ?? GetIt.I<AuthService>();
    this.form = form ?? ForgotPasswordFormBloc();
  }

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is PasswordReset) {
      yield* _mapPasswordResetToState();
    }
  }

  Stream<ForgotPasswordState> _mapPasswordResetToState() async* {
    yield state.copyWith(status: ForgotPasswordStatus.inProgress);
    try {
      await _authService.sendPasswordResetEmail(form.emailValue);
      yield state.copyWith(status: ForgotPasswordStatus.emailSent);
    } catch (e) {
      yield state.copyWith(
        status: ForgotPasswordStatus.failure,
        errorMessage: _recoverPasswordErr,
      );
    }
  }
}
