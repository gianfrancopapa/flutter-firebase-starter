import 'package:firebasestarter/widgets/auth/login_provider_buttons_section.dart';
import '../test_bench.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mocks/login_provider_button_mocks.dart';

void main() {
  testWidgets('Auth service button text', (WidgetTester tester) async {
    final loginBlocMock = MockLoginBloc();
    await tester.pumpApp(Material(
      child: LoginProviderButtonsSection(loginBlocMock),
    ));

    await tester.pump();
    expect(find.text('Sign in with Google'), findsOneWidget);
    expect(find.text('Sign in with Facebook'), findsOneWidget);
    expect(find.text('Sign in with Apple ID'), findsOneWidget);
    expect(find.text('Sign in anonymously'), findsOneWidget);
  });
}
