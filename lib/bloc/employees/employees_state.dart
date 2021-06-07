import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/employee.dart';

enum EmployeesStatus {
  initial,
  loadInProgress,
  loadFailure,
  loadSuccess,
  loadEmpty
}

class EmployeesState extends Equatable {
  final EmployeesStatus status;
  final List<Employee> employees;
  final String errorMessage;

  const EmployeesState({
    this.status = EmployeesStatus.initial,
    this.employees,
    this.errorMessage,
  }) : assert(status != null);

  EmployeesState copyWith({
    EmployeesStatus status,
    List<Employee> employees,
    String errorMessage,
  }) {
    return EmployeesState(
        status: status ?? this.status,
        employees: employees ?? this.employees,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  List<Object> get props => [status, employees, errorMessage];
}
