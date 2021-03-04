import 'dart:async';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/repository/employees_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  static const _errEvent =
      'Error: Invalid event [FilterEmployeesBloc.mapEventToState].';

  final _employeesRepository = EmployeesRepository();

  EmployeesBloc() : super(const NotDetermined());

  @override
  Stream<EmployeesState> mapEventToState(EmployeesEvent event) async* {
    yield const Loading();
    switch (event.runtimeType) {
      case GetEmployees:
        yield* _getEmployees();
        break;
      default:
        yield const Error(_errEvent);
    }
  }

  Stream<EmployeesState> _getEmployees() async* {
    try {
      final employees = await _employeesRepository.getEmployees(null);
      yield Employees(employees);
    } catch (err) {
      yield Error(err.toString());
    }
  }
}
