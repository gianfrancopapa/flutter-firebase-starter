import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:firebasestarter/validators/validators.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:firebasestarter/widgets/profile/profile_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<EditProfileBloc, EditProfileState>(
      listenWhen: (_, current) =>
          current.status == EditProfileStatus.profileSuccess ||
          current.status == EditProfileStatus.failure,
      listener: (BuildContext context, EditProfileState state) {
        if (state.status == EditProfileStatus.profileSuccess) {
          Navigator.of(context).pop();
        }

        if (state.status == EditProfileStatus.failure) {
          DialogHelper.showAlertDialog(
            context: context,
            story: state.errorMessage,
            btnText: 'Close',
            btnAction: () => Navigator.pop(context),
          );
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(title: AppLocalizations.of(context).editProfile),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44.0),
            child: Column(
              children: [
                Margin(0.0, 60.0),
                const _ProfileImage(),
                Margin(0.0, 45.0),
                _EditProfileForm(
                  key: const Key('editProfileScreen_form'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileImage extends StatelessWidget {
  const _ProfileImage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final image = context.select((EditProfileBloc bloc) => bloc.state.image);
    final status = context.select((EditProfileBloc bloc) => bloc.state.status);

    return ProfileImage(
      editable: true,
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        builder: (_) {
          return Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(20.0),
              ),
              Center(
                child: Text(
                  localizations.selectProfilePicture,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  size: 50,
                ),
                title: Text(
                  localizations.camera,
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () {
                  context
                      .read<EditProfileBloc>()
                      .add(PhotoWithCameraUploaded());
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.insert_photo,
                  size: 50,
                ),
                title: Text(
                  localizations.gallery,
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () {
                  context
                      .read<EditProfileBloc>()
                      .add(PhotoWithLibraryUpdated());
                  Navigator.pop(context);
                },
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
              )
            ],
          );
        },
      ),
      image: status == EditProfileStatus.avatarSuccess ? image : '',
    );
  }
}

class _EditProfileForm extends StatelessWidget {
  _EditProfileForm({Key key}) : super(key: key);

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          children: [
            const _FirstNameTextField(),
            Margin(0.0, 20.0),
            const _LastNameTextField(),
            Margin(0.0, 43.0),
            _EditButton(
              onTap: () {
                //TODO: move this logic to bloc
                final _formIsValid = _formKey.currentState.validate();

                context.read<EditProfileBloc>().add(FormChanged(_formIsValid));

                if (_formIsValid) {
                  context.read<EditProfileBloc>().add(
                        ProfileInfoUpdated(
                          firstName: _formKey
                              .currentState.fields['firstName'].value as String,
                          lastName: _formKey
                              .currentState.fields['lastName'].value as String,
                        ),
                      );
                }
              },
            ),
          ],
        ),
        onChanged: () {
          context
              .read<EditProfileBloc>()
              .add(FormChanged(_formKey.currentState.validate()));
        },
      ),
    );
  }
}

class _FirstNameTextField extends StatelessWidget {
  const _FirstNameTextField();

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

class _LastNameTextField extends StatelessWidget {
  const _LastNameTextField();

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
    final disabled =
        context.select((EditProfileBloc bloc) => !bloc.state.formIsValid);
    return Button(
      backgroundColor: disabled ? AppColor.grey : AppColor.blue,
      text: Strings.editProfile,
      onTap: () => disabled ? null : onTap(),
    );
  }
}
