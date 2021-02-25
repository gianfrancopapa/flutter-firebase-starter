import 'package:flutterBoilerplate/models/firebase_query.dart';
import 'package:flutterBoilerplate/models/query.dart';
import 'package:flutterBoilerplate/models/service_factory.dart';
import 'package:flutterBoilerplate/models/datatypes/persistance_service_type.dart';

//Singleton
class QueryFactory {
  static final QueryFactory _instance = QueryFactory._internal();
  final _serviceFactory = ServiceFactory();

  QueryFactory._internal();

  factory QueryFactory() => _instance;

  Query create({int limit, bool descendant, String orderBy}) {
    switch (_serviceFactory.persistanceServiceType) {
      case PersistanceServiceType.Firebase:
        return FirebaseQuery(
          limit: limit,
          descendant: descendant,
          orderBy: orderBy,
        );
      default:
        throw 'Error: cannot find specified type in [QueryFactory.getQuery]';
    }
  }
}
