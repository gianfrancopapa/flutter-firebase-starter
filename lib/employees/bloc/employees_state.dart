part of 'employees_bloc.dart';

enum EmployeesStatus { initial, loading, failure, success }

class EmployeesState extends Equatable {
  const EmployeesState({
    required this.status,
    this.employees,
  });

  final EmployeesStatus status;
  final List<Employee>? employees;

  EmployeesState copyWith(
      {EmployeesStatus? status, List<Employee>? employees}) {
    return EmployeesState(
      status: status ?? this.status,
      employees: employees ?? this.employees,
    );
  }

  @override
  List<Object?> get props => [status, employees];
}
