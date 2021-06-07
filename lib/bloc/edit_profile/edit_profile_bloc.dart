import 'dart:io';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:firebasestarter/bloc/forms/edit_profile_form.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/services/image_picker/image_service.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  static const _errEvent = 'Error: Invalid event in [edit_profile_bloc.dart]';
  AuthService _authService;
  StorageService _storageService;
  ImageService _imageService;
  PickedFile _pickedPhoto;
  EditProfileFormBloc form;
  UserBloc userBloc;

  EditProfileBloc(this.userBloc,
      [AuthService auth,
      StorageService storage,
      ImageService image,
      EditProfileFormBloc formBloc,
      PickedFile fakePhoto])
      : super(const EditProfileState()) {
    _authService = auth ?? GetIt.I.get<AuthService>();
    _storageService = storage ?? GetIt.I.get<StorageService>();
    _imageService = image ?? GetIt.I.get<ImageService>();
    form = formBloc ?? EditProfileFormBloc();
    _pickedPhoto = fakePhoto ?? null;
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    switch (event.runtimeType) {
      case PhotoWithCameraUploaded:
        yield* _mapPhotoUploadedToState(_imageService.imgFromCamera);
        break;
      case PhotoWithLibraryUpdated:
        yield* _mapPhotoUploadedToState(_imageService.imgFromGallery);
        break;
      case ProfileInfoUpdated:
        yield* _mapProfileInfoUpdatedToState();
        break;
      case CurrentUserLoaded:
        yield* _mapCurrentUserLoadedToState();
        break;
      default:
        yield state.copyWith(
            status: EditProfileStatus.failure, errorMessage: _errEvent);
    }
  }

  Stream<EditProfileState> _mapCurrentUserLoadedToState() async* {
    yield state.copyWith(status: EditProfileStatus.inProgress);
    try {
      final user = await _authService.currentUser();
      form.onFirstNameChanged(user.firstName);
      form.onLastNameChanged(user.lastName);
      yield state.copyWith(
        status: EditProfileStatus.currentUser,
        user: user,
      );
      _pickedPhoto = PickedFile(user.imageUrl);
      yield state.copyWith(
        status: EditProfileStatus.avatarSuccess,
        image: user.imageUrl,
      );
    } catch (e) {
      yield state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: 'Error: Something went wrong',
      );
    }
  }

  Stream<EditProfileState> _mapPhotoUploadedToState(
    Future<PickedFile> Function() uploadMethod,
  ) async* {
    try {
      final image = await uploadMethod();
      if (image == null) {
        yield state.copyWith(
          status: EditProfileStatus.failure,
          errorMessage: 'Error: Insert valid image',
        );
        return;
      }
      _pickedPhoto = image;
      yield state.copyWith(
        status: EditProfileStatus.avatarSuccess,
        image: _pickedPhoto.path,
      );
    } catch (err) {
      yield state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: err,
      );
    }
  }

  Future<void> _uploadProfilePicture(User user) async {
    try {
      if (_pickedPhoto == null) throw 'Error: Invalid photo';
      final extension = _pickedPhoto.path.split('.').last;
      final path = '/users/${user.id}.${extension}';
      final file = File(_pickedPhoto.path);
      await _storageService.uploadFile(file, path);
      final imageURL = await _storageService.downloadURL(path);
      await _authService.changeProfile(photoURL: imageURL);
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<EditProfileState> _mapProfileInfoUpdatedToState() async* {
    yield state.copyWith(status: EditProfileStatus.inProgress);
    try {
      final user = await _authService.currentUser();
      if (user.firstName == form.firstNameVal &&
          user.lastName == form.lastNameVal &&
          (_pickedPhoto == null || user.imageUrl == _pickedPhoto.path)) {
        yield state.copyWith(status: EditProfileStatus.profileSuccess);
        return;
      }
      if (user.imageUrl != _pickedPhoto.path) {
        await _uploadProfilePicture(user);
      }
      await _authService.changeProfile(
        firstName: form.firstNameVal,
        lastName: form.lastNameVal,
      );
      yield state.copyWith(status: EditProfileStatus.profileSuccess);
      userBloc.add(const UserLoaded());
      yield state.copyWith(
        status: EditProfileStatus.avatarSuccess,
        image: user.imageUrl,
      );
    } catch (error) {
      yield state.copyWith(
        status: EditProfileStatus.failure,
        errorMessage: error,
      );
    }
  }
}
