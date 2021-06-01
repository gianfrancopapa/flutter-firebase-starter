import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:firebasestarter/screens/team/team_screen.dart';
import 'package:firebasestarter/widgets/team/employees_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import '../test_bench.dart';
import '../test_bench_mocks.dart';

void main() {
  final employeesRepository = MockEmployeesRepository();
  final testEmployee = EmployeeEntity.fromJson({
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
  EmployeesBloc employeesBloc;

  setUpAll(() {
    employeesBloc = MockEmployeesBloc();
  });

  testWidgets('Employees load correctly', (WidgetTester tester) async {
    final employeesEntityList = [testEmployee];

    when(employeesRepository.getAll())
        .thenAnswer((_) async => employeesEntityList);

    await tester.pumpApp(TeamScreen(),
        employeesRepository: employeesRepository);

    expect(find.text('testName testLastName'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('No employees found'), findsNothing);
  });

  testWidgets('Employees load empty', (WidgetTester tester) async {
    // ignore: omit_local_variable_types
    final List<EmployeeEntity> employeesEntityList = [];

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
    final employeesEntityList = [testEmployee];
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
