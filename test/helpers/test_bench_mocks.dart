import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/employees/employees.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:mockito/mockito.dart';
import 'package:repository/repository.dart';

class MockEmployeesRepository extends Mock implements EmployeesRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class MockLoginBloc extends MockBloc<LoginEvent, LoginState>
    implements LoginBloc {}

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

class MockEmployeesBloc extends MockBloc<EmployeesEvent, EmployeesState>
    implements EmployeesBloc {}
