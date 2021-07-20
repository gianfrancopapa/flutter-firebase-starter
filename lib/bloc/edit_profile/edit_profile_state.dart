part of 'edit_profile_bloc.dart';

enum EditProfileStatus {
  initial,
  loading,
  profileSuccess,
  avatarSuccess,
  failure,
  valid,
  invalid,
}

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final User user;
  final FirstName firstName;
  final LastName lastName;
  final PickedFile image;

  const EditProfileState({
    @required EditProfileStatus this.status,
    this.user,
    this.firstName,
    this.lastName,
    this.image,
  }) : assert(status != null);

  EditProfileState copyWith({
    EditProfileStatus status,
    User user,
    FirstName firstName,
    LastName lastName,
    PickedFile image,
  }) {
    return EditProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      image: image ?? this.image,
    );
  }

  @override
  List<Object> get props => [status, user, firstName, lastName, image];
}
