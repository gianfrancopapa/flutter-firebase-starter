const String _STRING_WEB = '1.0';
const String _STRING_IOS = '1.0';
const String _STRING_ANDROID = '1.0';

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
