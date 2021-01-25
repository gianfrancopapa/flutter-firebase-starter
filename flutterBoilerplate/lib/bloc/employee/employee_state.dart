import 'package:flutterBoilerplate/models/domain/employee.dart';

abstract class EmployeeState {
  const EmployeeState();
}

class NotDetermined extends EmployeeState {
  const NotDetermined();
}

class Loading extends EmployeeState {
  const Loading();
}

class Error extends EmployeeState {
  final String message;
  const Error(this.message);
}

class SingleEmployee extends EmployeeState {
  final Employee employee;
  const SingleEmployee(this.employee);
}

class EmployeeCreated extends EmployeeState {
  const EmployeeCreated();
}

class EmployeeUpdated extends EmployeeState {
  const EmployeeUpdated();
}

class EmployeeDeleted extends EmployeeState {
  const EmployeeDeleted();
}
