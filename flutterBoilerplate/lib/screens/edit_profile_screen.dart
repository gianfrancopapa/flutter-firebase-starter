import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/widgets/edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppString.editProfile),
          backgroundColor: Colors.blueGrey,
        ),
        body: EditProfileForm(),
      );
}
