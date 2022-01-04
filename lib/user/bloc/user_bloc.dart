import 'dart:async';
import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({required AuthService authService})
      : _authService = authService,
        super(const UserState(status: UserStatus.initial)) {
    on<UserLoaded>(_mapUserLoadedToState);
  }

  final AuthService _authService;

  Future<void> _mapUserLoadedToState(
    UserLoaded event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      final user = await (_authService.currentUser());

      emit(state.copyWith(status: UserStatus.success, user: _toUser(user!)));
    } on AuthError {
      emit(state.copyWith(status: UserStatus.failure));
    }
  }

  User _toUser(UserEntity entity) => User.fromEntity(entity);
}
