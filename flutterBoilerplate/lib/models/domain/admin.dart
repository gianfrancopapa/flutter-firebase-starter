import 'package:flutterBoilerplate/models/domain/user.dart';

class Admin extends User {
  const Admin({
    String id,
    String firstName,
    String lastName,
    String email,
    int age,
    String phoneNumber,
    String address,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          age: age,
          address: address,
          phoneNumber: phoneNumber,
        );

  static Admin fromJson(Map<String, dynamic> json) => Admin(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        age: json['age'],
        phoneNumber: json['phoneNumber'],
        address: json['address'],
      );
}
