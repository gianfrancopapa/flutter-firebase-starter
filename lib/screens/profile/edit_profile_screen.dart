import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/edit_profile/edit_profile_form.dart';
import 'package:firebasestarter/widgets/profile/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  Widget _userPhoto() => BlocBuilder<EditProfileBloc, EditProfileState>(
        buildWhen: (_, EditProfileState state) => state is AvatarChangeSuccess,
        builder: (BuildContext context, EditProfileState state) {
          return ProfileImage(
            editable: true,
            onTap: () => showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0)),
              ),
              builder: (_) {
                return _selectProfilePicture(context);
              },
            ),
            image: state is AvatarChangeSuccess ? state.image : '',
          );
        },
      );

  @override
  Widget build(BuildContext context) =>
      BlocListener<EditProfileBloc, EditProfileState>(
        listener: (BuildContext context, EditProfileState state) {
          if (state is EditProfileSuccess) {
            Navigator.pop(context);
          }
          if (state is EditProfileFailure) {
            DialogHelper.showAlertDialog(
              context: context,
              story: state.message,
              btnText: 'Close',
              btnAction: () => Navigator.pop(context),
            );
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(title: AppLocalizations.of(context).editProfile),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44.0),
              child: Column(
                children: [
                  Margin(0.0, 60.0),
                  _userPhoto(),
                  Margin(0.0, 45.0),
                  EditProfileForm(context.read<EditProfileBloc>()),
                ],
              ),
            ),
          ),
        ),
      );

  Widget _selectProfilePicture(BuildContext context) {
    final _appLocalizations = AppLocalizations.of(context);

    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(20.0),
        ),
        Center(
          child: Text(
            _appLocalizations.selectProfilePicture,
            style: const TextStyle(fontSize: 22),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
        ),
        ListTile(
          leading: const Icon(
            Icons.photo_camera,
            size: 50,
          ),
          title: Text(
            _appLocalizations.camera,
            style: const TextStyle(fontSize: 20),
          ),
          onTap: () {
            context.read<EditProfileBloc>().add(PhotoWithCameraUploaded());
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.insert_photo,
            size: 50,
          ),
          title: Text(
            _appLocalizations.gallery,
            style: const TextStyle(fontSize: 20),
          ),
          onTap: () {
            context.read<EditProfileBloc>().add(PhotoWithLibraryUpdated());
            Navigator.pop(context);
          },
        ),
        const Padding(
          padding: EdgeInsets.all(20.0),
        )
      ],
    );
  }
}
