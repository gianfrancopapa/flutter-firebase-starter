import 'dart:async';

import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
import 'package:firebasestarter/services/auth/user_mapper.dart';
import 'package:somnio_firebase_authentication/src/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  AuthService _authService;

  UserBloc([AuthService authService]) : super(const UserState()) {
    _authService = authService ?? GetIt.I.get<AuthService>();
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoaded) {
      yield* _mapUserLoadedToState();
    }
  }

  Stream<UserState> _mapUserLoadedToState() async* {
    yield state.copyWith(status: UserStatus.inProgress);
    try {
      final user = mapFirebaseUser(await _authService.currentUser());
      yield state.copyWith(
        status: UserStatus.success,
        user: user,
      );
    } catch (e) {
      yield state.copyWith(
        status: UserStatus.failure,
        errorMessage: 'Something went wrong',
      );
    }
  }
}
