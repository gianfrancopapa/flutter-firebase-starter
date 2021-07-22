import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({@required AuthService authService})
      : assert(authService != null),
        _authService = authService,
        super(const UserState(status: UserStatus.initial));

  final AuthService _authService;

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is UserLoaded) {
      yield* _mapUserLoadedToState();
    }
  }

  Stream<UserState> _mapUserLoadedToState() async* {
    yield state.copyWith(status: UserStatus.loading);

    try {
      final user = await _authService.currentUser();

      yield state.copyWith(status: UserStatus.success, user: user);
    } on AuthError {
      yield state.copyWith(status: UserStatus.failure);
    }
  }
}
