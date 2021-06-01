import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/widgets/profile/user_info_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../test_bench.dart';

void main() {
  User user;
  const testId = '1';
  const testFirstName = 'testFirstName';
  const testLastName = 'testLastName';
  const testEmail = 'test@email.com';
  const testURL = 'URL';
  const testAnonymous = false;
  const testAge = 20;
  const testPhoneNumber = '1234';
  const testAddress = 'address';

  setUp(() {
    final json = {
      'id': testId,
      'firstName': testFirstName,
      'lastName': testLastName,
      'email': testEmail,
      'imageUrl': testURL,
      'isAnonymous': testAnonymous,
      'age': testAge,
      'phoneNumber': testPhoneNumber,
      'address': testAddress,
    };
    user = User.fromJson(json);
  });

  testWidgets('User info section', (WidgetTester tester) async {
    await tester.pumpApp(UserInfoSection(user));

    expect(find.text(testFirstName), findsOneWidget);
    expect(find.text(testLastName), findsOneWidget);
    expect(find.text(testEmail), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });
}
