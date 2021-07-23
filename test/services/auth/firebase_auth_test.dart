import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasestarter/models/user.dart' as Model;
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockSignInServiceFactory extends Mock implements SignInServiceFactory {}

class MockUserCredential extends Mock implements UserCredential {}

class MockOAuthCredential extends Mock implements OAuthCredential {}

class MockFirebaseUser extends Mock implements User {}

// ignore: must_be_immutable
class MockModelUser extends Mock implements Model.User {}

// ignore: must_be_immutable
class MockFirebaseAuthException extends Mock implements FirebaseAuthException {}

class MockISignInService extends Mock implements ISignInService {}

void main() {
  group('FirebaseAuthService', () {
    FirebaseAuth mockFirebaseAuth;
    SignInServiceFactory mockSignInServiceFactory;
    FirebaseAuthException mockFirebaseAuthException;
    ISignInService mockISignInService;

    FirebaseAuthService subject;

    UserCredential mockUserCredential;
    OAuthCredential mockOAuthCredential;
    Model.User mockModelUser;
    User mockFirebaseUser;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockSignInServiceFactory = MockSignInServiceFactory();
      mockFirebaseAuthException = MockFirebaseAuthException();
      mockISignInService = MockISignInService();

      subject = FirebaseAuthService(
        authService: mockFirebaseAuth,
        signInServiceFactory: mockSignInServiceFactory,
      );

      mockModelUser = MockModelUser();

      when(mockModelUser.id).thenReturn('1');
      when(mockModelUser.firstName).thenReturn('firstName');
      when(mockModelUser.lastName).thenReturn('lastName');
      when(mockModelUser.email).thenReturn('email@email.com');

      mockFirebaseUser = MockFirebaseUser();

      when(mockFirebaseUser.uid).thenReturn('1');
      when(mockFirebaseUser.displayName).thenReturn('firstName lastName');
      when(mockFirebaseUser.email).thenReturn('email@email.com');
      when(mockFirebaseUser.photoURL).thenReturn('photoURL');

      mockUserCredential = MockUserCredential();

      when(mockUserCredential.user).thenReturn(mockFirebaseUser);

      mockOAuthCredential = MockOAuthCredential();

      when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
    });

    test('throwsAssertionError when authService is null', () {
      expect(
        () => FirebaseAuthService(
          authService: null,
          signInServiceFactory: mockSignInServiceFactory,
        ),
        throwsAssertionError,
      );
    });

    test('throwsAssertionError when signInServiceFactory is null', () {
      expect(
        () => FirebaseAuthService(
          authService: mockFirebaseAuth,
          signInServiceFactory: null,
        ),
        throwsAssertionError,
      );
    });

    group('.signInAnonymously', () {
      test('succeeds when authService.signInAnonymously succeeds', () {
        when(mockFirebaseAuth.signInAnonymously())
            .thenAnswer((_) async => mockUserCredential);

        expect(subject.signInAnonymously(), completes);
      });

      test('fails when authService.signInAnonymously throws', () {
        when(mockFirebaseAuthException.code).thenReturn('');

        when(mockFirebaseAuth.signInAnonymously())
            .thenThrow(mockFirebaseAuthException);

        expect(
          subject.signInAnonymously(),
          throwsA(AuthError.ERROR),
        );
      });
    });

    group('.signInWithEmailAndPassword', () {
      const email = 'email@gmail.com';
      const password = 'Password01';

      test('throwsAssertionError when email is null', () {
        expect(
          subject.signInWithEmailAndPassword(
            email: null,
            password: password,
          ),
          throwsAssertionError,
        );
      });

      test('throwsAssertionError when password is null', () {
        expect(
          subject.signInWithEmailAndPassword(
            email: email,
            password: null,
          ),
          throwsAssertionError,
        );
      });

      test(
        'succeeds when authService.signInWithEmailAndPassword succeeds',
        () {
          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          expect(
            subject.signInWithEmailAndPassword(
              email: email,
              password: password,
            ),
            completes,
          );
        },
      );

      test(
        'fails when authService.signInWithEmailAndPassword throws',
        () {
          when(mockFirebaseAuthException.code)
              .thenReturn('email-already-in-use');

          when(
            mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenThrow(mockFirebaseAuthException);

          expect(
            subject.signInWithEmailAndPassword(
              email: email,
              password: password,
            ),
            throwsA(AuthError.EMAIL_ALREADY_IN_USE),
          );
        },
      );
    });

    group('.createUserWithEmailAndPassword', () {
      const firstName = 'firstName';
      const lastName = 'lastName';
      const email = 'email@gmail.com';
      const password = 'Password01';

      test('throwsAssertionError when firstName is null', () {
        expect(
          () => subject.createUserWithEmailAndPassword(
            name: null,
            lastName: lastName,
            email: email,
            password: password,
          ),
          throwsAssertionError,
        );
      });

      test('throwsAssertionError when lastName is null', () {
        expect(
          () => subject.createUserWithEmailAndPassword(
            name: firstName,
            lastName: null,
            email: email,
            password: password,
          ),
          throwsAssertionError,
        );
      });

      test('throwsAssertionError when email is null', () {
        expect(
          () => subject.createUserWithEmailAndPassword(
            name: firstName,
            lastName: lastName,
            email: null,
            password: password,
          ),
          throwsAssertionError,
        );
      });

      test('throwsAssertionError when password is null', () {
        expect(
          () => subject.createUserWithEmailAndPassword(
            name: firstName,
            lastName: lastName,
            email: email,
            password: null,
          ),
          throwsAssertionError,
        );
      });

      test(
        'succeeds when authService.createUserWithEmailAndPassword succeeds',
        () {
          when(
            mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenAnswer((_) async => mockUserCredential);

          expect(
            subject.createUserWithEmailAndPassword(
              name: firstName,
              lastName: lastName,
              email: email,
              password: password,
            ),
            completes,
          );
        },
      );

      test(
        'fails when authService.createUserWithEmailAndPassword throws',
        () {
          when(mockFirebaseAuthException.code)
              .thenReturn('account-exists-with-different-credential');

          when(
            mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            ),
          ).thenThrow(mockFirebaseAuthException);

          expect(
            subject.createUserWithEmailAndPassword(
              name: firstName,
              lastName: lastName,
              email: email,
              password: password,
            ),
            throwsA(AuthError.EMAIL_ALREADY_IN_USE),
          );
        },
      );
    });

    group('.sendPasswordResetEmail', () {
      const email = 'email@gmail.com';

      test('throwsAssertionError when email is null', () {
        expect(
          () => subject.sendPasswordResetEmail(email: null),
          throwsAssertionError,
        );
      });

      test('succeeds when authService.sendPasswordResetEmail succeeds', () {
        when(mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .thenAnswer((_) async => null);

        expect(subject.sendPasswordResetEmail(email: email), completes);
      });

      test('fails when authService.sendPasswordResetEmail throws', () {
        when(mockFirebaseAuthException.code).thenReturn('user-not-found');

        when(mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .thenThrow(mockFirebaseAuthException);

        expect(
          subject.sendPasswordResetEmail(email: email),
          throwsA(AuthError.USER_NOT_FOUND),
        );
      });
    });

    group('.signInWithSocialMedia', () {
      const method = SocialMediaMethod.GOOGLE;

      test('throwsAssertionError when method is null', () {
        expect(
          () => subject.signInWithSocialMedia(method: null),
          throwsAssertionError,
        );
      });

      test('succeeds when signInWithCredential succeeds', () {
        when(mockSignInServiceFactory.getService(method: method))
            .thenReturn(mockISignInService);

        when(mockISignInService.getFirebaseCredential())
            .thenAnswer((_) async => mockOAuthCredential);

        when(mockFirebaseAuth.signInWithCredential(mockOAuthCredential))
            .thenAnswer((_) async => mockUserCredential);

        expect(
          subject.signInWithSocialMedia(method: method),
          completes,
        );
      });

      test('fails when signInService.getFirebaseCredential throws', () {
        when(mockSignInServiceFactory.getService(method: method))
            .thenReturn(mockISignInService);

        when(mockFirebaseAuthException.code).thenReturn('invalid-credential');

        when(mockISignInService.getFirebaseCredential())
            .thenThrow(mockFirebaseAuthException);

        expect(
          subject.signInWithSocialMedia(method: method),
          throwsA(AuthError.INVALID_CREDENTIAL),
        );
      });

      test('fails when authService.signInWithCredential throws', () {
        when(mockSignInServiceFactory.getService(method: method))
            .thenReturn(mockISignInService);

        when(mockISignInService.getFirebaseCredential())
            .thenAnswer((_) async => mockOAuthCredential);

        when(mockFirebaseAuthException.code).thenReturn('invalid-credential');

        when(mockFirebaseAuth.signInWithCredential(mockOAuthCredential))
            .thenThrow(mockFirebaseAuthException);

        expect(
          subject.signInWithSocialMedia(method: method),
          throwsA(AuthError.INVALID_CREDENTIAL),
        );
      });
    });

    group('.signOut', () {
      test('succeeds when authService.signOut succeeds', () {
        expect(subject.signOut(), completes);
      });
    });

    group('.changeProfile', () {
      const firstName = 'firstNameUpdated';
      const lastName = 'lastNameUpdated';
      const photoURL = 'photoURLUpdated';

      test(
        'succeeds when user.updateDisplayName '
        'user.updatePhotoURL succeeds',
        () {
          when(mockFirebaseUser.updateDisplayName('$firstName $lastName'))
              .thenAnswer((_) async => null);
          when(mockFirebaseUser.updatePhotoURL(photoURL))
              .thenAnswer((_) async => null);

          expect(
            subject.changeProfile(
              firstName: firstName,
              lastName: lastName,
              photoURL: photoURL,
            ),
            completes,
          );
        },
      );

      test(
        'fails when user.updateDisplayName throws',
        () {
          when(mockFirebaseAuthException.code).thenReturn('');

          when(mockFirebaseUser.updateDisplayName('$firstName $lastName'))
              .thenThrow(mockFirebaseAuthException);

          expect(
            subject.changeProfile(
              firstName: firstName,
              lastName: lastName,
              photoURL: photoURL,
            ),
            throwsA(AuthError.ERROR),
          );
        },
      );

      test(
        'fails when user.updatePhotoURL throws',
        () {
          when(mockFirebaseAuthException.code).thenReturn('');

          when(mockFirebaseUser.updatePhotoURL(photoURL))
              .thenThrow(mockFirebaseAuthException);

          expect(
            subject.changeProfile(
              firstName: firstName,
              lastName: lastName,
              photoURL: photoURL,
            ),
            throwsA(AuthError.ERROR),
          );
        },
      );
    });

    group('.deleteAccount', () {
      test('succeeds when user.delete succeeds', () {
        expect(subject.deleteAccount(), completes);
      });

      test('fails when user.delete throws', () {
        when(mockFirebaseAuthException.code).thenReturn('');
        when(mockFirebaseUser.delete()).thenThrow(mockFirebaseAuthException);

        expect(
          subject.deleteAccount(),
          throwsA(AuthError.ERROR),
        );
      });
    });
  });
}
