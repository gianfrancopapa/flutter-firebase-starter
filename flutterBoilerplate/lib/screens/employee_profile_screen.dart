import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/models/domain/employee.dart';
import 'package:flutterBoilerplate/screens/edit_employee_screen.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';
import 'package:flutterBoilerplate/widgets/common/button.dart';

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
        story: AppString.doYouWantToDeleteThisUser,
        btnText: AppString.yes,
        btnText2: AppString.no,
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
          'Sector: ${employee.getWorkingArea()}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          'Email: ${employee.email}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          'Phone Number: ${employee.phoneNumber}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          'Address: ${employee.address}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Text(
          'Age: ${employee.age}',
          style: const TextStyle(color: Colors.white, fontSize: 18.0),
        ),
      ];

  Widget _adminActions(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Button(
            text: 'Update',
            onTap: () => _goToEditEmployeeScreen(context),
            width: MediaQuery.of(context).size.width * 0.40,
            backgroundColor: Colors.blueAccent,
          ),
          Button(
            text: 'Delete',
            onTap: () => _deleteEmployeePopUp(context),
            width: MediaQuery.of(context).size.width * 0.40,
            backgroundColor: Colors.blueAccent,
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('${employee.firstName} ${employee.lastName}'),
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
