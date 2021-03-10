import 'package:firebasestarter/models/firebase_query.dart';
import 'package:firebasestarter/models/query.dart' as model;
import 'package:firebasestarter/services/persistence/persistance_service_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebasePersistanceService implements IPersistanceService {
  final _db = FirebaseFirestore.instance;
  final String _path;
  CollectionReference _ref;

  FirebasePersistanceService(this._path) {
    _ref = _db.collection(_path);
  }

  @override
  Future<List<Map<String, dynamic>>> getAll(model.Query query) async {
    try {
      QuerySnapshot res;
      if (query != null) {
        (query as FirebaseQuery).reference = _ref;
        res = await (query as FirebaseQuery).generate().get();
      } else {
        res = await _ref.get();
      }
      final list = List<Map<String, dynamic>>();
      for (final document in res.docs) {
        final map = document.data();
        map['id'] = document.id;
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
