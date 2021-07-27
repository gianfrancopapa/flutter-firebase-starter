import 'package:firebasestarter/employees/employees.dart';
import 'package:firebasestarter/home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/user_profile/user_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const HomeScreen(),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;

  Widget _bottomNavigationBar() {
    return StarterBottomNavigationBar(
      index: _index,
      updateIndex: (int index) => setState(() => _index = index),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: _index == 0
          ? EmployeesScreen(bottomNavigationBar: _bottomNavigationBar())
          : UserProfileScreen(bottomNavigationBar: _bottomNavigationBar()),
    );
  }
}
