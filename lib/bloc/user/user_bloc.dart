import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  AuthService _authService;

  UserBloc() : super(const NotDetermined()) {
    _authService = GetIt.I.get<AuthService>();
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch (event.runtimeType) {
      case GetUser:
        yield* _mapGetUserToState();
        break;
      default:
        yield const Error('Undetermined event');
    }
  }

  Stream<UserState> _mapGetUserToState() async* {
    yield const Loading();
    try {
      final user = await _authService.currentUser();
      yield CurrentUser(user);
    } catch (e) {
      yield const Error('Something went wrong');
    }
  }
}
