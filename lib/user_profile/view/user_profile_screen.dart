import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/edit_profile/edit_profile.dart';
import 'package:firebasestarter/settings/settings.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/user_profile/user_profile.dart';
import 'package:firebasestarter/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key, required this.bottomNavigationBar})
      : super(key: key);

  final Widget bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        goBack: false,
        title: localizations.myProfile,
        suffixWidget: InkWell(
          onTap: () {
            Navigator.of(context).push(SettingsScreen.route());
          },
          child: Container(
            margin: const EdgeInsets.only(right: 15.0),
            child: const Icon(
              Icons.settings_outlined,
              color: FSColors.white,
              size: 20.0,
            ),
          ),
        ),
      ),
      body: const _UserInfoSection(
        key: Key('userProfileScreen_userInfoSection'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: const _EditIcon(
        key: Key('userProfileScreen_editProfileButton'),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserBloc>().state;

    if (state.status == UserStatus.failure) {
      return const Center(
        key: Key('userProfileScreen_userInfoSection_errorText'),
        child: Text('Error'),
      );
    }

    if (state.status == UserStatus.success) {
      return UserInfoSection(
        key: const Key('userProfileScreen_userInfoSection_section'),
        user: state.user!,
      );
    }

    return const Center(
      key: Key('userProfileScreen_userInfoSection_loadingSpinner'),
      child: CircularProgressIndicator(),
    );
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon({Key? key}) : super(key: key);

  static const _padding = 50.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, _padding, _padding),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(EditProfileScreen.route());
        },
        child: const Icon(
          Icons.edit,
          size: 22.0,
          color: FSColors.white,
        ),
      ),
    );
  }
}
