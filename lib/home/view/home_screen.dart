import 'package:firebasestarter/constants/colors.dart';
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
  int _index;
  List<Widget> _screens;

  @override
  void initState() {
    _index = 0;
    _screens = [
      const EmployeesScreen(),
      const UserProfileScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      backgroundColor: AppColor.lightGrey,
      bottomNavigationBar: StarterBottomNavigationBar(
        index: _index,
        updateIndex: (int index) => setState(() => _index = index),
      ),
    );
  }
}
