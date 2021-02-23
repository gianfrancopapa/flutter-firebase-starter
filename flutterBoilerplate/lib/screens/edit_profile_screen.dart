import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/widgets/edit_profile_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).editProfile),
          backgroundColor: Colors.blueGrey,
        ),
        body: EditProfileForm(),
      );
}
