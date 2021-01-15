import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/models/user.dart';
import 'package:flutterBoilerplate/screens/edit_user_scren.dart';

class UserCard extends StatelessWidget {
  final bool showAdminControls;
  final User user;

  const UserCard(this.user, this.showAdminControls);

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
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditUserScreen(user.id),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.redAccent,
              ),
              onPressed: () {},
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) => Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: Colors.blueGrey,
            width: 10.0,
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
              child: Image.asset(Assets.somnioLogo),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${user.firstName} ${user.lastName}',
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
      );
}
