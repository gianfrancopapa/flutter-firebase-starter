import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/users/users_bloc.dart';
import 'package:flutterBoilerplate/bloc/users/users_event.dart';
import 'package:flutterBoilerplate/constants/assets.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/models/domain/user.dart';
import 'package:flutterBoilerplate/screens/edit_user_scren.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';

class UserCard extends StatelessWidget {
  final User user;
  final UsersBloc bloc;
  final bool showAdminControls;

  const UserCard({
    this.user,
    this.showAdminControls,
    this.bloc,
  });

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
              onPressed: () => DialogHelper.showAlertDialog(
                  context: context,
                  story: AppString.doYouWantToDeleteThisUser,
                  btnText: AppString.yes,
                  btnText2: AppString.no,
                  btnAction2: () => Navigator.pop(context),
                  btnAction: () {
                    bloc.add(DeleteUser(user.id));
                    Navigator.pop(context);
                  }),
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
              child: Image.asset(AppAsset.somnioLogo),
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
