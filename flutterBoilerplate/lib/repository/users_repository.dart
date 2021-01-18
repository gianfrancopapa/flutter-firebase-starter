import 'package:flutterBoilerplate/models/datatypes/persistance_service_type.dart';
import 'package:flutterBoilerplate/models/service_factory.dart';
import 'package:flutterBoilerplate/models/domain/admin.dart';
import 'package:flutterBoilerplate/models/filter.dart';
import 'package:flutterBoilerplate/models/firebase_filter.dart';
import 'package:flutterBoilerplate/models/domain/user.dart';
import 'package:flutterBoilerplate/repository/repository.dart';

class UsersRepository extends Repository<User> {
  static final _serviceFactory = ServiceFactory();
  static const _path = 'users';

  UsersRepository()
      : super(
          _serviceFactory.getPersistanceService(
            PersistanceServiceType.Firebase,
            _path,
          ),
          User.fromJson,
        );

  Future<List<User>> getUsers(Filter<FirebaseFilter> filter) async {
    try {
      final users = await getAll(filter);
      return users;
    } catch (err) {
      throw ('Error: $err while fetching users in [UsersRepository.getUsers]');
    }
  }

  Future<User> getUser(String id) async {
    try {
      final user = await getById(id);
      return user as Admin;
    } catch (err) {
      throw ('Error: $err while fetching users in [UsersRepository.getUser]');
    }
  }

  Future<void> addUser(User user) async {
    try {
      final map = user.toJson();
      if (user.runtimeType == Admin) {
        map['role'] = 'admin';
      }
      await post(map);
    } catch (err) {
      throw 'Error: $err in [usersRepository.addUser]';
    }
  }

  Future<void> updateUser(User user) async {
    try {
      final map = user.toJson();
      if (user.runtimeType == Admin) {
        map['role'] = 'admin';
      }
      await update(user.id, map);
    } catch (err) {
      throw 'Error: $err in [usersRepository.addUser]';
    }
  }

  Future<void> deleteUser(String id) async {
    try {
      await delete(id);
    } catch (err) {
      throw 'Error: $err in [usersRepository.deleteUser]';
    }
  }
}
