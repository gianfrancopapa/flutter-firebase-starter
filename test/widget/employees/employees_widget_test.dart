import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:firebasestarter/screens/team/team_screen.dart';
import 'package:firebasestarter/widgets/team/employees_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mocktail/mocktail.dart' as mocktail;

import 'package:repository/repository.dart';
import '../test_bench.dart';
import '../test_bench_mocks.dart';

class FakeEmployeesEvent extends Fake implements EmployeesEvent {}

class FakeEmployeesState extends Fake implements EmployeesState {}

void main() {
  EmployeesRepository employeesRepository;
  List<EmployeeEntity> employeesEntityList;
  EmployeeEntity testEmployee;
  EmployeesBloc employeesBloc;

  setUpAll(() {
    mocktail.registerFallbackValue<EmployeesState>(FakeEmployeesState());
    mocktail.registerFallbackValue<EmployeesEvent>(FakeEmployeesEvent());

    employeesRepository = MockEmployeesRepository();
    testEmployee = EmployeeEntity.fromJson({
      'firstName': 'testName',
      'lastName': 'testLastName',
      'email': 'testEmail',
      'avatarAsset': 'testAvatar',
      'role': 'user',
      'age': 20,
      'address': 'testAddress',
      'phoneNumber': '098123456',
      'description': 'testDescription',
    });
    employeesBloc = MockEmployeesBloc();
  });

  testWidgets('Employees load correctly', (WidgetTester tester) async {
    employeesEntityList = [testEmployee];

    when(employeesRepository.getAll())
        .thenAnswer((_) async => employeesEntityList);

    await tester.pumpApp(TeamScreen(),
        employeesRepository: employeesRepository);

    expect(find.text('testName testLastName'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('No employees found'), findsNothing);
  });

  testWidgets('Employees load empty', (WidgetTester tester) async {
    employeesEntityList = [];

    when(employeesRepository.getAll())
        .thenAnswer((_) async => employeesEntityList);

    await tester.pumpApp(TeamScreen(),
        employeesRepository: employeesRepository);

    expect(find.byType(EmployeesList), findsNothing);
    expect(find.text('No employees found'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Bloc emits EmployeesLoadEmpty, screen shows message',
      (WidgetTester tester) async {
    const loadingState = EmployeesLoadEmpty();
    whenListen(
      employeesBloc,
      Stream.value(loadingState),
    );

    await tester.pumpApp(TeamScreen(), employeesBloc: employeesBloc);

    expect(find.byType(EmployeesList), findsNothing);
    expect(find.text('No employees found'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Bloc emits EmployeesLoadSuccess, screen shows EmployeesList',
      (WidgetTester tester) async {
    employeesEntityList = [testEmployee];
    final employeesList = employeesEntityList
        .map((employee) => Employee.fromEntity(employee))
        .toList();

    final loadingState = EmployeesLoadSuccess(employeesList);

    whenListen(
      employeesBloc,
      Stream.value(loadingState),
    );

    await tester.pumpApp(TeamScreen(), employeesBloc: employeesBloc);

    expect(find.byType(EmployeesList), findsOneWidget);
    expect(find.text('No employees found'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets(
      'Bloc emits EmployeesInitial, screen shows CircularProgressIndicator',
      (WidgetTester tester) async {
    const loadingState = EmployeesInitial();
    whenListen(
      employeesBloc,
      Stream.value(loadingState),
    );

    await tester.pumpApp(TeamScreen(), employeesBloc: employeesBloc);

    expect(find.byType(EmployeesList), findsNothing);
    expect(find.text('No employees found'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'Bloc emits EmployeesLoadInProgress, screen shows CircularProgressIndicator',
      (WidgetTester tester) async {
    const loadingState = EmployeesLoadInProgress();
    whenListen(
      employeesBloc,
      Stream.value(loadingState),
    );

    await tester.pumpApp(TeamScreen(), employeesBloc: employeesBloc);

    expect(find.byType(EmployeesList), findsNothing);
    expect(find.text('No employees found'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets(
      'Bloc emits EmployeesLoadFailure, screen shows CircularProgressIndicator',
      (WidgetTester tester) async {
    const loadingState = EmployeesLoadFailure('error');
    whenListen(
      employeesBloc,
      Stream.value(loadingState),
    );

    await tester.pumpApp(TeamScreen(), employeesBloc: employeesBloc);

    expect(find.byType(EmployeesList), findsNothing);
    expect(find.text('No employees found'), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
