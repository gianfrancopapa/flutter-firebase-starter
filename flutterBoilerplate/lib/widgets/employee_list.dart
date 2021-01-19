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
  final _bloc = EmployeesBloc();

  @override
  void initState() {
    _bloc.add(const GetEmployees(null));
    super.initState();
  }

  Widget _presentData(BuildContext context, EmployeesState state) {
    switch (state.runtimeType) {
      case NotDetermined:
      case Loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
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
          child: Text('Error: Invalid state in [main_screen.dart]'),
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

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
