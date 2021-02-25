import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_bloc.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_event.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_state.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_bloc.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';
import 'package:flutterBoilerplate/widgets/employee_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddEmployeeScreen extends StatefulWidget {
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  EmployeeBloc _employeeBloc;

  @override
  void initState() {
    _employeeBloc = EmployeeBloc();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final _employeesBloc = BlocProvider.of<FilterEmployeesBloc>(context);
    _employeeBloc.attach(_employeesBloc);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
        cubit: _employeeBloc,
        listener: (context, state) {
          if (state.runtimeType == EmployeeCreated) {
            return DialogHelper.showAlertDialog(
              context: context,
              story: AppLocalizations.of(context).employeeAddedSuccessfully,
              btnText: AppLocalizations.of(context).ok,
              btnAction: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
          } else if (state.runtimeType == Error) {
            return DialogHelper.showAlertDialog(
              context: context,
              story: (state as Error).message,
              btnText: AppLocalizations.of(context).ok,
              btnAction: () => Navigator.pop(context),
            );
          }
        },
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: state.runtimeType == Loading,
          child: Scaffold(
            backgroundColor: Colors.teal,
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).addNewEmployee),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop<bool>(
                  context,
                  state.runtimeType == EmployeeCreated,
                ),
              ),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: EmployeeForm(
                  bloc: _employeeBloc,
                  editEmployee: false,
                  execute: () => _employeeBloc.add(const CreateEmployee()),
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
