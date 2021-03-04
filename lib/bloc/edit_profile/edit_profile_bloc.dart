import 'dart:io';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:firebasestarter/bloc/forms/edit_profile_form.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/services/image_picker/image_service.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileBloc extends EditProfileFormBloc {
  AuthService _authService;
  StorageService _storageService;
  ImageService _imageService;

  EditProfileBloc() {
    _authService = GetIt.I.get<AuthService>();
    _storageService = GetIt.I.get<StorageService>();
    _imageService = GetIt.I.get<ImageService>();
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    switch (event.runtimeType) {
      case UploadPhotoWithCamera:
        yield* _uploadProfilePicture(_imageService.imgFromCamera);
        break;
      case UpdatePhotoWithLibrary:
        yield* _uploadProfilePicture(_imageService.imgFromGallery);
        break;
      case UpdateProfileInfo:
        yield* _updateProfile();
        break;
      default:
        yield const Error('Undetermined event');
    }
  }

  Stream<EditProfileState> _uploadProfilePicture(
      Future<PickedFile> Function() uploadMethod) async* {
    yield const Loading();
    try {
      final user = await _authService.currentUser();
      final image = await uploadMethod();
      if (image == null) {
        yield const Error('Insert valid image');
        return;
      }
      final extension = image.path.split('.').last;
      final path = '/users/${user.id}.${extension}';
      final file = File(image.path);
      await _storageService.uploadFile(file, path);
      final imageURL = await _storageService.downloadURL(path);
      await _authService.changeProfile(photoURL: imageURL);
      yield AvatarChanged(imageURL);
    } catch (e) {
      yield const Error('Something went wrong');
    }
  }

  Stream<EditProfileState> _updateProfile() async* {
    yield const Loading();
    try {
      await _authService.changeProfile(
        firstName: firstNameController.value,
        lastName: lastNameController.value,
      );
      yield const ProfileEdited();
    } catch (e) {
      yield Error(e);
    }
  }
}
