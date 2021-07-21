part of 'app_bloc.dart';

enum AppStatus { initial, loading, firstTime, notFirstTime, failure }

class AppState extends Equatable {
  const AppState({@required this.status}) : assert(status != null);

  final AppStatus status;

  AppState copyWith({AppStatus status, String errorMessage}) {
    return AppState(status: status ?? this.status);
  }

  @override
  List<Object> get props => [status];
}
