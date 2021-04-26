import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/user.dart';

abstract class EditProfileState {
  const EditProfileState();
}

class AvatarChangeSuccess extends EditProfileState with EquatableMixin {
  final String image;
  const AvatarChangeSuccess(this.image);

  @override
  List<Object> get props => [image];
}

class EditProfileSuccess extends EditProfileState with EquatableMixin {
  const EditProfileSuccess();

  @override
  List<Object> get props => [];
}

class EditProfileInitial extends EditProfileState with EquatableMixin {
  const EditProfileInitial();

  @override
  List<Object> get props => [];
}

class EditProfileFailure extends EditProfileState with EquatableMixin {
  final String message;
  const EditProfileFailure(this.message);

  @override
  List<Object> get props => [message];
}

class EditProfileInProgress extends EditProfileState with EquatableMixin {
  const EditProfileInProgress();

  @override
  List<Object> get props => [];
}

class CurrentUser extends EditProfileState with EquatableMixin {
  final User user;
  const CurrentUser(this.user);

  @override
  List<Object> get props => [user];
}
