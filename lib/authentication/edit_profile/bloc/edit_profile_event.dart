part of 'edit_profile_bloc.dart';

enum PhotoUploadMethod { camera, gallery }

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();
}

class EditProfileInfoUpdated extends EditProfileEvent {
  const EditProfileInfoUpdated();

  @override
  List<Object> get props => [];
}

class EditProfileFirstNameChanged extends EditProfileEvent {
  const EditProfileFirstNameChanged({required this.firstName});

  final String firstName;

  @override
  List<Object> get props => [firstName];
}

class EditProfileLastNameChanged extends EditProfileEvent {
  const EditProfileLastNameChanged({required this.lastName});

  final String lastName;

  @override
  List<Object> get props => [lastName];
}

class EditProfilePhotoUpdated extends EditProfileEvent {
  const EditProfilePhotoUpdated({required this.method});

  final PhotoUploadMethod method;

  @override
  List<Object> get props => [method];
}

class EditProfileUserRequested extends EditProfileEvent {
  const EditProfileUserRequested();

  @override
  List<Object> get props => [];
}
