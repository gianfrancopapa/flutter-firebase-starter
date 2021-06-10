import 'dart:async';
import 'package:firebasestarter/bloc/employees/employees_event.dart';
import 'package:firebasestarter/bloc/employees/employees_state.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:repository/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final Repository<EmployeeEntity> _employeesRepository;

  EmployeesBloc(this._employeesRepository) : super(const EmployeesState());

  @override
  Stream<EmployeesState> mapEventToState(EmployeesEvent event) async* {
    yield state.copyWith(status: EmployeesStatus.loadInProgress);
    if (event is EmployeesLoaded) {
      yield* _mapEmployeesLoadedToState();
    }
  }

  Stream<EmployeesState> _mapEmployeesLoadedToState() async* {
    try {
      final employees = await _employeesRepository.getAll();

      if (employees.isEmpty) {
        yield state.copyWith(status: EmployeesStatus.loadEmpty);
      } else {
        final loadedEmployees = employees.map<Employee>(_toEmployee).toList();
        yield state.copyWith(
          status: EmployeesStatus.loadSuccess,
          employees: loadedEmployees,
        );
      }
    } catch (err) {
      yield state.copyWith(
        status: EmployeesStatus.loadFailure,
        errorMessage: err.message,
      );
    }
  }

  Employee _toEmployee(EmployeeEntity entity) => Employee.fromEntity(entity);

  @override
  Future<void> close() {
    return super.close();
  }
}
