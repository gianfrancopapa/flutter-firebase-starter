import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/widgets/auth/login_form.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/screens/home.dart';
import 'package:firebasestarter/bloc/login/login_bloc.dart';
import 'package:firebasestarter/bloc/login/login_state.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //ignore: close_sinks
  LoginBloc _bloc;

  @override
  void initState() {
    _bloc = BlocProvider.of<LoginBloc>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColor.lightGrey,
        appBar: const CustomAppBar(
          title: 'Login',
        ),
        body: BlocListener<LoginBloc, LoginState>(
          cubit: _bloc,
          listener: (BuildContext context, LoginState state) {
            if (state is ErrorLogin) {
              DialogHelper.showAlertDialog(
                context: context,
                story: state.message,
                btnText: 'Close',
                btnAction: () => Navigator.pop(context),
              );
            }
            if (state is LoggedIn) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(state.currentUser),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44.0),
            child: SingleChildScrollView(child: LoginForm(_bloc)),
          ),
        ),
      );
}
