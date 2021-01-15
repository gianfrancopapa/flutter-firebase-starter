import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/app.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    BlocProvider(
      create: (context) => LoginBloc(),
      child: App(),
    ),
  );
}
