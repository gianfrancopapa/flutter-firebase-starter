import 'package:flutterBoilerplate/models/user.dart';

class Admin extends User {
  const Admin({
    String id,
    String firstName,
    String lastName,
    String email,
  }) : super(
          id: id,
          firstName: firstName,
          lastName: lastName,
          email: email,
        );

  static Admin fromJson(Map<String, dynamic> json) => Admin(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
      );
}
