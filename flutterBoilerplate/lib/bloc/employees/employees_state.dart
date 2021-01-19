import 'package:flutterBoilerplate/models/domain/employee.dart';

abstract class EmployeesState {
  const EmployeesState();
}

class NotDetermined extends EmployeesState {
  const NotDetermined();
}

class Loading extends EmployeesState {
  const Loading();
}

class Error extends EmployeesState {
  final String message;
  const Error(this.message);
}

class Employees extends EmployeesState {
  final List<Employee> employees;
  const Employees(this.employees);
}

class SingleEmployee extends EmployeesState {
  final Employee employee;
  const SingleEmployee(this.employee);
}

class EmployeeCreated extends EmployeesState {
  const EmployeeCreated();
}

class EmployeeUpdated extends EmployeesState {
  const EmployeeUpdated();
}

class EmployeeDeleted extends EmployeesState {
  const EmployeeDeleted();
}
