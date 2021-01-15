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
      case FetchUserToEdit:
        yield* _getUser((event as FetchUserToEdit).id);
        break;
      case UpdateUser:
        yield* _updateUser((event as UpdateUser).id);
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

  Stream<UsersState> _updateUser(String id) async* {
    try {
      yield const Loading();
      await _usersRepository.updateUser(
        isAdminController.value
            ? Admin(
                id: id,
                firstName: firstNameController.value,
                lastName: lastNameController.value,
                email: emailController.value,
                phoneNumber: phoneController.value,
                age: ageController.value.truncate(),
                address: addressController.value,
              )
            : User(
                id: id,
                firstName: firstNameController.value,
                lastName: lastNameController.value,
                email: emailController.value,
                phoneNumber: phoneController.value,
                age: ageController.value.truncate(),
                address: addressController.value,
              ),
      );
      yield const UserUpdated();
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<UsersState> _getUser(String id) async* {
    try {
      yield const Loading();
      final user = await _usersRepository.getUser(id);
      print(user.phoneNumber);
      firstNameController.sink.add(user.firstName);
      lastNameController.sink.add(user.lastName);
      emailController.sink.add(user.email);
      addressController.sink.add(user.address);
      ageController.sink.add(user.age.toDouble());
      isAdminController.sink.add(user.runtimeType == Admin);
      phoneController.sink.add(user.phoneNumber);
      yield SingleUser(user);
    } catch (err) {
      yield Error(err.toString());
    }
  }
}
