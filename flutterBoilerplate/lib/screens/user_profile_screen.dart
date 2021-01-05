import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/user/user_bloc.dart';
import 'package:flutterBoilerplate/bloc/user/user_event.dart';
import 'package:flutterBoilerplate/bloc/user/user_state.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc _bloc;
  @override
  void initState() {
    _bloc = UserBloc();
    _bloc.add(const GetUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
          cubit: _bloc,
          builder: (context, state) {
            switch (state.runtimeType) {
              case Loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case Error:
                return Center(
                  child: Text((state as Error).message.toString()),
                );
              case CurrentUser:
                final user = (state as CurrentUser).user;
                return Container(
                  child: Column(
                    children: [
                      CustomRow(AppString.fstName, user.firstName),
                      CustomRow(AppString.lstName, user.lastName),
                      CustomRow(AppString.email, user.email),
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                  alignment: Alignment.centerRight,
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          }),
    );
  }

  Widget CustomRow(String cardText, String text) {
    return Row(
      children: [
        Card(
          child: Text(
            cardText,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 18.0),
        ),
      ],
    );
  }
}
