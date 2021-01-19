import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/employees/employees_bloc.dart';
import 'package:flutterBoilerplate/bloc/employees/employees_event.dart';
import 'package:flutterBoilerplate/bloc/employees/employees_state.dart';
import 'package:flutterBoilerplate/widgets/common/widgets_list.dart';
import 'package:flutterBoilerplate/widgets/employee_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeList extends StatefulWidget {
  final bool isAdmin;
  const EmployeeList(this.isAdmin);
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  EmployeesBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<EmployeesBloc>(context);
    _bloc.add(const GetEmployees(null));
    super.didChangeDependencies();
  }

  Widget _presentData(BuildContext context, EmployeesState state) {
    switch (state.runtimeType) {
      case Error:
        return Center(
          child: Text((state as Error).message),
        );
      case Employees:
        return WidgetsList(
          children: (state as Employees)
              .employees
              .map(
                (user) => EmployeeCard(
                  employee: user,
                  bloc: _bloc,
                  showAdminControls: widget.isAdmin,
                ),
              )
              .toList(),
        );
      default:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<EmployeesBloc, EmployeesState>(
        listener: (BuildContext context, EmployeesState state) {
          if (state.runtimeType == EmployeeDeleted) {
            _bloc.add(const GetEmployees(null));
          }
        },
        cubit: _bloc,
        builder: _presentData,
      );
}
