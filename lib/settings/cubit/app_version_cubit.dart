import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/services/remote_config/remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'app_version_state.dart';

class AppVersionCubit extends Cubit<AppVersionState> {
  AppVersionCubit({@required RemoteConfigService remoteConfigService})
      : assert(remoteConfigService != null),
        _remoteConfigService = remoteConfigService,
        super(const AppVersionState());

  final RemoteConfigService _remoteConfigService;

  Future<void> appVersion() async {
    if (kIsWeb) {
      emit(state.copyWith(appVersion: _remoteConfigService?.getStringValueWeb));
    } else {
      emit(state.copyWith(
          appVersion: Platform.isAndroid
              ? _remoteConfigService?.getStringValueAndroid
              : _remoteConfigService?.getStringValueIos));
    }
  }

  void showVersion(String appVersion) {
    if (appVersion != null && appVersion.isNotEmpty) {
      emit(state.copyWith(showVersion: true));
    } else {
      emit(state.copyWith(showVersion: false));
    }
  }
}
