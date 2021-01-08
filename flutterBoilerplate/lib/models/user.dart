import 'dart:io';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final File avatar;

  const User({this.id, this.firstName, this.lastName, this.email, this.avatar});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      avatar: json['avatar']);
}
