import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as FirebaseAuthApi;
import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_bloc.dart';

import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_state.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/constants/strings.dart';

import 'package:flutterBoilerplate/widgets/common/image_picker_button.dart';
import 'package:flutterBoilerplate/widgets/edit_profile_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppString.editProfile),
          backgroundColor: Colors.blueGrey,
        ),
        body: EditProfileForm(),
      );
}

/*class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  FirebaseAuthApi.User _user;
  EditProfileBloc _bloc;

  @override
  void initState() {
    _bloc = EditProfileBloc();
    _user = FirebaseAuthApi.FirebaseAuth.instance.currentUser;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppString.editProfile),
      ),
      body: Column(children: [
        Center(
          child: ImagePickerButton(
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
                    case AvatarChanged:
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network(
                          _user.photoURL,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitHeight,
                        ),
                      );
                    default:
                      return const Image(image: AssetImage(AppAsset.anonUser));
                  }
                },
              ),
            ),
          ),
        ),
      ]),
    );
  }
}*/
