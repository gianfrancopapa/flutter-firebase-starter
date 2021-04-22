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
      : super(const EditProfileInitial()) {
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
        yield const EditProfileFailure(_errEvent);
    }
  }

  Stream<EditProfileState> _mapCurrentUserLoadedToState() async* {
    yield const EditProfileInProgress();
    try {
      final user = await _authService.currentUser();
      form.onFirstNameChanged(user.firstName);
      form.onLastNameChanged(user.lastName);
      yield CurrentUser(user);
      _pickedPhoto = PickedFile(user.imageUrl);
      yield AvatarChangeSuccess(user.imageUrl);
    } catch (e) {
      yield const EditProfileFailure('Error: Something went wrong');
    }
  }

  Stream<EditProfileState> _mapPhotoUploadedToState(
    Future<PickedFile> Function() uploadMethod,
  ) async* {
    try {
      final image = await uploadMethod();
      if (image == null) {
        yield const EditProfileFailure('Error: Insert valid image');
        return;
      }
      _pickedPhoto = image;
      yield AvatarChangeSuccess(_pickedPhoto.path);
    } catch (err) {
      yield EditProfileFailure(err.toString());
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
    yield const EditProfileInProgress();
    try {
      final user = await _authService.currentUser();
      if (user.firstName == form.firstNameVal &&
          user.lastName == form.lastNameVal &&
          (_pickedPhoto == null || user.imageUrl == _pickedPhoto.path)) {
        yield const EditProfileSuccess();
        return;
      }
      if (user.imageUrl != _pickedPhoto.path) {
        await _uploadProfilePicture(user);
      }
      await _authService.changeProfile(
        firstName: form.firstNameVal,
        lastName: form.lastNameVal,
      );
      yield const EditProfileSuccess();
      userBloc.add(const UserLoaded());
      yield AvatarChangeSuccess(user.imageUrl);
    } catch (e) {
      yield EditProfileFailure(e);
    }
  }
}
