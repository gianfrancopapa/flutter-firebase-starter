import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterBoilerplate/models/custom_query.dart';
import 'package:flutterBoilerplate/models/filter.dart';

class FirebaseFilter extends Filter<Query> {
  static const _equal = '==';
  static const _minorOrEqual = '<=';
  static const _biggerOrEqual = '>=';
  static const _contains = 'array-contains';

  const FirebaseFilter({
    List<CustomQuery> queries: const [],
    int limit = 10,
    String orderBy = '',
    bool descendant = false,
  }) : super(
          queries: queries,
          limit: limit,
          orderBy: orderBy,
          descendant: descendant,
        );

  @override
  Query createQuery({CollectionReference reference}) {
    var firebaseQuery = reference.limit(limit);
    if (orderBy != '') {
      firebaseQuery = firebaseQuery.orderBy(
        orderBy,
        descending: descendant,
      );
    }
    if (queries.isEmpty) return firebaseQuery;
    for (final query in queries) {
      switch (query.operator) {
        case _equal:
          firebaseQuery = firebaseQuery.where(
            query.key,
            isEqualTo: query.value,
          );
          break;
        case _minorOrEqual:
          firebaseQuery = firebaseQuery.where(
            query.key,
            isLessThanOrEqualTo: query.runtimeType == DateTime
                ? Timestamp.fromDate(query.value)
                : query.value,
          );
          break;
        case _biggerOrEqual:
          firebaseQuery = firebaseQuery.where(
            query.key,
            isGreaterThanOrEqualTo: query.runtimeType == DateTime
                ? Timestamp.fromDate(query.value)
                : query.value,
          );
          break;
        case _contains:
          firebaseQuery = firebaseQuery.where(
            query.key,
            arrayContains: query.value,
          );
          break;
      }
    }
    return firebaseQuery;
  }
}
