import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/screens/settings/settings_screen.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/profile/user_info_section.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc _bloc;
  @override
  void initState() {
    _bloc = UserBloc();
    _bloc.add(const GetUser());
    super.initState();
  }

  Widget _settingsIcon() => InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SettingsScreen(),
            ),
          );
          //To update name, lastName and image
          setState(() {});
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
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          goBack: false,
          title: Strings.myProfile,
          suffixWidget: _settingsIcon(),
        ),
        body: BlocBuilder<UserBloc, UserState>(
          cubit: _bloc,
          builder: (BuildContext context, UserState state) {
            switch (state.runtimeType) {
              case Error:
                return Center(child: Text((state as Error).message.toString()));
              case CurrentUser:
                return UserInfoSection((state as CurrentUser).user);
              case Loading:
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      );

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
