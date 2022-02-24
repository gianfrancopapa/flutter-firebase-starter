import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/gen/assets.gen.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/services/app_info/app_info_service.dart';
import 'package:firebasestarter/widgets/app_bar.dart';
import 'package:firebasestarter/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) =>
            AppVersionCubit(appInfo: context.read<AppInfoService>())
              ..appVersion(),
        child: const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _localizedStrings = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: _localizedStrings.settings),
      body: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
              ),
              FSTextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(FSColors.blue),
                ),
                onPressed: () {
                  context.read<AppBloc>().add(const AppLogoutRequsted());
                },
                child: Text(
                  _localizedStrings.logout,
                  style: const TextStyle(color: FSColors.white),
                ),
              ),
              const _DeleteAccount(),
              const SizedBox(height: 200.0),
              const AppVersion(),
              const SizedBox(height: 20.45),
              SvgPicture.asset(
                Assets.packages.firebaseStarterUi.assets.images.somnioGreyLogo,
                color: FSColors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeleteAccount extends StatelessWidget {
  const _DeleteAccount({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _localizedStrings = AppLocalizations.of(context)!;
    final _loginMethod = context.read<LoginBloc>().state.method;

    return FSTextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(FSColors.blue),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _loginMethod != null
              ? const _DialogDeleteAccountSocialMedia()
              : const _DialogDeleteAccountEmail(),
        );
      },
      child: Text(
        _localizedStrings.deleteAccount,
        style: const TextStyle(color: FSColors.white),
      ),
    );
  }
}

class _DialogDeleteAccountEmail extends StatelessWidget {
  const _DialogDeleteAccountEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _localizedStrings = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(_localizedStrings.deleteAccount),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_localizedStrings.deleteAccountConfirmation),
          TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: _localizedStrings.password,
              errorText:
                  context.watch<AppBloc>().state.status == AppStatus.failure
                      ? _localizedStrings.wrongPasswordReauthentication
                      : null,
            ),
            onChanged: (value) {
              context.read<AppBloc>().add(AppPasswordReauthentication(value));
            },
          ),
        ],
      ),
      actions: <Widget>[
        FSTextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_localizedStrings.cancel),
        ),
        FSTextButton(
          onPressed: () {
            context.read<AppBloc>().add(const AppDeleteRequested());
          },
          child: Text(
            _localizedStrings.delete,
            style: const TextStyle(color: FSColors.red),
          ),
        ),
      ],
    );
  }
}

class _DialogDeleteAccountSocialMedia extends StatelessWidget {
  const _DialogDeleteAccountSocialMedia({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations _localizedStrings = AppLocalizations.of(context)!;
    final _loginMethod = context.read<LoginBloc>().state.method;
    return AlertDialog(
      title: Text(_localizedStrings.deleteAccount),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_localizedStrings.deleteAccountConfirmationSocialMedia),
        ],
      ),
      actions: <Widget>[
        FSTextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(_localizedStrings.cancel),
        ),
        FSTextButton(
          onPressed: () {
            context
                .read<AppBloc>()
                .add(AppDeleteRequestedSocialMedia(_loginMethod!));
          },
          child: Text(
            _localizedStrings.delete,
            style: const TextStyle(color: FSColors.red),
          ),
        ),
      ],
    );
  }
}
