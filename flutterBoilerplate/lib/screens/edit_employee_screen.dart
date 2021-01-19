import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/employees/employees_bloc.dart';
import 'package:flutterBoilerplate/bloc/employees/employees_event.dart';
import 'package:flutterBoilerplate/bloc/employees/employees_state.dart';
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
  EmployeesBloc _bloc;

  @override
  void didChangeDependencies() {
    _bloc = BlocProvider.of<EmployeesBloc>(context);
    _bloc.add(FetchEmployee(widget.employeeId));
    super.didChangeDependencies();
  }

  void _listener(BuildContext context, EmployeesState state) {
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
      BlocConsumer<EmployeesBloc, EmployeesState>(
        cubit: _bloc,
        listener: _listener,
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: state.runtimeType == Loading,
          child: Scaffold(
            backgroundColor: Colors.teal,
            appBar: AppBar(
              title: const Text(AppString.editEmployee),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: EmployeeForm(
                  bloc: _bloc,
                  editEmployee: true,
                  execute: () => _bloc.add(UpdateEmployee(widget.employeeId)),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.add(const GetEmployees(null));
    super.dispose();
  }
}
