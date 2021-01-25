import 'package:flutterBoilerplate/models/query.dart';

abstract class IPersistanceService {
  IPersistanceService(String path);

  Future<List<Map<String, dynamic>>> getAll(Query query);

  Future<Map<String, dynamic>> getById(String id);

  Future<void> delete(String id);

  Future<void> post(Map<String, dynamic> intance);

  Future<void> put(String id, Map<String, dynamic> instance);
}
