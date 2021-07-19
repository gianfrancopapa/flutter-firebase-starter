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

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<ForgotPasswordBloc>(
        create: (_) => ForgotPasswordBloc(),
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
            current.status == ForgotPasswordStatus.emailSent,
        listener: (BuildContext context, ForgotPasswordState state) {
          if (state.status == ForgotPasswordStatus.emailSent) {
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
    final localizations = AppLocalizations.of(context);

    final emailAddress =
        context.select((ForgotPasswordBloc bloc) => bloc.state.emailAddress);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Margin(0.0, 131.0),
          TextFieldBuilder(
            value: emailAddress ?? '',
            labelText: localizations.email,
            onChanged: (email) {
              context
                  .read<ForgotPasswordBloc>()
                  .add(EmailAddressUpdated(emailAddress: email));
            },
          ),
          Margin(0.0, 41.0),
          Button(
            text: localizations.send,
            onTap: () {
              context.read<ForgotPasswordBloc>().add(const PasswordReset());
            },
            backgroundColor: AppColor.blue,
          ),
        ],
      ),
    );
  }
}
