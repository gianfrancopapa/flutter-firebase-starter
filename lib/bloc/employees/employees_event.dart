import 'package:equatable/equatable.dart';

abstract class EmployeesEvent extends Equatable {
  const EmployeesEvent();

  @override
  List<Object> get props => [];
}

class EmployeesLoaded extends EmployeesEvent {
  const EmployeesLoaded();
}
