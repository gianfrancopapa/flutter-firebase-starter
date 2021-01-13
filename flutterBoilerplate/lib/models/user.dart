import 'package:flutter/material.dart';

class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatarAsset;

  const User(
      {this.id, this.firstName, this.lastName, this.email, this.avatarAsset});

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      avatarAsset: json['avatarAsset']);
}
