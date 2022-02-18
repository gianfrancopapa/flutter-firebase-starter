// Mocks generated by Mockito 5.1.0 from annotations
// in firebasestarter/test/user/bloc/user_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: must_be_immutable

import 'dart:async' as _i3;

import 'package:auth/auth.dart' as _i2;
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

/// A class which mocks [AuthService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthService extends _i1.Mock implements _i2.AuthService {
  MockAuthService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i2.UserEntity?> get onAuthStateChanged =>
      (super.noSuchMethod(Invocation.getter(#onAuthStateChanged),
              returnValue: Stream<_i2.UserEntity?>.empty())
          as _i3.Stream<_i2.UserEntity?>);
  @override
  _i3.Future<_i2.UserEntity?> currentUser() =>
      (super.noSuchMethod(Invocation.method(#currentUser, []),
              returnValue: Future<_i2.UserEntity?>.value())
          as _i3.Future<_i2.UserEntity?>);
  @override
  _i3.Future<_i2.UserEntity?> signInAnonymously() =>
      (super.noSuchMethod(Invocation.method(#signInAnonymously, []),
              returnValue: Future<_i2.UserEntity?>.value())
          as _i3.Future<_i2.UserEntity?>);
  @override
  _i3.Future<_i2.UserEntity?> signInWithEmailAndPassword(
          {String? email, String? password}) =>
      (super.noSuchMethod(
              Invocation.method(#signInWithEmailAndPassword, [],
                  {#email: email, #password: password}),
              returnValue: Future<_i2.UserEntity?>.value())
          as _i3.Future<_i2.UserEntity?>);
  @override
  _i3.Future<_i2.UserEntity?> createUserWithEmailAndPassword(
          {String? name, String? lastName, String? email, String? password}) =>
      (super.noSuchMethod(
              Invocation.method(#createUserWithEmailAndPassword, [], {
                #name: name,
                #lastName: lastName,
                #email: email,
                #password: password
              }),
              returnValue: Future<_i2.UserEntity?>.value())
          as _i3.Future<_i2.UserEntity?>);
  @override
  _i3.Future<void>? sendPasswordResetEmail({String? email}) =>
      (super.noSuchMethod(
              Invocation.method(#sendPasswordResetEmail, [], {#email: email}),
              returnValueForMissingStub: Future<void>.value())
          as _i3.Future<void>?);
  @override
  _i3.Future<_i2.UserEntity?> signInWithSocialMedia(
          {_i2.SocialMediaMethod? method}) =>
      (super.noSuchMethod(
              Invocation.method(#signInWithSocialMedia, [], {#method: method}),
              returnValue: Future<_i2.UserEntity?>.value())
          as _i3.Future<_i2.UserEntity?>);
  @override
  _i3.Future<void>? signOut() => (super.noSuchMethod(
      Invocation.method(#signOut, []),
      returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>?);
  @override
  _i3.Future<void>? deleteAccount(String? password) => (super.noSuchMethod(
      Invocation.method(#deleteAccount, [password]),
      returnValueForMissingStub: Future<void>.value()) as _i3.Future<void>?);
}

/// A class which mocks [UserEntity].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserEntity extends _i1.Mock implements _i2.UserEntity {
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
