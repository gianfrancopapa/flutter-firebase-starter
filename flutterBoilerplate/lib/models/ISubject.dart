import 'package:flutterBoilerplate/models/IObserver.dart';

abstract class ISubject {
  final observers = List<IObserver>();

  void notify();
  void attach(IObserver observer);
}
