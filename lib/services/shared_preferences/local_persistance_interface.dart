abstract class LocalPersistanceService {
  Future<void> setValue<T>(String key, T value);

  Future<T> getValue<T>(String key);

  Future<void> removeValue(String key);

  Future<void> removeAll();

  Future<bool> containsKey(String value);
}
