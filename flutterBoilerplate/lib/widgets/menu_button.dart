import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/screens/add_employee_screen.dart';
import 'package:flutterBoilerplate/widgets/floating_action_button_item.dart';

class MenuButton extends StatelessWidget {
  void _goTo(BuildContext context, Widget screen) => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => screen),
      );

  SizedBox _template(BuildContext context, List<Widget> children) => SizedBox(
        height: (MediaQuery.of(context).size.height * 0.4) / 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      );

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.only(left: 20, right: 20),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        backgroundColor: Colors.transparent,
        child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                _template(
                  context,
                  [
                    ItemMenuButton(
                      onTap: () => _goTo(context, AddUserScreen()),
                      title: AppString.addUser,
                      icon: Icons.add,
                    ),
                    ItemMenuButton(
                      onTap: () => _goTo(
                        context,
                        Scaffold(
                          body: Container(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      title: AppString.editUser,
                      icon: Icons.edit,
                    )
                  ],
                ),
                _template(
                  context,
                  [
                    ItemMenuButton(
                      onTap: () => {},
                      title: 'Option 3',
                      icon: Icons.verified_user_outlined,
                    ),
                    ItemMenuButton(
                      onTap: () => {},
                      title: 'Option 4',
                      icon: Icons.verified_user_outlined,
                    )
                  ],
                )
              ],
            )),
      );
}
