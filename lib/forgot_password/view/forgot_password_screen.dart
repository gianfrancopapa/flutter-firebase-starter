import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/forgot_password/forgot_password.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<ForgotPasswordBloc>(
        create: (_) => ForgotPasswordBloc(
          authService: GetIt.I.get<AuthService>(),
        ),
        child: const ForgotPasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.forgotPassword,
      ),
      body: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
        listenWhen: (_, current) =>
            current.status == ForgotPasswordStatus.success,
        listener: (BuildContext context, ForgotPasswordState state) {
          if (state.status == ForgotPasswordStatus.success) {
            DialogHelper.showAlertDialog(
              context: context,
              story: localizations.emailSent,
              btnText: localizations.ok,
              btnAction: () => Navigator.pop(context),
            );
          }
        },
        child: const _ForgotPasswordForm(
          key: Key('forgotPasswordScreen_form'),
        ),
      ),
    );
  }
}

class _ForgotPasswordForm extends StatelessWidget {
  const _ForgotPasswordForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 131.0),
          const _EmailTextField(
            key: Key('forgotPasswordScreen_form_emailTextField'),
          ),
          const SizedBox(height: 41.0),
          const _ForgotPasswordTextButton(
            key: Key('forgotPasswordScreen_form_forgotPasswordButton'),
          ),
        ],
      ),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final email = context.select((ForgotPasswordBloc bloc) => bloc.state.email);

    return TextField(
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: email.valid ? FSColors.blue : FSColors.red,
          ),
        ),
        errorText: email.valid ? null : 'Error: Invalid email',
      ),
      onChanged: (email) {
        context
            .read<ForgotPasswordBloc>()
            .add(ForgotPasswordEmailChanged(email: email));
      },
    );
  }
}

class _ForgotPasswordTextButton extends StatelessWidget {
  const _ForgotPasswordTextButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final status =
        context.select((ForgotPasswordBloc bloc) => bloc.state.status);
    final isNotValid = status != ForgotPasswordStatus.valid;

    return TextButton(
      style: ButtonStyle(
        backgroundColor: isNotValid
            ? MaterialStateProperty.all(FSColors.grey)
            : MaterialStateProperty.all(FSColors.blue),
      ),
      child: Text(localizations.send),
      onPressed: isNotValid
          ? null
          : () {
              context
                  .read<ForgotPasswordBloc>()
                  .add(const ForgotPasswordResetRequested());
            },
    );
  }
}
