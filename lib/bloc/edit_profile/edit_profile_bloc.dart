import 'dart:io';
import 'package:flutterBoilerplate/models/datatypes/storage_service_type.dart';
import 'package:flutterBoilerplate/models/service_factory.dart';
import 'package:flutterBoilerplate/bloc/forms/edit_profile_form_bloc.dart';
import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_state.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutterBoilerplate/services/image_picker_service.dart';
import 'package:flutterBoilerplate/services/storage_interface.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileBloc extends EditProfileFormBloc {
  final _authService = FirebaseAuthService();
  IStorage _storageService;
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
      final user = await _authService.getCurrentUser();
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
    final user = await _authService.getCurrentUser();
    final url = user.avatarAsset;
    return url;
  }

  Future<void> pickImageFromGallery() async {
    emit(const Loading());
    _image = await PickImageService.imgFromGallery();
    if (_image == null) {
      return emit(const Error('Insert valid image'));
    }
    try {
      final user = await _authService.getCurrentUser();
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
