import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_event.dart';
import 'package:flutterBoilerplate/bloc/filter_employees/filter_employees_state.dart';
import 'package:flutterBoilerplate/models/IObserver.dart';
import 'package:flutterBoilerplate/models/filter.dart';
import 'package:flutterBoilerplate/repository/employees_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterEmployeesBloc
    extends Bloc<FilterEmployeesEvent, FilterEmployeesState>
    implements IObserver {
  final _employeesRepository = EmployeesRepository();

  FilterEmployeesBloc() : super(const NotDetermined());

  @override
  Stream<FilterEmployeesState> mapEventToState(
      FilterEmployeesEvent event) async* {
    switch (event.runtimeType) {
      case GetEmployees:
        yield* _getEmployees((event as GetEmployees).filter);
        break;
      default:
        yield const Error(
          'Error: Invalid event [FilterEmployeesBloc.mapEventToState].',
        );
    }
  }

  Stream<FilterEmployeesState> _getEmployees(Filter filter) async* {
    yield const Loading();
    try {
      final employees = await _employeesRepository.getEmployees(filter);

      yield Employees(employees);
    } catch (err) {
      yield Error(err.toString());
    }
  }

  @override
  void update() {
    add(const GetEmployees(null));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
