import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileForm extends StatelessWidget {
  final EditProfileBloc bloc;

  const EditProfileForm(this.bloc);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            _FirstName(),
            Margin(0.0, 20.0),
            _LastName(),
            Margin(0.0, 43.0),
            _EditButton()
          ],
        ),
      );
}

class _FirstName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProfileBloc>();
    final name = context.select<EditProfileBloc, String>(
        (EditProfileBloc bloc) => bloc.state.firstName);

    return TextFieldBuilder(
      withInitialValue: true,
      value: name,
      labelText: Strings.firstName,
      onChanged: (firstName) => bloc.add(FirstNameUpdated(value: firstName)),
    );
  }
}

class _LastName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProfileBloc>();
    final name = context.select<EditProfileBloc, String>(
        (EditProfileBloc bloc) => bloc.state.lastName);

    return TextFieldBuilder(
      withInitialValue: true,
      value: name,
      labelText: Strings.lastName,
      onChanged: (lastName) => bloc.add(LastNameUpdated(value: lastName)),
    );
  }
}

class _EditButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProfileBloc>();
    return Button(
      backgroundColor: AppColor.blue,
      text: Strings.editProfile,
      onTap: () => bloc.add(ProfileInfoUpdated()),
    );
  }
}
