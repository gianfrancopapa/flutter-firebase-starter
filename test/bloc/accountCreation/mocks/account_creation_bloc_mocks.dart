import 'package:firebasestarter/bloc/forms/create_account_form.dart';
import 'package:mockito/mockito.dart';
import 'package:somnio_firebase_authentication/src/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class MockCreateAccountFormBloc extends Mock implements CreateAccountFormBloc {}

class MockAuthService extends Mock implements AuthService {}

class MockFirebaseUser extends Mock implements Auth.User {}
