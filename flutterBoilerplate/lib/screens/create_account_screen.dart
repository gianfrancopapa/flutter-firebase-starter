import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/widgets/create_account_form.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppString.createAccount),
          backgroundColor: Colors.blueGrey,
        ),
        body: CreateAccountForm(),
      );
}
