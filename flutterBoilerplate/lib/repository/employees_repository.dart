import 'package:flutterBoilerplate/models/datatypes/persistance_service_type.dart';
import 'package:flutterBoilerplate/models/domain/employee.dart';
import 'package:flutterBoilerplate/models/service_factory.dart';
import 'package:flutterBoilerplate/models/filter.dart';
import 'package:flutterBoilerplate/models/firebase_filter.dart';
import 'package:flutterBoilerplate/repository/repository.dart';

class EmployeesRepository extends Repository<Employee> {
  static final _serviceFactory = ServiceFactory();
  static const _path = 'employees';

  EmployeesRepository()
      : super(
          _serviceFactory.getPersistanceService(
            PersistanceServiceType.Firebase,
            _path,
          ),
          Employee.fromJson,
        );

  Future<List<Employee>> getEmployees(Filter<FirebaseFilter> filter) async {
    try {
      final employees = await getAll(filter);
      return employees;
    } catch (err) {
      throw ('Error: $err while fetching users in [UsersRepository.getEmployees]');
    }
  }

  Future<Employee> getEmployee(String id) async {
    try {
      final employee = await getById(id);
      return employee;
    } catch (err) {
      throw ('Error: $err while fetching users in [UsersRepository.getEmployee]');
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      final map = employee.toJson();
      await post(map);
    } catch (err) {
      throw 'Error: $err in [usersRepository.addEmployee]';
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      final map = employee.toJson();
      await update(employee.id, map);
    } catch (err) {
      throw 'Error: $err in [usersRepository.updateEmployee]';
    }
  }

  Future<void> deleteEmployee(String id) async {
    try {
      await delete(id);
    } catch (err) {
      throw 'Error: $err in [usersRepository.deleteEmployee]';
    }
  }
}
