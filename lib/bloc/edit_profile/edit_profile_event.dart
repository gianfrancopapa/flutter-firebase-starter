import 'package:equatable/equatable.dart';

abstract class EditProfileEvent extends Equatable {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileInfoUpdated extends EditProfileEvent {}

class PhotoWithCameraUploaded extends EditProfileEvent {}

class PhotoWithLibraryUpdated extends EditProfileEvent {}

class FirstNameUpdated extends EditProfileEvent {
  final value;

  FirstNameUpdated({String this.value}) {}
}

class LastNameUpdated extends EditProfileEvent {
  final value;

  LastNameUpdated({String this.value}) {}
}

class CurrentUserLoaded extends EditProfileEvent {
  const CurrentUserLoaded();
}
