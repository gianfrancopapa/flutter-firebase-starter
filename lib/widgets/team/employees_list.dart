import 'package:firebasestarter/models/employee.dart';
import 'package:firebasestarter/widgets/team/employee_card.dart';
import 'package:flutter/material.dart';

class EmployeesList extends StatelessWidget {
  final List<Employee> employees;

  const EmployeesList(this.employees);

  @override
  Widget build(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.fromLTRB(44.0, 22.0, 44.0, 0.0),
        itemCount: employees?.length ?? 0,
        itemBuilder: (BuildContext context, int i) => EmployeeCard(
          employees[i],
        ),
      );
}
