import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_bloc.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_bloc.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_event.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_state.dart';
import 'package:flutterBoilerplate/widgets/employee_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'common/widgets_list.dart';

class EmployeeList extends StatefulWidget {
  final bool isAdmin;
  const EmployeeList(this.isAdmin);
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  FilterEmployeesBloc _filterEmployeesBloc;
  EmployeeBloc _employeeBloc;

  @override
  void didChangeDependencies() {
    _employeeBloc = EmployeeBloc();
    _filterEmployeesBloc = BlocProvider.of<FilterEmployeesBloc>(context);
    _employeeBloc.attach(_filterEmployeesBloc);
    _filterEmployeesBloc.add(const GetEmployees(false));
    super.didChangeDependencies();
  }

  Widget _presentData(BuildContext context, FilterEmployeesState state) {
    switch (state.runtimeType) {
      case Error:
        return Center(
          child: Text((state as Error).message),
        );
      case Employees:
        return WidgetsList(
          padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 20.0),
          height: MediaQuery.of(context).size.height,
          children: (state as Employees)
              .employees
              .map(
                (user) => EmployeeCard(
                  employee: user,
                  bloc: _employeeBloc,
                  showAdminControls: widget.isAdmin,
                ),
              )
              .toList(),
        );
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<FilterEmployeesBloc, FilterEmployeesState>(
        cubit: _filterEmployeesBloc,
        builder: _presentData,
      );

  @override
  void dispose() {
    _employeeBloc.close();
    super.dispose();
  }
}
