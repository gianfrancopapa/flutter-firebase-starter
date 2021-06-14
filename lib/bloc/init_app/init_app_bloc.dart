import 'package:firebasestarter/bloc/init_app/init_app_event.dart';
import 'package:firebasestarter/bloc/init_app/init_app_state.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class InitAppBloc extends Bloc<InitAppEvent, InitAppState> {
  static const String _isFirstTime = 'is_first_time';
  LocalPersistanceService _localPersistanceService;

  InitAppBloc({LocalPersistanceService localPersistanceService})
      : super(const InitAppState()) {
    _localPersistanceService =
        localPersistanceService ?? GetIt.I.get<LocalPersistanceService>();
  }

  @override
  Stream<InitAppState> mapEventToState(InitAppEvent event) async* {
    if (event is InitAppIsFirstTime) {
      yield* _mapInitAppIsFirstTimeToState();
    }
  }

  Stream<InitAppState> _mapInitAppIsFirstTimeToState() async* {
    yield state.copyWith(status: InitAppStatus.inProgress);
    try {
      final firstTime =
          await _localPersistanceService.getValue<bool>(_isFirstTime);
      const _duration = Duration(seconds: 2);
      await Future.delayed(_duration, () async {});
      if (firstTime ?? true) {
        await _localPersistanceService.setValue<bool>(_isFirstTime, false);
        yield state.copyWith(status: InitAppStatus.firstTime);
      } else {
        yield state.copyWith(status: InitAppStatus.notFirstTime);
      }
    } catch (error) {
      yield state.copyWith(
        status: InitAppStatus.failure,
        errorMessage: error,
      );
    }
  }
}
