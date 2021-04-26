import 'package:firebasestarter/bloc/create_account/create_account_bloc.dart';
import 'package:firebasestarter/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_event.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/screens/auth/create_account_screen.dart';
import 'package:firebasestarter/screens/auth/forgot_password_screen.dart';
import 'package:firebasestarter/widgets/auth/login_provider_buttons_section.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatelessWidget {
  final LoginBloc bloc;

  const LoginForm(this.bloc);

  void _goToCreateAccountScreen(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (_) => CreateAccountBloc(), child: CreateAccountScreen()),
        ),
      );

  void _goToForgotPasswordScreen(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
              create: (_) => ForgotPasswordBloc(),
              child: ForgotPasswordScreen()),
        ),
      );

  Widget _createAccountStory(BuildContext context) => InkWell(
        onTap: () => _goToCreateAccountScreen(context),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              AppLocalizations.of(context).createAccount,
              style: const TextStyle(
                color: AppColor.skyBlue,
                fontSize: 13.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_right_outlined,
              color: AppColor.skyBlue,
              size: 15.0,
            )
          ],
        ),
      );

  Widget _orStory(BuildContext context) => SizedBox(
        height: 20.0,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: AppColor.grey,
              height: 0.5,
              width: MediaQuery.of(context).size.width / 3,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 0.0,
                horizontal: 5.0,
              ),
              child: Text(
                'OR',
                style: TextStyle(
                  color: AppColor.grey,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Container(
              color: AppColor.grey,
              height: 0.5,
              width: MediaQuery.of(context).size.width / 3,
            ),
          ],
        ),
      );

  Widget _forgotPasswordStory(BuildContext context) => TextButton(
        onPressed: () => _goToForgotPasswordScreen(context),
        child: SizedBox(
          width: double.infinity,
          child: Text(
            AppLocalizations.of(context).didYouForgetYourPassword,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColor.blue,
              fontSize: 13.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final _localizedStrings = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Margin(0, 47.0),
        _createAccountStory(context),
        Margin(0, 12.0),
        TextFieldBuilder(
          stream: bloc.form.email,
          labelText: _localizedStrings.email,
          onChanged: (email) => bloc.form.onEmailChanged(email),
        ),
        Margin(0, 20.0),
        TextFieldBuilder(
          stream: bloc.form.password,
          labelText: _localizedStrings.password,
          onChanged: (password) => bloc.form.onPasswordChanged(password),
          isPassword: true,
          showPasswordButton: true,
        ),
        Margin(0, 27.5),
        _forgotPasswordStory(context),
        Margin(0, 21.0),
        Button(
          backgroundColor: AppColor.blue,
          text: _localizedStrings.login,
          onTap: () => bloc.add(const LoginStarted()),
        ),
        Margin(0, 26.0),
        _orStory(context),
        Margin(0, 20.0),
        LoginProviderButtonsSection(bloc),
        Margin(0, 40.0),
      ],
    );
  }
}
