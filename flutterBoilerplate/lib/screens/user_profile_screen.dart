import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/user/user_bloc.dart';
import 'package:flutterBoilerplate/bloc/user/user_event.dart';
import 'package:flutterBoilerplate/bloc/user/user_state.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/screens/settings_screen.dart';
import 'package:flutterBoilerplate/widgets/profile_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserBloc _bloc;

  @override
  void initState() {
    _bloc = UserBloc();
    _bloc.add(const GetUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          automaticallyImplyLeading: false,
          title: const Text(AppString.myProfile),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<UserBloc, UserState>(
          cubit: _bloc,
          builder: (context, state) {
            switch (state.runtimeType) {
              case Loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case Error:
                return Center(
                  child: Text((state as Error).message.toString()),
                );
              case CurrentUser:
                final user = (state as CurrentUser).user;
                return Container(
                  child: Column(
                    children: [
                      ProfileImage(image: user.avatarAsset),
                      customRow(AppString.fstName + ': ', user.firstName),
                      customRow(AppString.lstName + ': ', user.lastName),
                      customRow(AppString.email + ': ', user.email),
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                  ),
                  alignment: Alignment.centerRight,
                );
              default:
                return const Center(
                  child: CircularProgressIndicator(),
                );
            }
          },
        ),
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
