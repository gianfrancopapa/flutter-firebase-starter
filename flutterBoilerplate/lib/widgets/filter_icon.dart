import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/screens/filter_employees_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class FilterIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 20.0),
        child: GestureDetector(
          onTap: () => showMaterialModalBottomSheet(
            context: context,
            builder: (context) => FilterEmployeesScreen(),
          ),
          child: const Icon(
            Icons.filter_list,
            color: Colors.white,
          ),
        ),
      );
}
