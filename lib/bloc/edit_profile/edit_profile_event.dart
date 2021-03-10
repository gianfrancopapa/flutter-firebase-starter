abstract class EditProfileEvent {
  const EditProfileEvent();
}

class ProfileInfoUpdated extends EditProfileEvent {}

class PhotoWithCameraUploaded extends EditProfileEvent {}

class PhotoWithLibraryUpdated extends EditProfileEvent {}

class CurrentUserLoaded extends EditProfileEvent {
  const CurrentUserLoaded();
}
