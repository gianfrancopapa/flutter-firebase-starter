import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_event.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  ForgotPasswordBloc _bloc;

  void _onEmailChanged(String email) => _bloc.onEmailChanged(email);

  void _dispatchForgotPasswordEvent() => _bloc.add(const ForgotPassword());

  void _goToLoginScreen() => Navigator.pop(context);

  void _determineAction(ForgotPasswordState state) {
    if (state.runtimeType == EmailSent) {
      DialogHelper.showAlertDialog(
        context: context,
        story: AppLocalizations.of(context).emailSended,
        btnText: AppLocalizations.of(context).ok,
        btnAction: () => _goToLoginScreen(),
      );
    }
  }

  @override
  void initState() {
    _bloc = ForgotPasswordBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context).forgotPassword),
        ),
        body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          cubit: _bloc,
          listener: (context, state) => _determineAction(state),
          builder: (BuildContext context, state) => Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFieldBuilder(
                        stream: _bloc.email,
                        labelText: AppLocalizations.of(context).email,
                        onChanged: _onEmailChanged,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.02,
                        ),
                      ),
                    ],
                  ),
                ),
                Button(
                    text: AppLocalizations.of(context).send,
                    onTap: _dispatchForgotPasswordEvent),
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
