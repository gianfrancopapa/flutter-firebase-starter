import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_bloc.dart';
import 'package:flutterBoilerplate/bloc/employee/employee_event.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutterBoilerplate/models/domain/employee.dart';
import 'package:flutterBoilerplate/screens/team/edit_employee_screen.dart';
import 'package:flutterBoilerplate/screens/team/employee_profile_screen.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';

class EmployeeCard extends StatelessWidget {
  final Employee employee;
  final EmployeeBloc bloc;
  final bool showAdminControls;

  const EmployeeCard({
    this.employee,
    this.showAdminControls,
    this.bloc,
  });

  void _dispatchDeleteEvent() => bloc.add(DeleteEmployee(employee.id));

  void _deleteEmployeePopUp(BuildContext context) =>
      DialogHelper.showAlertDialog(
        context: context,
        story: AppLocalizations.of(context).doYouWantToDeleteThisUser,
        btnText: AppLocalizations.of(context).yes,
        btnText2: AppLocalizations.of(context).no,
        btnAction2: () => Navigator.pop(context),
        btnAction: () {
          _dispatchDeleteEvent();
          Navigator.pop(context);
        },
      );

  void _goToEditEmployeeScreen(BuildContext context) => Navigator.push<bool>(
        context,
        MaterialPageRoute(
          builder: (context) => EditEmployeeScreen(employee.id),
        ),
      );

  void _goToEmployeeProfile(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmployeeProfileScreen(
            employee: employee,
            isAdmin: showAdminControls,
            deleteEmployeeCb: _dispatchDeleteEvent,
          ),
        ),
      );

  SizedBox _adminControls(BuildContext context) => SizedBox(
        width: MediaQuery.of(context).size.width -
            MediaQuery.of(context).size.width / 2.5 -
            50,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.blueGrey,
              ),
              onPressed: () => _goToEditEmployeeScreen(context),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: () => _deleteEmployeePopUp(context),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => _goToEmployeeProfile(context),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: Colors.blueGrey,
              width: 8.0,
              style: BorderStyle.solid,
            ),
          ),
          padding: const EdgeInsets.all(5.0),
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.03,
          ),
          child: Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width / 2.5,
                child: Image.asset(AppAsset.somnioLogo),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${employee.firstName} ${employee.lastName}',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                    showAdminControls
                        ? _adminControls(context)
                        : const SizedBox(
                            height: 0.0,
                            width: 0.0,
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
