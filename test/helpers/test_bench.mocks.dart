// Mocks generated by Mockito 5.1.0 from annotations
// in firebasestarter/test/helpers/test_bench.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;

import 'package:firebasestarter/app/bloc/app_bloc.dart' as _i3;
import 'package:firebasestarter/authentication/login/bloc/login_bloc.dart'
    as _i4;
import 'package:firebasestarter/employees/bloc/employees_bloc.dart' as _i6;
import 'package:firebasestarter/user/bloc/user_bloc.dart' as _i5;
import 'package:flutter_bloc/flutter_bloc.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:repository/repository.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeIDatabase_0<T> extends _i1.Fake implements _i2.IDatabase<T> {}

class _FakeEmployeeEntity_1 extends _i1.Fake implements _i2.EmployeeEntity {}

class _FakeAppState_2 extends _i1.Fake implements _i3.AppState {}

class _FakeLoginState_3 extends _i1.Fake implements _i4.LoginState {}

class _FakeUserState_4 extends _i1.Fake implements _i5.UserState {}

class _FakeEmployeesState_5 extends _i1.Fake implements _i6.EmployeesState {}

/// A class which mocks [EmployeesRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockEmployeesRepository extends _i1.Mock
    implements _i2.EmployeesRepository {
  MockEmployeesRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.IDatabase<_i2.EmployeeEntity> get dataSource =>
      (super.noSuchMethod(Invocation.getter(#dataSource),
              returnValue: _FakeIDatabase_0<_i2.EmployeeEntity>())
          as _i2.IDatabase<_i2.EmployeeEntity>);
  @override
  set dataSource(_i2.IDatabase<_i2.EmployeeEntity>? _dataSource) =>
      super.noSuchMethod(Invocation.setter(#dataSource, _dataSource),
          returnValueForMissingStub: null);
  @override
  _i7.Future<List<_i2.EmployeeEntity>> getAll() => (super.noSuchMethod(
          Invocation.method(#getAll, []),
          returnValue:
              Future<List<_i2.EmployeeEntity>>.value(<_i2.EmployeeEntity>[]))
      as _i7.Future<List<_i2.EmployeeEntity>>);
  @override
  _i7.Future<_i2.EmployeeEntity> getById(String? id) =>
      (super.noSuchMethod(Invocation.method(#getById, [id]),
              returnValue:
                  Future<_i2.EmployeeEntity>.value(_FakeEmployeeEntity_1()))
          as _i7.Future<_i2.EmployeeEntity>);
  @override
  _i7.Future<void> post(_i2.EmployeeEntity? employee) =>
      (super.noSuchMethod(Invocation.method(#post, [employee]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> put(_i2.EmployeeEntity? employee) =>
      (super.noSuchMethod(Invocation.method(#put, [employee]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  _i7.Future<void> delete(_i2.EmployeeEntity? employee) =>
      (super.noSuchMethod(Invocation.method(#delete, [employee]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
}

/// A class which mocks [AppBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppBloc extends _i1.Mock implements _i3.AppBloc {
  MockAppBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.AppState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeAppState_2()) as _i3.AppState);
  @override
  _i7.Stream<_i3.AppState> get stream => (super.noSuchMethod(
      Invocation.getter(#stream),
      returnValue: Stream<_i3.AppState>.empty()) as _i7.Stream<_i3.AppState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  _i7.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  void add(_i3.AppEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i3.AppEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i3.AppState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i3.AppEvent>(_i8.EventHandler<E, _i3.AppState>? handler,
          {_i8.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(_i8.Transition<_i3.AppEvent, _i3.AppState>? transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  void onChange(_i8.Change<_i3.AppState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}

/// A class which mocks [LoginBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginBloc extends _i1.Mock implements _i4.LoginBloc {
  MockLoginBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get passwordlessEmailKey =>
      (super.noSuchMethod(Invocation.getter(#passwordlessEmailKey),
          returnValue: '') as String);
  @override
  _i4.LoginState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeLoginState_3()) as _i4.LoginState);
  @override
  _i7.Stream<_i4.LoginState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i4.LoginState>.empty())
          as _i7.Stream<_i4.LoginState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i4.LoginEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i4.LoginEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i4.LoginState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i4.LoginEvent>(
          _i8.EventHandler<E, _i4.LoginState>? handler,
          {_i8.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i8.Transition<_i4.LoginEvent, _i4.LoginState>? transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  void onChange(_i8.Change<_i4.LoginState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}

/// A class which mocks [UserBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserBloc extends _i1.Mock implements _i5.UserBloc {
  MockUserBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.UserState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeUserState_4()) as _i5.UserState);
  @override
  _i7.Stream<_i5.UserState> get stream => (super.noSuchMethod(
      Invocation.getter(#stream),
      returnValue: Stream<_i5.UserState>.empty()) as _i7.Stream<_i5.UserState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i5.UserEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i5.UserEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i5.UserState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i5.UserEvent>(_i8.EventHandler<E, _i5.UserState>? handler,
          {_i8.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(_i8.Transition<_i5.UserEvent, _i5.UserState>? transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  void onChange(_i8.Change<_i5.UserState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}

/// A class which mocks [EmployeesBloc].
///
/// See the documentation for Mockito's code generation for more information.
class MockEmployeesBloc extends _i1.Mock implements _i6.EmployeesBloc {
  MockEmployeesBloc() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.EmployeesState get state => (super.noSuchMethod(Invocation.getter(#state),
      returnValue: _FakeEmployeesState_5()) as _i6.EmployeesState);
  @override
  _i7.Stream<_i6.EmployeesState> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: Stream<_i6.EmployeesState>.empty())
          as _i7.Stream<_i6.EmployeesState>);
  @override
  bool get isClosed =>
      (super.noSuchMethod(Invocation.getter(#isClosed), returnValue: false)
          as bool);
  @override
  void add(_i6.EmployeesEvent? event) =>
      super.noSuchMethod(Invocation.method(#add, [event]),
          returnValueForMissingStub: null);
  @override
  void onEvent(_i6.EmployeesEvent? event) =>
      super.noSuchMethod(Invocation.method(#onEvent, [event]),
          returnValueForMissingStub: null);
  @override
  void emit(_i6.EmployeesState? state) =>
      super.noSuchMethod(Invocation.method(#emit, [state]),
          returnValueForMissingStub: null);
  @override
  void on<E extends _i6.EmployeesEvent>(
          _i8.EventHandler<E, _i6.EmployeesState>? handler,
          {_i8.EventTransformer<E>? transformer}) =>
      super.noSuchMethod(
          Invocation.method(#on, [handler], {#transformer: transformer}),
          returnValueForMissingStub: null);
  @override
  void onTransition(
          _i8.Transition<_i6.EmployeesEvent, _i6.EmployeesState>? transition) =>
      super.noSuchMethod(Invocation.method(#onTransition, [transition]),
          returnValueForMissingStub: null);
  @override
  _i7.Future<void> close() => (super.noSuchMethod(Invocation.method(#close, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i7.Future<void>);
  @override
  void onChange(_i8.Change<_i6.EmployeesState>? change) =>
      super.noSuchMethod(Invocation.method(#onChange, [change]),
          returnValueForMissingStub: null);
  @override
  void addError(Object? error, [StackTrace? stackTrace]) =>
      super.noSuchMethod(Invocation.method(#addError, [error, stackTrace]),
          returnValueForMissingStub: null);
  @override
  void onError(Object? error, StackTrace? stackTrace) =>
      super.noSuchMethod(Invocation.method(#onError, [error, stackTrace]),
          returnValueForMissingStub: null);
}
