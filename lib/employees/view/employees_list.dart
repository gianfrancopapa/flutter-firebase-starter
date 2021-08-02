import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:firebasestarter/utils/screen_size.dart';
import 'package:flutter/material.dart';

class EmployeesList extends StatelessWidget {
  final List<Employee> employees;

  const EmployeesList({Key key, this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(44.0, 22.0, 44.0, 0.0),
        itemCount: employees?.length ?? 0,
        itemBuilder: (BuildContext context, int i) => _EmployeeCard(
          employees[i],
        ),
      );
}

class _EmployeeCard extends StatelessWidget {
  final Employee employee;
  final _screenSize = ScreenSize();
  _EmployeeCard(this.employee);

  Size _cardSize(BuildContext context) => _screenSize.getSize(
        context: context,
        designHeight: 63.0,
        designWidth: 287.0,
      );

  Widget _employeePhoto() => Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: FSColors.white,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: employee?.avatarAsset?.contains('http') ?? false
                ? NetworkImage(employee.avatarAsset)
                : const AssetImage(FSAssetImage.anonLogin),
          ),
        ),
      );

  Widget _employeName(BuildContext context) => Container(
        width: _cardSize(context).width / 1.8,
        alignment: Alignment.centerLeft,
        child: Text(
          employee.firstName + ' ' + employee.lastName,
          textAlign: TextAlign.start,
          style: const TextStyle(
            color: FSColors.black,
            fontSize: 15.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 22.0),
        margin: const EdgeInsets.only(bottom: 22.0),
        height: _cardSize(context).height,
        width: _cardSize(context).width,
        decoration: BoxDecoration(
          color: FSColors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: FSColors.black,
              offset: Offset(0.0, 5.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_employeePhoto(), _employeName(context)],
        ),
      );
}
