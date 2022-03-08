import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'verifiy_email_event.dart';
part 'verifiy_email_state.dart';

class VerifiyEmailBloc extends Bloc<VerifiyEmailEvent, VerifiyEmailState> {
  VerifiyEmailBloc({required AuthService authService})
      : _authService = authService,
        super(const VerifiyEmailState()) {
    on<VerifyEmailButtonEvent>(_mapVerifyEmailButtonEventToState);
  }

  final AuthService _authService;

  _mapVerifyEmailButtonEventToState(
      VerifyEmailButtonEvent event, Emitter emit) {
    emit(state.copyWith(status: VerifyEmailStatus.loading));
    try {
      _authService.sendEmailVerification();
      emit(state.copyWith(status: VerifyEmailStatus.success));
    } on AuthError {
      emit(state.copyWith(status: VerifyEmailStatus.error));
    }
  }
}
