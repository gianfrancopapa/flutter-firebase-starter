import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/screens/settings/settings_screen.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/profile/user_info_section.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
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
    final status = context.select((UserBloc bloc) => bloc.state.status);

    if (status == UserStatus.failure) {
      return Center(child: Text(context.read<UserBloc>().state.errorMessage));
    }

    if (status == UserStatus.success) {
      return UserInfoSection(context.read<UserBloc>().state.user);
    }

    return const Center(child: CircularProgressIndicator());
  }
}
