import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:auth/auth.dart';
import '../../helpers/test_bench.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockLoginState extends Fake implements LoginState {}

class MockLoginEvent extends Fake implements LoginEvent {}

void main() {
  LoginBloc? loginBloc;

  setUp(() {
    loginBloc = MockLoginBloc();

    when(() => loginBloc!.state).thenReturn(LoginState.initial());
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
        () => loginBloc!.add(const LoginEmailChanged(email: 'test@gmail.com')),
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
        () => loginBloc!.add(
          const LoginPasswordChanged(password: 'Password01'),
        ),
      ).called(1);
    });

    testWidgets('adds LoginWithEmailAndPasswordRequested', (tester) async {
      when(() => loginBloc!.state).thenReturn(
        loginBloc!.state.copyWith(status: LoginStatus.valid),
      );

      await tester.pumpApp(
        const LoginScreen(),
        loginBloc: loginBloc,
      );

      final loginButtonFinder =
          find.byKey(const Key('loginScreen_loginForm_loginButton'));

      await tester.tap(loginButtonFinder);

      verify(
        () => loginBloc!.add(
          const LoginWithEmailAndPasswordRequested(),
        ),
      ).called(1);
    });

    testWidgets(
      'does not add LoginWithEmailAndPasswordRequested',
      (tester) async {
        when(() => loginBloc!.state).thenReturn(
          loginBloc!.state.copyWith(status: LoginStatus.invalid),
        );

        await tester.pumpApp(
          const LoginScreen(),
          loginBloc: loginBloc,
        );

        final loginButtonFinder =
            find.byKey(const Key('loginScreen_loginForm_loginButton'));

        await tester.tap(loginButtonFinder);

        verifyNever(
          () => loginBloc!.add(
            const LoginWithEmailAndPasswordRequested(),
          ),
        );
      },
    );

    testWidgets(
      'adds LoginWithSocialMediaRequested with Google',
      (tester) async {
        await tester.pumpApp(
          const LoginScreen(),
          loginBloc: loginBloc,
        );

        final loginWithGoogleButtonFinder = find
            .byKey(const Key('loginScreen_loginForm_loginWithGoogleButton'));

        await tester.tap(loginWithGoogleButtonFinder);

        verify(
          () => loginBloc!.add(
            const LoginWithSocialMediaRequested(
              method: SocialMediaMethod.google,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'adds LoginWithSocialMediaRequested with Facebook',
      (tester) async {
        await tester.pumpApp(
          const LoginScreen(),
          loginBloc: loginBloc,
        );

        final loginWithFacebookButtonFinder = find.byKey(
          const Key('loginScreen_loginForm_loginWithFacebookButton'),
        );

        await tester.tap(loginWithFacebookButtonFinder);

        verify(
          () => loginBloc!.add(
            const LoginWithSocialMediaRequested(
              method: SocialMediaMethod.facebook,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'adds LoginWithSocialMediaRequested with Apple',
      (tester) async {
        await tester.pumpApp(
          const LoginScreen(),
          loginBloc: loginBloc,
        );

        final loginWithAppleButtonFinder =
            find.byKey(const Key('loginScreen_loginForm_loginWithAppleButton'));

        await tester.ensureVisible(loginWithAppleButtonFinder);

        await tester.tap(loginWithAppleButtonFinder);

        verify(
          () => loginBloc!.add(
            const LoginWithSocialMediaRequested(
              method: SocialMediaMethod.apple,
            ),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'adds LoginAnonymouslyRequested',
      (tester) async {
        await tester.pumpApp(
          const LoginScreen(),
          loginBloc: loginBloc,
        );

        final loginAnonymouslyButtonFinder = find.byKey(
          const Key('loginScreen_loginForm_loginAnonymouslyButton'),
        );

        await tester.ensureVisible(loginAnonymouslyButtonFinder);

        await tester.tap(loginAnonymouslyButtonFinder);

        verify(() => loginBloc!.add(const LoginAnonymouslyRequested()))
            .called(1);
      },
    );

    testWidgets(
      'shows a Dialog when mockLoginBloc emits failure',
      (tester) async {
        whenListen(
          loginBloc!,
          Stream.value(
            LoginState.initial().copyWith(status: LoginStatus.failure),
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
