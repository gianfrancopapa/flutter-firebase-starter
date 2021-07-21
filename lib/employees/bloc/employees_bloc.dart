import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/models/employee.dart';
import 'package:flutter/foundation.dart';
import 'package:repository/repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employees_event.dart';
part 'employees_state.dart';

class EmployeesBloc extends Bloc<EmployeesEvent, EmployeesState> {
  final Repository<EmployeeEntity> _employeesRepository;

  EmployeesBloc(this._employeesRepository)
      : super(const EmployeesState(status: EmployeesStatus.initial));

  @override
  Stream<EmployeesState> mapEventToState(EmployeesEvent event) async* {
    if (event is EmployeesLoaded) {
      yield* _mapEmployeesLoadedToState();
    }
  }

  Stream<EmployeesState> _mapEmployeesLoadedToState() async* {
    yield state.copyWith(status: EmployeesStatus.loading);

    try {
      final employees = await _employeesRepository.getAll();

      final loadedEmployees = employees.map<Employee>(_toEmployee).toList();
      yield state.copyWith(
        status: EmployeesStatus.success,
        employees: loadedEmployees,
      );
    } on Exception {
      yield state.copyWith(status: EmployeesStatus.failure);
    }
  }

  Employee _toEmployee(EmployeeEntity entity) => Employee.fromEntity(entity);
}
