import 'package:firebasestarter/models/employee.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repository/repository.dart';

void main() {
  const testId = '1';
  const testFirstName = 'A';
  const testLastName = 'Test';
  const testEmail = 'test@email.com';
  const testAge = 20;
  const testPhoneNumber = '1234';
  const testAddress = 'address';
  const testDescription = 'testDescription';
  const testAvatar = 'testAvatar';
  Employee employee;

  void testEmployee(Employee employee) {
    expect(employee.id, testId);
    expect(employee.firstName, testFirstName);
    expect(employee.lastName, testLastName);
    expect(employee.email, testEmail);
    expect(employee.age, testAge);
    expect(employee.phoneNumber, testPhoneNumber);
    expect(employee.address, testAddress);
    expect(employee.description, testDescription);
    expect(employee.avatarAsset, testAvatar);
  }

  void testJSON(Map<String, dynamic> json) {
    expect(json['firstName'], testFirstName);
    expect(json['lastName'], testLastName);
    expect(json['email'], testEmail);
    expect(json['age'], testAge);
    expect(json['phoneNumber'], testPhoneNumber);
    expect(json['address'], testAddress);
    expect(json['description'], testDescription);
    expect(json['avatarAsset'], testAvatar);
  }

  group('Employee class', () {
    setUp(() {
      employee = Employee(
        id: testId,
        firstName: testFirstName,
        lastName: testLastName,
        email: testEmail,
        avatarAsset: testAvatar,
        age: testAge,
        phoneNumber: testPhoneNumber,
        address: testAddress,
        description: testDescription,
      );
    });

    test('constructor', () {
      testEmployee(employee);
    });

    test('from JSON', () {
      const employeeJSON = {
        'id': testId,
        'firstName': testFirstName,
        'lastName': testLastName,
        'email': testEmail,
        'age': testAge,
        'phoneNumber': testPhoneNumber,
        'address': testAddress,
        'description': testDescription,
        'avatarAsset': testAvatar
      };

      final employeeEntity = EmployeeEntity.fromJson(employeeJSON);

      final employee = Employee.fromEntity(employeeEntity);

      testEmployee(employee);
    });

    test('toJSON', () {
      final employeeJSON = employee.toEntity().toJson();
      testJSON(employeeJSON);
    });
  });
}
