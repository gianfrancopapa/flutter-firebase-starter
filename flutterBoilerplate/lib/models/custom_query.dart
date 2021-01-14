class CustomQuery<T> {
  final String key;
  final String operator;
  final T value;

  const CustomQuery({
    this.key,
    this.operator,
    this.value,
  });
}
