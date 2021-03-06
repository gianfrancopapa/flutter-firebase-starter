import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
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
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context).forgotPassword,
        ),
        body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (BuildContext context, ForgotPasswordState state) {
            if (state is ForgotPasswordEmailSent) {
              DialogHelper.showAlertDialog(
                context: context,
                story: AppLocalizations.of(context).emailSended,
                btnText: AppLocalizations.of(context).ok,
                btnAction: () => Navigator.pop(context),
              );
            }
          },
          child: buildForgotPasswordForm(
              context, context.read<ForgotPasswordBloc>()),
        ),
      );

  Padding buildForgotPasswordForm(
      BuildContext context, ForgotPasswordBloc forgotPasswordBloc) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Margin(0.0, 131.0),
          TextFieldBuilder(
            stream: forgotPasswordBloc.form.email,
            labelText: AppLocalizations.of(context).email,
            onChanged: (email) => forgotPasswordBloc.form.onEmailChanged(email),
          ),
          Margin(0.0, 41.0),
          Button(
            text: AppLocalizations.of(context).send,
            onTap: () => forgotPasswordBloc.add(const PasswordReset()),
            backgroundColor: AppColor.blue,
          ),
        ],
      ),
    );
  }
}
