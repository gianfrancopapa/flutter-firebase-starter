import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_bloc.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_event.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_state.dart';
import 'package:firebasestarter/bloc/forms/create_account_form.dart';
import 'package:firebasestarter/models/user.dart' as Starter;
import 'package:somnio_firebase_authentication/somnio_firebase_authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'mocks/account_creation_bloc_mocks.dart';

void main() {
  AuthService auth;
  CreateAccountFormBloc form;
  User firebaseUser;
  Starter.User user;

  const passwordMismatchError = 'Error: Passwords doesn\'t match.';

  setUp(() {
    auth = MockAuthService();
    form = MockCreateAccountFormBloc();
    final map = <String, dynamic>{
      'id': '1',
      'firstName': 'testName',
      'lastName': 'testLastName',
      'email': 'testEmail',
      'emailVerified': false,
      'imageUrl': 'testImage',
      'isAnonymous': false,
      'age': 0,
      'phoneNumber': '',
      'address': '',
    };
    user = Starter.User.fromJson(map);
    firebaseUser = MockFirebaseUser();
    when(firebaseUser.displayName).thenReturn('testName testLastName');
    when(firebaseUser.uid).thenReturn('1');
    when(firebaseUser.email).thenReturn('testEmail');
    when(firebaseUser.photoURL).thenReturn('testImage');
    when(firebaseUser.isAnonymous).thenReturn(false);
  });

  group(
    'AccountCreationBloc /',
    () {
      test('Initial state', () {
        final accountCreationBloc = AccountCreationBloc(authService: auth);
        expect(accountCreationBloc.state.status, AccountCreationStatus.initial);
      });

      blocTest(
        'AccountCreationRequested started, success',
        build: () => AccountCreationBloc(authService: auth, form: form),
        act: (bloc) {
          when(form.firstNameVal).thenReturn('testFirstName');
          when(form.lastNameVal).thenReturn('testLastName');
          when(form.emailVal).thenReturn('test@email.com');
          when(form.passwordVal).thenReturn('testPassword');
          when(form.passwordConfVal).thenReturn('testPassword');

          when(auth.createUserWithEmailAndPassword(
            name: 'testFirstName',
            lastName: 'testLastName',
            email: 'test@email.com',
            password: 'testPassword',
          )).thenAnswer((_) async => firebaseUser);
          bloc.add(const AccountCreationRequested());
        },
        expect: () => [
          const AccountCreationState(status: AccountCreationStatus.inProgress),
          AccountCreationState(
            status: AccountCreationStatus.success,
            user: user,
          ),
        ],
      );

      blocTest(
        'AccountCreationRequested started, failure - password mismatch',
        build: () => AccountCreationBloc(authService: auth, form: form),
        act: (bloc) {
          when(form.firstNameVal).thenReturn('testFirstName');
          when(form.lastNameVal).thenReturn('testLastName');
          when(form.emailVal).thenReturn('test@email.com');
          when(form.passwordVal).thenReturn('testPassword');
          when(form.passwordConfVal).thenReturn('testPassword2');
          bloc.add(const AccountCreationRequested());
        },
        expect: () => [
          const AccountCreationState(status: AccountCreationStatus.inProgress),
          const AccountCreationState(
            status: AccountCreationStatus.failure,
            errorMessage: passwordMismatchError,
          ),
        ],
      );
    },
  );
}
