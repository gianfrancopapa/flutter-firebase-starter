import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_bloc.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_event.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_state.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_bloc.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';
import 'package:flutterBoilerplate/widgets/employee_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditEmployeeScreen extends StatefulWidget {
  final String employeeId;
  const EditEmployeeScreen(this.employeeId);
  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditEmployeeScreen> {
  EmployeeBloc _employeeBloc;

  @override
  void initState() {
    _employeeBloc = EmployeeBloc();
    _employeeBloc.add(FetchEmployee(widget.employeeId));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final _employeesBloc = BlocProvider.of<FilterEmployeesBloc>(context);
    _employeeBloc.attach(_employeesBloc);
    super.didChangeDependencies();
  }

  void _listener(BuildContext context, EmployeeState state) {
    switch (state.runtimeType) {
      case EmployeeUpdated:
        DialogHelper.showAlertDialog(
          context: context,
          story: AppString.userUpdatedSuccessfully,
          btnText: AppString.ok,
          btnAction: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
        break;
      case Error:
        DialogHelper.showAlertDialog(
          context: context,
          story: (state as Error).message,
          btnText: AppString.ok,
          btnAction: () => Navigator.pop(context),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) =>
      BlocConsumer<EmployeeBloc, EmployeeState>(
        cubit: _employeeBloc,
        listener: _listener,
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: state.runtimeType == Loading,
          child: Scaffold(
            backgroundColor: Colors.teal,
            appBar: AppBar(
              title: const Text(AppString.editEmployee),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop<bool>(
                  context,
                  state.runtimeType == EmployeeUpdated,
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: EmployeeForm(
                  bloc: _employeeBloc,
                  editEmployee: true,
                  execute: () =>
                      _employeeBloc.add(UpdateEmployee(widget.employeeId)),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _employeeBloc.close();
    super.dispose();
  }
}
