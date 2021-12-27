import 'package:equatable/equatable.dart';
import 'package:repository/repository.dart';

class Employee extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? avatarAsset;
  final int? age;
  final String? phoneNumber;
  final String? address;
  final String? description;

  const Employee({
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

  bool get isAvatarFromNetwork => (avatarAsset ?? '').contains('http');

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

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        age,
        phoneNumber,
        address,
        description,
        avatarAsset,
      ];
}
