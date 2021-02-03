import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/models/domain/admin.dart';
import 'package:flutterBoilerplate/models/domain/user.dart';
import 'package:flutterBoilerplate/screens/employees_list_screen.dart';
import 'package:flutterBoilerplate/screens/user_profile_screen.dart';
import 'package:flutterBoilerplate/widgets/menu_button.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen(this.user);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
    final isAdmin = widget.user is Admin;
    _index = 0;
    _screens = [
      EmployeesListScreen(isAdmin),
      ProfileScreen(),
    ];
    if (isAdmin) {
      _screens.insert(1, Container());
      _bottomNavBarItems.insert(
        1,
        BottomNavigationBarItem(
          label: '',
          icon: IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => showMaterialModalBottomSheet(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => MenuButton(),
            ),
          ),
        ),
      );
    }
    super.initState();
  }

  void _changeScreen(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _screens[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 22.0,
          selectedItemColor: Colors.teal,
          onTap: _changeScreen,
          items: _bottomNavBarItems,
        ),
      );
}
