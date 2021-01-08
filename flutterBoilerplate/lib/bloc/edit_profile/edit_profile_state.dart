import 'dart:io';

abstract class EditProfileState {
  const EditProfileState();
}

class AvatarChanged extends EditProfileState {
  final File file;
  const AvatarChanged(this.file);
}

/*class LoggedOut extends EditProfileState {
  const LoggedOut();
}*/

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
