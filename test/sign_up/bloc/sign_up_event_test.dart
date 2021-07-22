// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignUpEvent', () {
    group('SignUpRequested', () {
      test('supports value comparison', () {
        expect(SignUpRequested(), equals(SignUpRequested()));
      });
    });

    group('SignUpFirstNameChanged', () {
      const firstName = 'firstName';

      test('supports value comparison', () {
        expect(
          SignUpFirstNameChanged(firstName: firstName),
          equals(
            SignUpFirstNameChanged(firstName: firstName),
          ),
        );
      });
    });

    group('SignUpLastNameChanged', () {
      const lastName = 'lastName';

      test('supports value comparison', () {
        expect(
          SignUpLastNameChanged(lastName: lastName),
          equals(
            SignUpLastNameChanged(lastName: lastName),
          ),
        );
      });
    });

    group('SignUpEmailChanged', () {
      const email = 'email@gmail.com';

      test('supports value comparison', () {
        expect(
          SignUpEmailChanged(email: email),
          equals(
            SignUpEmailChanged(email: email),
          ),
        );
      });
    });

    group('SignUpPasswordChanged', () {
      const password = 'Password01';

      test('supports value comparison', () {
        expect(
          SignUpPasswordChanged(password: password),
          equals(
            SignUpPasswordChanged(password: password),
          ),
        );
      });
    });

    group('SignUpPasswordConfirmationChanged', () {
      const passwordConfirmation = 'Password01';

      test('supports value comparison', () {
        expect(
          SignUpPasswordConfirmationChanged(
            passwordConfirmation: passwordConfirmation,
          ),
          equals(
            SignUpPasswordConfirmationChanged(
              passwordConfirmation: passwordConfirmation,
            ),
          ),
        );
      });
    });
  });
}
