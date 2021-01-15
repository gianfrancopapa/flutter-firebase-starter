import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/models/user.dart';

class UserCard extends StatelessWidget {
  final User user;
  const UserCard(this.user);

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
            )),
        padding: const EdgeInsets.all(5.0),
        margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.03,
        ),
        child: Row(children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width / 2.5,
            child: Image.asset(Assets.somnioLogo),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                  style: const TextStyle(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ]),
      );
}
