import 'package:flutter/material.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/screens/profile/user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen(this.user);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index;
  List<Widget> _screens;
  final _bottomNavBarItems = [
    const BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.home),
    ),
    const BottomNavigationBarItem(
      label: '',
      icon: Icon(Icons.settings),
    ),
  ];

  @override
  void initState() {
    _index = 0;
    _screens = [
      ProfileScreen(),
      ProfileScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _screens[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 22.0,
          selectedItemColor: Colors.teal,
          onTap: (index) => setState(() => _index = index),
          items: _bottomNavBarItems,
        ),
      );
}
