import 'package:flutterBoilerplate/models/datatypes/working_area.dart';

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatarAsset;
  final int age;
  final String phoneNumber;
  final String address;
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
  });

  static Employee fromJson(Map<String, dynamic> json) => Employee(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        age: json['age'],
        phoneNumber: json['phoneNumber'],
        address: json['address'],
        workingArea: _determineWorkingArea(
          json['workingArea'],
        ),
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
      };

  static WorkingArea _determineWorkingArea(String workingArea) {
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
      default:
        throw 'Error: Invalid working area. [Employee.fromJson]';
    }
  }

  String getWorkingArea() {
    switch (workingArea) {
      case WorkingArea.CTO:
        return 'CTO';
      case WorkingArea.COO:
        return 'COO';
      case WorkingArea.CEO:
        return 'CEO';
      case WorkingArea.Development:
        return 'Development';
      case WorkingArea.Marketing:
        return 'Marketing';
      case WorkingArea.RRHH:
        return 'RRHH';
      default:
        throw 'Error: Invalid working area. [Employee.getWorkingArea]';
    }
  }
}
