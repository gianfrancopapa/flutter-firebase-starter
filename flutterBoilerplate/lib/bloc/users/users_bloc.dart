import 'package:flutterBoilerplate/bloc/forms/user_form_bloc.dart';
import 'package:flutterBoilerplate/bloc/users/users_event.dart';
import 'package:flutterBoilerplate/bloc/users/users_state.dart';
import 'package:flutterBoilerplate/models/admin.dart';
import 'package:flutterBoilerplate/models/filter.dart';
import 'package:flutterBoilerplate/models/user.dart';
import 'package:flutterBoilerplate/repository/users_repository.dart';

class UsersBloc extends UserFormBloc<UsersEvent, UsersState> {
  final _usersRepository = UsersRepository();

  UsersBloc() : super(const NotDetermined());

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    switch (event.runtimeType) {
      case GetUsers:
        yield* _getUsers((event as GetUsers).filter);
        break;
      case CreateUser:
        yield* _postNewUser();
        break;
      default:
        yield const Error('Error: Invalid event.');
    }
  }

  Stream<UsersState> _getUsers(Filter filter) async* {
    yield const Loading();
    try {
      final users = await _usersRepository.getUsers(filter);
      yield Users(users);
    } catch (err) {
      yield Error(err);
    }
  }

  Stream<UsersState> _postNewUser() async* {
    try {
      yield const Loading();
      await _usersRepository.addUser(
        isAdminController.value
            ? Admin(
                firstName: firstNameController.value,
                lastName: lastNameController.value,
                email: emailController.value,
                phoneNumber: phoneController.value,
                age: ageController.value.truncate(),
                address: addressController.value,
              )
            : User(
                firstName: firstNameController.value,
                lastName: lastNameController.value,
                email: emailController.value,
                phoneNumber: phoneController.value,
                age: ageController.value.truncate(),
                address: addressController.value,
              ),
      );
      yield const UserCreated();
    } catch (err) {
      yield Error(err.toString());
    }
  }
}
