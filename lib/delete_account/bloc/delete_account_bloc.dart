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
    on<DeleteAccountRequested>(_mapAppDeleteRequestedToState);
    on<DeleteAccountPasswordReauthentication>(
        _mapAppPasswordReauthenticationToState);
    on<DeleteAccountRequestedSocialMedia>(
        _mapAppDeleteRequestedSocialMediaToState);
  }

  final AuthService _authService;

  Future<void> _mapAppDeleteRequestedToState(
      DeleteAccountRequested event, Emitter<DeleteAccountState> emit) async {
    try {
      await _authService.deleteAccountEmail(state.password!);
      emit(state.copyWith(
        user: User.empty,
        password: '',
      ));
    } on AuthError {
      emit(state.copyWith());
    }
  }

  Future<void> _mapAppDeleteRequestedSocialMediaToState(
      DeleteAccountRequestedSocialMedia event,
      Emitter<DeleteAccountState> emit) async {
    try {
      await _authService.deleteAccountSocialMedia(event.method);
      emit(state.copyWith(
        user: User.empty,
        password: '',
      ));
    } on AuthError {
      emit(state.copyWith());
    }
  }

  Future<void> _mapAppPasswordReauthenticationToState(
      DeleteAccountPasswordReauthentication event,
      Emitter<DeleteAccountState> emit) async {
    emit(state.copyWith(password: event.password));
  }
}
