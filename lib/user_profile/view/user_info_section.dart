import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/edit_profile/edit_profile.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/user_profile/user_profile.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({Key key, @required this.user})
      : assert(user != null),
        super(key: key);

  final User user;

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
          UserProfileImage(image: user.imageUrl),
          Margin(0.0, 43.0),
          _UserInfoItem(
            title: _localizedStrings.firstName,
            data: user.firstName,
          ),
          Margin(0.0, 12.0),
          _UserInfoItem(
            title: _localizedStrings.lastName,
            data: user.lastName,
          ),
          Margin(0.0, 12.0),
          _UserInfoItem(
            title: _localizedStrings.email,
            data: user.email,
          ),
          Margin(0.0, 80.0),
          const _EditIcon(),
        ],
      ),
    );
  }
}

class _UserInfoItem extends StatelessWidget {
  const _UserInfoItem({
    Key key,
    @required this.title,
    @required this.data,
  }) : super(key: key);

  final String title;
  final String data;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
  }
}

class _EditIcon extends StatelessWidget {
  const _EditIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(EditProfileScreen.route());
        },
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
      ),
    );
  }
}
