import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/common/text_field_builder.dart';
import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  final EditProfileBloc bloc;

  const EditProfileForm(this.bloc);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          TextFieldBuilder(
            withInitialValue: true,
            stream: bloc.form.firstName,
            labelText: Strings.firstName,
            onChanged: (firstName) => bloc.form.onFirstNameChanged(firstName),
          ),
          Margin(0.0, 20.0),
          TextFieldBuilder(
            withInitialValue: true,
            stream: bloc.form.lastName,
            labelText: Strings.lastName,
            onChanged: (lastName) => bloc.form.onLastNameChanged(lastName),
          ),
          Margin(0.0, 43.0),
          Button(
            backgroundColor: AppColor.blue,
            text: Strings.editProfile,
            onTap: () => bloc.add(UpdateProfileInfo()),
          ),
        ],
      );
}
