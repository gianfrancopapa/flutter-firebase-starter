part of 'edit_profile_bloc.dart';

enum EditProfileStatus {
  initial,
  loading,
  success,
  failure,
  valid,
  invalid,
}

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final User? user;
  final FirstName? firstName;
  final LastName? lastName;
  final String? imageURL;

  const EditProfileState({
    required this.status,
    this.user,
    this.firstName,
    this.lastName,
    this.imageURL,
  });

  EditProfileState copyWith({
    EditProfileStatus? status,
    User? user,
    FirstName? firstName,
    LastName? lastName,
    String? imageURL,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      imageURL: imageURL ?? this.imageURL,
    );
  }

  @override
  List<Object?> get props => [status, user, firstName, lastName, imageURL];
}
