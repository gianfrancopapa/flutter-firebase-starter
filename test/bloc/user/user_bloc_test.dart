import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../unit/auth/mocks/auth_mocks.dart';
import './mocks/user_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  final auth = MockFirebaseAuthService();
  final user = MockUser();
  group('User bloc /', () {
    blocTest(
      'Map UserLoaded to state',
      build: () => UserBloc(auth),
      act: (bloc) {
        when(auth.currentUser()).thenAnswer((_) async => user);
        bloc.add(const UserLoaded());
      },
      expect: () => [
        const UserState(status: UserStatus.inProgress),
        UserState(status: UserStatus.success, user: user),
      ],
    );
  });
}
