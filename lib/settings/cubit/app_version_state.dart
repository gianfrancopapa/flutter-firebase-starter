part of 'app_version_cubit.dart';

class AppVersionState extends Equatable {
  const AppVersionState({this.showVersion, this.appVersion});

  final bool showVersion;
  final String appVersion;

  @override
  List<Object> get props => [showVersion, appVersion];

  AppVersionState copyWith({bool showVersion, String appVersion}) {
    return AppVersionState(
        showVersion: showVersion ?? this.showVersion,
        appVersion: appVersion ?? this.appVersion);
  }
}
