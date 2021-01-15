import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/strings.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;
  const BottomNavBar(this.currentIndex, this.onIndexChanged);
  @override
  Widget build(BuildContext context) => BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onIndexChanged,
        items: [
          const BottomNavigationBarItem(
            label: AppString.home,
            icon: Icon(Icons.home),
          ),
          const BottomNavigationBarItem(
            label: AppString.settings,
            icon: Icon(Icons.settings),
          ),
        ],
      );
}
