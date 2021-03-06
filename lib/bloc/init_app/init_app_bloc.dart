import 'package:firebasestarter/bloc/init_app/init_app_event.dart';
import 'package:firebasestarter/bloc/init_app/init_app_state.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class InitAppBloc extends Bloc<FirstTimeInAppEvent, FirstTimeInAppState> {
  static const String _isFirstTime = 'is_first_time';
  LocalPersistanceService _localPersistanceService;

  InitAppBloc() : super(const NotDetermined()) {
    _localPersistanceService = GetIt.I.get<LocalPersistanceService>();
  }

  @override
  Stream<FirstTimeInAppState> mapEventToState(
      FirstTimeInAppEvent event) async* {
    switch (event.runtimeType) {
      case IsFirstTime:
        yield* _checkIfFirstTime();
        break;
      default:
        yield const Error('Invalid event.');
    }
  }

  Stream<FirstTimeInAppState> _checkIfFirstTime() async* {
    yield const Loading();
    try {
      final firstTime =
          await _localPersistanceService.containsKey(_isFirstTime);
      if (firstTime ?? true) {
        await _localPersistanceService.setValue<bool>(_isFirstTime, false);
        yield const FirstTime();
      } else {
        yield const NoFirstTime();
      }
    } catch (err) {
      yield Error(err.toString());
    }
  }
}
