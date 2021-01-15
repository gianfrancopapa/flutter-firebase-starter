import 'package:flutterBoilerplate/bloc/users/users_event.dart';
import 'package:flutterBoilerplate/bloc/users/users_state.dart';
import 'package:flutterBoilerplate/models/filter.dart';
import 'package:flutterBoilerplate/repository/users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  final _usersRepository = UsersRepository();

  UsersBloc() : super(const NotDetermined());

  @override
  Stream<UsersState> mapEventToState(UsersEvent event) async* {
    switch (event.runtimeType) {
      case GetUsers:
        yield* _getUsers((event as GetUsers).filter);
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
}
