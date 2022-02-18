import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/gen/assets.gen.dart';
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
              _DeleteAccount(localizedStrings: _localizedStrings),
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
    required AppLocalizations localizedStrings,
  })  : _localizedStrings = localizedStrings,
        super(key: key);

  final AppLocalizations _localizedStrings;

  @override
  Widget build(BuildContext context) {
    return FSTextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(FSColors.blue),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(_localizedStrings.deleteAccount),
            content: Column(
              children: [
                Text(_localizedStrings.deleteAccountConfirmation),
                TextField(
                  decoration:
                      InputDecoration(labelText: _localizedStrings.password),
                  onChanged: (value) {
                    context
                        .read<AppBloc>()
                        .add(AppPasswordReauthentication(value));
                  },
                ),
              ],
            ),
            actions: <Widget>[
              FSTextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              FSTextButton(
                onPressed: () {
                  context.read<AppBloc>().add(const AppDeleteRequested());
                },
                child: Text(_localizedStrings.delete,
                    style: const TextStyle(color: FSColors.red)),
              ),
            ],
          ),
        );
      },
      child: Text(
        _localizedStrings.deleteAccount,
        style: const TextStyle(color: FSColors.white),
      ),
    );
  }
}
