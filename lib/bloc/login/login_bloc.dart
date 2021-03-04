import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:firebasestarter/bloc/forms/login_form_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  static const _errEvent = 'Error: Invalid event in [login_bloc.dart]';
  final _auth = FirebaseAuthService();
  final form = LoginFormBloc();

  LoginBloc() : super(const NotDetermined());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    switch (event.runtimeType) {
      case StartLogin:
        yield* _login();
        break;
      case StartGoogleLogin:
        yield* _signIn(_auth.signInWithGoogle);
        break;
      case StartAppleLogin:
        yield* _signIn(_auth.signInWithApple);
        break;
      case StartFacebookLogin:
        yield* _signIn(_auth.signInWithFacebook);
        break;
      case StartAnonymousLogin:
        yield* _signIn(_auth.signInAnonymously);
        break;
      case StartLogout:
        yield* _logout();
        break;
      case CheckIfUserIsLoggedIn:
        yield* _checkIfUserIsLoggedIn();
        break;
      default:
        yield const ErrorLogin(_errEvent);
    }
  }

  Stream<LoginState> _login() async* {
    yield const Loading();
    try {
      final user = await _auth.signInWithEmailAndPassword(
        form.emailValue,
        form.passwordValue,
      );
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  Stream<LoginState> _signIn(Future<User> Function() signInMethod) async* {
    yield const Loading();
    try {
      final user = await signInMethod();
      yield LoggedIn(user);
    } catch (e) {
      yield ErrorLogin(e.toString());
    }
  }

  Stream<LoginState> _logout() async* {
    yield const Loading();
    try {
      await _auth.signOut();
      yield const LoggedOut();
    } catch (e) {
      yield const ErrorLogin('Error while trying to log out');
    }
  }

  Stream<LoginState> _checkIfUserIsLoggedIn() async* {
    yield const Loading();
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        yield LoggedIn(user);
      } else {
        yield const LoggedOut();
      }
    } catch (e) {
      yield const ErrorLogin(
          'Error while trying to verify if user is logged in');
    }
  }
}
