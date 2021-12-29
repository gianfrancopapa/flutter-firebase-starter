import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:repository/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final Repository<EmployeeEntity> _employeesRepository;

  EmployeesBloc(this._employeesRepository)
      : super(const EmployeesState(status: EmployeesStatus.initial)) {
    on<EmployeesLoaded>(_mapEmployeesLoadedToState);
  }

  Future<void> _mapEmployeesLoadedToState(
      EmployeesLoaded event, Emitter<EmployeesState> emit) async {
    emit(state.copyWith(status: EmployeesStatus.loading));

    try {
      final employees = await _employeesRepository.getAll();

      final loadedEmployees = employees.map<Employee>(_toEmployee).toList();
      return emit(state.copyWith(
        status: EmployeesStatus.success,
        employees: loadedEmployees,
      ));
    } on Exception {
      emit(state.copyWith(status: EmployeesStatus.failure));
    }
  }

  Employee _toEmployee(EmployeeEntity entity) => Employee.fromEntity(entity);
}
