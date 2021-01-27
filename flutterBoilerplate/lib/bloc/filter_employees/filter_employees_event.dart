abstract class FilterEmployeesEvent {
  const FilterEmployeesEvent();
}

class GetEmployees extends FilterEmployeesEvent {
  final bool filterEvent;
  const GetEmployees(this.filterEvent);
}
