import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:flutterBoilerplate/bloc/edit_profile/edit_profile_state.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/screens/user_profile_screen.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';
import 'package:flutterBoilerplate/widgets/common/image_picker_button.dart';
import 'package:flutterBoilerplate/widgets/common/text_field_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileForm extends StatefulWidget {
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  EditProfileBloc _bloc;
  String imageURL;
  @override
  void initState() {
    _bloc = EditProfileBloc();
    super.initState();
  }

  void _onFirstNameChanged(String firstName) =>
      _bloc.onFirstNameChanged(firstName);
  void _onLastNameChanged(String lastName) => _bloc.onLastNameChanged(lastName);
  void _navigateToProfileScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(),
      ),
    );
  }

  Widget _determineImageSource(EditProfileState state) =>
      state.runtimeType == AvatarChanged
          ? Image.asset(AppAsset.anonUser)
          : Image.network(
              (state as AvatarChanged).image,
              width: 100,
              height: 100,
              fit: BoxFit.fitHeight,
            );
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: ImagePickerButton(
          dispatchImageFromCamera: _bloc.pickImageFromCamera,
          dispatchImageFromGallery: _bloc.pickImageFromGallery,
          child: CircleAvatar(
            child: BlocConsumer<EditProfileBloc, EditProfileState>(
              cubit: _bloc,
              listener: (context, state) {
                if (state.runtimeType == ProfileEdited) {
                  _navigateToProfileScreen();
                }
              },
              builder: (context, state) => _determineImageSource(state),
            ),
            radius: 55,
            backgroundColor: const Color(0xffFDCF09),
          ),
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 0.0),
          children: [
            TextFieldBuilder(
              stream: _bloc.firstName,
              labelText: AppString.firstName,
              onChanged: _onFirstNameChanged,
            ),
            TextFieldBuilder(
              stream: _bloc.lastName,
              labelText: AppString.lastName,
              onChanged: _onLastNameChanged,
            ),
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: Button(
                width: MediaQuery.of(context).size.width / 2,
                text: AppString.editProfile,
                onTap: _bloc.editProfile,
              ),
            ),
          ],
        ),
      )
    ]);
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
