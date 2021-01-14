import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/create_account/create_account_bloc.dart';
import 'package:flutterBoilerplate/bloc/create_account/create_account_event.dart';
import 'package:flutterBoilerplate/bloc/create_account/create_account_state.dart';
import 'package:flutterBoilerplate/screens/main_screen.dart';
import 'package:flutterBoilerplate/screens/onboarding_screen.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';
import 'package:flutterBoilerplate/widgets/common/text_field_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

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

  void _dispatchCreateAccountEvent() => _bloc.add(const CreateAccount());

  void _onFirstNameChanged(String firstName) =>
      _bloc.onFirstNameChanged(firstName);

  void _onLastNameChanged(String lastName) => _bloc.onLastNameChanged(lastName);

  void _onEmailChanged(String email) => _bloc.onEmailChanged(email);

  void _onPasswordChanged(String password) => _bloc.onPasswordChanged(password);

  void _onPasswordConfirmationChanged(String passwordConf) =>
      _bloc.onPasswordConfirmationChanged(passwordConf);

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
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: state.runtimeType == Loading,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 0.0),
              children: [
                TextFieldBuilder(
                  stream: _bloc.firstName,
                  labelText: AppString.firstName,
                  onChanged: _onFirstNameChanged,
                ),
                TextFieldBuilder(
                  stream: _bloc.lastName,
                  labelText: AppString.lastName,
                  onChanged: _onLastNameChanged,
                ),
                TextFieldBuilder(
                  stream: _bloc.email,
                  labelText: AppString.email,
                  onChanged: _onEmailChanged,
                ),
                TextFieldBuilder(
                  stream: _bloc.password,
                  labelText: AppString.password,
                  onChanged: _onPasswordChanged,
                  isPassword: true,
                ),
                TextFieldBuilder(
                  stream: _bloc.passwordConfirmation,
                  labelText: AppString.passwordConfirmation,
                  onChanged: _onPasswordConfirmationChanged,
                  isPassword: true,
                ),
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Button(
                    width: MediaQuery.of(context).size.width / 2,
                    text: AppString.createAccount,
                    onTap: _dispatchCreateAccountEvent,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
