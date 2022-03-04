import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Logout extends StatelessWidget {
  const Logout({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _localizations = context.l10n;
    return FSTextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(FSColors.blue),
      ),
      onPressed: () {
        context.read<AppBloc>().add(const AppLogoutRequested());
      },
      child: Text(
        _localizations.logout,
        style: const TextStyle(color: FSColors.white),
      ),
    );
  }
}
