import 'package:flutterBoilerplate/models/filter.dart';

abstract class UsersEvent {
  const UsersEvent();
}

class GetUsers extends UsersEvent {
  final Filter filter;
  const GetUsers(this.filter);
}

class CreateUser extends UsersEvent {
  const CreateUser();
}

class UpdateUser extends UsersEvent {
  final String id;
  const UpdateUser(this.id);
}

class FetchUserToEdit extends UsersEvent {
  final String id;
  const FetchUserToEdit(this.id);
}

class DeleteUser extends UsersEvent {
  final String id;
  const DeleteUser(this.id);
}
