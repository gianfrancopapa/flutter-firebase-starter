import 'package:flutterBoilerplate/models/custom_query.dart';

abstract class Filter<T> {
  final List<CustomQuery> queries;
  final int limit;
  final String orderBy;
  final bool descendant;

  const Filter({this.descendant, this.limit, this.orderBy, this.queries});

  T createQuery();
}
