import 'package:firebasestarter/models/employee.dart';
import 'package:firebasestarter/models/query.dart';
import 'package:firebasestarter/repository/repository.dart';
import 'package:firebasestarter/services/persistence/firebase_persistance_service.dart';

class EmployeesRepository extends Repository<Employee> {
  static const _path = 'employees';
  static final _firebaseDb = FirebasePersistanceService(_path);

  EmployeesRepository() : super(_firebaseDb, Employee.fromJson);

  Future<List<Employee>> getEmployees(Query query) async {
    try {
      final employees = await getAll(query);
      return employees;
    } catch (err) {
      throw ('Error: $err while fetching users in [EmployeesRepository.getEmployees]');
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
