import 'package:flutterBoilerplate/models/filter.dart';

abstract class EmployeesEvent {
  const EmployeesEvent();
}

class GetEmployees extends EmployeesEvent {
  final Filter filter;
  const GetEmployees(this.filter);
}

class CreateEmployee extends EmployeesEvent {
  const CreateEmployee();
}

class UpdateEmployee extends EmployeesEvent {
  final String id;
  const UpdateEmployee(this.id);
}

class FetchEmployee extends EmployeesEvent {
  final String id;
  const FetchEmployee(this.id);
}

class DeleteEmployee extends EmployeesEvent {
  final String id;
  const DeleteEmployee(this.id);
}
