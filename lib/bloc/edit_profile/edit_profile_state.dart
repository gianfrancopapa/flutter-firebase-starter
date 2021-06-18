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

  const EditProfileState({
    EditProfileStatus this.status = EditProfileStatus.initial,
    String this.image,
    String this.errorMessage,
    User this.user,
  }) : assert(status != null);

  EditProfileState copyWith(
      {EditProfileStatus status,
      String image,
      String errorMessage,
      User user,
      String firstName,
      String lastName}) {
    return EditProfileState(
      status: status ?? this.status,
      image: image ?? this.image,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object> get props => [status, errorMessage, image, user];
}
