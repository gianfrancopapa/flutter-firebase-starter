import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
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

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget _settingsIcon() => InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(right: 15.0),
          child: const Icon(
            Feather.settings,
            color: AppColor.white,
            size: 20.0,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          goBack: false,
          title: Strings.myProfile,
          suffixWidget: _settingsIcon(),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            switch (state.runtimeType) {
              case UserLoadFailure:
                return Center(
                    child: Text((state as UserLoadFailure).message.toString()));
              case UserLoadSuccess:
                return UserInfoSection((state as UserLoadSuccess).user);
              case UserLoadInProgress:
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
