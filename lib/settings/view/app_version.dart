import 'dart:io';

import 'package:firebasestarter/services/remote_config/remote_config.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/settings/cubit/app_version_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';

class AppVersion extends StatelessWidget {
  const AppVersion({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AppVersionCubit(
          remoteConfigService: GetIt.I.get<RemoteConfigService>()),
      child: BlocListener<AppVersionCubit, AppVersionState>(
        listener: (context, state) {
          if (state.showVersion) {
            return Text(
              state.appVersion,
              style: const TextStyle(
                color: AppColor.grey,
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            );
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

// class AppVersion extends StatefulWidget {
//   const AppVersion({Key key}) : super(key: key);

//   @override
//   _AppVersionState createState() => _AppVersionState();
// }

// class _AppVersionState extends State<AppVersion> {
//   // ignore: unused_field
//   PackageInfo _packageInfo = PackageInfo(
//     appName: '',
//     packageName: '',
//     version: '',
//     buildNumber: '',
//   );
//   RemoteConfigService _remoteConfigService;
//   String appVersion = '';
//   bool showVersion = false;

//   @override
//   void initState() {
//     super.initState();
//     _initPackageInfo();
//     _initializeRemoteConfig();
//   }

//   Future<void> _initPackageInfo() async {
//     final info = await PackageInfo.fromPlatform();
//     setState(() {
//       _packageInfo = info;
//     });
//   }

//   Future<void> _initializeRemoteConfig() async {
//     _remoteConfigService = RemoteConfigService().getInstance();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (kIsWeb) {
//       appVersion = _remoteConfigService?.getStringValueWeb;
//     } else {
//       appVersion = Platform.isAndroid
//           ? _remoteConfigService?.getStringValueAndroid
//           : _remoteConfigService?.getStringValueIos;
//     }
//     if (appVersion != null && appVersion.isNotEmpty) {
//       setState(() {
//         showVersion = true;
//       });
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         showVersion
//             ? Text(
//                 appVersion,
//                 style: const TextStyle(
//                   color: AppColor.grey,
//                   fontSize: 20.0,
//                   fontWeight: FontWeight.w400,
//                 ),
//               )
//             : const SizedBox(),
//       ],
//     );
//   }
// }
