import 'package:flutter/material.dart';
import 'package:firebasestarter/widgets/auth/create_account_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).createAccount),
        backgroundColor: Colors.blueGrey,
      ),
      body: CreateAccountForm(),
    );
  }
}
