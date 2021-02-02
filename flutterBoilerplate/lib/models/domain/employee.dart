import 'package:flutterBoilerplate/models/datatypes/working_area.dart';
import 'package:flutterBoilerplate/utils/enum.dart';

class Employee {
  final String id;
  String firstName;
  String lastName;
  String email;
  String avatarAsset;
  int age;
  String phoneNumber;
  String address;
  String description;
  WorkingArea workingArea;

  Employee({
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
