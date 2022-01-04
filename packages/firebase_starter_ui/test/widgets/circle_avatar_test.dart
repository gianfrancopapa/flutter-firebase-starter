// ignore_for_file: prefer_const_constructors
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FSCircleAvatar', () {
    testWidgets('renders circle avatar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: FSCircleAvatar(
              backgroundColor: FSColors.mediumLightGrey,
              child: FlutterLogo(),
            ),
          ),
        ),
      );
      expect(find.byType(FSCircleAvatar), findsOneWidget);
    });
  });
}
