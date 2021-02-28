import 'package:firebasestarter/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/create_account/create_account_bloc.dart';
import 'package:firebasestarter/bloc/create_account/create_account_event.dart';
import 'package:firebasestarter/bloc/create_account/create_account_state.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountForm extends StatefulWidget {
  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  CreateAccountBloc _bloc;

  @override
  void initState() {
    _bloc = CreateAccountBloc();
    super.initState();
  }

  void _determineAction(CreateAccountState state) {
    if (state.runtimeType == Error) {
      DialogHelper.showAlertDialog(
        context: context,
        story: (state as Error).message,
        btnText: 'Close',
        btnAction: () => Navigator.pop(context),
      );
    } else if (state.runtimeType == AccountCreated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnBoardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<CreateAccountBloc, CreateAccountState>(
        cubit: _bloc,
        listener: (context, state) => _determineAction(state),
        builder: (context, state) => Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: ListView(
            padding: const EdgeInsets.symmetric(
              vertical: 40.0,
              horizontal: 0.0,
            ),
            children: [
              TextFieldBuilder(
                stream: _bloc.firstName,
                labelText: AppLocalizations.of(context).firstName,
                onChanged: (firstName) => _bloc.onFirstNameChanged(firstName),
              ),
              TextFieldBuilder(
                stream: _bloc.lastName,
                labelText: AppLocalizations.of(context).lastName,
                onChanged: (lastName) => _bloc.onLastNameChanged(lastName),
              ),
              TextFieldBuilder(
                stream: _bloc.email,
                labelText: AppLocalizations.of(context).email,
                onChanged: (email) => _bloc.onEmailChanged(email),
              ),
              TextFieldBuilder(
                stream: _bloc.password,
                labelText: AppLocalizations.of(context).password,
                onChanged: (password) => _bloc.onPasswordChanged(password),
                isPassword: true,
                showPasswordButton: true,
              ),
              TextFieldBuilder(
                stream: _bloc.passwordConfirmation,
                labelText: AppLocalizations.of(context).passwordConfirmation,
                onChanged: (passwordConf) =>
                    _bloc.onPasswordConfirmationChanged(passwordConf),
                isPassword: true,
              ),
              Padding(
                padding: const EdgeInsets.all(36.0),
                child: Button(
                  width: MediaQuery.of(context).size.width / 2,
                  text: AppLocalizations.of(context).createAccount,
                  onTap: () => _bloc.add(const CreateAccount()),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
