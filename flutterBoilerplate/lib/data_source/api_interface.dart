import 'package:flutterBoilerplate/models/filter.dart';

abstract class IApi {
  Future<List<Map<String, dynamic>>> getAll(Filter filter);

  Future<Map<String, dynamic>> getById(String id);

  Future<void> delete(String id);

  Future<void> post(Map<String, dynamic> intance);

  Future<void> put(String id, Map<String, dynamic> instance);
}
