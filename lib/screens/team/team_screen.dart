import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/team/employees_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _localizedStrings = AppLocalizations.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        goBack: false,
        title: _localizedStrings.employees,
      ),
      backgroundColor: AppColor.lightGrey,
      body: BlocBuilder<EmployeesBloc, EmployeesState>(
          builder: (BuildContext context, EmployeesState state) {
        if (state.status == EmployeesStatus.loadSuccess) {
          return EmployeesList(state.employees);
        }

        if (state.status == EmployeesStatus.loadEmpty) {
          return Center(
            child: Text(
              _localizedStrings.noEmployees,
              style: const TextStyle(fontSize: 20),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }
}
