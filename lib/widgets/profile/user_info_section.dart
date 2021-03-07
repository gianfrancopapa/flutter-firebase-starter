import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/screens/profile/edit_profile_screen.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/profile/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserInfoSection extends StatelessWidget {
  final User user;
  const UserInfoSection(this.user);

  Widget _userInfoItem(BuildContext context, String title, String data) =>
      SizedBox(
        height: 52.0,
        width: MediaQuery.of(context).size.width / 1.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
              ),
            ),
            Margin(0.0, 6.0),
            Text(
              data,
              style: const TextStyle(
                color: AppColor.grey,
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );

  Widget _editIcon(BuildContext context) => InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<EditProfileBloc>(
              create: (BuildContext context) =>
                  EditProfileBloc(context.read<UserBloc>())
                    ..add(const CurrentUserLoaded()),
              child: EditProfileScreen(),
            ),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.only(right: 44.0),
          padding: const EdgeInsets.all(3.0),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.blue,
          ),
          alignment: Alignment.center,
          height: 50.0,
          width: 50.0,
          child: const Icon(
            Feather.edit,
            size: 22.0,
            color: AppColor.white,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final _localizedStrings = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Margin(0.0, 30.0),
          ProfileImage(image: user.imageUrl),
          Margin(0.0, 43.0),
          _userInfoItem(context, _localizedStrings.firstName, user.firstName),
          Margin(0.0, 12.0),
          _userInfoItem(context, _localizedStrings.lastName, user.lastName),
          Margin(0.0, 12.0),
          _userInfoItem(context, _localizedStrings.email, user.email),
          Margin(0.0, 80.0),
          Container(
            alignment: Alignment.centerRight,
            width: double.infinity,
            child: _editIcon(context),
          ),
        ],
      ),
    );
  }
}
