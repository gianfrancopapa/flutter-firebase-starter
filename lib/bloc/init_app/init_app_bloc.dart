import 'package:firebasestarter/bloc/init_app/init_app_event.dart';
import 'package:firebasestarter/bloc/init_app/init_app_state.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class InitAppBloc extends Bloc<InitAppEvent, InitAppState> {
  static const String _isFirstTime = 'is_first_time';
  LocalPersistanceService _localPersistanceService;

  InitAppBloc() : super(const InitAppInitial()) {
    _localPersistanceService = GetIt.I.get<LocalPersistanceService>();
  }

  @override
  Stream<InitAppState> mapEventToState(InitAppEvent event) async* {
    switch (event.runtimeType) {
      case InitAppIsFirstTime:
        yield* _mapInitAppIsFirstTimeToState();
        break;
      default:
        yield const InitAppError('Invalid event.');
    }
  }

  Stream<InitAppState> _mapInitAppIsFirstTimeToState() async* {
    yield const InitAppLoadInProgress();
    try {
      final firstTime =
          await _localPersistanceService.getValue<bool>(_isFirstTime);
      if (firstTime ?? true) {
        await _localPersistanceService.setValue<bool>(_isFirstTime, false);
        yield const InitAppFirstTime();
      } else {
        yield const InitAppNotFirstTime();
      }
    } catch (err) {
      yield InitAppError(err.toString());
    }
  }
}
