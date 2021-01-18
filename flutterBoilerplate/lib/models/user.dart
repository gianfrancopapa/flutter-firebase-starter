import 'package:flutterBoilerplate/models/admin.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatarAsset;
  final int age;
  final String phoneNumber;
  final String address;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.avatarAsset,
    this.age,
    this.phoneNumber,
    this.address,
  });

  static User fromJson(Map<String, dynamic> json) => json['role'] == 'admin'
      ? Admin.fromJson(json)
      : User(
          id: json['id'],
          firstName: json['firstName'],
          lastName: json['lastName'],
          email: json['email'],
          avatarAsset: json['avatarAsset'],
          age: json['age'],
          phoneNumber: json['phoneNumber'],
          address: json['address'],
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
      };
}
