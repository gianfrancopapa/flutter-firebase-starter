import 'package:repository/repository.dart';

class Employee {
  String id;
  String firstName;
  String lastName;
  String email;
  String avatarAsset;
  int age;
  String phoneNumber;
  String address;
  String description;

  Employee({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avatarAsset,
    this.age,
    this.phoneNumber,
    this.address,
    this.description,
  });

  static Employee fromEntity(EmployeeEntity entity) => Employee(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        email: entity.email,
        age: entity.age,
        phoneNumber: entity.phoneNumber,
        address: entity.address,
        description: entity.description,
        avatarAsset: entity.avatarAsset,
      );

  EmployeeEntity toEntity() => EmployeeEntity(
        id: id,
        firstName: firstName,
        lastName: lastName,
        email: email,
        age: age,
        phoneNumber: phoneNumber,
        address: address,
        description: description,
        avatarAsset: avatarAsset,
      );
}
