import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_state.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/services/firebase_storage.dart';
import 'package:flutterBoilerplate/services/image_picker_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileBloc extends Cubit<EditProfileState> {
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorageService();
  PickedFile _image;

  EditProfileBloc() : super(const NotDetermined());

  /*Future<void> editProfile() async {
    emit(const Loading());
    if (_image == null) {
      return emit(const Error('Insert valid image'));
    }
    try {
      final user = _firebaseAuth.currentUser;
      await _firebaseStorage.uploadFile(
          File(_image.path), 'user/profile/${user.uid}');

      emit(AvatarChanged(File(_image.path)));
    } catch (e) {
      emit(Error(e));
    }
  }*/

  Future<void> pickImageFromCamera() async {
    emit(const Loading());
    _image = await PickImageService.imgFromCamera();
    if (_image == null) {
      return emit(const Error('Insert valid image'));
    }
    try {
      final user = _firebaseAuth.currentUser;
      await _firebaseStorage.uploadFile(File(_image.path), _image.path);
      final imageURL = await _firebaseStorage.downloadURL(_image.path);
      await user.updateProfile(photoURL: imageURL);

      emit(ProfileEdited(AssetImage(_image.path)));
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  Future<void> pickImageFromGallery() async {
    emit(const Loading());
    _image = await PickImageService.imgFromGallery();
    if (_image == null) {
      return emit(const Error('Insert valid image'));
    }
    try {
      final user = _firebaseAuth.currentUser;
      await _firebaseStorage.uploadFile(
          File(_image.path), 'user/profile/${user.uid}');
      await user.updateProfile(
          photoURL:
              await _firebaseStorage.downloadURL('user/profile/${user.uid}'));
      emit(ProfileEdited(AssetImage(_image.path)));
    } catch (e) {
      emit(Error(e));
    }
  }
}
