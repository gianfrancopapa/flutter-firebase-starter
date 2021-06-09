import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/init_app/init_app_bloc.dart';
import 'package:firebasestarter/bloc/init_app/init_app_event.dart';
import 'package:firebasestarter/bloc/init_app/init_app_state.dart';
import 'package:firebasestarter/services/shared_preferences/local_persistance_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks/init_app_bloc_mocks.dart';

void main() {
  LocalPersistanceService localPersistance;
  const error = 'Error';
  const _isFirstTime = 'is_first_time';

  setUp(() {
    localPersistance = MockLocalPersistanceService();
  });

  group(
    'InitAppBloc /',
    () {
      test('Initial state', () {
        final loginBloc =
            InitAppBloc(localPersistanceService: localPersistance);
        expect(loginBloc.state.status, InitAppStatus.initial);
      });

      blocTest(
        'InitAppIsFirstTime started, success - is first time',
        build: () => InitAppBloc(localPersistanceService: localPersistance),
        act: (bloc) {
          when(localPersistance.getValue<bool>(_isFirstTime))
              .thenAnswer((_) async => true);
          bloc.add(const InitAppIsFirstTime());
        },
        expect: () => [
          const InitAppState(status: InitAppStatus.inProgress),
          const InitAppState(status: InitAppStatus.firstTime),
        ],
      );

      blocTest(
        'InitAppIsFirstTime started, success - not first time',
        build: () => InitAppBloc(localPersistanceService: localPersistance),
        act: (bloc) {
          when(localPersistance.getValue<bool>(_isFirstTime))
              .thenAnswer((_) async => false);
          bloc.add(const InitAppIsFirstTime());
        },
        expect: () => [
          const InitAppState(status: InitAppStatus.inProgress),
          const InitAppState(status: InitAppStatus.notFirstTime),
        ],
      );

      blocTest(
        'InitAppIsFirstTime started, failure',
        build: () => InitAppBloc(localPersistanceService: localPersistance),
        act: (bloc) {
          when(localPersistance.getValue<bool>(_isFirstTime)).thenThrow(error);
          bloc.add(const InitAppIsFirstTime());
        },
        expect: () => [
          const InitAppState(status: InitAppStatus.inProgress),
          const InitAppState(
              status: InitAppStatus.failure, errorMessage: error),
        ],
      );

      blocTest(
        'Invalid event started, failure',
        build: () => InitAppBloc(localPersistanceService: localPersistance),
        act: (bloc) {
          bloc.add(null);
        },
        expect: () => [
          const InitAppState(
            status: InitAppStatus.failure,
            errorMessage: 'Invalid event.',
          ),
        ],
      );
    },
  );
}
