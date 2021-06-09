import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/widgets/team/employee_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Employee card text', (WidgetTester tester) async {
    const employee = Employee(
      id: 'testID',
      firstName: 'testName',
      lastName: 'testLastName',
      email: 'testEmail',
      avatarAsset: Assets.anonUser,
      age: 20,
      phoneNumber: '098123456',
      address: 'testAddress',
      description: 'testDescription',
    );

    await tester.pumpWidget(MaterialApp(home: EmployeeCard(employee)));

    await tester.pump();
    expect(find.text('testName testLastName'), findsOneWidget);
  });
}
