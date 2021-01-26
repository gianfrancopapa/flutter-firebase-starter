import 'package:flutterBoilerplate/bloc/user/user_event.dart';
import 'package:flutterBoilerplate/bloc/user/user_state.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutterBoilerplate/services/google_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const NotDetermined());
  IAuth _authService;
  final String _authServiceKey = 'auth_service';

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
    _getCurrentAuthService();
    yield const Loading();
    try {
      final user = await _authService.getCurrentUser();
      yield CurrentUser(user);
    } catch (e) {
      yield const Error('Something went wrong');
    }
  }

  void _getCurrentAuthService() async {
    final prefs = await SharedPreferences.getInstance();
    final currentAuth = prefs.getString(_authServiceKey);
    if (currentAuth == null) {
      _authService = null;
    } else if (currentAuth == FirebaseAuthService().toString()) {
      _authService = FirebaseAuthService();
    }
    _authService = GoogleAuthService();
  }
}
