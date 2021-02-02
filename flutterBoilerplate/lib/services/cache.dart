abstract class Cache<T> {
  List<T> getAll();

  T getById(String id);

  void delete(String id);

  void add(T intance);

  void put(T instance);
}
