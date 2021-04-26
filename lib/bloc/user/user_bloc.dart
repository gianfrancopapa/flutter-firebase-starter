import 'dart:async';

import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  AuthService _authService;

  UserBloc([AuthService authService]) : super(const UserInitial()) {
    _authService = authService ?? GetIt.I.get<AuthService>();
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch (event.runtimeType) {
      case UserLoaded:
        yield* _mapUserLoadedToState();
        break;
      default:
        yield const UserLoadFailure('Undetermined event');
    }
  }

  Stream<UserState> _mapUserLoadedToState() async* {
    yield const UserLoadInProgress();
    try {
      final user = await _authService.currentUser();
      yield UserLoadSuccess(user);
    } catch (e) {
      yield const UserLoadFailure('Something went wrong');
    }
  }
}
