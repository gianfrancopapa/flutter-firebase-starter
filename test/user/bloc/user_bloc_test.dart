import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuthService extends Mock implements AuthService {}

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

void main() {
  group('UserBloc', () {
    AuthService authService;
    User user;

    setUp(() {
      authService = MockAuthService();
      user = MockUser();
    });

    test('has valid initial state', () {
      expect(
        UserBloc(authService: authService).state,
        const UserState(status: UserStatus.initial),
      );
    });

    blocTest<UserBloc, UserState>(
      'calls authService.currentUser',
      act: (bloc) => bloc.add(const UserLoaded()),
      build: () {
        return UserBloc(authService: authService);
      },
      verify: (_) => verify(authService.currentUser()).called(1),
    );

    blocTest<UserBloc, UserState>(
      'emits [loading, success] when authService.currentUser succeeds',
      act: (bloc) => bloc.add(const UserLoaded()),
      build: () {
        when(authService.currentUser()).thenAnswer((_) async => user);

        return UserBloc(authService: authService);
      },
      expect: () => <UserState>[
        const UserState(status: UserStatus.loading),
        UserState(
          status: UserStatus.success,
          user: user,
        ),
      ],
    );

    blocTest<UserBloc, UserState>(
      'emits [loading, failure] when authService.currentUser throws',
      act: (bloc) => bloc.add(const UserLoaded()),
      build: () {
        when(authService.currentUser()).thenThrow(AuthError.ERROR);

        return UserBloc(authService: authService);
      },
      expect: () => <UserState>[
        const UserState(status: UserStatus.loading),
        const UserState(status: UserStatus.failure),
      ],
    );
  });
}
