import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? imageUrl;

  const User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.imageUrl,
  });

  static const empty = User(
    id: '-1',
    firstName: null,
    lastName: null,
    email: null,
    imageUrl: null,
  );

  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        imageUrl: json['imageUrl'],
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      };

  static User fromEntity(UserEntity entity) => User(
        id: entity.id,
        firstName: entity.firstName,
        lastName: entity.lastName,
        email: entity.email,
        imageUrl: entity.imageUrl,
      );

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        imageUrl,
      ];

  @override
  bool get stringify => false;
}
