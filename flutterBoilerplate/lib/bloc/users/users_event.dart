import 'package:flutterBoilerplate/models/filter.dart';

abstract class UsersEvent {
  const UsersEvent();
}

class GetUsers extends UsersEvent {
  final Filter filter;
  const GetUsers(this.filter);
}
