import 'dart:async';

import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_event.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_state.dart';
import 'package:flutterBoilerplate/models/criteria.dart';
import 'package:flutterBoilerplate/models/domain/employee.dart';
import 'package:flutterBoilerplate/models/observer_interface.dart';
import 'package:flutterBoilerplate/models/datatypes/working_area.dart';
import 'package:flutterBoilerplate/models/query_factory.dart';
import 'package:flutterBoilerplate/repository/employees_repository.dart';
import 'package:flutterBoilerplate/utils/chip.dart';
import 'package:flutterBoilerplate/utils/enum.dart';
import 'package:flutterBoilerplate/utils/working_area_chip.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/subjects.dart';

class FilterEmployeesBloc
    extends Bloc<FilterEmployeesEvent, FilterEmployeesState>
    implements IObserver {
  static const _workingArea = 'workingArea';
  List<Employee> _filteredList;
  final _employeesRepository = EmployeesRepository();
  final _queryFactory = QueryFactory();
  final _workingAreaChipList = List<WorkingAreaChip>();
  final _enabledWorkingAreaChipsList = List<WorkingAreaChip>();
  final _workingAreaChipController = BehaviorSubject<Chip>();
  final _workingAreaChipListController =
      BehaviorSubject<List<WorkingAreaChip>>();
  final _enabledWorkingAreaChipListController =
      BehaviorSubject<List<WorkingAreaChip>>();

  Stream<List<WorkingAreaChip>> get workingAreaChipList =>
      _workingAreaChipListController.stream;

  Stream<List<WorkingAreaChip>> get enabledWorkingAreaChipList =>
      _enabledWorkingAreaChipListController.stream;

  void onWorkingAreaChipChanged(Chip chip) =>
      _workingAreaChipController.sink.add(chip);

  void Function(void) get _onWorkingAreaChipListChanged =>
      _workingAreaChipListController.sink.add;

  void Function(void) get _onEnabledWorkingAreaChipListChanged =>
      _enabledWorkingAreaChipListController.sink.add;

  FilterEmployeesBloc() : super(const NotDetermined()) {
    _init();
  }

  @override
  Stream<FilterEmployeesState> mapEventToState(
    FilterEmployeesEvent event,
  ) async* {
    switch (event.runtimeType) {
      case GetEmployees:
        yield* _getEmployees(event);
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
      if (_enabledWorkingAreaChipsList.length == 0) {
        final employees = await _employeesRepository.getEmployees(null);
        _filteredList = employees;
        yield Employees(employees);
        return;
      }
      final criteria = Criteria<List<String>>(
        key: _workingArea,
        operator: QueryOperator.Match,
        value: _enabledWorkingAreaChipsList
            .map(
              (wAChip) => wAChip.text,
            )
            .toList(),
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

  @override
  void update() {
    add(const GetEmployees(false));
  }

  void _init() {
    var id = 0;
    WorkingArea.values.forEach(
      (wA) {
        final chip = WorkingAreaChip(id, Enum.getEnumValue(wA), false);
        id++;
        _workingAreaChipList.add(chip);
      },
    );
    _onWorkingAreaChipListChanged(_workingAreaChipList);
    _onEnabledWorkingAreaChipListChanged(_enabledWorkingAreaChipsList);
    _workingAreaChipController.stream.listen(
      (toggledChip) {
        _workingAreaChipList.forEach(
          (chip) {
            if (chip.id == toggledChip.id) {
              chip.enabled = !(chip.enabled);
            }
            if (chip.enabled && !_enabledWorkingAreaChipsList.contains(chip)) {
              _enabledWorkingAreaChipsList.add(chip);
            }
          },
        );
        _enabledWorkingAreaChipsList.removeWhere((chip) => !(chip.enabled));
        _onWorkingAreaChipListChanged(_workingAreaChipList);
        _onEnabledWorkingAreaChipListChanged(_enabledWorkingAreaChipsList);
      },
    );
  }

  @override
  Future<void> close() {
    _workingAreaChipController.close();
    _workingAreaChipListController.close();
    _enabledWorkingAreaChipListController.close();
    return super.close();
  }
}
