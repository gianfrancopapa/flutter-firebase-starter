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
                      Row(
                        children: [
                          const Card(
                            child: Text(
                              AppString.fstName,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            user.firstName,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const Card(
                            child: Text(
                              AppString.lstName,
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            user.lastName,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Card(
                            child: Text(
                              AppString.email,
                              style: const TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            user.email,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        ],
                      ),
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
}
