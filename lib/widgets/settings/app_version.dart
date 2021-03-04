import 'package:firebasestarter/services/remote_config/remote_config.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class AppVersion extends StatefulWidget {
  @override
  _AppVersionState createState() => _AppVersionState();
}

class _AppVersionState extends State<AppVersion> {
  PackageInfo _packageInfo = PackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
  );
  RemoteConfigService _remoteConfigService;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    _initializeRemoteConfig();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<void> _initializeRemoteConfig() async {
    _remoteConfigService = await RemoteConfigService().getInstance();
    await _remoteConfigService.initialize();
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'v${_remoteConfigService.getStringValueIos}',
            style: const TextStyle(
              color: AppColor.grey,
              fontSize: 20.0,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
}
