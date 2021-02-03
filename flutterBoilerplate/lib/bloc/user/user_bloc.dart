import 'package:flutterBoilerplate/bloc/user/user_event.dart';
import 'package:flutterBoilerplate/bloc/user/user_state.dart';
import 'package:flutterBoilerplate/models/datatypes/auth_service_type.dart';
import 'package:flutterBoilerplate/models/service_factory.dart';
import 'package:flutterBoilerplate/services/auth_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const NotDetermined());
  IAuth _authService;
  ServiceFactory _serviceFactory;

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch (event.runtimeType) {
      case GetUser:
        yield* _mapGetUserToState();
        break;
      default:
        yield const Error('Undetermined event');
    }
  }

  Stream<UserState> _mapGetUserToState() async* {
    yield const Loading();
    try {
      _authService =
          await _serviceFactory.getAuthService(AuthServiceType.CurrentAuth);
      final user = await _authService.getCurrentUser();
      yield CurrentUser(user);
    } catch (e) {
      yield const Error('Something went wrong');
    }
  }
}
