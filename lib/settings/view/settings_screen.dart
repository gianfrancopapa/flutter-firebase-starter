import 'package:auth/auth.dart';
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/delete_account/bloc/delete_account_bloc.dart';
import 'package:firebasestarter/delete_account/view/delete_account_button.dart';
import 'package:firebasestarter/gen/assets.gen.dart';
import 'package:firebasestarter/l10n/l10n.dart';
import 'package:firebasestarter/logout/view/view.dart';
import 'package:firebasestarter/services/app_info/app_info_service.dart';
import 'package:firebasestarter/widgets/app_bar.dart';
import 'package:firebasestarter/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AppVersionCubit(appInfo: context.read<AppInfoService>())
                  ..appVersion(),
          ),
          BlocProvider(
            create: (context) => DeleteAccountBloc(
                authService: context.read<FirebaseAuthService>()),
          ),
        ],
        child: const SettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _localizations = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(title: _localizations.settings),
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
              const Logout(),
              const DeleteAccount(),
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
