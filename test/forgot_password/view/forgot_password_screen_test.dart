import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/forgot_password/forgot_password.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_bench.dart';

class MockForgotPasswordBloc
    extends MockBloc<ForgotPasswordEvent, ForgotPasswordState>
    implements ForgotPasswordBloc {}

class MockForgotPasswordEvent extends Fake implements ForgotPasswordEvent {}

class MockForgotPasswordState extends Fake implements ForgotPasswordState {}

void main() {
  group('ForgotPasswordScreen', () {
    late ForgotPasswordBloc mockForgotPasswordBloc;

    setUp(() {
      mockForgotPasswordBloc = MockForgotPasswordBloc();

      when(() => mockForgotPasswordBloc.state)
          .thenReturn(ForgotPasswordState.initial());
    });

    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockForgotPasswordBloc,
          child: const ForgotPasswordScreen(),
        ),
      );

      expect(
        find.byKey(const Key('forgotPasswordScreen_form_emailTextField')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('forgotPasswordScreen_form_forgotPasswordButton')),
        findsOneWidget,
      );
    });

    testWidgets('adds ForgotPasswordEmailChanged', (tester) async {
      const email = 'test@gmail.com';

      await tester.pumpApp(
        BlocProvider.value(
          value: mockForgotPasswordBloc,
          child: const ForgotPasswordScreen(),
        ),
      );

      final emailTextFieldFinder =
          find.byKey(const Key('forgotPasswordScreen_form_emailTextField'));

      await tester.enterText(emailTextFieldFinder, email);

      verify(
        () => mockForgotPasswordBloc
            .add(const ForgotPasswordEmailChanged(email: email)),
      ).called(1);
    });

    testWidgets(
      'adds ForgotPasswordResetRequested '
      'when email is valid',
      (tester) async {
        when(() => mockForgotPasswordBloc.state).thenReturn(
          ForgotPasswordState(
            status: ForgotPasswordStatus.valid,
            email: Email.dirty('test@gmail.com'),
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: mockForgotPasswordBloc,
            child: const ForgotPasswordScreen(),
          ),
        );

        final forgotPasswordTextButton = find
            .byKey(const Key('forgotPasswordScreen_form_forgotPasswordButton'));

        await tester.tap(forgotPasswordTextButton);

        verify(
          () =>
              mockForgotPasswordBloc.add(const ForgotPasswordResetRequested()),
        ).called(1);
      },
    );

    testWidgets(
      'does not add ForgotPasswordResetRequested '
      'when email is invalid',
      (tester) async {
        when(() => mockForgotPasswordBloc.state).thenReturn(
          ForgotPasswordState(
            status: ForgotPasswordStatus.invalid,
            email: Email.dirty('test'),
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: mockForgotPasswordBloc,
            child: const ForgotPasswordScreen(),
          ),
        );

        final forgotPasswordTextButton = find
            .byKey(const Key('forgotPasswordScreen_form_forgotPasswordButton'));

        await tester.tap(forgotPasswordTextButton);

        verifyNever(
          () =>
              mockForgotPasswordBloc.add(const ForgotPasswordResetRequested()),
        );
      },
    );

    testWidgets(
      'shows a Dialog when ForgotPasswordBloc emits [success]',
      (tester) async {
        whenListen(
          mockForgotPasswordBloc,
          Stream.value(
            ForgotPasswordState(
              status: ForgotPasswordStatus.success,
              email: Email.dirty('test@gmail.com'),
            ),
          ),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: mockForgotPasswordBloc,
            child: const ForgotPasswordScreen(),
          ),
        );

        await tester.pump();

        expect(find.byType(Dialog), findsOneWidget);
      },
    );
  });
}
