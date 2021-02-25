import 'package:flutterBoilerplate/bloc/user/user_event.dart';
import 'package:flutterBoilerplate/bloc/user/user_state.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const NotDetermined());
  final _authService = FirebaseAuthService();

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
      final user = await _authService.getCurrentUser();
      yield CurrentUser(user);
    } catch (e) {
      yield const Error('Something went wrong');
    }
  }
}
