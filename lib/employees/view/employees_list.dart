import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/gen/assets.gen.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:flutter/material.dart';

class EmployeesList extends StatelessWidget {
  const EmployeesList({Key? key, required this.employees}) : super(key: key);

  final List<Employee> employees;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: FSSpacing.s40),
      itemCount: employees.length,
      itemBuilder: (_, i) => _EmployeeCard(employee: employees[i]),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard({required this.employee});

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: FSSpacing.s20),
      decoration: BoxDecoration(
        color: FSColors.white,
        borderRadius: BorderRadius.circular(FSSpacing.s4),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: FSColors.black.withOpacity(0.3),
            offset: const Offset(FSSpacing.s0, FSSpacing.s4),
            blurRadius: FSSpacing.s2,
          ),
        ],
      ),
      child: FSListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: FSSpacing.s6,
          horizontal: FSSpacing.s20,
        ),
        leading: _EmployeeImage(
          employee: employee,
        ),
        title: Center(
          child: _EmployeeDisplayName(
            employee: employee,
          ),
        ),
      ),
    );
  }
}

class _EmployeeImage extends StatelessWidget {
  const _EmployeeImage({Key? key, required this.employee}) : super(key: key);

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: FSSpacing.s40,
      width: FSSpacing.s40,
      decoration: BoxDecoration(
        color: FSColors.white,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: (employee.isAvatarFromNetwork
              ? NetworkImage(employee.avatarAsset!)
              : AssetImage(Assets.packages.firebaseStarterUi.assets.images
                  .anonLogin.path)) as ImageProvider<Object>,
        ),
      ),
    );
  }
}

class _EmployeeDisplayName extends StatelessWidget {
  const _EmployeeDisplayName({Key? key, required this.employee})
      : super(key: key);

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Text(
      employee.firstName! + ' ' + employee.lastName!,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: FSColors.black,
        fontSize: FSSpacing.s16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
