import 'package:equatable/equatable.dart';

abstract class InitAppEvent extends Equatable {
  const InitAppEvent();

  @override
  List<Object> get props => [];
}

class InitAppIsFirstTime extends InitAppEvent {
  const InitAppIsFirstTime();
}
