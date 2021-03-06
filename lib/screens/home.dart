import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/screens/team/team_screen.dart';
import 'package:firebasestarter/widgets/home/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/screens/profile/user_profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen(this.user);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index;
  List<Widget> _screens;

  @override
  void initState() {
    _index = 0;
    _screens = [
      BlocProvider(
        create: (context) => EmployeesBloc()..add(const EmployeesLoaded()),
        child: TeamScreen(),
      ),
      BlocProvider(
          create: (_) => UserBloc()..add(const UserLoaded()),
          child: ProfileScreen())
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _screens[_index],
        backgroundColor: AppColor.lightGrey,
        bottomNavigationBar: BottomNavBar(
          _index,
          (int index) => setState(() => _index = index),
        ),
      );
}
