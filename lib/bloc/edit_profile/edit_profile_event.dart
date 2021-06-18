import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileInfoUpdated extends EditProfileEvent {
  final firstName;
  final lastName;

  ProfileInfoUpdated({String this.firstName, String this.lastName}) {}
}

class PhotoWithCameraUploaded extends EditProfileEvent {}

class PhotoWithLibraryUpdated extends EditProfileEvent {}

class CurrentUserLoaded extends EditProfileEvent {
  const CurrentUserLoaded();
}
