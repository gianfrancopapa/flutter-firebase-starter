import 'package:firebasestarter/bloc/account_creation/account_creation_event.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/screens/home.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_bloc.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_state.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO: Localize screen completely
class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<AccountCreationBloc>(
        create: (_) => AccountCreationBloc(),
        child: const CreateAccountScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.createAccount,
      ),
      body: BlocListener<AccountCreationBloc, AccountCreationState>(
        listenWhen: (_, current) =>
            current.status == AccountCreationStatus.failure ||
            current.status == AccountCreationStatus.success,
        listener: (BuildContext context, AccountCreationState state) {
          if (state.status == AccountCreationStatus.failure) {
            DialogHelper.showAlertDialog(
              context: context,
              story: state.errorMessage,
              btnText: 'Close',
              btnAction: () => Navigator.pop(context),
            );
            return;
          }

          if (state.status == AccountCreationStatus.success) {
            BlocProvider.of<UserBloc>(context)..add(const UserLoaded());
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(state.user),
              ),
            );
          }
        },
        child: const _CreateAccountForm(
          key: Key('createAccountScreen_form'),
        ),
      ),
    );
  }
}

class _CreateAccountForm extends StatelessWidget {
  const _CreateAccountForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44.0),
        child: Column(
          children: [
            Margin(0.0, 71.0),
            TextFieldBuilder(
              stream: context.read<AccountCreationBloc>().form.firstName,
              labelText: localizations.firstName,
              onChanged: (firstName) {
                context
                    .read<AccountCreationBloc>()
                    .form
                    .onFirstNameChanged(firstName);
              },
            ),
            Margin(0.0, 20.5),
            TextFieldBuilder(
              stream: context.read<AccountCreationBloc>().form.lastName,
              labelText: localizations.lastName,
              onChanged: (lastName) {
                context
                    .read<AccountCreationBloc>()
                    .form
                    .onLastNameChanged(lastName);
              },
            ),
            Margin(0.0, 20.5),
            TextFieldBuilder(
              stream: context.read<AccountCreationBloc>().form.email,
              labelText: localizations.email,
              onChanged: (email) {
                context.read<AccountCreationBloc>().form.onEmailChanged(email);
              },
            ),
            Margin(0.0, 20.5),
            TextFieldBuilder(
              stream: context.read<AccountCreationBloc>().form.password,
              labelText: localizations.password,
              onChanged: (password) {
                context
                    .read<AccountCreationBloc>()
                    .form
                    .onPasswordChanged(password);
              },
              isPassword: true,
              showPasswordButton: true,
            ),
            Margin(0.0, 20.5),
            TextFieldBuilder(
              stream:
                  context.read<AccountCreationBloc>().form.passwordConfirmation,
              labelText: localizations.passwordConfirmation,
              onChanged: (passwordConf) {
                context
                    .read<AccountCreationBloc>()
                    .form
                    .onPasswordConfirmationChanged(passwordConf);
              },
              isPassword: true,
              showPasswordButton: true,
            ),
            Margin(0.0, 49.5),
            Button(
              backgroundColor: AppColor.blue,
              text: localizations.createAccount,
              onTap: () {
                context
                    .read<AccountCreationBloc>()
                    .add(const AccountCreationRequested());
              },
            ),
            Margin(0.0, 49.5),
          ],
        ),
      ),
    );
  }
}
