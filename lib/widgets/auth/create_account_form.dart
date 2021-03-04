import 'package:firebasestarter/bloc/create_account/create_account_bloc.dart';
import 'package:firebasestarter/bloc/create_account/create_account_event.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CreateAccountForm extends StatelessWidget {
  final CreateAccountBloc bloc;

  const CreateAccountForm(this.bloc);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Margin(0.0, 71.0),
          TextFieldBuilder(
            stream: bloc.form.firstName,
            labelText: AppLocalizations.of(context).firstName,
            onChanged: (firstName) => bloc.form.onFirstNameChanged(firstName),
          ),
          Margin(0.0, 20.5),
          TextFieldBuilder(
            stream: bloc.form.lastName,
            labelText: AppLocalizations.of(context).lastName,
            onChanged: (lastName) => bloc.form.onLastNameChanged(lastName),
          ),
          Margin(0.0, 20.5),
          TextFieldBuilder(
            stream: bloc.form.email,
            labelText: AppLocalizations.of(context).email,
            onChanged: (email) => bloc.form.onEmailChanged(email),
          ),
          Margin(0.0, 20.5),
          TextFieldBuilder(
            stream: bloc.form.password,
            labelText: AppLocalizations.of(context).password,
            onChanged: (password) => bloc.form.onPasswordChanged(password),
            isPassword: true,
            showPasswordButton: true,
          ),
          Margin(0.0, 20.5),
          TextFieldBuilder(
            stream: bloc.form.passwordConfirmation,
            labelText: AppLocalizations.of(context).passwordConfirmation,
            onChanged: (passwordConf) =>
                bloc.form.onPasswordConfirmationChanged(passwordConf),
            isPassword: true,
            showPasswordButton: true,
          ),
          Margin(0.0, 49.5),
          Button(
            backgroundColor: AppColor.blue,
            text: AppLocalizations.of(context).createAccount,
            onTap: () => bloc.add(const CreateAccount()),
          ),
          Margin(0.0, 49.5),
        ],
      );
}
