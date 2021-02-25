import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/models/domain/employee.dart';
import 'package:flutterBoilerplate/screens/team/edit_employee_screen.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmployeeProfileScreen extends StatelessWidget {
  final bool isAdmin;
  final Employee employee;
  final VoidCallback deleteEmployeeCb;

  const EmployeeProfileScreen({
    this.employee,
    this.isAdmin = false,
    this.deleteEmployeeCb,
  });

  void _goToEditEmployeeScreen(BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditEmployeeScreen(employee.id),
        ),
      );

  void _deleteEmployeePopUp(BuildContext context) =>
      DialogHelper.showAlertDialog(
        context: context,
        story: AppLocalizations.of(context).doYouWantToDeleteThisUser,
        btnText: AppLocalizations.of(context).yes,
        btnText2: AppLocalizations.of(context).no,
        btnAction2: () => Navigator.pop(context),
        btnAction: () {
          deleteEmployeeCb();
          Navigator.pop(context);
        },
      );

  Widget _userImage(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.blueGrey,
            width: 10.0,
            style: BorderStyle.solid,
          ),
        ),
        height: MediaQuery.of(context).size.height * 0.25,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(AppAsset.somnioLogo),
      );

  List<Widget> _userData(BuildContext context) => [
        Text(
          '${AppLocalizations.of(context).sector}: ${employee.getWorkingArea()}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          '${AppLocalizations.of(context).email}: ${employee.email}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          '${AppLocalizations.of(context).phoneNumber}: ${employee.phoneNumber}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          '${AppLocalizations.of(context).address}: ${employee.address}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          '${AppLocalizations.of(context).age}: ${employee.age}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          '${AppLocalizations.of(context).description}: ${employee.description}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ];

  Widget _adminActions(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Button(
            text: AppLocalizations.of(context).update,
            onTap: () => _goToEditEmployeeScreen(context),
            width: MediaQuery.of(context).size.width * 0.40,
            backgroundColor: Colors.white,
            textColor: Colors.teal,
          ),
          Button(
            text: AppLocalizations.of(context).delete,
            onTap: () => _deleteEmployeePopUp(context),
            width: MediaQuery.of(context).size.width * 0.40,
            backgroundColor: Colors.white,
            textColor: Colors.teal,
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
              '${AppLocalizations.of(context).firstName} ${AppLocalizations.of(context).lastName}'),
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding:
                const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _userImage(context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  ..._userData(context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  isAdmin
                      ? _adminActions(context)
                      : const SizedBox(
                          height: 0.0,
                          width: 0.0,
                        ),
                ],
              ),
            ),
          ),
        ),
      );
}
