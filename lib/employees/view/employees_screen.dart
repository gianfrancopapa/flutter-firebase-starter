import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/employees/employees.dart';
import 'package:firebasestarter/l10n/l10n.dart';
import 'package:firebasestarter/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({Key? key, required this.bottomNavigationBar})
      : super(key: key);

  final Widget bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final _localizations = context.l10n;

    return Scaffold(
      appBar: CustomAppBar(
        goBack: false,
        title: _localizations.employees,
      ),
      backgroundColor: FSColors.lightGrey,
      body: const _EmployeesList(
        key: Key('employeesScreen_employeesList'),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class _EmployeesList extends StatelessWidget {
  const _EmployeesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _localizations = context.l10n;

    final state = context.watch<EmployeesBloc>().state;

    if (state.status == EmployeesStatus.success) {
      if (state.employees!.isEmpty) {
        return Center(
          child: Text(
            _localizations.noEmployees,
            style: const TextStyle(fontSize: 20),
          ),
        );
      }

      return EmployeesList(employees: state.employees!);
    }

    return const Center(child: CircularProgressIndicator());
  }
}
