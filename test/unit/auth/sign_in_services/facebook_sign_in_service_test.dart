import 'package:firebasestarter/services/auth/sign_in_services/facebook/facebook_sign_in_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import '.././mocks/auth_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

void main() {
  group('Facebook sign in service /', () {
    FacebookAuth _facebook;
    LoginResult _loginResult;
    AccessToken _accessToken;
    FacebookSignInService _facebookSignInService;

    setUp(() {
      _facebook = MockFacebookLogin();
      _loginResult = MockFacebookLoginResult();
      _accessToken = MockFacebookAccessToken();
      _facebookSignInService = FacebookSignInService(signInMethod: _facebook);

      when(_facebook.login(loginBehavior: LoginBehavior.nativeWithFallback))
          .thenAnswer((_) async => _loginResult);
    });

    test('Success', () async {
      when(_loginResult.status).thenReturn(LoginStatus.success);

      when(_loginResult.accessToken).thenReturn(_accessToken);

      when(_accessToken.token).thenReturn('abcd1234');

      final credential = Auth.FacebookAuthProvider.credential('abcd1234');

      final obtainedCredential =
          await _facebookSignInService.getFirebaseCredential();

      expect(obtainedCredential.accessToken, credential.accessToken);
    });

    test('Cancelled by user', () async {
      when(_loginResult.status).thenReturn(LoginStatus.cancelled);

      expect(await _facebookSignInService.getFirebaseCredential(), null);
    });

    test('Facebook Error', () async {
      const error = 'error';

      when(_loginResult.status).thenReturn(LoginStatus.failed);

      when(_loginResult.message).thenReturn(error);

      expect(_facebookSignInService.getFirebaseCredential(), throwsException);
    });
  });
}
