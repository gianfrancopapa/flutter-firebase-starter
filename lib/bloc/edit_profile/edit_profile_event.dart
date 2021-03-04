abstract class EditProfileEvent {
  const EditProfileEvent();
}

class UpdateProfileInfo extends EditProfileEvent {}

class UploadPhotoWithCamera extends EditProfileEvent {}

class UpdatePhotoWithLibrary extends EditProfileEvent {}

class GetCurrentUser extends EditProfileEvent {
  const GetCurrentUser();
}
