import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterBoilerplate/models/criteria.dart';
import 'package:flutterBoilerplate/models/query.dart' as my;

class FirebaseQuery extends my.Query<Query> {
  CollectionReference _reference;

  FirebaseQuery({
    int limit,
    bool descendant,
    String orderBy,
  });

  set reference(CollectionReference ref) {
    _reference = ref;
  }

  @override
  Query generate() {
    if (_reference == null) {
      throw 'Error: Try to set db reference before generate actual query. [FirebaseQuery.generate]';
    }
    Query firebaseQuery = _reference;
    if (orderBy != null) {
      firebaseQuery = firebaseQuery.orderBy(
        orderBy,
        descending: descendant ?? false,
      );
    }
    if (limit != null) {
      firebaseQuery = firebaseQuery.limit(limit);
    }
    for (final criteria in criterias) {
      switch (criteria.operator) {
        case QueryOperator.IsGreaterThan:
          firebaseQuery = firebaseQuery.where(
            criteria.key,
            isGreaterThan: criteria.value,
          );
          break;
        case QueryOperator.IsLessThan:
          firebaseQuery = firebaseQuery.where(
            criteria.key,
            isLessThan: criteria.value,
          );
          break;
        case QueryOperator.IsEqual:
          firebaseQuery = firebaseQuery.where(
            criteria.key,
            isEqualTo: criteria.value,
          );
          break;
        case QueryOperator.Match:
          firebaseQuery = firebaseQuery.where(
            criteria.key,
            whereIn: criteria.value as List<dynamic>,
          );
          break;
        default:
          throw 'Error: Invalid criteria in [FirebaseQuery.generate]';
      }
    }
    return firebaseQuery;
  }
}
