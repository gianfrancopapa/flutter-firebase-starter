import 'dart:io';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:firebasestarter/bloc/forms/edit_profile_form.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
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
  final form = EditProfileFormBloc();
  UserBloc userBloc;

  EditProfileBloc(this.userBloc) : super(const EditProfileInitial()) {
    _authService = GetIt.I.get<AuthService>();
    _storageService = GetIt.I.get<StorageService>();
    _imageService = GetIt.I.get<ImageService>();
  }

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    switch (event.runtimeType) {
      case PhotoWithCameraUploaded:
        yield* _updateUserPhoto(_imageService.imgFromCamera);
        break;
      case PhotoWithLibraryUpdated:
        yield* _updateUserPhoto(_imageService.imgFromGallery);
        break;
      case ProfileInfoUpdated:
        yield* _updateProfile();
        break;
      case CurrentUserLoaded:
        yield* _mapGetCurrentUserEventToState();
        break;
      default:
        yield const EditProfileFailure(_errEvent);
    }
  }

  Stream<EditProfileState> _mapGetCurrentUserEventToState() async* {
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

  Stream<EditProfileState> _updateUserPhoto(
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

  Future<void> _uploadProfilePicture() async {
    try {
      if (_pickedPhoto == null) throw 'Error: Invalid photo';
      final user = await _authService.currentUser();
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

  Stream<EditProfileState> _updateProfile() async* {
    yield const EditProfileInProgress();
    try {
      final user = await _authService.currentUser();
      if (user.firstName == form.firstNameVal &&
          user.lastName == form.lastNameVal &&
          (user.imageUrl == _pickedPhoto.path || _pickedPhoto == null)) {
        yield const EditProfileSuccess();
        return;
      }
      if (user.imageUrl != _pickedPhoto.path) {
        await _uploadProfilePicture();
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
