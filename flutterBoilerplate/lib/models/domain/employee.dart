import 'package:flutterBoilerplate/models/datatypes/working_area.dart';
import 'package:flutterBoilerplate/utils/enum.dart';

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatarAsset;
  final int age;
  final String phoneNumber;
  final String address;
  final String description;
  final WorkingArea workingArea;

  const Employee({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avatarAsset,
    this.age,
    this.phoneNumber,
    this.address,
    this.workingArea,
    this.description,
  });

  static Employee fromJson(Map<String, dynamic> json) => Employee(
        id: json['id'],
        firstName: json['firstName'] ?? 'Gonzalo',
        lastName: json['lastName'] ?? 'LastName',
        email: json['email'] ?? 'employee@somnio.com',
        age: json['age'] ?? 18,
        phoneNumber: json['phoneNumber'] ?? '99999999',
        address: json['address'] ?? 'Address',
        workingArea: determineWorkingArea(json['workingArea']),
        description: json['description'] ?? '-',
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'avatarAsset': avatarAsset,
        'role': 'user',
        'age': age,
        'address': address,
        'phoneNumber': phoneNumber,
        'workingArea': getWorkingArea(),
        'description': description,
      };

  static WorkingArea determineWorkingArea(String workingArea) {
    switch (workingArea.toUpperCase()) {
      case 'CTO':
        return WorkingArea.CTO;
      case 'COO':
        return WorkingArea.COO;
      case 'CEO':
        return WorkingArea.CEO;
      case 'DEVELOPMENT':
        return WorkingArea.Development;
      case 'MARKETING':
        return WorkingArea.Marketing;
      case 'DESIGN':
        return WorkingArea.Design;
      case 'RRHH':
        return WorkingArea.RRHH;
      case 'OTHER':
        return WorkingArea.Other;
      case 'DESIGN':
        return WorkingArea.Design;
      default:
        throw 'Error: Invalid working area. [Employee.fromJson]';
    }
  }

  String getWorkingArea() => Enum.getEnumValue(workingArea);
}
