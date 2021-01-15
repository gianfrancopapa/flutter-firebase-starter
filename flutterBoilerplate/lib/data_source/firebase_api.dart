import 'package:flutterBoilerplate/data_source/api_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterBoilerplate/models/filter.dart';

class FirebaseAPI implements IApi {
  final _db = FirebaseFirestore.instance;
  final String _path;
  CollectionReference _ref;

  FirebaseAPI(this._path) {
    _ref = _db.collection(_path);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(Filter filter) async {
    try {
      final query = filter.createQuery();
      final res = await query.concatQueries(reference: _ref).getDocuments();
      final list = List<Map<String, dynamic>>();
      for (final document in res.documents) {
        final map = document.data;
        map['id'] = document.documentID;
        list.add(map);
      }
      return list;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Map<String, dynamic>> getById(String id) async {
    try {
      final document = await _ref.doc(id).get();
      final map = document.data();
      map['id'] = document.id;
      return map;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      return await _ref.doc(id).delete();
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> post(Map<String, dynamic> data) async {
    try {
      await _ref.add(data);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> put(String id, Map<String, dynamic> data) async {
    try {
      await _ref.doc(id).update(data);
    } catch (e) {
      throw e;
    }
  }
}
