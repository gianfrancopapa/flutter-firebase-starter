import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc({
    required AuthService authService,
  })  : _authService = authService,
        super(ForgotPasswordState.initial()) {
    on<ForgotPasswordResetRequested>(_mapForgotPasswordResetRequestedToState);
    on<ForgotPasswordEmailChanged>(_mapForgotPasswordEmailChangedToState);
  }

  final AuthService _authService;

  Future<void> _mapForgotPasswordResetRequestedToState(
    ForgotPasswordResetRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(state.copyWith(status: ForgotPasswordStatus.loading));

    if (!(state.email?.valid ?? false)) {
      emit(state.copyWith(status: ForgotPasswordStatus.failure));
      return;
    }

    try {
      await _authService.sendPasswordResetEmail(email: state.email!.value!);

      emit(state.copyWith(status: ForgotPasswordStatus.success));
    } on AuthError {
      emit(state.copyWith(status: ForgotPasswordStatus.failure));
    }
  }

  Future<void> _mapForgotPasswordEmailChangedToState(
    ForgotPasswordEmailChanged event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    final email = Email.dirty(event.email);

    emit(state.copyWith(
      email: email,
      status: email.valid
          ? ForgotPasswordStatus.valid
          : ForgotPasswordStatus.invalid,
    ));
  }
}
