import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/widgets/profile/user_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_bench.dart';

void main() {
  final user = User.fromJson({
    'id': 'testId',
    'firstName': 'testFirstName',
    'lastName': 'testLastName',
    'email': 'test@Email.com',
    'imageUrl': 'testURL',
    'isAnonymous': false,
    'age': 20,
    'phoneNumber': '098123456',
    'address': 'testAddress',
  });

  testWidgets('User info section', (WidgetTester tester) async {
    await tester.pumpApp(UserInfoSection(user));

    expect(find.text(user.firstName), findsOneWidget);
    expect(find.text(user.lastName), findsOneWidget);
    expect(find.text(user.email), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });
}
