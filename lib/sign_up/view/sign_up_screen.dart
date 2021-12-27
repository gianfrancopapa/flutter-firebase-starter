import 'package:auth/auth.dart';
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/home/home.dart';
import 'package:firebasestarter/sign_up/sign_up.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: localizations.createAccount,
      ),
      body: BlocListener<SignUpBloc, SignUpState>(
        listenWhen: (prev, current) =>
            (prev.status != current.status) &&
            (current.status == SignUpStatus.failure ||
                current.status == SignUpStatus.success),
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
  const _SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44.0),
        child: Column(
          children: const [
            SizedBox(height: 71.0),
            _FirstNameTextField(
              key: Key('signUpScreen_signUpForm_firstNameTextField'),
            ),
            SizedBox(height: 20.5),
            _LastNameTextField(
              key: Key('signUpScreen_signUpForm_lastNameTextField'),
            ),
            SizedBox(height: 20.5),
            _EmailTextField(
              key: Key('signUpScreen_signUpForm_emailTextField'),
            ),
            SizedBox(height: 20.5),
            _PasswordTextField(
              key: Key('signUpScreen_signUpForm_passwordTextField'),
            ),
            SizedBox(height: 20.5),
            _PasswordConfirmationTextField(
              key: Key('signUpScreen_signUpForm_passwordConfirmationTextField'),
            ),
            SizedBox(height: 49.5),
            _SignUpTextButton(
              key: Key('signUpScreen_signUpForm_signUpTextButton'),
            ),
            SizedBox(height: 49.5),
          ],
        ),
      ),
    );
  }
}

class _FirstNameTextField extends StatelessWidget {
  const _FirstNameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final firstName =
        context.select(((SignUpBloc bloc) => bloc.state.firstName!));

    return TextField(
      decoration: InputDecoration(
        labelText: localizations.firstName,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: FSColors.red),
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
  const _LastNameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final lastName =
        context.select(((SignUpBloc bloc) => bloc.state.lastName!));

    return TextField(
      decoration: InputDecoration(
        labelText: localizations.lastName,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: FSColors.red),
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
  const _EmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final email = context.select(((SignUpBloc bloc) => bloc.state.email!));

    return TextField(
      decoration: InputDecoration(
        labelText: localizations.email,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: FSColors.red),
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
  const _PasswordTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final password =
        context.select(((SignUpBloc bloc) => bloc.state.password!));

    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: localizations.password,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: FSColors.red),
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
  const _PasswordConfirmationTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final passwordConfirmation =
        context.select(((SignUpBloc bloc) => bloc.state.password!));

    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: localizations.passwordConfirmation,
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: FSColors.red),
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
  const _SignUpTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final status = context.select((SignUpBloc bloc) => bloc.state.status);

    return FSTextButton(
      onPressed: status != SignUpStatus.valid
          ? null
          : () {
              context.read<SignUpBloc>().add(const SignUpRequested());
            },
      child: Text(
        localizations.createAccount,
        style: TextStyle(
          color: status != SignUpStatus.valid ? FSColors.grey : FSColors.blue,
        ),
      ),
    );
  }
}
