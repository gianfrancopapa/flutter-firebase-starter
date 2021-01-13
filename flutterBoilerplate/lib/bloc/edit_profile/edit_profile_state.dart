import 'package:flutter/material.dart';

abstract class EditProfileState {
  const EditProfileState();
}

class ProfileEdited extends EditProfileState {
  final AssetImage image;
  const ProfileEdited(this.image);
}

class NotDetermined extends EditProfileState {
  const NotDetermined();
}

class Error extends EditProfileState {
  final String message;
  const Error(this.message);
}

class Loading extends EditProfileState {
  const Loading();
}
