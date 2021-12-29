import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebasestarter/settings/settings.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appVersion = context.select(
      (AppVersionCubit cubit) => cubit.state.appVersion,
    );
    return appVersion != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appVersion,
                style: const TextStyle(
                  color: FSColors.grey,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          )
        : const CircularProgressIndicator();
  }
}
