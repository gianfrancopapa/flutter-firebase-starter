import 'dart:async';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:repository/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  static const _errEvent =
      'Error: Invalid event [FilterEmployeesBloc.mapEventToState].';

  final Repository<EmployeeEntity> _employeesRepository;

  EmployeesBloc(this._employeesRepository) : super(const EmployeesInitial());

  @override
  Stream<EmployeesState> mapEventToState(EmployeesEvent event) async* {
    yield const EmployeesLoadInProgress();
    switch (event.runtimeType) {
      case EmployeesLoaded:
        yield* _mapEmployeesLoadedToState();
        break;
      default:
        yield const EmployeesLoadFailure(_errEvent);
    }
  }

  Stream<EmployeesState> _mapEmployeesLoadedToState() async* {
    try {
      final employees = await _employeesRepository.getAll();
      if (employees.isEmpty) {
        yield const EmployeesLoadEmpty();
      } else {
        yield EmployeesLoadSuccess(
          employees.map<Employee>(_toEmployee).toList(),
        );
      }
    } catch (err) {
      yield EmployeesLoadFailure(err.toString());
    }
  }

  Employee _toEmployee(EmployeeEntity entity) => Employee.fromEntity(entity);
}
