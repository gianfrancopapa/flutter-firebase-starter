import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

const testId = '1';
const testFirstName = 'A';
const testLastName = 'Test';
const testEmail = 'test@email.com';
const testURL = 'URL';
const testAnonymous = false;
const testAge = 20;
const testPhoneNumber = '1234';
const testAddress = 'address';

void testUser(User user) {
  expect(user.id, testId);
  expect(user.firstName, testFirstName);
  expect(user.lastName, testLastName);
  expect(user.email, testEmail);
  expect(user.imageUrl, testURL);
  expect(user.isAnonymous, testAnonymous);
  expect(user.age, testAge);
  expect(user.phoneNumber, testPhoneNumber);
  expect(user.address, testAddress);
}

void testJSON(Map<String, dynamic> json) {
  expect(json['firstName'], testFirstName);
  expect(json['lastName'], testLastName);
  expect(json['email'], testEmail);
  expect(json['age'], testAge);
  expect(json['address'], testAddress);
  expect(json['phoneNumber'], testPhoneNumber);
}

User createUser() {
  return const User(
    id: testId,
    firstName: testFirstName,
    lastName: testLastName,
    email: testEmail,
    imageUrl: testURL,
    isAnonymous: testAnonymous,
    age: testAge,
    phoneNumber: testPhoneNumber,
    address: testAddress,
  );
}

void main() {
  group('User class', () {
    test('constructor', () {
      final user = createUser();
      testUser(user);
    });
    test('from JSON', () {
      const userJSON = <String, dynamic>{
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

      final user = User.fromJson(userJSON);

      testUser(user);
    });

    test('toJSON', () {
      final user = createUser();
      final userJSON = user.toJson();

      testJSON(userJSON);
    });
  });
}
