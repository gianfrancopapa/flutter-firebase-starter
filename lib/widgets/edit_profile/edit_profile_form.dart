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

class EditProfileForm extends StatefulWidget {
  final _formKey = GlobalKey<FormBuilderState>();
  final EditProfileBloc bloc;

  EditProfileForm(this.bloc);

  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  bool _formEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: FormBuilder(
      key: widget._formKey,
      child: Column(
        children: [
          _FirstName(widget.bloc),
          Margin(0.0, 20.0),
          _LastName(widget.bloc),
          Margin(0.0, 43.0),
          _EditButton(
            onTap: () {
              _editProfile();
            },
            disabled: !_formEnabled,
          ),
        ],
      ),
      onChanged: () {
        setState(() {
          _formEnabled = widget._formKey.currentState.validate();
        });
      },
    ));
  }

  void _editProfile() {
    widget.bloc.add(
      ProfileInfoUpdated(
        firstName:
            widget._formKey.currentState.fields['firstName'].value as String,
        lastName:
            widget._formKey.currentState.fields['lastName'].value as String,
      ),
    );
  }
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
    );
  }
}

class _EditButton extends StatelessWidget {
  final Function() onTap;
  final bool disabled;

  const _EditButton({Function() this.onTap, bool this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Button(
      backgroundColor: disabled ? AppColor.grey : AppColor.blue,
      text: Strings.editProfile,
      onTap: () => onTap != null ? onTap() : null,
    );
  }
}
