import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/app.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_bloc.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        BlocProvider<FilterEmployeesBloc>(
          create: (BuildContext context) => FilterEmployeesBloc(),
        ),
      ],
      child: App(),
    ),
  );
}
