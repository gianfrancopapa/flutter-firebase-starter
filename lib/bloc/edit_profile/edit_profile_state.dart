import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';

enum EditProfileStatus {
  initial,
  inProgress,
  profileSuccess,
  avatarSuccess,
  failure,
  currentUser
}

class EditProfileState extends Equatable {
  final EditProfileStatus status;
  final String image;
  final String errorMessage;
  final User user;
  final bool formIsValid;

  const EditProfileState({
    EditProfileStatus this.status = EditProfileStatus.initial,
    String this.image,
    String this.errorMessage,
    User this.user,
    bool this.formIsValid = true,
  }) : assert(status != null);

  EditProfileState copyWith(
      {EditProfileStatus status,
      String image,
      String errorMessage,
      User user,
      bool formIsValid}) {
    return EditProfileState(
      status: status ?? this.status,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      formIsValid: formIsValid ?? this.formIsValid,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, image, user, formIsValid];
}
