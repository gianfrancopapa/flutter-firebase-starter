import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/services/app_info/app_info.dart';
import 'package:firebasestarter/services/remote_config/remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

part 'app_version_state.dart';

class AppVersionCubit extends Cubit<AppVersionState> {
  AppVersionCubit({@required AppInfo appInfo})
      : assert(appInfo != null),
        _appInfo = appInfo,
        super(const AppVersionState());

  final AppInfo _appInfo;

  Future<void> appVersion() async {
    emit(state.copyWith(appVersion: await _appInfo?.getVersionNumber()));
  }

  void showVersion(String appVersion) {
    if (appVersion != null && appVersion.isNotEmpty) {
      emit(state.copyWith(showVersion: true));
    } else {
      emit(state.copyWith(showVersion: false));
    }
  }
}
