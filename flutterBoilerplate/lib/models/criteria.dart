enum QueryOperator { IsGreaterThan, IsLessThan, IsEqual, Match }

class Criteria<T> {
  final String key;
  final QueryOperator operator;
  final T value;

  const Criteria({
    this.key,
    this.operator,
    this.value,
  });
}
