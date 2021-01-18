import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/bloc/users/users_bloc.dart';
import 'package:flutterBoilerplate/bloc/users/users_event.dart';
import 'package:flutterBoilerplate/bloc/users/users_state.dart';
import 'package:flutterBoilerplate/constants/strings.dart';
import 'package:flutterBoilerplate/utils/dialog.dart';
import 'package:flutterBoilerplate/widgets/user_form.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class EditUserScreen extends StatefulWidget {
  final String userId;
  const EditUserScreen(this.userId);
  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  UsersBloc _bloc;
  @override
  void initState() {
    _bloc = UsersBloc();
    _bloc.add(FetchUserToEdit(widget.userId));
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer(
        cubit: _bloc,
        listener: (context, state) {
          switch (state.runtimeType) {
            case UserUpdated:
              return DialogHelper.showAlertDialog(
                  context: context,
                  story: AppString.userUpdatedSuccessfully,
                  btnText: AppString.ok,
                  btnAction: () => Navigator.pop(context));
              break;
            case Error:
              return DialogHelper.showAlertDialog(
                context: context,
                story: (state as Error).message,
                btnText: AppString.ok,
                btnAction: () => Navigator.pop(context),
              );
              break;
            default:
              break;
          }
        },
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: state.runtimeType == Loading,
          child: Scaffold(
            backgroundColor: Colors.teal,
            appBar: AppBar(
              title: const Text(AppString.editUser),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: UserForm(
                  bloc: _bloc,
                  editUser: true,
                  execute: () => _bloc.add(UpdateUser(widget.userId)),
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
