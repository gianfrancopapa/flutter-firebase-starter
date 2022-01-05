import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/employees/employees.dart';
import 'package:firebasestarter/home/home.dart';
import 'package:flutter/material.dart';
import 'package:firebasestarter/user_profile/user_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<HomeCubit>(
        create: (_) => HomeCubit(),
        child: const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex =
        context.select((HomeCubit cubit) => cubit.state.pageIndex);

    return pageIndex == 0
        ? EmployeesScreen(
            bottomNavigationBar: _BottomNavigationBar(
              index: pageIndex,
            ),
          )
        : UserProfileScreen(
            bottomNavigationBar: _BottomNavigationBar(
              index: pageIndex,
            ),
          );
  }
}

class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    Key? key,
    required this.index,
  }) : super(key: key);

  static const _index1 = 0;
  static const _index2 = 1;

  final int index;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomAppBar(
        elevation: 0.0,
        child: Container(
          decoration: const BoxDecoration(
            color: FSColors.lightGrey,
            border: Border(
              top: BorderSide(color: Color(0xffC1C1C1), width: 1.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    context.read<HomeCubit>().updatePageIndex(_index1);
                  },
                  child: SizedBox(
                    child: Icon(
                      Icons.home,
                      color: index == _index1 ? FSColors.blue : FSColors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 150.0),
                InkWell(
                  onTap: () {
                    context.read<HomeCubit>().updatePageIndex(_index2);
                  },
                  child: SizedBox(
                    child: Icon(
                      Icons.person,
                      color: index == _index2 ? FSColors.blue : FSColors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
