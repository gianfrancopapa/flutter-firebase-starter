import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_bloc.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_event.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_state.dart';
import 'package:firebasestarter/bloc/forms/create_account_form.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../unit/auth/mocks/auth_mocks.dart';
import '../user/mocks/user_mocks.dart';
import 'mocks/account_creation_bloc_mocks.dart';

void main() {
  AuthService auth;
  CreateAccountFormBloc form;
  User user;

  const passwordMismatchError = 'Error: Passwords doesn\'t match.';

  setUp(() {
    auth = MockAuthService();
    form = MockCreateAccountFormBloc();
    user = MockUser();
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
          )).thenAnswer((realInvocation) async => user);
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

      blocTest(
        'Invalid event started, failure - exception',
        build: () => AccountCreationBloc(authService: auth),
        act: (bloc) {
          bloc.add(null);
        },
        expect: () => [
          const AccountCreationState(
            status: AccountCreationStatus.failure,
            errorMessage: 'Error: Invalid event in [create_account_bloc.dart]',
          ),
        ],
      );
    },
  );
}
