abstract class EditProfileState {
  const EditProfileState();
}

class AvatarChanged extends EditProfileState {
  final String image;
  const AvatarChanged(this.image);
}

class ProfileEdited extends EditProfileState {
  const ProfileEdited();
}

class NotDetermined extends EditProfileState {
  const NotDetermined();
}

class Error extends EditProfileState {
  final String message;
  const Error(this.message);
}

class Loading extends EditProfileState {
  const Loading();
}
