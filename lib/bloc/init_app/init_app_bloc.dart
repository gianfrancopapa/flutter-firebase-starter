import 'package:firebasestarter/bloc/init_app/init_app_event.dart';
import 'package:firebasestarter/bloc/init_app/init_app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitAppBloc extends Bloc<FirstTimeInAppEvent, FirstTimeInAppState> {
  static const _isFirstTime = 'is_first_time';

  InitAppBloc() : super(const NotDetermined());

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
    final prefs = await SharedPreferences.getInstance();
    final result = (prefs.getBool(_isFirstTime) ?? true);

    if (result) {
      await prefs.setBool(_isFirstTime, false);
      yield const FirstTime();
    } else {
      yield const NoFirstTime();
    }
  }
}
