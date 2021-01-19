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
  void initState() {
    _bloc = EmployeesBloc();
    _bloc.add(FetchEmployee(widget.employeeId));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
        cubit: _bloc,
        listener: (context, state) {
          switch (state.runtimeType) {
            case EmployeeUpdated:
              return DialogHelper.showAlertDialog(
                  context: context,
                  story: AppString.userUpdatedSuccessfully,
                  btnText: AppString.ok,
                  btnAction: () => Navigator.pop(context));
              break;
            case Error:
              return DialogHelper.showAlertDialog(
                context: context,
                story: (state as Error).message,
                btnText: AppString.ok,
                btnAction: () => Navigator.pop(context),
              );
              break;
            default:
              break;
          }
        },
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: state.runtimeType == Loading,
          child: Scaffold(
            backgroundColor: Colors.teal,
            appBar: AppBar(
              title: const Text(AppString.editUser),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
    _bloc.close();
    super.dispose();
  }
}
