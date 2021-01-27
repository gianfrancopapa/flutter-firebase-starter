import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/models/domain/admin.dart';
import 'package:flutterBoilerplate/models/domain/user.dart';
import 'package:flutterBoilerplate/widgets/employees_list_with_filters.dart';
import 'package:flutterBoilerplate/widgets/filter_icon.dart';
import 'package:flutterBoilerplate/widgets/settings.dart';
import 'package:flutterBoilerplate/screens/user_profile_screen.dart';
import 'package:flutterBoilerplate/widgets/bottom_navigation_bar.dart';
import 'package:flutterBoilerplate/widgets/menu_button.dart';

class MainScreen extends StatefulWidget {
  final User user;
  const MainScreen(this.user);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _screen = 'screen';
  static const _title = 'title';
  int _index;

  List<Map<String, dynamic>> _embbededScreensData;

  @override
  void initState() {
    _index = 0;
    _embbededScreensData = [
      {
        _screen: EmployeesListWithFilter(widget.user.runtimeType == Admin),
        _title: AppString.employees
      },
      {_screen: Settings(), _title: AppString.settings},
    ];
    super.initState();
  }

  void _changeScreen(int index) => setState(() => _index = index);

  Widget _showAdminButton() => widget.user.runtimeType == Admin
      ? FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => MenuButton(),
          ),
        )
      : const SizedBox(
          height: 0,
          width: 0,
        );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blueGrey,
          title: Text(_embbededScreensData[_index][_title]),
          actions: <Widget>[
            FilterIcon(),
            IconButton(
              icon: const Icon(Icons.supervised_user_circle),
              tooltip: AppString.myProfile,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              ),
            )
          ],
        ),
        body: _embbededScreensData[_index][_screen],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _showAdminButton(),
        bottomNavigationBar: BottomNavBar(_index, _changeScreen),
      );
}
