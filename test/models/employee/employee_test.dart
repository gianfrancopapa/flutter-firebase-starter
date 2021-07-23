import 'package:firebasestarter/models/employee.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repository/repository.dart';

void main() {
  const employee = Employee(
    id: '1',
    firstName: 'A',
    lastName: 'Test',
    email: 'test@email.com',
    avatarAsset: 'testAvatar',
    age: 20,
    phoneNumber: '1234',
    address: 'address',
    description: 'testDescription',
  );

  void testEmployee(Employee employeeToTest) {
    expect(employeeToTest.id, employee.id);
    expect(employeeToTest.firstName, employee.firstName);
    expect(employeeToTest.lastName, employee.lastName);
    expect(employeeToTest.email, employee.email);
    expect(employeeToTest.age, employee.age);
    expect(employeeToTest.phoneNumber, employee.phoneNumber);
    expect(employeeToTest.address, employee.address);
    expect(employeeToTest.description, employee.description);
    expect(employeeToTest.avatarAsset, employee.avatarAsset);
  }

  void testJSON(Map<String, dynamic> json) {
    expect(json['firstName'], employee.firstName);
    expect(json['lastName'], employee.lastName);
    expect(json['email'], employee.email);
    expect(json['age'], employee.age);
    expect(json['phoneNumber'], employee.phoneNumber);
    expect(json['address'], employee.address);
    expect(json['description'], employee.description);
    expect(json['avatarAsset'], employee.avatarAsset);
  }

  group('Employee', () {
    test('constructor', () {
      testEmployee(employee);
    });

    test('fromJson', () {
      final employeeJSON = {
        'id': employee.id,
        'firstName': employee.firstName,
        'lastName': employee.lastName,
        'email': employee.email,
        'age': employee.age,
        'phoneNumber': employee.phoneNumber,
        'address': employee.address,
        'description': employee.description,
        'avatarAsset': employee.avatarAsset
      };

      final employeeEntity = EmployeeEntity.fromJson(employeeJSON);

      final resultEmployee = Employee.fromEntity(employeeEntity);

      testEmployee(resultEmployee);
    });

    test('toJson', () {
      final employeeJSON = employee.toEntity().toJson();

      testJSON(employeeJSON);
    });
  });
}
