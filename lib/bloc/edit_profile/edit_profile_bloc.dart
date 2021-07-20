import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/bloc/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth_service.dart';
import 'package:firebasestarter/services/image_picker/image_service.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc({
    @required AuthService authService,
    @required StorageService storageService,
    @required ImageService imageService,
  })  : assert(authService != null),
        assert(storageService != null),
        assert(imageService != null),
        _authService = authService,
        _storageService = storageService,
        _imageService = imageService,
        super(
          EditProfileState(
            status: EditProfileStatus.initial,
            firstName: FirstName.pure(),
            lastName: LastName.pure(),
          ),
        );

  final AuthService _authService;
  final StorageService _storageService;
  final ImageService _imageService;

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditProfileCurrentUserLoaded) {
      yield* _mapEditProfileCurrentUserLoadedToState();
    } else if (event is EditProfileFirstNameChanged) {
      yield* _mapEditProfileFirstNameChangedToState(event);
    } else if (event is EditProfileLastNameChanged) {
      yield* _mapEditProfileLastNameChangedToState(event);
    } else if (event is EditProfilePhotoUpdated) {
      yield* _mapEditProfilePhotoUpdatedToState(event);
    } else if (event is EditProfileInfoUpdated) {
      yield* _mapEditProfileInfoUpdatedToState(event);
    }
  }

  Stream<EditProfileState> _mapEditProfileCurrentUserLoadedToState() async* {
    yield state.copyWith(status: EditProfileStatus.loading);

    try {
      final user = await _authService.currentUser();

      final firstName = FirstName.dirty(user.firstName);
      final lastName = LastName.dirty(user.lastName);
      final image = PickedFile(user.imageUrl);

      yield state.copyWith(
        status: _status(firstName: firstName, lastName: lastName, image: image),
        user: user,
        firstName: firstName,
        lastName: lastName,
        image: image,
      );
    } on Exception {
      yield state.copyWith(status: EditProfileStatus.failure);
    }
  }

  Stream<EditProfileState> _mapEditProfileFirstNameChangedToState(
    EditProfileFirstNameChanged event,
  ) async* {
    final firstName = FirstName.dirty(event.name);

    yield state.copyWith(
      firstName: firstName,
      status: _status(firstName: firstName),
    );
  }

  Stream<EditProfileState> _mapEditProfileLastNameChangedToState(
    EditProfileLastNameChanged event,
  ) async* {
    final lastName = LastName.dirty(event.lastName);

    yield state.copyWith(
      lastName: lastName,
      status: _status(lastName: lastName),
    );
  }

  Stream<EditProfileState> _mapEditProfilePhotoUpdatedToState(
    EditProfilePhotoUpdated event,
  ) async* {
    try {
      Future<PickedFile> Function() uploadMethod;

      if (event.method == PhotoUploadMethod.CAMERA) {
        uploadMethod = _imageService.imgFromCamera;
      } else {
        uploadMethod = _imageService.imgFromGallery;
      }

      final image = await uploadMethod();

      if (image == null) {
        yield state.copyWith(status: EditProfileStatus.failure);
        return;
      }

      yield state.copyWith(image: image, status: _status(image: image));
    } on Exception {
      yield state.copyWith(status: EditProfileStatus.failure);
    }
  }

  Stream<EditProfileState> _mapEditProfileInfoUpdatedToState(
    EditProfileInfoUpdated event,
  ) async* {
    yield state.copyWith(status: EditProfileStatus.loading);

    try {
      final user = state.user;

      if (user.firstName == state.firstName.value &&
          user.lastName == state.lastName.value &&
          (state.image == null || user.imageUrl == state.image.path)) {
        yield state.copyWith(status: EditProfileStatus.profileSuccess);
        return;
      }

      if (user.imageUrl != state.image.path) {
        await _uploadProfilePicture(user);
      }

      await _authService.changeProfile(
        firstName: state.firstName.value,
        lastName: state.lastName.value,
      );

      final updatedUser = await _authService.currentUser();

      yield state.copyWith(
        status: EditProfileStatus.profileSuccess,
        user: updatedUser,
        image: PickedFile(updatedUser.imageUrl),
      );
    } on Exception {
      yield state.copyWith(status: EditProfileStatus.failure);
    }
  }

  //TODO: This should not be here
  Future<void> _uploadProfilePicture(User user) async {
    try {
      if (state.image == null) throw 'Error: Invalid photo';

      final extension = state.image.path.split('.').last;
      final path = '/users/${user.id}.${extension}';
      final file = File(state.image.path);

      await _storageService.uploadFile(file, path);
      final imageURL = await _storageService.downloadURL(path);
      await _authService.changeProfile(photoURL: imageURL);
    } catch (e) {
      throw e.toString();
    }
  }

  EditProfileStatus _status({
    FirstName firstName,
    LastName lastName,
    PickedFile image,
  }) {
    final _firstName = firstName ?? state.firstName;
    final _lastName = lastName ?? state.lastName;
    final _image = image ?? state.image;

    if (!_firstName.valid || !_lastName.valid || _image == null) {
      return EditProfileStatus.invalid;
    }

    return EditProfileStatus.valid;
  }
}
