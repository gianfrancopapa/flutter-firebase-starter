import 'package:firebasestarter/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/screens/profile/edit_profile_screen.dart';
import 'package:firebasestarter/widgets/profile/profile_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc _bloc;
  bool _isAnon;

  @override
  void initState() {
    _bloc = UserBloc();
    _bloc.add(const GetUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocBuilder<UserBloc, UserState>(
        cubit: _bloc,
        builder: (context, state) {
          switch (state.runtimeType) {
            case Loading:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            case Error:
              return Scaffold(
                body: Center(
                  child: Text((state as Error).message.toString()),
                ),
              );
            case CurrentUser:
              final user = (state as CurrentUser).user;
              _isAnon = user.isAnonymous;
              return Scaffold(
                appBar: AppBar(
                    leading: const SizedBox(),
                    automaticallyImplyLeading: false,
                    title: const Text(Strings.myProfile),
                    actions: _isAnon
                        ? <Widget>[
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(),
                                ),
                              ),
                            ),
                          ]
                        : <Widget>[
                            IconButton(
                              icon: const Icon(Icons.settings),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SettingsScreen(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                FeatherIcons.penTool,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfileScreen(),
                                  )),
                            )
                          ]),
                body: Container(
                  child: Column(
                    children: [
                      ProfileImage(image: user.imageUrl),
                      customRow(AppLocalizations.of(context).firstName + ': ',
                          user.firstName),
                      customRow(AppLocalizations.of(context).lastName + ': ',
                          user.lastName),
                      customRow(AppLocalizations.of(context).email + ': ',
                          user.email),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                  alignment: Alignment.centerRight,
                ),
              );
            default:
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
          }
        },
      );

  Widget customRow(String cardText, String text) => Container(
        padding: const EdgeInsets.all(15.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Row(
          children: [
            Text(
              cardText,
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            Text(
              text,
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ],
        ),
      );
}
