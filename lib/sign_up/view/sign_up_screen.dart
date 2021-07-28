import 'package:firebasestarter/home/home.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/sign_up/sign_up.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<SignUpBloc>(
        create: (context) =>
            SignUpBloc(authService: context.read<FirebaseAuthService>()),
        child: const SignUpScreen(),
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
      body: BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (_, current) =>
            current.status == SignUpStatus.failure ||
            current.status == SignUpStatus.success,
        listener: (BuildContext context, SignUpState state) {
          if (state.status == SignUpStatus.failure) {
            DialogHelper.showAlertDialog(
              context: context,
              story: 'Error',
              btnText: 'Close',
              btnAction: () => Navigator.pop(context),
            );
            return;
          }

          if (state.status == SignUpStatus.success) {
            context.read<UserBloc>().add(const UserLoaded());

            Navigator.of(context).pushReplacement(HomeScreen.route());
          }
        },
        child: const _SignUpForm(
          key: Key('signUpScreen_signUpForm'),
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  const _SignUpForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44.0),
        child: Column(
          children: [
            Margin(0.0, 71.0),
            const _FirstNameTextField(
              key: Key('signUpScreen_signUpForm_firstNameTextField'),
            ),
            Margin(0.0, 20.5),
            const _LastNameTextField(
              key: Key('signUpScreen_signUpForm_lastNameTextField'),
            ),
            Margin(0.0, 20.5),
            const _EmailTextField(
              key: Key('signUpScreen_signUpForm_emailTextField'),
            ),
            Margin(0.0, 20.5),
            const _PasswordTextField(
              key: Key('signUpScreen_signUpForm_passwordTextField'),
            ),
            Margin(0.0, 20.5),
            const _PasswordConfirmationTextField(
              key: Key('signUpScreen_signUpForm_passwordConfirmationTextField'),
            ),
            Margin(0.0, 49.5),
            const _SignUpTextButton(
              key: Key('signUpScreen_signUpForm_signUpTextButton'),
            ),
            Margin(0.0, 49.5),
          ],
        ),
      ),
    );
  }
}

class _FirstNameTextField extends StatelessWidget {
  const _FirstNameTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final firstName = context.select((SignUpBloc bloc) => bloc.state.firstName);

    return TextField(
      decoration: InputDecoration(
        labelText: localizations.firstName,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorText: firstName.valid ? null : 'Invalid first name',
      ),
      onChanged: (firstName) {
        context
            .read<SignUpBloc>()
            .add(SignUpFirstNameChanged(firstName: firstName));
      },
    );
  }
}

class _LastNameTextField extends StatelessWidget {
  const _LastNameTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final lastName = context.select((SignUpBloc bloc) => bloc.state.lastName);

    return TextField(
      decoration: InputDecoration(
        labelText: localizations.lastName,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorText: lastName.valid ? null : 'Invalid last name',
      ),
      onChanged: (lastName) {
        context
            .read<SignUpBloc>()
            .add(SignUpLastNameChanged(lastName: lastName));
      },
    );
  }
}

class _EmailTextField extends StatelessWidget {
  const _EmailTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final email = context.select((SignUpBloc bloc) => bloc.state.email);

    return TextField(
      decoration: InputDecoration(
        labelText: localizations.email,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorText: email.valid ? null : 'Invalid email',
      ),
      onChanged: (email) {
        context.read<SignUpBloc>().add(SignUpEmailChanged(email: email));
      },
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final password = context.select((SignUpBloc bloc) => bloc.state.password);

    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: localizations.password,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorText: password.valid ? null : 'Weak password',
      ),
      onChanged: (password) {
        context
            .read<SignUpBloc>()
            .add(SignUpPasswordChanged(password: password));
      },
    );
  }
}

class _PasswordConfirmationTextField extends StatelessWidget {
  const _PasswordConfirmationTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final passwordConfirmation =
        context.select((SignUpBloc bloc) => bloc.state.password);

    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: localizations.passwordConfirmation,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorText: passwordConfirmation.valid ? null : 'Weak password',
      ),
      onChanged: (passwordConfirmation) {
        context.read<SignUpBloc>().add(
              SignUpPasswordConfirmationChanged(
                passwordConfirmation: passwordConfirmation,
              ),
            );
      },
    );
  }
}

class _SignUpTextButton extends StatelessWidget {
  const _SignUpTextButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final status = context.select((SignUpBloc bloc) => bloc.state.status);

    return TextButton(
      onPressed: status != SignUpStatus.valid
          ? null
          : () {
              context.read<SignUpBloc>().add(const SignUpRequested());
            },
      child: Text(
        localizations.createAccount,
        style: TextStyle(
          color: status != SignUpStatus.valid ? Colors.grey : Colors.blue,
        ),
      ),
    );
  }
}
