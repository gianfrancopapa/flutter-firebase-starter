import 'package:equatable/equatable.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({@required LocalPersistanceService localPersistanceService})
      : assert(localPersistanceService != null),
        _localPersistanceService = localPersistanceService,
        super(const AppState(status: AppStatus.initial));

  static const String _isFirstTime = 'is_first_time';

  final LocalPersistanceService _localPersistanceService;

  @override
  Stream<AppState> mapEventToState(AppEvent event) async* {
    if (event is AppIsFirstTimeLaunched) {
      yield* _mapAppIsFirstTimeLaunchedToState();
    }
  }

  Stream<AppState> _mapAppIsFirstTimeLaunchedToState() async* {
    yield state.copyWith(status: AppStatus.loading);

    try {
      final firstTime =
          await _localPersistanceService.getValue<bool>(_isFirstTime);

      await Future.delayed(const Duration(seconds: 2));

      if (firstTime ?? true) {
        await _localPersistanceService.setValue<bool>(_isFirstTime, false);
        yield state.copyWith(status: AppStatus.firstTime);
      } else {
        yield state.copyWith(status: AppStatus.notFirstTime);
      }
    } on Exception {
      yield state.copyWith(status: AppStatus.failure);
    }
  }
}
