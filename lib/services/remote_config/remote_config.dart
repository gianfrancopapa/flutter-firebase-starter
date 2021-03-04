import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _STRING_IOS = 'ios_app_version';
const String _STRING_ANDROID = 'android_app_version';

class RemoteConfigService {
  RemoteConfig _remoteConfig;
  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  final defaults = <String, dynamic>{
    _STRING_IOS: '0.1',
    _STRING_ANDROID: '0.1',
  };
  RemoteConfigService _instance;

  Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance =
          RemoteConfigService(remoteConfig: await RemoteConfig.instance);
    }
    return _instance;
  }

  String get getStringValueIos => _remoteConfig.getString(_STRING_IOS);
  String get getStringValueAndroid => _remoteConfig.getString(_STRING_ANDROID);

  Future initialize() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on FetchThrottledException catch (e) {
      print('Remote Config throttled: $e');
    } catch (e) {
      print('Unable to fetch remote config. Default value will be used');
    }
  }

  Future _fetchAndActivate() async {
    await _remoteConfig.fetch(expiration: const Duration(seconds: 10));
    await _remoteConfig.activateFetched();
    print('$getStringValueIos');
    print('$getStringValueAndroid');
  }
}
