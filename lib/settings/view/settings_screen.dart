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
    );
  }
}
