import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/widgets/auth/login_provider_buttons_section.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../test_bench.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/login_provider_button_mocks.dart';

void main() {
  group('LoginProviderButtonsSection', () {
    LoginBloc loginBloc;

    setUp(() {
      loginBloc = MockLoginBloc();
    });

    testWidgets('Auth service button text renders', (tester) async {
      await tester.pumpApp(
        Material(
          child: BlocProvider.value(
            value: loginBloc,
            child: const LoginProviderButtonsSection(),
          ),
        ),
      );

      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.text('Sign in with Facebook'), findsOneWidget);
      expect(find.text('Sign in with Apple ID'), findsOneWidget);
      expect(find.text('Sign in anonymously'), findsOneWidget);
    });
  });
}
