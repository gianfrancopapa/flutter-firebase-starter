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

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'v${_packageInfo.version}',
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }
}
