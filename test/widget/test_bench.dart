import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import './employees/mocks/employees_widget_mocks.dart';

extension TestBench on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    EmployeesRepository employeesRepository,
    TargetPlatform platform,
    bool hasScaffold = true,
  }) async {
    assert(widgetUnderTest != null);
    await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => EmployeesBloc(
              employeesRepository ?? MockEmployeesRepository,
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
          home: hasScaffold
                  ? Scaffold(body: widgetUnderTest)
                  : widgetUnderTest,
        ),
      ),
    );
    await pump();
  }
}
