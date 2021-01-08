import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/app.dart';
import 'package:flutterBoilerplate/bloc/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    BlocProvider(
      create: (context) => LoginBloc(),
      child: App(),
    ),
  );
}
