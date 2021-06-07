import 'package:firebasestarter/bloc/account_creation/account_creation_bloc.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_event.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CreateAccountForm extends StatelessWidget {
  final AccountCreationBloc bloc;

  const CreateAccountForm(this.bloc);

  @override
  Widget build(BuildContext context) {
    final _localizedStrings = AppLocalizations.of(context);
    return Column(
      children: [
        Margin(0.0, 71.0),
        TextFieldBuilder(
          stream: bloc.form.firstName,
          labelText: _localizedStrings.firstName,
          onChanged: (firstName) => bloc.form.onFirstNameChanged(firstName),
        ),
        Margin(0.0, 20.5),
        TextFieldBuilder(
          stream: bloc.form.lastName,
          labelText: _localizedStrings.lastName,
          onChanged: (lastName) => bloc.form.onLastNameChanged(lastName),
        ),
        Margin(0.0, 20.5),
        TextFieldBuilder(
          stream: bloc.form.email,
          labelText: _localizedStrings.email,
          onChanged: (email) => bloc.form.onEmailChanged(email),
        ),
        Margin(0.0, 20.5),
        TextFieldBuilder(
          stream: bloc.form.password,
          labelText: _localizedStrings.password,
          onChanged: (password) => bloc.form.onPasswordChanged(password),
          isPassword: true,
          showPasswordButton: true,
        ),
        Margin(0.0, 20.5),
        TextFieldBuilder(
          stream: bloc.form.passwordConfirmation,
          labelText: _localizedStrings.passwordConfirmation,
          onChanged: (passwordConf) =>
              bloc.form.onPasswordConfirmationChanged(passwordConf),
          isPassword: true,
          showPasswordButton: true,
        ),
        Margin(0.0, 49.5),
        Button(
          backgroundColor: AppColor.blue,
          text: _localizedStrings.createAccount,
          onTap: () => bloc.add(const AccountCreationRequested()),
        ),
        Margin(0.0, 49.5),
      ],
    );
  }
}
