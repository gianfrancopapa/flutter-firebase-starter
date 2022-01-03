import 'package:auth/auth.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
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
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

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
