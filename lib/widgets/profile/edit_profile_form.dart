import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/screens/profile/user_profile_screen.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/image_picker_button.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
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

  void _navigateToProfileScreen() async {
    Navigator.pop(
        context, MaterialPageRoute(builder: (context) => ProfileScreen()));
  }

  Widget _determineImageSource(EditProfileState state) {
    if (state.runtimeType == AvatarChanged) {
      return Image(
        image: CachedNetworkImageProvider((state as AvatarChanged).image),
        width: 100,
        height: 100,
        fit: BoxFit.fitHeight,
      );
    }
    return Image.asset(Assets.anonUser,
        width: 100, height: 100, fit: BoxFit.fitHeight);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: ListView(
        children: [
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
                backgroundColor: Colors.white,
              ),
            ),
          ),
          TextFieldBuilder(
            stream: _bloc.firstName,
            labelText: Strings.firstName,
            onChanged: (firstName) => _bloc.onFirstNameChanged(firstName),
          ),
          TextFieldBuilder(
            stream: _bloc.lastName,
            labelText: Strings.lastName,
            onChanged: (lastName) => _bloc.onLastNameChanged(lastName),
          ),
          Padding(
            padding: const EdgeInsets.all(36.0),
            child: Button(
              width: MediaQuery.of(context).size.width / 2,
              text: Strings.editProfile,
              onTap: _bloc.editProfile,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
