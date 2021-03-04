import 'package:firebasestarter/models/employee.dart';

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
