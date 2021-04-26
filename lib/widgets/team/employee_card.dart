import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:firebasestarter/utils/screen_size.dart';
import 'package:flutter/material.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final _screenSize = ScreenSize();
  EmployeeCard(this.employee);

  Size _cardSize(BuildContext context) => _screenSize.getSize(
        context: context,
        designHeight: 63.0,
        designWidth: 287.0,
      );

  Widget _employeePhoto() => Container(
        height: 40.0,
        width: 40.0,
        decoration: BoxDecoration(
          color: AppColor.white,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: employee?.avatarAsset?.contains('http') ?? false
                ? NetworkImage(employee.avatarAsset)
                : const AssetImage(Assets.anonLogin),
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
            color: Colors.black,
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
          color: AppColor.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: <BoxShadow>[
            const BoxShadow(
              color: Colors.black12,
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
