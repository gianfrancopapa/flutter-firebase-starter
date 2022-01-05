import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/employees/employees.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mockito/annotations.dart';
import 'package:repository/repository.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_bench.mocks.dart';

@GenerateMocks(
    [EmployeesRepository, AppBloc, LoginBloc, UserBloc, EmployeesBloc])
extension TestBench on WidgetTester {
  Future<void> pumpApp(
    Widget widgetUnderTest, {
    EmployeesRepository? employeesRepository,
    AppBloc? initAppBloc,
    LoginBloc? loginBloc,
    UserBloc? userBloc,
    EmployeesBloc? employeesBloc,
    TargetPlatform? platform,
    bool hasScaffold = true,
  }) async {
    await pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AppBloc>(
            create: (_) {
              final bloc = initAppBloc ?? MockAppBloc();
              return bloc..add(const AppIsFirstTimeLaunched());
            },
          ),
          BlocProvider<LoginBloc>(
            create: (_) {
              final bloc = loginBloc ?? MockLoginBloc();
              return bloc;
            },
          ),
          BlocProvider<UserBloc>(
            create: (_) {
              final bloc = userBloc ?? MockUserBloc();
              return bloc..add(const UserLoaded());
            },
          ),
          BlocProvider<EmployeesBloc>(
            create: (_) {
              final bloc = employeesBloc ??
                  EmployeesBloc(
                    employeesRepository ?? MockEmployeesRepository(),
                  );
              return bloc..add(const EmployeesLoaded());
            },
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: hasScaffold ? Scaffold(body: widgetUnderTest) : widgetUnderTest,
        ),
      ),
    );
    await pump();
  }
}
