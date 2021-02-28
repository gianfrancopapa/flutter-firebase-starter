import 'dart:io';
import 'package:firebasestarter/bloc/forms/edit_profile_form.dart';
import 'package:firebasestarter/models/datatypes/storage_service_type.dart';
import 'package:firebasestarter/models/service_factory.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:firebasestarter/services/auth/firebase_auth_service.dart';
import 'package:firebasestarter/services/image_picker/image_picker_service.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileBloc extends EditProfileFormBloc {
  final _authService = FirebaseAuthService();
  StorageService _storageService;
  final _serviceFactory = ServiceFactory();
  PickedFile _image;

  EditProfileBloc() : super() {
    _serviceFactory
        .getStorageService(StorageServiceType.Firebase)
        .then((value) => _storageService);
  }

  Future<void> pickImageFromCamera() async {
    emit(const Loading());
    _image = await PickImageService.imgFromCamera();
    if (_image == null) {
      return emit(const Error('Insert valid image'));
    }
    try {
      final user = await _authService.currentUser();
      final userId = user.id;
      await _storageService.uploadFile(File(_image.path), userId);
      final imageURL = await _storageService.downloadURL(userId);
      await _authService.changeProfile(photoURL: imageURL);
      emit(AvatarChanged(imageURL));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<String> getURL() async {
    final user = await _authService.currentUser();
    final url = user.imageUrl;
    return url;
  }

  Future<void> pickImageFromGallery() async {
    emit(const Loading());
    _image = await PickImageService.imgFromGallery();
    if (_image == null) {
      return emit(const Error('Insert valid image'));
    }
    try {
      final user = await _authService.currentUser();
      final userId = user.id;
      await _storageService.uploadFile(File(_image.path), userId);
      final imageURL = await _storageService.downloadURL(userId);
      await _authService.changeProfile(
          firstName: user.firstName,
          lastName: user.lastName,
          photoURL: imageURL);
      emit(AvatarChanged(imageURL));
    } catch (e) {
      emit(Error(e));
    }
  }

  Future<void> editProfile() async {
    emit(const Loading());
    try {
      await _authService.changeProfile(
          firstName: firstNameController.value,
          lastName: lastNameController.value);
      emit(const ProfileEdited());
    } catch (e) {
      emit(Error(e));
    }
  }
}
