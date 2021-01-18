import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/users/users_bloc.dart';
import 'package:flutterBoilerplate/bloc/users/users_event.dart';
import 'package:flutterBoilerplate/bloc/users/users_state.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';
import 'package:flutterBoilerplate/widgets/user_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  UsersBloc _bloc;
  @override
  void initState() {
    _bloc = UsersBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
        cubit: _bloc,
        listener: (context, state) {
          if (state.runtimeType == UserCreated) {
            return DialogHelper.showAlertDialog(
                context: context,
                story: AppString.userAddedSuccessfully,
                btnText: AppString.ok,
                btnAction: () => Navigator.pop(context));
          } else if (state.runtimeType == Error) {
            return DialogHelper.showAlertDialog(
                context: context,
                story: (state as Error).message,
                btnText: AppString.ok,
                btnAction: () => Navigator.pop(context));
          }
        },
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: state.runtimeType == Loading,
          child: Scaffold(
            backgroundColor: Colors.teal,
            appBar: AppBar(
              title: const Text(AppString.addNewUser),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: UserForm(
                  bloc: _bloc,
                  editUser: false,
                  execute: () => _bloc.add(const CreateUser()),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
