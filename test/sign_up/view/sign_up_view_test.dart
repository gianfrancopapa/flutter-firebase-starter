import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/sign_up/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_bench.dart';

class MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

class MockSignUpState extends Fake implements SignUpState {}

class MockSignUpEvent extends Fake implements SignUpEvent {}

class MockUser extends Mock implements User {}

void main() {
  group('SignUpView', () {
    SignUpBloc mockSignUpBloc;

    setUp(() {
      registerFallbackValue<SignUpState>(MockSignUpState());
      registerFallbackValue<SignUpEvent>(MockSignUpEvent());

      mockSignUpBloc = MockSignUpBloc();

      when(() => mockSignUpBloc.state).thenReturn(
        SignUpState(
          status: SignUpStatus.initial,
          firstName: FirstName.pure(),
          lastName: LastName.pure(),
          email: Email.pure(),
          password: Password.pure(),
          passwordConfirmation: Password.pure(),
        ),
      );
    });

    test('is a route', () {
      expect(SignUpScreen.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockSignUpBloc,
          child: const SignUpScreen(),
        ),
      );

      expect(
        find.byKey(const Key('signUpScreen_signUpForm_firstNameTextField')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('signUpScreen_signUpForm_lastNameTextField')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('signUpScreen_signUpForm_emailTextField')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('signUpScreen_signUpForm_passwordTextField')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key('signUpScreen_signUpForm_passwordConfirmationTextField'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('adds SignUpFirstNameChanged', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockSignUpBloc,
          child: const SignUpScreen(),
        ),
      );

      final firstNameTextFieldFinder =
          find.byKey(const Key('signUpScreen_signUpForm_firstNameTextField'));

      await tester.enterText(firstNameTextFieldFinder, 'firstName');

      verify(
        () => mockSignUpBloc.add(
          const SignUpFirstNameChanged(firstName: 'firstName'),
        ),
      ).called(1);
    });

    testWidgets('adds SignUpLastNameChanged', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockSignUpBloc,
          child: const SignUpScreen(),
        ),
      );

      final lastNameTextFieldFinder =
          find.byKey(const Key('signUpScreen_signUpForm_lastNameTextField'));

      await tester.enterText(lastNameTextFieldFinder, 'lastName');

      verify(
        () => mockSignUpBloc.add(
          const SignUpLastNameChanged(lastName: 'lastName'),
        ),
      ).called(1);
    });

    testWidgets('adds SignUpEmailChanged', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockSignUpBloc,
          child: const SignUpScreen(),
        ),
      );

      final emailTextFieldFinder =
          find.byKey(const Key('signUpScreen_signUpForm_emailTextField'));

      await tester.enterText(emailTextFieldFinder, 'email@email.com');

      verify(
        () => mockSignUpBloc.add(
          const SignUpEmailChanged(email: 'email@email.com'),
        ),
      ).called(1);
    });

    testWidgets('adds SignUpPasswordChanged', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockSignUpBloc,
          child: const SignUpScreen(),
        ),
      );

      final passwordTextFieldFinder =
          find.byKey(const Key('signUpScreen_signUpForm_passwordTextField'));

      await tester.enterText(passwordTextFieldFinder, 'Password01');

      verify(
        () => mockSignUpBloc.add(
          const SignUpPasswordChanged(password: 'Password01'),
        ),
      ).called(1);
    });

    testWidgets('adds SignUpPasswordConfirmationChanged', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockSignUpBloc,
          child: const SignUpScreen(),
        ),
      );

      final passwordConfirmationTextFieldFinder = find.byKey(
        const Key('signUpScreen_signUpForm_passwordConfirmationTextField'),
      );

      await tester.enterText(passwordConfirmationTextFieldFinder, 'Password01');

      verify(
        () => mockSignUpBloc.add(
          const SignUpPasswordConfirmationChanged(
            passwordConfirmation: 'Password01',
          ),
        ),
      ).called(1);
    });

    testWidgets('adds SignUpRequested when status is valid', (tester) async {
      when(() => mockSignUpBloc.state).thenReturn(
        mockSignUpBloc.state.copyWith(status: SignUpStatus.valid),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: mockSignUpBloc,
          child: const SignUpScreen(),
        ),
      );

      final signUpTextButtonFinder = find.byKey(
        const Key('signUpScreen_signUpForm_signUpTextButton'),
      );

      await tester.tap(signUpTextButtonFinder);

      verify(() => mockSignUpBloc.add(const SignUpRequested())).called(1);
    });

    testWidgets(
      'does not add SignUpRequested when status is invalid',
      (tester) async {
        when(() => mockSignUpBloc.state).thenReturn(
          mockSignUpBloc.state.copyWith(status: SignUpStatus.invalid),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: mockSignUpBloc,
            child: const SignUpScreen(),
          ),
        );

        final signUpTextButtonFinder = find.byKey(
          const Key('signUpScreen_signUpForm_signUpTextButton'),
        );

        await tester.tap(signUpTextButtonFinder);

        verifyNever(() => mockSignUpBloc.add(const SignUpRequested()));
      },
    );
  });
}
