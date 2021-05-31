import 'package:firebasestarter/widgets/auth/auth_service_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebasestarter/constants/assets.dart';
import '../test_bench.dart';

void main() {
  testWidgets('Auth service button text', (tester) async {
    await tester.pumpApp(
      const Material(
        child: AuthServiceButton(
          text: 'testText',
          asset: Assets.googleLogo,
        ),
      ),
    );

    expect(find.text('testText'), findsOneWidget);
  });
}
