import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/screens/home.dart';
import 'package:firebasestarter/widgets/auth/create_account_form.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_bloc.dart';
import 'package:firebasestarter/bloc/account_creation/account_creation_state.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context).createAccount,
        ),
        body: BlocListener<AccountCreationBloc, AccountCreationState>(
          listener: (BuildContext context, AccountCreationState state) {
            if (state.status == AccountCreationStatus.failure) {
              DialogHelper.showAlertDialog(
                context: context,
                story: state.errorMessage,
                btnText: 'Close',
                btnAction: () => Navigator.pop(context),
              );
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 44.0),
              child: CreateAccountForm(context.read<AccountCreationBloc>()),
            ),
          ),
        ),
      );
}
