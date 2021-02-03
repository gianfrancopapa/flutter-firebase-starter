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
  static const _error =
      'Error: Invalid event [FilterEmployeesBloc.mapEventToState].';

  final _employeesRepository = EmployeesRepository();
  final _queryFactory = QueryFactory();

  List<Employee> _filteredList;
  final _wAList = List<WorkingAreaChip>();
  final _enabledWAList = List<WorkingAreaChip>();

  FilterEmployeesBloc() : super(const NotDetermined()) {
    var id = 0;
    WorkingArea.values.forEach(
      (wA) {
        _wAList.add(WorkingAreaChip(id, Enum.getEnumValue(wA), false));
        id++;
      },
    );
  }

  @override
  void update() {
    add(const GetEmployees());
  }

  @override
  Stream<FilterEmployeesState> mapEventToState(
    FilterEmployeesEvent event,
  ) async* {
    yield const Loading();
    switch (event.runtimeType) {
      case GetEmployees:
        yield* _getEmployees();
        break;
      case GetFilters:
        yield* _getFilters();
        break;
      case ToggleWorkingAreaFilter:
        yield* _toggleWorkingAreaChip((event as ToggleWorkingAreaFilter).id);
        break;
      case ApplyFilters:
        yield* _applyFilters();
        break;
      case GetAppliedFilters:
        yield* _appliedFilters();
        break;
      case RemoveWorkingAreaFilter:
        yield* _removeFilter((event as RemoveWorkingAreaFilter).id);
        break;
      case ClearFilters:
        yield* _clearFilters();
        break;
      default:
        yield const Error(_error);
    }
  }

  Stream<FilterEmployeesState> _getEmployees() async* {
    try {
      if (_filteredList?.isNotEmpty ?? false) {
        yield Employees(_filteredList);
        return;
      }
      final employees = await _employeesRepository.getEmployees(null);
      yield Employees(employees);
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<FilterEmployeesState> _applyFilters() async* {
    try {
      _enabledWAList.clear();
      _wAList.forEach((waChip) {
        if (waChip.enabled) {
          _enabledWAList.add(waChip);
        }
      });
      var query;
      if (_enabledWAList.length > 0) {
        final criteria = Criteria<List<String>>(
          key: _workingArea,
          operator: QueryOperator.Match,
          value: _enabledWAList.map((chip) => chip.text).toList(),
        );
        query = _queryFactory.create();
        query.addCriteria(criteria);
      }
      _filteredList = await _employeesRepository.getEmployees(query);
      yield AppliedFilters(_enabledWAList);
      yield Employees(_filteredList);
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<FilterEmployeesState> _toggleWorkingAreaChip(int id) async* {
    try {
      final chip = _wAList.firstWhere((waChip) => waChip.id == id);
      chip.enabled = !(chip.enabled);
      yield WorkingAreaChipsChanged(_wAList);
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<FilterEmployeesState> _appliedFilters() async* {
    try {
      yield AppliedFilters(_enabledWAList);
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<FilterEmployeesState> _getFilters() async* {
    try {
      if (_enabledWAList.isNotEmpty) {
        for (final wA in _wAList) {
          final wAToUpdate = _enabledWAList.firstWhere(
            (enabledWA) => enabledWA.id == wA.id,
            orElse: () => null,
          );
          wA.enabled = wAToUpdate != null;
        }
      } else {
        _wAList.forEach((chip) => chip.enabled = false);
      }
      yield Filters(_wAList);
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<FilterEmployeesState> _removeFilter(int id) async* {
    try {
      _enabledWAList.removeWhere((wA) => wA.id == id);
      final wA = _wAList.firstWhere((wA) => wA.id == id);
      wA.enabled = false;
      yield* _applyFilters();
    } catch (err) {
      yield Error(err.toString());
    }
  }

  Stream<FilterEmployeesState> _clearFilters() async* {
    try {
      _enabledWAList.clear();
      _wAList.forEach((wA) => wA.enabled = false);
      _filteredList = await _employeesRepository.getEmployees(null);
      yield AppliedFilters(_enabledWAList);
      yield Employees(_filteredList);
    } catch (err) {
      yield Error(err.toString());
    }
  }
}
