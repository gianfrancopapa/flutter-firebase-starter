part of 'edit_profile_bloc.dart';

enum PhotoUploadMethod { CAMERA, GALLERY }

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class EditProfileInfoUpdated extends EditProfileEvent {
  const EditProfileInfoUpdated();
}

class EditProfileFirstNameChanged extends EditProfileEvent {
  const EditProfileFirstNameChanged(this.name);

  final String name;

  @override
  List<Object> get props => [name];
}

class EditProfileLastNameChanged extends EditProfileEvent {
  const EditProfileLastNameChanged(this.lastName);

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class EditProfilePhotoUpdated extends EditProfileEvent {
  const EditProfilePhotoUpdated({@required this.method})
      : assert(method != null);

  final PhotoUploadMethod method;

  @override
  List<Object> get props => [method];
}

class EditProfileCurrentUserLoaded extends EditProfileEvent {
  const EditProfileCurrentUserLoaded();
}
