part of auth;

class UserEntity extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String imageUrl;

  const UserEntity({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.imageUrl,
  });

  static UserEntity fromJson(Map<String, dynamic> json) => UserEntity(
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

  @override
  List<Object> get props => [id, firstName, lastName, email, imageUrl];

  @override
  bool get stringify => false;
}
