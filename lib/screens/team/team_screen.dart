import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/team/employees_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({Key key}) : super(key: key);

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
        key: Key('teamScreen_employeesList'),
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

    if (state.status == EmployeesStatus.loadSuccess) {
      return EmployeesList(state.employees);
    }

    if (state.status == EmployeesStatus.loadEmpty) {
      return Center(
        child: Text(
          localizations.noEmployees,
          style: const TextStyle(fontSize: 20),
        ),
      );
    }

    return const Center(child: CircularProgressIndicator());
  }
}
