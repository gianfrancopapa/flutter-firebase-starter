import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repository/repository.dart';

class FirebaseEmployeeDatabase implements IDatabase<EmployeeEntity> {
  static const _collectionName = 'employees';

  final _db = FirebaseFirestore.instance.collection(_collectionName);

  @override
  Future<List<EmployeeEntity>> getAll() async {
    try {
      final response = await _db.get();
      return response.docs.map<EmployeeEntity>(_toEntity).toList();
    } catch (err) {
      throw 'Error: An error occurs while fetching Employees.';
    }
  }

  @override
  Future<EmployeeEntity> getById(String id) async {
    try {
      final response = await _db.doc(id).get();
      return _toEntity(response);
    } catch (err) {
      throw 'Error: An error occurs while fetching Employee with id: $id.';
    }
  }

  @override
  Future<String> post(EmployeeEntity entity) async {
    try {
      final response = await _db.add(entity.toJson());
      return response.id;
    } catch (err) {
      throw 'Error: An error occurs while posting Employee.';
    }
  }

  @override
  Future<void> put(EmployeeEntity entity) async {
    try {
      await _db.doc(entity.id).update(entity.toJson());
    } catch (err) {
      throw 'Error: An error occurs while posting Employee.';
    }
  }

  @override
  Future<void> delete(EmployeeEntity entity) async {
    try {
      await _db.doc(entity.id).delete();
    } catch (err) {
      throw 'Error: An error occurs while deleting Employee.';
    }
  }

  EmployeeEntity _toEntity(DocumentSnapshot doc) {
    return EmployeeEntity.fromJson(
        {'id': doc.id, ...(doc.data() as Map) as Map<String, dynamic>});
  }
}
