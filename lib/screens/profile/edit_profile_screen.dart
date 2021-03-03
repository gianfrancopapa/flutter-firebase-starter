import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/screens/profile/user_profile_screen.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/image_picker_button.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileBloc _bloc;
  String imageURL;
  @override
  void initState() {
    _bloc = EditProfileBloc();
    super.initState();
  }

  Widget _userImage() => Center(
        child: ImagePickerButton(
          dispatchImageFromCamera: _bloc.pickImageFromCamera,
          dispatchImageFromGallery: _bloc.pickImageFromGallery,
          child: CircleAvatar(
            child: BlocConsumer<EditProfileBloc, EditProfileState>(
              cubit: _bloc,
              listener: (context, state) {
                if (state.runtimeType == ProfileEdited) {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state.runtimeType == AvatarChanged) {
                  return Image(
                    image: CachedNetworkImageProvider(
                        (state as AvatarChanged).image),
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitHeight,
                  );
                }
                return Image.asset(Assets.anonUser,
                    width: 100, height: 100, fit: BoxFit.fitHeight);
              },
            ),
            radius: 55,
            backgroundColor: Colors.white,
          ),
        ),
      );

  Widget _nameInput() => TextFieldBuilder(
        stream: _bloc.firstName,
        labelText: Strings.firstName,
        onChanged: (firstName) => _bloc.onFirstNameChanged(firstName),
      );

  Widget _updateButton() => Padding(
        padding: const EdgeInsets.all(36.0),
        child: Button(
          width: MediaQuery.of(context).size.width / 2,
          text: Strings.editProfile,
          onTap: _bloc.editProfile,
        ),
      );

  Widget _lastNameInput() => TextFieldBuilder(
        stream: _bloc.lastName,
        labelText: Strings.lastName,
        onChanged: (lastName) => _bloc.onLastNameChanged(lastName),
      );

  Widget _body() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: ListView(
          children: [
            _userImage(),
            _nameInput(),
            _lastNameInput(),
            _updateButton(),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).editProfile),
          backgroundColor: Colors.blueGrey,
        ),
        body: _body(),
      );

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
