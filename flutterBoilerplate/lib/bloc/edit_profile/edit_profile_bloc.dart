import 'dart:io';
import 'package:flutterBoilerplate/services/firebase_auth.dart';
import 'package:flutterBoilerplate/bloc/forms/edit_profile_form_bloc.dart';
import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_state.dart';
import 'package:flutterBoilerplate/services/firebase_storage.dart';
import 'package:flutterBoilerplate/services/image_picker_service.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileBloc extends EditProfileFormBloc {
  final _firebaseAuth = FirebaseAuthService();
  final _firebaseStorage = FirebaseStorageService();
  PickedFile _image;

  Future<void> pickImageFromCamera() async {
    emit(const Loading());
    _image = await PickImageService.imgFromCamera();
    if (_image == null) {
      return emit(const Error('Insert valid image'));
    }
    try {
      await _firebaseStorage.uploadFile(File(_image.path), _image.path);
      final imageURL = await _firebaseStorage.downloadURL(_image.path);
      await _firebaseAuth.changeProfile(photoURL: imageURL);
      emit(AvatarChanged(imageURL));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<String> getURL() async {
    final user = await _firebaseAuth.getCurrentUser();
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
      await _firebaseStorage.uploadFile(File(_image.path), _image.path);
      final imageURL = await _firebaseStorage.downloadURL(_image.path);
      await _firebaseAuth.changeProfile(photoURL: imageURL);
      emit(AvatarChanged(imageURL));
    } catch (e) {
      emit(Error(e));
    }
  }

  Future<void> editProfile() async {
    emit(const Loading());
    try {
      await _firebaseAuth.changeProfile(
          firstName: firstNameController.value,
          lastName: lastNameController.value);
      emit(const ProfileEdited());
    } catch (e) {
      emit(Error(e));
    }
  }
}
