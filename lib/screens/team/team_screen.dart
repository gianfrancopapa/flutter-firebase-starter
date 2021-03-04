import 'package:firebasestarter/bloc/employees/employees_bloc.dart';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/team/employees_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  EmployeesBloc _bloc;

  @override
  void initState() {
    _bloc = EmployeesBloc()..add(const GetEmployees());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(
          goBack: false,
          title: AppLocalizations.of(context).employees,
        ),
        backgroundColor: AppColor.lightGrey,
        body: BlocBuilder<EmployeesBloc, EmployeesState>(
          cubit: _bloc,
          buildWhen: (_, EmployeesState current) => current is Employees,
          builder: (BuildContext context, EmployeesState state) =>
              state is Employees
                  ? EmployeesList(state.employees)
                  : const Center(child: CircularProgressIndicator()),
        ),
      );

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
