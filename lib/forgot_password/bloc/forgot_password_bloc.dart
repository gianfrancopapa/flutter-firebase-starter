import 'package:equatable/equatable.dart';
import 'package:firebasestarter/forms/models/email.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
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
        super(const ForgotPasswordState(status: ForgotPasswordStatus.initial));

  final AuthService _authService;

  @override
  Stream<ForgotPasswordState> mapEventToState(
      ForgotPasswordEvent event) async* {
    if (event is ForgotPasswordResetRequested) {
      yield* _mapForgotPasswordResetRequestedToState();
    } else if (event is ForgotPasswordEmailChanged) {
      yield* _mapForgotPasswordEmailChangedToState(event);
    }
  }

  Stream<ForgotPasswordState> _mapForgotPasswordResetRequestedToState() async* {
    yield state.copyWith(status: ForgotPasswordStatus.loading);

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
    yield state.copyWith(email: Email.dirty(event.email));
  }
}
