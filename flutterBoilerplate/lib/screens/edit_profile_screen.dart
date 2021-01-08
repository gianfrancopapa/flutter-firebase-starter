import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthApi;
import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_bloc.dart';

import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_state.dart';

import 'package:flutterBoilerplate/services/firebase_storage.dart';

import 'package:flutterBoilerplate/widgets/common/image_picker_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileImage extends StatefulWidget {
  const ProfileImage({Key key}) : super(key: key);

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  FirebaseAuthApi.User _user;
  EditProfileBloc _bloc;
  File _image;
  @override
  void initState() {
    _bloc = EditProfileBloc();
    _user = FirebaseAuthApi.FirebaseAuth.instance.currentUser;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ImagePickerButton(
        dispatchImageFromCamera: _bloc.pickImageFromCamera,
        dispatchImageFromGallery: _bloc.pickImageFromGallery,
        child: CircleAvatar(
          radius: 55,
          backgroundColor: const Color(0xffFDCF09),
          child: BlocBuilder<EditProfileBloc, EditProfileState>(
              cubit: _bloc,
              builder: (context, state) {
                switch (state.runtimeType) {
                  case Loading:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  case Error:
                    return Center(
                      child: Text((state as Error).message.toString()),
                    );
                  case ProfileEdited:
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        (state as ProfileEdited).file,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    );

                  default:
                    loadProfilePhoto();
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        _image,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    );
                }
              }),
        ),
      ),
    ]);
  }

  Future<File> loadProfilePhoto() async {
    final path = await FirebaseStorageService()
        .downloadFile('user/profile/${_user.uid}');
    return _image = File(path);
  }
}
