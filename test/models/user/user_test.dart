import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

const testId = '1';
const testFirstName = 'A';
const testLastName = 'Test';
const testEmail = 'test@email.com';
const testURL = 'URL';

void testUser(User user) {
  expect(user.id, testId);
  expect(user.firstName, testFirstName);
  expect(user.lastName, testLastName);
  expect(user.email, testEmail);
  expect(user.imageUrl, testURL);
}

void testJSON(Map<String, dynamic> json) {
  expect(json['firstName'], testFirstName);
  expect(json['lastName'], testLastName);
  expect(json['email'], testEmail);
}

User createUser() {
  return const User(
    id: testId,
    firstName: testFirstName,
    lastName: testLastName,
    email: testEmail,
    imageUrl: testURL,
  );
}

void main() {
  group('User', () {
    test('constructor', () {
      final user = createUser();

      testUser(user);
    });

    test('fromJson', () {
      const userJSON = <String, dynamic>{
        'id': testId,
        'firstName': testFirstName,
        'lastName': testLastName,
        'email': testEmail,
        'imageUrl': testURL,
      };

      final user = User.fromJson(userJSON);

      testUser(user);
    });

    test('toJson', () {
      final user = createUser();
      final userJSON = user.toJson();

      testJSON(userJSON);
    });
  });
}
