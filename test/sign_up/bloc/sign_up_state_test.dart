// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignUpState', () {
    test('has valid initial state', () {
      expect(
        SignUpState.initial(),
        equals(
          SignUpState(
            status: SignUpStatus.initial,
            firstName: FirstName.pure(),
            lastName: LastName.pure(),
            email: Email.pure(),
            password: Password.pure(),
            passwordConfirmation: Password.pure(),
          ),
        ),
      );
    });

    test('supports value comparison', () {
      expect(
        SignUpState(status: SignUpStatus.initial),
        equals(SignUpState(status: SignUpStatus.initial)),
      );
    });

    group('copyWith', () {
      test('returns same object when no properties are passed', () {
        expect(
          SignUpState(status: SignUpStatus.initial).copyWith(),
          equals(SignUpState(status: SignUpStatus.initial)),
        );
      });

      test('returns object with updated status when passed', () {
        expect(
          SignUpState(status: SignUpStatus.initial).copyWith(
            status: SignUpStatus.loading,
          ),
          equals(SignUpState(status: SignUpStatus.loading)),
        );
      });

      test('returns object with updated firstName when passed', () {
        expect(
          SignUpState(status: SignUpStatus.initial)
              .copyWith(firstName: FirstName.dirty('firstName')),
          equals(
            SignUpState(
              status: SignUpStatus.initial,
              firstName: FirstName.dirty('firstName'),
            ),
          ),
        );
      });

      test('returns object with updated lastName when passed', () {
        expect(
          SignUpState(status: SignUpStatus.initial)
              .copyWith(lastName: LastName.dirty('lastName')),
          equals(
            SignUpState(
              status: SignUpStatus.initial,
              lastName: LastName.dirty('lastName'),
            ),
          ),
        );
      });

      test('returns object with updated email when passed', () {
        expect(
          SignUpState(status: SignUpStatus.initial)
              .copyWith(email: Email.dirty('email@email.com')),
          equals(
            SignUpState(
              status: SignUpStatus.initial,
              email: Email.dirty('email@email.com'),
            ),
          ),
        );
      });

      test('returns object with updated password when passed', () {
        expect(
          SignUpState(status: SignUpStatus.initial)
              .copyWith(password: Password.dirty('Password01')),
          equals(
            SignUpState(
              status: SignUpStatus.initial,
              password: Password.dirty('Password01'),
            ),
          ),
        );
      });

      test('returns object with updated passwordConfirmation when passed', () {
        expect(
          SignUpState(status: SignUpStatus.initial)
              .copyWith(passwordConfirmation: Password.dirty('Password01')),
          equals(
            SignUpState(
              status: SignUpStatus.initial,
              passwordConfirmation: Password.dirty('Password01'),
            ),
          ),
        );
      });
    });
  });
}
