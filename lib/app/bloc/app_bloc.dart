import 'dart:async';

import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthService authService,
    required LocalPersistanceService localPersistanceService,
  })  : _authService = authService,
        _localPersistanceService = localPersistanceService,
        super(const AppState(status: AppStatus.initial)) {
    _userSubscription = _authService.onAuthStateChanged.listen(_onUserChanged);
    on<AppIsFirstTimeLaunched>(_mapAppIsFirstTimeLaunchedToState);
    on<AppUserChanged>(_mapAppUserChangedToState);
    on<AppLogoutRequsted>(_mapAppLogoutRequstedToState);
  }

  static const String _isFirstTime = 'is_first_time';

  final AuthService _authService;
  final LocalPersistanceService _localPersistanceService;
  StreamSubscription<UserEntity?>? _userSubscription;

  void _onUserChanged(UserEntity? user) {
    add(
      AppUserChanged(
        user: user != null ? User.fromEntity(user) : User.empty,
      ),
    );
  }

  Future<void> _mapAppIsFirstTimeLaunchedToState(
      AppIsFirstTimeLaunched event, Emitter<AppState> emit) async {
    try {
      final firstTime =
          await _localPersistanceService.getValue<bool>(_isFirstTime);

      await Future.delayed(const Duration(seconds: 2));

      if (firstTime ?? true) {
        await _localPersistanceService.setValue<bool>(_isFirstTime, false);
        emit(state.copyWith(status: AppStatus.firstTime));
      } else {
        emit(state.copyWith(status: AppStatus.unauthenticated));
      }
    } on Exception {
      emit(state.copyWith(status: AppStatus.failure));
    }
  }

  Future<void> _mapAppUserChangedToState(
      AppUserChanged event, Emitter<AppState> emit) async {
    final user = event.user;

    if (user == User.empty) {
      emit(state.copyWith(user: user));
      add(const AppIsFirstTimeLaunched());
      return;
    }

    emit(state.copyWith(
      status: AppStatus.authenticated,
      user: user,
    ));
  }

  Future<void> _mapAppLogoutRequstedToState(
      AppLogoutRequsted event, Emitter<AppState> emit) async {
    try {
      await _authService.signOut();

      emit(state.copyWith(
        status: AppStatus.unauthenticated,
        user: User.empty,
      ));
    } on AuthError {
      emit(state.copyWith(status: AppStatus.failure));
    }
  }

  @override
  Future<void> close() async {
    _userSubscription?.cancel();
    return super.close();
  }
}
