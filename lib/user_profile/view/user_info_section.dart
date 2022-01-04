import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/user_profile/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserInfoSection extends StatelessWidget {
  const UserInfoSection({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30.0),
          UserProfileImage(image: user.imageUrl),
          const SizedBox(height: 43.0),
          _UserInfoItem(
            title: localizations.firstName,
            data: user.firstName,
          ),
          const SizedBox(height: 10.0),
          _UserInfoItem(
            title: localizations.lastName,
            data: user.lastName,
          ),
          const SizedBox(height: 10.0),
          _UserInfoItem(
            title: localizations.email,
            data: user.email,
          ),
        ],
      ),
    );
  }
}

class _UserInfoItem extends StatelessWidget {
  const _UserInfoItem({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  final String title;
  final String? data;

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
              color: FSColors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6.0),
          Text(
            data!,
            style: const TextStyle(
              color: FSColors.grey,
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
