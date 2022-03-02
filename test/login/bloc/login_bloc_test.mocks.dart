// Mocks generated by Mockito 5.1.0 from annotations
// in firebasestarter/test/login/bloc/login_bloc_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:auth/auth.dart' as _i3;
import 'package:firebasestarter/services/analytics/analytics_service.dart'
    as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [AnalyticsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAnalyticsService extends _i1.Mock implements _i2.AnalyticsService {
  MockAnalyticsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  void logAppOpen() => super.noSuchMethod(Invocation.method(#logAppOpen, []),
      returnValueForMissingStub: null);
  @override
  void logTutorialBegin() =>
      super.noSuchMethod(Invocation.method(#logTutorialBegin, []),
          returnValueForMissingStub: null);
  @override
  void logTutorialComplete() =>
      super.noSuchMethod(Invocation.method(#logTutorialComplete, []),
          returnValueForMissingStub: null);
  @override
  void logSignUp(String? method) =>
      super.noSuchMethod(Invocation.method(#logSignUp, [method]),
          returnValueForMissingStub: null);
  @override
  void logLogin(String? method) =>
      super.noSuchMethod(Invocation.method(#logLogin, [method]),
          returnValueForMissingStub: null);
  @override
  void logLogout() => super.noSuchMethod(Invocation.method(#logLogout, []),
      returnValueForMissingStub: null);
  @override
  void logEvent({String? name, Map<String, dynamic>? parameters}) =>
      super.noSuchMethod(
          Invocation.method(
              #logEvent, [], {#name: name, #parameters: parameters}),
          returnValueForMissingStub: null);
}

/// A class which mocks [FirebaseAuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseAuthService extends _i1.Mock
    implements _i3.FirebaseAuthService {
  MockFirebaseAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i3.UserEntity?> get onAuthStateChanged =>
      (super.noSuchMethod(Invocation.getter(#onAuthStateChanged),
              returnValue: Stream<_i3.UserEntity?>.empty())
          as _i4.Stream<_i3.UserEntity?>);
  @override
  _i4.Future<_i3.UserEntity?> currentUser() =>
      (super.noSuchMethod(Invocation.method(#currentUser, []),
              returnValue: Future<_i3.UserEntity?>.value())
          as _i4.Future<_i3.UserEntity?>);
  @override
  _i4.Future<_i3.UserEntity?> signInAnonymously() =>
      (super.noSuchMethod(Invocation.method(#signInAnonymously, []),
              returnValue: Future<_i3.UserEntity?>.value())
          as _i4.Future<_i3.UserEntity?>);
  @override
  _i4.Future<_i3.UserEntity?> signInWithEmailAndPassword(
          {String? email, String? password}) =>
      (super.noSuchMethod(
              Invocation.method(#signInWithEmailAndPassword, [],
                  {#email: email, #password: password}),
              returnValue: Future<_i3.UserEntity?>.value())
          as _i4.Future<_i3.UserEntity?>);
  @override
  _i4.Future<_i3.UserEntity?> createUserWithEmailAndPassword(
          {String? name, String? lastName, String? email, String? password}) =>
      (super.noSuchMethod(
              Invocation.method(#createUserWithEmailAndPassword, [], {
                #name: name,
                #lastName: lastName,
                #email: email,
                #password: password
              }),
              returnValue: Future<_i3.UserEntity?>.value())
          as _i4.Future<_i3.UserEntity?>);
  @override
  _i4.Future<void>? sendPasswordResetEmail({String? email}) =>
      (super.noSuchMethod(
              Invocation.method(#sendPasswordResetEmail, [], {#email: email}),
              returnValueForMissingStub: Future<void>.value())
          as _i4.Future<void>?);
  @override
  _i4.Future<_i3.UserEntity?> signInWithSocialMedia(
          {_i3.AuthenticationMethod? method}) =>
      (super.noSuchMethod(
              Invocation.method(#signInWithSocialMedia, [], {#method: method}),
              returnValue: Future<_i3.UserEntity?>.value())
          as _i4.Future<_i3.UserEntity?>);
  @override
  _i4.Future<void> sendSignInLinkToEmail({String? email}) =>
      (super.noSuchMethod(
          Invocation.method(#sendSignInLinkToEmail, [], {#email: email}),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i3.UserEntity?> signInWithEmailLink(
          {dynamic email, dynamic emailLink}) =>
      (super.noSuchMethod(
          Invocation.method(
              #signInWithEmailLink, [], {#email: email, #emailLink: emailLink}),
          returnValue:
              Future<_i3.UserEntity?>.value()) as _i4.Future<_i3.UserEntity?>);
  @override
  bool isSignInWithEmailLink({String? emailLink}) => (super.noSuchMethod(
      Invocation.method(#isSignInWithEmailLink, [], {#emailLink: emailLink}),
      returnValue: false) as bool);
  @override
  _i4.Future<void>? signOut() => (super.noSuchMethod(
      Invocation.method(#signOut, []),
      returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>?);
  @override
  _i4.Future<void>? deleteAccount(String? password) => (super.noSuchMethod(
      Invocation.method(#deleteAccount, [password]),
      returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>?);
  @override
  _i4.Future<void>? deleteAccountSocialMedia(
          _i3.AuthenticationMethod? method) =>
      (super.noSuchMethod(
              Invocation.method(#deleteAccountSocialMedia, [method]),
              returnValueForMissingStub: Future<void>.value())
          as _i4.Future<void>?);
}

/// A class which mocks [UserEntity].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserEntity extends _i1.Mock implements _i3.UserEntity {
  MockUserEntity() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<Object?> get props =>
      (super.noSuchMethod(Invocation.getter(#props), returnValue: <Object?>[])
          as List<Object?>);
  @override
  bool get stringify =>
      (super.noSuchMethod(Invocation.getter(#stringify), returnValue: false)
          as bool);
  @override
  Map<String, dynamic> toJson() =>
      (super.noSuchMethod(Invocation.method(#toJson, []),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
}
