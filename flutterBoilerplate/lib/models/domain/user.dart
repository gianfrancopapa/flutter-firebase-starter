import 'package:flutterBoilerplate/models/domain/admin.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final int age;
  final String phoneNumber;
  final String address;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
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
          age: json['age'],
          phoneNumber: json['phoneNumber'],
          address: json['address'],
        );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'role': 'user',
        'age': age,
        'address': address,
        'phoneNumber': phoneNumber,
      };
}
