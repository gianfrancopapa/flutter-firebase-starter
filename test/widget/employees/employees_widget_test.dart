import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/screens/team/team_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';
import 'mocks/employees_widget_mocks.dart';

void main() {
  testWidgets('Employees load correctly', (WidgetTester tester) async {
    final mockEmployeesRepository = MockEmployeesRepository();
    final employeesList = [
      EmployeeEntity.fromJson({
        'firstName': 'testName',
        'lastName': 'testLastName',
        'email': 'testEmail',
        'avatarAsset': 'testAvatar',
        'role': 'user',
        'age': 20,
        'address': 'testAddress',
        'phoneNumber': '098123456',
        'description': 'testDescription',
      })
    ];

    when(mockEmployeesRepository.getAll())
        .thenAnswer((_) async => employeesList);

    await tester.pumpWidget(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EmployeesBloc(
            mockEmployeesRepository,
          )..add(const EmployeesLoaded()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: TeamScreen(),
      ),
    ));

    await tester.pump(const Duration(seconds: 3));
    expect(find.text('testName testLastName'), findsOneWidget);

    // await tester.enterText(finder, text)
    // await tester.tap(finder)

    // await tester.pump() //rebuilds widget

    // expect(actual, matcher);
  });
}
