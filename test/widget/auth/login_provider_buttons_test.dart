import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../test_bench.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

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
