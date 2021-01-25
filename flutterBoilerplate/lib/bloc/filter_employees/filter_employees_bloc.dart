import 'dart:async';

import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_event.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_state.dart';
import 'package:flutterBoilerplate/models/criteria.dart';
import 'package:flutterBoilerplate/models/domain/employee.dart';
import 'package:flutterBoilerplate/models/observer_interface.dart';
import 'package:flutterBoilerplate/models/datatypes/working_area.dart';
import 'package:flutterBoilerplate/models/query_factory.dart';
import 'package:flutterBoilerplate/repository/employees_repository.dart';
import 'package:flutterBoilerplate/utils/enum.dart';
import 'package:flutterBoilerplate/utils/working_area_chip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterEmployeesBloc
    extends Bloc<FilterEmployeesEvent, FilterEmployeesState>
    implements IObserver {
  static const _workingArea = 'workingArea';
  final _employeesRepository = EmployeesRepository();
  final _workingAreaChipList = List<WorkingAreaChip>();
  final _queryFactory = QueryFactory();
  List<Employee> _filteredList;

  FilterEmployeesBloc() : super(const NotDetermined()) {
    var id = 0;
    WorkingArea.values.forEach(
      (wA) {
        final chip = WorkingAreaChip(id, Enum.getEnumValue(wA), false);
        id++;
        _workingAreaChipList.add(chip);
      },
    );
  }

  @override
  Stream<FilterEmployeesState> mapEventToState(
    FilterEmployeesEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetFilters:
        yield WorkingAreaFilterList(_workingAreaChipList);
        break;
      case GetEmployees:
        yield* _getEmployees(event);
        break;
      case ClearFilters:
        yield* _clearFilters();
        break;
      case ToggleChip:
        switch ((event as ToggleChip).chip.runtimeType) {
          case WorkingAreaChip:
            yield* _toggleWorkingAreaChip((event as ToggleChip).chip.id);
            break;
          default:
            return;
        }
        break;
      default:
        yield const Error(
          'Error: Invalid event [FilterEmployeesBloc.mapEventToState].',
        );
    }
  }

  Stream<FilterEmployeesState> _getEmployees(GetEmployees event) async* {
    if (event.filterEvent) {
      yield* _applyFilters();
    } else {
      yield const Loading();
      try {
        if (_filteredList?.isNotEmpty ?? false) {
          yield Employees(_filteredList);
          return;
        }
        final employees = await _employeesRepository.getEmployees(null);
        _filteredList = employees;
        yield Employees(employees);
      } catch (err) {
        yield Error(err.toString());
      }
    }
  }

  Stream<FilterEmployeesState> _applyFilters() async* {
    yield const Loading();
    try {
      final enabledChips = List<String>();
      _workingAreaChipList.forEach((wAChip) {
        if (wAChip.enabled) enabledChips.add(wAChip.text);
      });
      if (enabledChips.length == 0) {
        final employees = await _employeesRepository.getEmployees(null);
        _filteredList = employees;
        yield Employees(employees);
        return;
      }
      final criteria = Criteria<List<String>>(
        key: _workingArea,
        operator: QueryOperator.Match,
        value: enabledChips,
      );
      final query = _queryFactory.create();
      query.addCriteria(criteria);
      final employees = await _employeesRepository.getEmployees(query);
      _filteredList = employees;
      yield Employees(employees);
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<FilterEmployeesState> _toggleWorkingAreaChip(int id) async* {
    yield const Loading();
    _workingAreaChipList.forEach((chip) {
      if (chip.id == id) {
        chip.enabled = !(chip.enabled);
      }
    });
    yield WorkingAreaFilterList(_workingAreaChipList);
  }

  Stream<FilterEmployeesState> _clearFilters() async* {
    yield const Loading();
    _workingAreaChipList.forEach((wAChip) {
      wAChip.enabled = false;
    });
    yield WorkingAreaFilterList(_workingAreaChipList);
  }

  @override
  void update() {
    add(const GetEmployees(false));
  }
}
