import 'package:firebasestarter/services/app_info/app_info.dart';
import 'package:package_info/package_info.dart';

class AppInfoService extends AppInfo {
  @override
  Future<String> getAppName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  @override
  Future<String> getBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  @override
  Future<Flavor> getCurrentFlavor() async {
    final packageName = await getPackageName();
    if (packageName.endsWith('dev')) {
      return Flavor.development;
    } else if (packageName.endsWith('staging')) {
      return Flavor.staging;
    } else {
      return Flavor.production;
    }
  }

  @override
  Future<String> getPackageName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  @override
  Future<String> getVersionNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}

enum Flavor { development, staging, production }
