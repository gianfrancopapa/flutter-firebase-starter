abstract class LocalPersistanceService {
  Future<void>? setValue<T>(String key, T value);

  Future<T?> getValue<T>(String key);

  Future<bool>? removeValue(String key);

  Future<bool>? removeAll();

  Future<bool>? containsKey(String value);
}
