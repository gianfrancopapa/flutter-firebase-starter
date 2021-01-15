import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/users/users_bloc.dart';
import 'package:flutterBoilerplate/bloc/users/users_event.dart';
import 'package:flutterBoilerplate/bloc/users/users_state.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/screens/configuration_screen.dart';
import 'package:flutterBoilerplate/screens/user_profile_screen.dart';
import 'package:flutterBoilerplate/widgets/common/widgets_list.dart';
import 'package:flutterBoilerplate/widgets/user_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _bloc = UsersBloc();

  @override
  void initState() {
    _bloc.add(const GetUsers(null));
    super.initState();
  }

  Widget _presentData(BuildContext context, UsersState state) {
    switch (state.runtimeType) {
      case Loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case Error:
        return Center(
          child: Text((state as Error).message),
        );
      case Users:
        return WidgetsList(
          children:
              (state as Users).users.map((user) => UserCard(user)).toList(),
        );
      default:
        return const Center(
          child: Text('Error: Invalid state in [main_screen.dart]'),
        );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey,
          title: const Text(AppString.users),
          actions: <Widget>[
            CustomButton(const Icon(Icons.miscellaneous_services_rounded),
                AppString.configuration, context, ConfigurationScreen()),
            CustomButton(const Icon(Icons.supervised_user_circle),
                AppString.myProfile, context, ProfileScreen()),
          ],
        ),
        body: BlocBuilder<UsersBloc, UsersState>(
          cubit: _bloc,
          builder: _presentData,
        ),
      );

  Widget CustomButton(
      Icon icon, String tooltip, BuildContext context, Widget screen) {
    return IconButton(
      icon: icon,
      tooltip: tooltip,
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      ),
    );
  }
}
