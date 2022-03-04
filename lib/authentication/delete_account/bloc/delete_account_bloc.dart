import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';

part 'delete_account_event.dart';
part 'delete_account_state.dart';

class DeleteAccountBloc extends Bloc<DeleteAccountEvent, DeleteAccountState> {
  DeleteAccountBloc({
    required AuthService authService,
  })  : _authService = authService,
        super(const DeleteAccountState()) {
    on<DeleteAccountRequestedEmail>(_mapDeleteAccountEmailRequestedToState);
    on<DeleteAccountPasswordReauthentication>(
        _mapDeleteAccountPasswordReauthenticationToState);
    on<DeleteAccountRequestedSocialMedia>(
        _mapDeleteAccountRequestedSocialMediaToState);
  }

  final AuthService _authService;

  Future<void> _mapDeleteAccountEmailRequestedToState(
      DeleteAccountRequestedEmail event,
      Emitter<DeleteAccountState> emit) async {
    try {
      final String password = state.password ?? '';
      await _authService.deleteAccountEmail(password);
      emit(state.copyWith(
        user: User.empty,
        password: '',
        status: DeleteAccountStatus.success,
      ));
    } on AuthError {
      emit(state.copyWith(status: DeleteAccountStatus.error));
    }
  }

  Future<void> _mapDeleteAccountRequestedSocialMediaToState(
      DeleteAccountRequestedSocialMedia event,
      Emitter<DeleteAccountState> emit) async {
    try {
      await _authService.deleteAccountSocialMedia(event.method);
      emit(state.copyWith(
        user: User.empty,
        password: '',
      ));
    } on AuthError {
      emit(state.copyWith(status: DeleteAccountStatus.error));
    }
  }

  Future<void> _mapDeleteAccountPasswordReauthenticationToState(
      DeleteAccountPasswordReauthentication event,
      Emitter<DeleteAccountState> emit) async {
    emit(state.copyWith(password: event.password));
  }
}
