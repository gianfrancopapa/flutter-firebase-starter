import 'package:package_info/package_info.dart';

class AppInfo {
  Future<String> getAppName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  Future<String> getVersionNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  Future<String> getPackageName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  Future<String> getBuildNumber() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<Flavor> getCurrentFlavor() async {
    final packageName = await getPackageName();
    if (packageName.endsWith('dev')) {
      return Flavor.DEVELOPMENT;
    } else if (packageName.endsWith('staging')) {
      return Flavor.STAGING;
    } else {
      return Flavor.PRODUCTION;
    }
  }
}

enum Flavor { DEVELOPMENT, STAGING, PRODUCTION }
