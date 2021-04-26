const String _STRING_WEB = 'web_app_version';
const String _STRING_IOS = 'ios_app_version';
const String _STRING_ANDROID = 'android_app_version';

class RemoteConfigService {
  RemoteConfigService() {}

  RemoteConfigService _instance;

  RemoteConfigService getInstance() {
    if (_instance == null) {
      _instance = RemoteConfigService();
    }
    return _instance;
  }

  String get getStringValueWeb => _STRING_WEB;
  String get getStringValueIos => _STRING_IOS;
  String get getStringValueAndroid => _STRING_ANDROID;
}
