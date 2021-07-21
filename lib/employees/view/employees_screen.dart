import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/employees/employees.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/team/employees_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        goBack: false,
        title: localizations.employees,
      ),
      backgroundColor: AppColor.lightGrey,
      body: const _EmployeesList(
        key: Key('employeesScreen_employeesList'),
      ),
    );
  }
}

class _EmployeesList extends StatelessWidget {
  const _EmployeesList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final state = context.watch<EmployeesBloc>().state;

    if (state.status == EmployeesStatus.success) {
      if (state.employees.isEmpty) {
        return Center(
          child: Text(
            localizations.noEmployees,
            style: const TextStyle(fontSize: 20),
          ),
        );
      }

      return EmployeesList(state.employees);
    }

    return const Center(child: CircularProgressIndicator());
  }
}
