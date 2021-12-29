part of 'app_version_cubit.dart';

class AppVersionState extends Equatable {
  const AppVersionState({this.appVersion});

  final String? appVersion;

  @override
  List<Object?> get props => [appVersion];

  AppVersionState copyWith({String? appVersion}) {
    return AppVersionState(appVersion: appVersion ?? this.appVersion);
  }
}
