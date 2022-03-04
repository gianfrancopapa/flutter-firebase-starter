import 'package:auth/auth.dart';
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/delete_account/bloc/delete_account_bloc.dart';
import 'package:firebasestarter/l10n/l10n.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteAccount extends StatelessWidget {
  const DeleteAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _localizations = context.l10n;
    final _loginMethod = context.read<LoginBloc>().state.method;
    final bloc = context.watch<DeleteAccountBloc>();

    return FSTextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(FSColors.blue),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) {
            return BlocProvider.value(
              value: bloc,
              child: _loginMethod == AuthenticationMethod.email
                  ? const _DialogDeleteAccountEmail()
                  : const _DialogDeleteAccountSocialMedia(),
            );
          },
        );
      },
      child: Text(
        _localizations.deleteAccount,
        style: const TextStyle(color: FSColors.white),
      ),
    );
  }
}

class _DialogDeleteAccountEmail extends StatelessWidget {
  const _DialogDeleteAccountEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _localizations = context.l10n;
    return AlertDialog(
      title: Text(_localizations.deleteAccount),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_localizations.deleteAccountConfirmation),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: _localizations.password,
              errorText: context.watch<DeleteAccountBloc>().state.status ==
                      DeleteAccountStatus.error
                  ? _localizations.wrongPasswordReauthentication
                  : null,
            ),
            onChanged: (value) {
              context
                  .read<DeleteAccountBloc>()
                  .add(DeleteAccountPasswordReauthentication(value));
            },
          ),
        ],
      ),
      actions: <Widget>[
        FSTextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_localizations.cancel),
        ),
        FSTextButton(
          onPressed: () {
            context
                .read<DeleteAccountBloc>()
                .add(const DeleteAccountRequestedEmail());
          },
          child: Text(
            _localizations.delete,
            style: const TextStyle(color: FSColors.red),
          ),
        ),
      ],
    );
  }
}

class _DialogDeleteAccountSocialMedia extends StatelessWidget {
  const _DialogDeleteAccountSocialMedia({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _localizations = context.l10n;
    final _loginMethod = context.read<LoginBloc>().state.method;
    return AlertDialog(
      title: Text(_localizations.deleteAccount),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_localizations.deleteAccountConfirmationSocialMedia),
        ],
      ),
      actions: <Widget>[
        FSTextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_localizations.cancel),
        ),
        FSTextButton(
          onPressed: () {
            context
                .read<DeleteAccountBloc>()
                .add(DeleteAccountRequestedSocialMedia(_loginMethod!));
          },
          child: Text(
            _localizations.delete,
            style: const TextStyle(color: FSColors.red),
          ),
        ),
      ],
    );
  }
}
