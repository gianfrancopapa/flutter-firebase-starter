import 'package:flutterBoilerplate/models/criteria.dart';

abstract class Query<S> {
  final int limit;
  final String orderBy;
  final bool descendant;
  final criterias = List<Criteria>();

  Query({this.limit, this.orderBy, this.descendant});

  void addCriteria(Criteria criteria) {
    criterias.add(criteria);
  }

  S generate();
}
