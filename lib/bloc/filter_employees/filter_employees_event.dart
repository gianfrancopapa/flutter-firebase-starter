abstract class FilterEmployeesEvent {
  const FilterEmployeesEvent();
}

class GetEmployees extends FilterEmployeesEvent {
  const GetEmployees();
}

class ApplyFilters extends FilterEmployeesEvent {
  const ApplyFilters();
}

class GetFilters extends FilterEmployeesEvent {
  const GetFilters();
}

class GetAppliedFilters extends FilterEmployeesEvent {
  const GetAppliedFilters();
}

class ToggleWorkingAreaFilter extends FilterEmployeesEvent {
  final int id;
  const ToggleWorkingAreaFilter(this.id);
}

class RemoveWorkingAreaFilter extends FilterEmployeesEvent {
  final int id;
  const RemoveWorkingAreaFilter(this.id);
}

class ClearFilters extends FilterEmployeesEvent {
  const ClearFilters();
}
