import 'package:firebasestarter/services/auth/sign_in_services/facebook/facebook_sign_in_service.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_test/flutter_test.dart';
import '.././mocks/auth_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

void main() {
  group('Facebook sign in service /', () {
    FacebookLogin _facebook;
    FacebookLoginResult _loginResult;
    FacebookAccessToken _accessToken;
    FacebookSignInService _facebookSignInService;

    setUp(() {
      _facebook = MockFacebookLogin();
      _loginResult = MockFacebookLoginResult();
      _accessToken = MockFacebookAccessToken();
      _facebookSignInService = FacebookSignInService(signInMethod: _facebook);

      when(_facebook.logIn(permissions: [
        FacebookPermission.publicProfile,
        FacebookPermission.email,
      ])).thenAnswer((_) async => _loginResult);
    });

    test('Success', () async {
      when(_loginResult.status).thenReturn(FacebookLoginStatus.success);

      when(_loginResult.accessToken).thenReturn(_accessToken);

      when(_accessToken.token).thenReturn('abcd1234');

      final credential = Auth.FacebookAuthProvider.credential('abcd1234');

      final obtainedCredential =
          await _facebookSignInService.getFirebaseCredential();

      expect(obtainedCredential.accessToken, credential.accessToken);
    });

    test('Cancelled by user', () async {
      when(_loginResult.status).thenReturn(FacebookLoginStatus.cancel);

      expect(await _facebookSignInService.getFirebaseCredential(), null);
    });

    test('Facebook Error', () async {
      when(_loginResult.status).thenReturn(FacebookLoginStatus.error);

      final error = FacebookError(
          developerMessage: 'error',
          localizedDescription: 'error',
          localizedTitle: 'error');

      when(_loginResult.error).thenReturn(error);

      expect(_facebookSignInService.getFirebaseCredential(), throwsException);
    });
  });
}
