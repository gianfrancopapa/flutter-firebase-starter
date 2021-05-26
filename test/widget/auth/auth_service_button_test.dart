import 'package:firebasestarter/widgets/auth/auth_service_button.dart';
import 'package:firebasestarter/widgets/common/test_bench.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebasestarter/constants/assets.dart';

void main() {
  testWidgets('Auth service button text', (WidgetTester tester) async {
    const widget = TestBench(
      null,
      Material(
        child: AuthServiceButton(
          text: 'testText',
          asset: Assets.googleLogo,
        ),
      ),
    );
    await tester.pumpWidget(widget);

    await tester.pump();
    expect(find.text('testText'), findsOneWidget);
  });
}
