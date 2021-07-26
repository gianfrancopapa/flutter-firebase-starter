import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth.dart';
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
    if (event is EditProfileUserRequested) {
      yield* _mapEditProfileUserRequestedToState();
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

  Stream<EditProfileState> _mapEditProfileUserRequestedToState() async* {
    yield state.copyWith(status: EditProfileStatus.loading);

    try {
      final user = await _authService.currentUser();

      final firstName = FirstName.dirty(user.firstName);
      final lastName = LastName.dirty(user.lastName);
      final image = user.imageUrl;

      yield state.copyWith(
        user: user,
        firstName: firstName,
        lastName: lastName,
        imageURL: image,
        status:
            _status(firstName: firstName, lastName: lastName, imageURL: image),
      );
    } on Exception {
      yield state.copyWith(status: EditProfileStatus.failure);
    }
  }

  Stream<EditProfileState> _mapEditProfileFirstNameChangedToState(
    EditProfileFirstNameChanged event,
  ) async* {
    final firstName = FirstName.dirty(event.firstName);

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

      final file = await uploadMethod();

      if (file == null) {
        yield state.copyWith(status: EditProfileStatus.failure);
        return;
      }

      yield state.copyWith(
        imageURL: file.path,
        status: _status(imageURL: file.path),
      );
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
          (state.imageURL == null || user.imageUrl == state.imageURL)) {
        yield state.copyWith(status: EditProfileStatus.success);
        return;
      }

      final updatedUser = await _updateProfile(
        user: user,
        imageUrl: state.imageURL,
        firstName: state.firstName.value,
        lastName: state.lastName.value,
      );

      yield state.copyWith(
        status: EditProfileStatus.success,
        user: updatedUser,
        imageURL: updatedUser.imageUrl,
      );
    } on Exception {
      yield state.copyWith(status: EditProfileStatus.failure);
    }
  }

  //TODO: This should not be here
  Future<User> _updateProfile({
    @required User user,
    String imageUrl = '',
    String firstName = '',
    String lastName = '',
  }) async {
    assert(user != null);

    try {
      final needToUpdateImage =
          imageUrl != null && imageUrl.isNotEmpty && imageUrl != user.imageUrl;

      final needToUpdateDisplayName =
          (firstName.isNotEmpty || lastName.isNotEmpty) &&
              (firstName != user.firstName || lastName != user.firstName);

      if (needToUpdateImage) {
        final extension = imageUrl.split('.').last;
        final path = '/users/${user.id}.${extension}';
        final file = File(imageUrl);

        await _storageService.uploadFile(file, path);
        final photoURL = await _storageService.downloadURL(path);

        await _authService.changeProfile(
          photoURL: photoURL,
          firstName: firstName.isEmpty ? user.firstName : firstName,
          lastName: lastName.isEmpty ? user.lastName : lastName,
        );
      } else if (needToUpdateDisplayName) {
        await _authService.changeProfile(
          firstName: firstName.isEmpty ? user.firstName : firstName,
          lastName: lastName.isEmpty ? user.lastName : lastName,
        );
      }

      if (needToUpdateImage || needToUpdateDisplayName) {
        return await _authService.currentUser();
      }

      return user;
    } on Exception {
      throw Exception('Error: Something went wrong.');
    }
  }

  EditProfileStatus _status({
    FirstName firstName,
    LastName lastName,
    String imageURL,
  }) {
    final _firstName = firstName ?? state.firstName;
    final _lastName = lastName ?? state.lastName;
    final _image = imageURL ?? state.imageURL;

    if (_firstName.valid && _lastName.valid && _image != null) {
      return EditProfileStatus.valid;
    }

    return EditProfileStatus.invalid;
  }
}
