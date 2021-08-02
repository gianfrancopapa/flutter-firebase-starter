import 'dart:async';

import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    @required AuthService authService,
    @required LocalPersistanceService localPersistanceService,
  })  : assert(authService != null),
        assert(localPersistanceService != null),
        _authService = authService,
        _localPersistanceService = localPersistanceService,
        super(const AppState(status: AppStatus.initial)) {
    _userSubscription = _authService.onAuthStateChanged.listen(_onUserChanged);
  }

  static const String _isFirstTime = 'is_first_time';

  final AuthService _authService;
  final LocalPersistanceService _localPersistanceService;
  StreamSubscription<UserEntity> _userSubscription;

  void _onUserChanged(UserEntity user) {
    add(
      AppUserChanged(
        user: user != null ? User.fromEntity(user) : User.empty,
      ),
    );
  }

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppIsFirstTimeLaunched) {
      yield* _mapAppIsFirstTimeLaunchedToState();
    } else if (event is AppUserChanged) {
      yield* _mapAppUserChangedToState(event);
    } else if (event is AppLogoutRequsted) {
      yield* _mapAppLogoutRequstedToState();
    }
  }

  Stream<AppState> _mapAppIsFirstTimeLaunchedToState() async* {
    try {
      final firstTime =
          await _localPersistanceService.getValue<bool>(_isFirstTime);

      await Future.delayed(const Duration(seconds: 2));

      if (firstTime ?? true) {
        await _localPersistanceService.setValue<bool>(_isFirstTime, false);
        yield state.copyWith(status: AppStatus.firstTime);
      } else {
        yield state.copyWith(status: AppStatus.unauthenticated);
      }
    } on Exception {
      yield state.copyWith(status: AppStatus.failure);
    }
  }

  Stream<AppState> _mapAppUserChangedToState(
    AppUserChanged event,
  ) async* {
    final user = event.user;

    if (user == User.empty) {
      yield state.copyWith(user: user);
      add(const AppIsFirstTimeLaunched());
      return;
    }

    yield state.copyWith(
      status: AppStatus.authenticated,
      user: user,
    );
  }

  Stream<AppState> _mapAppLogoutRequstedToState() async* {
    try {
      await _authService.signOut();

      yield state.copyWith(
        status: AppStatus.unauthenticated,
        user: User.empty,
      );
    } on AuthError {
      yield state.copyWith(status: AppStatus.failure);
    }
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    return super.close();
  }
}
