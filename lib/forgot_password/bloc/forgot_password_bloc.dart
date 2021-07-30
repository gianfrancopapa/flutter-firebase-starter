import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    @required AuthService authService,
  })  : assert(authService != null),
        _authService = authService,
        super(ForgotPasswordState.initial());

  final AuthService _authService;

  @override
  Stream<ForgotPasswordState> mapEventToState(
    ForgotPasswordEvent event,
  ) async* {
    if (event is ForgotPasswordResetRequested) {
      yield* _mapForgotPasswordResetRequestedToState();
    } else if (event is ForgotPasswordEmailChanged) {
      yield* _mapForgotPasswordEmailChangedToState(event);
    }
  }

  Stream<ForgotPasswordState> _mapForgotPasswordResetRequestedToState() async* {
    yield state.copyWith(status: ForgotPasswordStatus.loading);

    if (!(state.email?.valid ?? false)) {
      yield state.copyWith(status: ForgotPasswordStatus.failure);
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email: state.email.value);

      yield state.copyWith(status: ForgotPasswordStatus.success);
    } on AuthError {
      yield state.copyWith(status: ForgotPasswordStatus.failure);
    }
  }

  Stream<ForgotPasswordState> _mapForgotPasswordEmailChangedToState(
    ForgotPasswordEmailChanged event,
  ) async* {
    final email = Email.dirty(event.email);

    yield state.copyWith(
      email: email,
      status: email.valid
          ? ForgotPasswordStatus.valid
          : ForgotPasswordStatus.invalid,
    );
  }
}
