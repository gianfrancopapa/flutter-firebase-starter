import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/sign_up/sign_up.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_bench.dart';

class MockSignUpBloc extends MockBloc<SignUpEvent, SignUpState>
    implements SignUpBloc {}

class MockSignUpState extends Fake implements SignUpState {}

class MockSignUpEvent extends Fake implements SignUpEvent {}

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

class MockUserEvent extends Fake implements UserEvent {}

class MockUserState extends Fake implements UserState {}

void main() {
  group('SignUpView', () {
    late SignUpBloc mockSignUpBloc;
    UserBloc mockUserBloc;

    setUp(() {
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

      mockUserBloc = MockUserBloc();

      when(() => mockUserBloc.state)
          .thenReturn(const UserState(status: UserStatus.initial));
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
        mockSignUpBloc.state.copyWith(
          firstName: FirstName.dirty('firstName'),
          lastName: LastName.dirty('lastName'),
          email: Email.dirty('email@gmail.com'),
          password: Password.dirty('Password01'),
          passwordConfirmation: Password.dirty('Password01'),
          status: SignUpStatus.valid,
        ),
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

      await tester.ensureVisible(signUpTextButtonFinder);

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

        await tester.ensureVisible(signUpTextButtonFinder);

        await tester.tap(signUpTextButtonFinder);

        verifyNever(() => mockSignUpBloc.add(const SignUpRequested()));
      },
    );

    testWidgets(
      'shows a Dialog when mockSignUpBloc emits [failure]',
      (tester) async {
        whenListen(
          mockSignUpBloc,
          Stream.value(
            SignUpState.initial().copyWith(status: SignUpStatus.failure),
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: mockSignUpBloc,
            child: const SignUpScreen(),
          ),
        );

        await tester.pump();

        expect(find.byType(Dialog), findsOneWidget);
      },
    );

    /// Need to add MockNavigator to avoid this failing test

    // testWidgets(
    //   'adds UserLoaded when mockSignUpBloc emits [success]',
    //   (tester) async {
    //     whenListen(
    //       mockSignUpBloc,
    //       Stream.value(
    //         SignUpState.initial().copyWith(status: SignUpStatus.success),
    //       ),
    //     );

    //     await tester.pumpApp(
    //       BlocProvider.value(
    //         value: mockSignUpBloc,
    //         child: const SignUpScreen(),
    //       ),
    //       userBloc: mockUserBloc,
    //     );

    //     await tester.pump();

    //     verify(() => mockUserBloc.add(const UserLoaded())).called(1);
    //   },
    // );
  });
}
