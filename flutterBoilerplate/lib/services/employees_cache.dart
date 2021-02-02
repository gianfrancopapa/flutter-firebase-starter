import 'package:flutterBoilerplate/models/domain/employee.dart';
import 'package:flutterBoilerplate/services/cache.dart';

//Singleton
class EmployeesCache implements Cache<Employee> {
  final _data = Map<String, Employee>();

  static final EmployeesCache _instance = EmployeesCache._internal();

  factory EmployeesCache() => _instance;

  EmployeesCache._internal();

  @override
  List<Employee> getAll() {
    final _employees = List<Employee>();
    for (final entrie in _data.entries) {
      _employees.add(_data[entrie]);
    }
    return _employees;
  }

  @override
  Employee getById(String id) => _data[id];

  @override
  void delete(String id) {
    _data.removeWhere((key, value) => key == id);
  }

  @override
  void add(Employee employee) {
    _data[employee.id] = employee;
  }

  @override
  void put(Employee employee) {
    _data[employee.id] = employee;
  }
}
