import 'package:flutterBoilerplate/models/domain/employee.dart';

abstract class FilterEmployeesState {
  const FilterEmployeesState();
}

class NotDetermined extends FilterEmployeesState {
  const NotDetermined();
}

class Loading extends FilterEmployeesState {
  const Loading();
}

class Error extends FilterEmployeesState {
  final String message;
  const Error(this.message);
}

class Employees extends FilterEmployeesState {
  final List<Employee> employees;
  const Employees(this.employees);
}
