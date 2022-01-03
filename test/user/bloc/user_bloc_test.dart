import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'user_bloc_test.mocks.dart';

@GenerateMocks([
  AuthService
], customMocks: [
  MockSpec<UserEntity>(as: #MockUserEntity, returnNullOnMissingStub: true)
])
void main() {
  group('UserBloc', () {
    late AuthService authService;
    UserEntity? user;

    setUp(() {
      authService = MockAuthService();
      user = MockUserEntity();
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
          user: User.fromEntity(user!),
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
