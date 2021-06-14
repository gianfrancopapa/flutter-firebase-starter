import 'package:equatable/equatable.dart';

enum InitAppStatus { initial, inProgress, firstTime, notFirstTime, failure }

class InitAppState extends Equatable {
  final InitAppStatus status;
  final String errorMessage;

  const InitAppState({
    InitAppStatus this.status = InitAppStatus.initial,
    String this.errorMessage,
  }) : assert(status != null);

  InitAppState copyWith({InitAppStatus status, String errorMessage}) {
    return InitAppState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object> get props => [
        status,
        errorMessage,
      ];
}
