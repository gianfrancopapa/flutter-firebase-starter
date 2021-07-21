import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/settings/settings.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/user_profile/user_profile.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        goBack: false,
        title: Strings.myProfile,
        suffixWidget: InkWell(
          onTap: () {
            Navigator.of(context).push(SettingsScreen.route());
          },
          child: Container(
            margin: const EdgeInsets.only(right: 15.0),
            child: const Icon(
              Feather.settings,
              color: AppColor.white,
              size: 20.0,
            ),
          ),
        ),
      ),
      body: const _UserInfoSection(
        key: Key('userProfileScreen_userInfoSection'),
      ),
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  const _UserInfoSection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<UserBloc>().state;

    if (state.status == UserStatus.failure) {
      return const Center(child: Text('Error'));
    }

    if (state.status == UserStatus.success) {
      return UserInfoSection(user: state.user);
    }

    return const Center(child: CircularProgressIndicator());
  }
}
