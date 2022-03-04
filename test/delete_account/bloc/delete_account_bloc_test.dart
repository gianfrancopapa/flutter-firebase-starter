import 'package:auth/auth.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/authentication/authentication.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'delete_account_bloc_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  group('DeleteAccountRequestedEmail', () {
    late AuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();

      when(mockAuthService.onAuthStateChanged)
          .thenAnswer((_) => const Stream<UserEntity?>.empty());
    });
    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'calls authService.deleteAccountEmail',
      act: (bloc) => bloc.add(const DeleteAccountRequestedEmail()),
      build: () {
        when(mockAuthService.deleteAccountEmail(''))
            .thenAnswer((_) async => const Stream.empty());

        return DeleteAccountBloc(
          authService: mockAuthService,
        );
      },
      verify: (_) {
        verify(mockAuthService.deleteAccountEmail('')).called(1);
      },
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [success] when authService.deleteAccountEmail succeeds',
      act: (bloc) => bloc.add(const DeleteAccountRequestedEmail()),
      build: () {
        when(mockAuthService.deleteAccountEmail(''))
            .thenAnswer((_) async => const Stream.empty());
        return DeleteAccountBloc(
          authService: mockAuthService,
        );
      },
      expect: () => <DeleteAccountState>[
        const DeleteAccountState(
          status: DeleteAccountStatus.success,
          user: User.empty,
          password: '',
        ),
      ],
    );
    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [failure] when authService.deleteAccountEmail throws',
      act: (bloc) => bloc.add(const DeleteAccountRequestedEmail()),
      build: () {
        when(mockAuthService.deleteAccountEmail('')).thenThrow(AuthError.error);
        return DeleteAccountBloc(
          authService: mockAuthService,
        );
      },
      expect: () => <DeleteAccountState>[
        const DeleteAccountState(status: DeleteAccountStatus.error)
      ],
    );
  });

  group('DeleteAccountRequestedSocialMedia', () {
    late AuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();

      when(mockAuthService.onAuthStateChanged)
          .thenAnswer((_) => const Stream<UserEntity?>.empty());
    });
    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'calls authService.deleteAccountSocialMedia',
      act: (bloc) => bloc.add(
          const DeleteAccountRequestedSocialMedia(AuthenticationMethod.google)),
      build: () {
        when(mockAuthService
                .deleteAccountSocialMedia(AuthenticationMethod.google))
            .thenAnswer((_) async => const Stream.empty());

        return DeleteAccountBloc(
          authService: mockAuthService,
        );
      },
      verify: (_) {
        verify(mockAuthService
                .deleteAccountSocialMedia(AuthenticationMethod.google))
            .called(1);
      },
    );

    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [success] when authService.deleteAccountSocialMedia succeeds',
      act: (bloc) => bloc.add(
        const DeleteAccountRequestedSocialMedia(AuthenticationMethod.google),
      ),
      build: () {
        when(mockAuthService
                .deleteAccountSocialMedia(AuthenticationMethod.google))
            .thenAnswer((_) async => const Stream.empty());
        return DeleteAccountBloc(
          authService: mockAuthService,
        );
      },
      expect: () => <DeleteAccountState>[
        const DeleteAccountState(
          status: DeleteAccountStatus.success,
          user: User.empty,
          password: '',
        ),
      ],
    );
    blocTest<DeleteAccountBloc, DeleteAccountState>(
      'emits [failure] when authService.deleteAccountSocialMedia throws',
      act: (bloc) => bloc.add(
          const DeleteAccountRequestedSocialMedia(AuthenticationMethod.google)),
      build: () {
        when(mockAuthService
                .deleteAccountSocialMedia(AuthenticationMethod.google))
            .thenThrow(AuthError.error);
        return DeleteAccountBloc(
          authService: mockAuthService,
        );
      },
      expect: () => <DeleteAccountState>[
        const DeleteAccountState(status: DeleteAccountStatus.error)
      ],
    );
  });
}
