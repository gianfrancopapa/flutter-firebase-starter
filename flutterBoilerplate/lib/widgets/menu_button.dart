import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutterBoilerplate/screens/add_employee_screen.dart';

class MenuButton extends StatelessWidget {
  final itemHeightWithMargin = 60.0;
  void _goTo(BuildContext context, Widget screen) {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Widget _menuItem(
    BuildContext context,
    VoidCallback action,
    IconData icon,
    String text,
  ) =>
      GestureDetector(
        child: Container(
          padding: const EdgeInsets.only(left: 10.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey[800],
                width: 1.5,
              ),
            ),
          ),
          margin: const EdgeInsets.all(10.0),
          height: 40.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.08,
              ),
              Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ],
          ),
        ),
        onTap: action,
      );

  @override
  Widget build(BuildContext context) => Container(
        height: itemHeightWithMargin * 3 + 20.0,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8.0),
            topRight: Radius.circular(8.0),
          ),
        ),
        child: Wrap(
          children: [
            _menuItem(
              context,
              () => _goTo(context, AddEmployeeScreen()),
              Icons.supervised_user_circle,
              AppLocalizations.of(context).addEmployee,
            ),
            _menuItem(
              context,
              null,
              Icons.info_outline,
              AppLocalizations.of(context).optionTwo,
            ),
            _menuItem(
              context,
              null,
              Icons.remove_circle,
              AppLocalizations.of(context).optionThree,
            ),
          ],
        ),
      );
}
