import 'package:firebasestarter/constants/colors.dart';
import 'package:firebasestarter/constants/strings.dart';
import 'package:firebasestarter/edit_profile/edit_profile.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/services/image_picker/image_picker.dart';
import 'package:firebasestarter/services/storage/firebase_storage_service.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:firebasestarter/user_profile/user_profile.dart';
import 'package:firebasestarter/utils/dialog.dart';
import 'package:firebasestarter/widgets/common/app_bar.dart';
import 'package:firebasestarter/widgets/common/button.dart';
import 'package:firebasestarter/widgets/common/margin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider<EditProfileBloc>(
        create: (context) => EditProfileBloc(
          authService: context.read<FirebaseAuthService>(),
          imageService: context.read<PickImageService>(),
          storageService: context.read<FirebaseStorageService>(),
        )..add(const EditProfileUserRequested()),
        child: const EditProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listenWhen: (previous, current) => previous.user != current.user,
          listener: (context, current) {
            if (current.status == UserStatus.success) {
              Navigator.of(context).pop();
            }
          },
        ),
        BlocListener<EditProfileBloc, EditProfileState>(
          listenWhen: (_, current) =>
              current.status == EditProfileStatus.success ||
              current.status == EditProfileStatus.failure,
          listener: (BuildContext context, EditProfileState state) {
            if (state.status == EditProfileStatus.success) {
              context.read<UserBloc>().add(const UserLoaded());
            }

            if (state.status == EditProfileStatus.failure) {
              DialogHelper.showAlertDialog(
                context: context,
                story: 'Error',
                btnText: 'Close',
                btnAction: () => Navigator.pop(context),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: const _AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44.0),
            child: Column(
              children: [
                Margin(0.0, 60.0),
                const _ProfileImage(
                  key: Key('editProfileScreen_profileImage'),
                ),
                Margin(0.0, 45.0),
                const _EditProfileForm(
                  key: Key('editProfileScreen_form'),
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

    final image = context.select((EditProfileBloc bloc) => bloc.state.imageURL);
    final validImage = image != null;

    return UserProfileImage(
      editable: true,
      onTap: () => showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
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
                key: const Key(
                  'editProfileScreen_profileImage_openCameraButton',
                ),
                leading: const Icon(
                  Icons.photo_camera,
                  size: 50,
                ),
                title: Text(
                  localizations.camera,
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () {
                  context.read<EditProfileBloc>().add(
                        const EditProfilePhotoUpdated(
                          method: PhotoUploadMethod.CAMERA,
                        ),
                      );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                key: const Key(
                  'editProfileScreen_profileImage_openGalleryButton',
                ),
                leading: const Icon(
                  Icons.insert_photo,
                  size: 50,
                ),
                title: Text(
                  localizations.gallery,
                  style: const TextStyle(fontSize: 20),
                ),
                onTap: () {
                  context.read<EditProfileBloc>().add(
                        const EditProfilePhotoUpdated(
                          method: PhotoUploadMethod.GALLERY,
                        ),
                      );
                  Navigator.of(context).pop();
                },
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
              )
            ],
          );
        },
      ),
      image: validImage ? image : '',
    );
  }
}

class _EditProfileForm extends StatelessWidget {
  const _EditProfileForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.select((EditProfileBloc bloc) => bloc.state.user);
    final userIsNotLoaded = user == null;

    return userIsNotLoaded
        ? const CircularProgressIndicator()
        : SingleChildScrollView(
            child: Column(
              children: [
                const _FirstNameTextField(
                  key: Key(
                    'editProfileScreen_editProfileForm_firstNameTextField',
                  ),
                ),
                Margin(0.0, 20.0),
                const _LastNameTextField(
                  key: Key(
                    'editProfileScreen_editProfileForm_lastNameTextField',
                  ),
                ),
                Margin(0.0, 43.0),
                const _UpdateProfileButton(
                  key: Key('updateProfileScreen_editProfileForm_button'),
                ),
              ],
            ),
          );
  }
}

class _FirstNameTextField extends StatelessWidget {
  const _FirstNameTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstName =
        context.select((EditProfileBloc bloc) => bloc.state.firstName);

    return TextFormField(
      initialValue: context.read<EditProfileBloc>().state.user.firstName,
      onChanged: (firstName) {
        context
            .read<EditProfileBloc>()
            .add(EditProfileFirstNameChanged(firstName: firstName));
      },
      decoration: InputDecoration(
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorText: firstName.valid ? null : 'Invalid first name',
      ),
    );
  }
}

class _LastNameTextField extends StatelessWidget {
  const _LastNameTextField({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final lastName =
        context.select((EditProfileBloc bloc) => bloc.state.lastName);

    return TextFormField(
      initialValue: context.read<EditProfileBloc>().state.user.lastName,
      onChanged: (lastName) {
        context
            .read<EditProfileBloc>()
            .add(EditProfileLastNameChanged(lastName: lastName));
      },
      decoration: InputDecoration(
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        errorText: lastName.valid ? null : 'Invalid last name',
      ),
    );
  }
}

class _UpdateProfileButton extends StatelessWidget {
  const _UpdateProfileButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditProfileBloc bloc) => bloc.state.status);
    final isInvalid = status == EditProfileStatus.invalid;

    return Button(
      backgroundColor: isInvalid ? AppColor.grey : AppColor.blue,
      text: Strings.editProfile,
      onTap: isInvalid
          ? null
          : () {
              context
                  .read<EditProfileBloc>()
                  .add(const EditProfileInfoUpdated());
            },
    );
  }
}

class _AppBar extends CustomAppBar {
  const _AppBar();

  @override
  Widget build(BuildContext context) {
    final status = context.select((EditProfileBloc bloc) => bloc.state.status);
    return CustomAppBar(
      title: AppLocalizations.of(context).editProfile,
      suffixWidget: status == EditProfileStatus.loading
          ? const Padding(
              padding: EdgeInsets.all(10.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const SizedBox(),
    );
  }
}
