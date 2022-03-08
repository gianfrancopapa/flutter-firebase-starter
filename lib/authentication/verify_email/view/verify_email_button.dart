import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/authentication/verify_email/bloc/verifiy_email_bloc.dart';
import 'package:firebasestarter/gen/assets.gen.dart';
import 'package:firebasestarter/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _localizations = context.l10n;
    final bloc = context.read<VerifiyEmailBloc>();
    return FSTextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(FSColors.blue),
      ),
      child: Text(
        _localizations.verifyEmail,
        style: const TextStyle(
          color: FSColors.white,
        ),
      ),
      onPressed: () {
        context.read<VerifiyEmailBloc>().add(
              const VerifyEmailButtonEvent(),
            );

        showDialog(
          context: context,
          builder: (_) {
            return BlocProvider.value(
              value: bloc,
              child: AlertDialog(
                title: Column(
                  children: [
                    Image(
                      image: AssetImage(Assets.packages.firebaseStarterUi.assets
                          .images.emailDelivered.path),
                      height: 30.0,
                      width: 30.0,
                    ),
                    bloc.state.status == VerifyEmailStatus.success
                        ? Text(_localizations.verifyEmailLinkSent)
                        : Text(_localizations.verifyEmailErrorTitle),
                  ],
                ),
                content: bloc.state.status == VerifyEmailStatus.success
                    ? Text(
                        _localizations.verifyEmailLinkSentDescription,
                      )
                    : Text(_localizations.verifyEmailPleaseTryAgain),
                actions: <Widget>[
                  FSTextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(_localizations.ok)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
