import 'package:firebasestarter/screens/home.dart';
import 'package:firebasestarter/widgets/auth/create_account_form.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/bloc/create_account/create_account_bloc.dart';
import 'package:firebasestarter/bloc/create_account/create_account_state.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateAccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          title: AppLocalizations.of(context).createAccount,
        ),
        body: BlocListener<CreateAccountBloc, CreateAccountState>(
          listener: (BuildContext context, CreateAccountState state) {
            if (state is Error) {
              DialogHelper.showAlertDialog(
                context: context,
                story: state.message,
                btnText: 'Close',
                btnAction: () => Navigator.pop(context),
              );
            }
            if (state is AccountCreated) {
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
              child: CreateAccountForm(context.read<CreateAccountBloc>()),
            ),
          ),
        ),
      );
}
