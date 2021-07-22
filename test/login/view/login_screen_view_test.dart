import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_bench.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockLoginState extends Fake implements LoginState {}

class MockLoginEvent extends Fake implements LoginEvent {}

class MockUser extends Mock implements User {}

void main() {
  LoginBloc loginBloc;
  User user;

  setUp(() {
    registerFallbackValue<LoginState>(MockLoginState());
    registerFallbackValue<LoginEvent>(MockLoginEvent());

    loginBloc = MockLoginBloc();
    user = MockUser();

    when(() => loginBloc.state).thenReturn(
      LoginState(
        status: LoginStatus.loggedIn,
        email: Email.pure(),
        password: Password.pure(),
        user: user,
      ),
    );
  });

  group('LoginScreenView', () {
    test('is a route', () {
      expect(LoginScreen.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        const LoginScreen(),
        loginBloc: loginBloc,
      );

      expect(
        find.byKey(const Key('loginScreen_loginForm_emailTextField')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('loginScreen_loginForm_passwordTextField')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('loginScreen_loginForm_forgotPasswordButton')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('loginScreen_loginForm_loginButton')),
        findsOneWidget,
      );
    });

    testWidgets('adds LoginEmailChanged', (tester) async {
      await tester.pumpApp(
        const LoginScreen(),
        loginBloc: loginBloc,
      );

      final emailFinder =
          find.byKey(const Key('loginScreen_loginForm_emailTextField'));

      await tester.enterText(emailFinder, 'test@gmail.com');

      verify(
        () => loginBloc.add(const LoginEmailChanged(email: 'test@gmail.com')),
      ).called(1);
    });

    testWidgets('adds LoginPasswordChanged', (tester) async {
      await tester.pumpApp(
        const LoginScreen(),
        loginBloc: loginBloc,
      );

      final passwordFinder =
          find.byKey(const Key('loginScreen_loginForm_passwordTextField'));

      await tester.enterText(passwordFinder, 'Password01');

      verify(
        () => loginBloc.add(
          const LoginPasswordChanged(password: 'Password01'),
        ),
      ).called(1);
    });

    testWidgets('adds LoginWithEmailAndPasswordRequested', (tester) async {
      when(() => loginBloc.state).thenReturn(
        loginBloc.state.copyWith(status: LoginStatus.valid),
      );

      await tester.pumpApp(
        const LoginScreen(),
        loginBloc: loginBloc,
      );

      final loginButtonFinder =
          find.byKey(const Key('loginScreen_loginForm_loginButton'));

      await tester.tap(loginButtonFinder);

      verify(
        () => loginBloc.add(
          const LoginWithEmailAndPasswordRequested(),
        ),
      ).called(1);
    });

    testWidgets(
      'does not add LoginWithEmailAndPasswordRequested',
      (tester) async {
        when(() => loginBloc.state).thenReturn(
          loginBloc.state.copyWith(status: LoginStatus.invalid),
        );

        await tester.pumpApp(
          const LoginScreen(),
          loginBloc: loginBloc,
        );

        final loginButtonFinder =
            find.byKey(const Key('loginScreen_loginForm_loginButton'));

        await tester.tap(loginButtonFinder);

        verifyNever(
          () => loginBloc.add(
            const LoginWithEmailAndPasswordRequested(),
          ),
        );
      },
    );

    testWidgets(
      'shows a Dialog when mockLoginBloc emits failure',
      (tester) async {
        whenListen(
          loginBloc,
          Stream.value(
            const LoginState(status: LoginStatus.failure),
          ),
        );

        await tester.pumpApp(
          const LoginScreen(),
          loginBloc: loginBloc,
        );

        await tester.pump();

        expect(find.byType(Dialog), findsOneWidget);
      },
    );

    // testWidgets('navigates to ForgotPasswordScreen', (tester) async {
    //   await tester.pumpApp(
    //     const LoginScreen(),
    //     loginBloc: loginBloc,
    //   );

    //   final forgotPasswordButtonFinder =
    //       find.byKey(const Key('loginScreen_loginForm_forgotPasswordButton'));

    //   await tester.tap(forgotPasswordButtonFinder);

    //   await tester.pump();

    //   expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    // });
  });
}
