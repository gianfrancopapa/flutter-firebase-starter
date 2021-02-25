import 'package:flutterBoilerplate/models/observer_interface.dart';

abstract class ISubject {
  final observers = List<IObserver>();

  void notify();
  void attach(IObserver observer);
}
