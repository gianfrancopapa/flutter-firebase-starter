import 'package:firebasestarter/models/user.dart';

abstract class EditProfileState {
  const EditProfileState();
}

class AvatarChangeSuccess extends EditProfileState {
  final String image;
  const AvatarChangeSuccess(this.image);
}

class EditProfileSuccess extends EditProfileState {
  const EditProfileSuccess();
}

class EditProfileInitial extends EditProfileState {
  const EditProfileInitial();
}

class EditProfileFailure extends EditProfileState {
  final String message;
  const EditProfileFailure(this.message);
}

class EditProfileInProgress extends EditProfileState {
  const EditProfileInProgress();
}

class CurrentUser extends EditProfileState {
  final User user;
  const CurrentUser(this.user);
}
