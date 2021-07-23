import 'package:firebasestarter/services/app_info/app_info.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:firebasestarter/settings/settings.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => AppVersionCubit(appInfo: GetIt.I.get<AppInfo>()),
        child: const TextAppVersion());
  }
}

class TextAppVersion extends StatelessWidget {
  const TextAppVersion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<AppVersionCubit>().appVersion();
    return BlocBuilder<AppVersionCubit, AppVersionState>(
        buildWhen: (previous, current) =>
            previous.appVersion != current.appVersion,
        builder: (context, state) {
          return state.appVersion != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.appVersion,
                      style: const TextStyle(
                        color: AppColor.grey,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                )
              : const CircularProgressIndicator();
        });
  }
}
