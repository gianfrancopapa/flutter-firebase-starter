import 'package:flutterBoilerplate/models/filter.dart';

abstract class FilterEmployeesEvent {
  const FilterEmployeesEvent();
}

class GetEmployees extends FilterEmployeesEvent {
  final Filter filter;
  const GetEmployees(this.filter);
}
