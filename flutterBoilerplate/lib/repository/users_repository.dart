import 'package:flutterBoilerplate/data_source/firebase_api.dart';
import 'package:flutterBoilerplate/models/admin.dart';
import 'package:flutterBoilerplate/models/filter.dart';
import 'package:flutterBoilerplate/models/firebase_filter.dart';
import 'package:flutterBoilerplate/models/user.dart';
import 'package:flutterBoilerplate/repository/repository.dart';

class UsersRepository extends Repository<User> {
  static const _path = 'users';

  UsersRepository() : super(FirebaseAPI(_path), User.fromJson);

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
}
