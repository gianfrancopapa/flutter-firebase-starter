import 'package:flutterBoilerplate/utils/chip.dart';

abstract class FilterEmployeesEvent {
  const FilterEmployeesEvent();
}

class GetEmployees extends FilterEmployeesEvent {
  final bool filterEvent;
  const GetEmployees(this.filterEvent);
}

class ToggleChip extends FilterEmployeesEvent {
  final Chip chip;
  const ToggleChip(this.chip);
}

class GetFilters extends FilterEmployeesEvent {
  const GetFilters();
}

class ClearFilters extends FilterEmployeesEvent {
  const ClearFilters();
}
