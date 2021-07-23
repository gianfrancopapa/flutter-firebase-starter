import 'package:firebasestarter/services/app_info/app_info_service.dart';

abstract class AppInfo {
  Future<String> getAppName();
  Future<String> getVersionNumber();
  Future<String> getPackageName();
  Future<String> getBuildNumber();
  Future<Flavor> getCurrentFlavor();
}
