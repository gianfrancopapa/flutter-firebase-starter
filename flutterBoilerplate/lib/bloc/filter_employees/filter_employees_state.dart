import 'package:flutterBoilerplate/models/domain/employee.dart';
import 'package:flutterBoilerplate/utils/chip.dart';
import 'package:flutterBoilerplate/utils/working_area_chip.dart';

abstract class FilterEmployeesState {
  const FilterEmployeesState();
}

class NotDetermined extends FilterEmployeesState {
  const NotDetermined();
}

class Loading extends FilterEmployeesState {
  const Loading();
}

class Error extends FilterEmployeesState {
  final String message;
  const Error(this.message);
}

class Employees extends FilterEmployeesState {
  final List<Employee> employees;
  const Employees(this.employees);
}

abstract class ChipsChanged extends FilterEmployeesState {
  const ChipsChanged();
}

class WorkingAreaChipsChanged extends ChipsChanged {
  final List<Chip> chips;
  const WorkingAreaChipsChanged(this.chips);
}

class AppliedFilters extends ChipsChanged {
  final List<WorkingAreaChip> chips;
  const AppliedFilters(this.chips);
}

class Filters extends FilterEmployeesState {
  final List<WorkingAreaChip> chips;
  const Filters(this.chips);
}
