import 'package:flutter/material.dart';
import 'package:firebasestarter/models/query.dart';
import 'package:firebasestarter/services/persistence/persistance_service_interface.dart';

typedef T Constructor<T>(Map<String, dynamic> map);

abstract class Repository<T> {
  final IPersistanceService _apiProvider;
  final Constructor<T> _constructor;

  const Repository(this._apiProvider, this._constructor);

  @protected
  Future<List<T>> getAll(Query query) async {
    try {
      final res = await _apiProvider.getAll(query);
      if (res.isEmpty) return [];
      final listOfT = List<T>();
      for (final item in res) {
        listOfT.add(_constructor(item));
      }
      return listOfT;
    } catch (e) {
      throw e;
    }
  }

  @protected
  Future<T> getById(String id) async {
    try {
      final res = await _apiProvider.getById(id);
      return _constructor(res);
    } catch (e) {
      throw e;
    }
  }

  @protected
  Future<void> post(Map<String, dynamic> data) async {
    try {
      await _apiProvider.post(data);
    } catch (e) {
      throw e;
    }
  }

  @protected
  Future<void> update(String id, Map<String, dynamic> data) async {
    try {
      await _apiProvider.put(id, data);
    } catch (e) {
      throw e;
    }
  }

  @protected
  Future<void> delete(String id) async {
    try {
      await _apiProvider.delete(id);
    } catch (e) {
      throw e;
    }
  }
}
