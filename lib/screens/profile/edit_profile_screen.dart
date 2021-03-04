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

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  EditProfileBloc _bloc;

  @override
  void initState() {
    _bloc = EditProfileBloc()..add(const GetCurrentUser());
    super.initState();
  }

  Widget _userPhoto() => BlocBuilder<EditProfileBloc, EditProfileState>(
        cubit: _bloc,
        buildWhen: (_, EditProfileState state) => state is AvatarChanged,
        builder: (BuildContext context, EditProfileState state) => ProfileImage(
          editable: true,
          onTap: () => _bloc.add(UpdatePhotoWithLibrary()),
          image: state is AvatarChanged ? state.image : null,
        ),
      );

  @override
  Widget build(BuildContext context) =>
      BlocListener<EditProfileBloc, EditProfileState>(
        cubit: _bloc,
        listener: (BuildContext context, EditProfileState state) {
          if (state is ProfileEdited) {
            Navigator.pop(context);
          }
          if (state is Error) {
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44.0),
            child: Column(
              children: [
                Margin(0.0, 60.0),
                _userPhoto(),
                Margin(0.0, 45.0),
                EditProfileForm(_bloc),
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
