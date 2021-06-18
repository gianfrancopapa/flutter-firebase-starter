import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/validators/validators.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EditProfileForm extends StatelessWidget {
  final EditProfileBloc bloc;
  final _formKey = GlobalKey<FormBuilderState>();

  EditProfileForm(this.bloc);

  bool _formIsValid() {
    return _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              _FirstName(bloc),
              Margin(0.0, 20.0),
              _LastName(bloc),
              Margin(0.0, 43.0),
              _EditButton(
                onTap: () {
                  if (_formIsValid()) {
                    bloc.add(ProfileInfoUpdated());
                  }
                },
              )
            ],
          ),
        ),
      );
}

class _FirstName extends StatelessWidget {
  final EditProfileBloc bloc;

  const _FirstName(this.bloc);

  @override
  Widget build(BuildContext context) {
    final name = context
        .select<UserBloc, String>((UserBloc bloc) => bloc.state.user.firstName);
    return FormBuilderTextField(
      name: 'firstName',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.compose(
        [
          Validators.onlyLetters(context,
              error: 'First name cannot contain numbers or symbols.'),
          Validators.required(context)
        ],
      ),
      initialValue: name,
      onChanged: (firstName) => bloc.add(FirstNameUpdated(value: firstName)),
    );
  }
}

class _LastName extends StatelessWidget {
  final EditProfileBloc bloc;

  const _LastName(this.bloc);

  @override
  Widget build(BuildContext context) {
    final name = context
        .select<UserBloc, String>((UserBloc bloc) => bloc.state.user.lastName);

    return FormBuilderTextField(
      name: 'lastName',
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: FormBuilderValidators.compose(
        [
          FormBuilderValidators.match(
            context,
            '^[a-zA-Z]+\$',
            errorText: 'Last name cannot contain numbers or symbols',
          ),
          FormBuilderValidators.required(context)
        ],
      ),
      initialValue: name,
      onChanged: (lastName) => bloc.add(LastNameUpdated(value: lastName)),
    );
  }
}

class _EditButton extends StatelessWidget {
  final Function() onTap;

  const _EditButton({Function() this.onTap});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<EditProfileBloc>();
    return Button(
      backgroundColor: AppColor.blue,
      text: Strings.editProfile,
      onTap: () => onTap(),
    );
  }
}
