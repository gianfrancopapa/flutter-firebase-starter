import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/users/users_bloc.dart';
import 'package:flutterBoilerplate/bloc/users/users_event.dart';
import 'package:flutterBoilerplate/bloc/users/users_state.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';
import 'package:flutterBoilerplate/widgets/common/widgets_list.dart';
import 'package:flutterBoilerplate/widgets/user_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersList extends StatefulWidget {
  final bool isAdmin;
  const UsersList(this.isAdmin);
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final _bloc = UsersBloc();

  @override
  void initState() {
    _bloc.add(const GetUsers(null));
    super.initState();
  }

  Widget _presentData(BuildContext context, UsersState state) {
    switch (state.runtimeType) {
      case NotDetermined:
      case Loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case Error:
        return Center(
          child: Text((state as Error).message),
        );
      case Users:
        return WidgetsList(
          children: (state as Users)
              .users
              .map(
                (user) => UserCard(
                  user: user,
                  bloc: _bloc,
                  showAdminControls: widget.isAdmin,
                ),
              )
              .toList(),
        );
      default:
        return const Center(
          child: Text('Error: Invalid state in [main_screen.dart]'),
        );
    }
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<UsersBloc, UsersState>(
        listener: (BuildContext context, UsersState state) {
          if (state.runtimeType == UserDeleted) {
            _bloc.add(const GetUsers(null));
          }
        },
        cubit: _bloc,
        builder: _presentData,
      );

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
