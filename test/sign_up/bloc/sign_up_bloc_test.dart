import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:auth/auth.dart';
import 'package:mockito/mockito.dart';
import 'sign_up_bloc_test.mocks.dart';

@GenerateMocks(
  [AuthService, UserEntity],
)
void main() {
  group(
    'SignUpBloc',
    () {
      late AuthService mockAuthService;
      UserEntity? mockUser;

      final firstName = FirstName.dirty('firstName');
      final lastName = LastName.dirty('lastName');
      final email = Email.dirty('email@email.com');
      final password = Password.dirty('Password01');
      final passwordConfirmation = Password.dirty('Password01');

      setUp(() {
        mockAuthService = MockAuthService();
        mockUser = MockUserEntity();
        when(mockUser!.id).thenReturn('1');
        when(mockUser!.firstName).thenReturn('firstName');
        when(mockUser!.lastName).thenReturn('lastName');
        when(mockUser!.email).thenReturn('email@email.com');
        when(mockUser!.imageUrl).thenReturn('https://mock-image.com');
      });

      test('has valid initial state', () {
        expect(
          SignUpBloc(authService: mockAuthService).state,
          equals(
            SignUpState(
              status: SignUpStatus.initial,
              firstName: FirstName.pure(),
              lastName: LastName.pure(),
              email: Email.pure(),
              password: Password.pure(),
              passwordConfirmation: Password.pure(),
            ),
          ),
        );
      });

      blocTest<SignUpBloc, SignUpState>(
        'calls authService.createUserWithEmailAndPassword',
        act: (bloc) => bloc.add(const SignUpRequested()),
        seed: () => SignUpState(
          status: SignUpStatus.valid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
        build: () {
          return SignUpBloc(authService: mockAuthService);
        },
        verify: (_) {
          verify(
            mockAuthService.createUserWithEmailAndPassword(
              name: firstName.value!,
              lastName: lastName.value!,
              email: email.value!,
              password: password.value!,
            ),
          ).called(1);
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [loading, success] when '
        'authService.createUserWithEmailAndPassword succeeds',
        act: (bloc) => bloc.add(const SignUpRequested()),
        seed: () => SignUpState(
          status: SignUpStatus.valid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
        build: () {
          when(
            mockAuthService.createUserWithEmailAndPassword(
              name: firstName.value!,
              lastName: lastName.value!,
              email: email.value!,
              password: password.value!,
            ),
          ).thenAnswer((_) async => mockUser);

          return SignUpBloc(authService: mockAuthService);
        },
        expect: () => <SignUpState>[
          SignUpState(
            status: SignUpStatus.loading,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
          SignUpState(
            status: SignUpStatus.success,
            user: User.fromEntity(mockUser!),
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [loading, failure] when '
        'authService.createUserWithEmailAndPassword throws',
        act: (bloc) => bloc.add(const SignUpRequested()),
        seed: () => SignUpState(
          status: SignUpStatus.valid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          passwordConfirmation: passwordConfirmation,
        ),
        build: () {
          when(
            mockAuthService.createUserWithEmailAndPassword(
              name: firstName.value!,
              lastName: lastName.value!,
              email: email.value!,
              password: password.value!,
            ),
          ).thenThrow(AuthError.error);

          return SignUpBloc(authService: mockAuthService);
        },
        expect: () => <SignUpState>[
          SignUpState(
            status: SignUpStatus.loading,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
          SignUpState(
            status: SignUpStatus.failure,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [loading, failure] when '
        'password isNotEqual to passwordConfirmation',
        act: (bloc) => bloc.add(const SignUpRequested()),
        seed: () => SignUpState(
          status: SignUpStatus.valid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          passwordConfirmation: Password.dirty('anotherPassword'),
        ),
        build: () {
          return SignUpBloc(authService: mockAuthService);
        },
        verify: (_) {
          verifyNever(
            mockAuthService.createUserWithEmailAndPassword(
              name: firstName.value!,
              lastName: lastName.value!,
              email: email.value!,
              password: password.value!,
            ),
          );
        },
        expect: () => <SignUpState>[
          SignUpState(
            status: SignUpStatus.loading,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            passwordConfirmation: Password.dirty('anotherPassword'),
          ),
          SignUpState(
            status: SignUpStatus.failure,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            passwordConfirmation: Password.dirty('anotherPassword'),
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits updated firstName',
        act: (bloc) => bloc.add(
          const SignUpFirstNameChanged(firstName: 'firstName'),
        ),
        build: () {
          return SignUpBloc(authService: mockAuthService);
        },
        expect: () => <SignUpState>[
          SignUpState(
            status: SignUpStatus.invalid,
            firstName: FirstName.dirty('firstName'),
            lastName: LastName.pure(),
            email: Email.pure(),
            password: Password.pure(),
            passwordConfirmation: Password.pure(),
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits updated lastName',
        act: (bloc) => bloc.add(
          const SignUpLastNameChanged(lastName: 'lastName'),
        ),
        build: () {
          return SignUpBloc(authService: mockAuthService);
        },
        expect: () => <SignUpState>[
          SignUpState(
            status: SignUpStatus.invalid,
            firstName: FirstName.pure(),
            lastName: LastName.dirty('lastName'),
            email: Email.pure(),
            password: Password.pure(),
            passwordConfirmation: Password.pure(),
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits updated email',
        act: (bloc) => bloc.add(
          const SignUpEmailChanged(email: 'email@email.com'),
        ),
        build: () {
          return SignUpBloc(authService: mockAuthService);
        },
        expect: () => <SignUpState>[
          SignUpState(
            status: SignUpStatus.invalid,
            firstName: FirstName.pure(),
            lastName: LastName.pure(),
            email: Email.dirty('email@email.com'),
            password: Password.pure(),
            passwordConfirmation: Password.pure(),
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits updated password',
        act: (bloc) => bloc.add(
          const SignUpPasswordChanged(password: 'Password01'),
        ),
        build: () {
          return SignUpBloc(authService: mockAuthService);
        },
        expect: () => <SignUpState>[
          SignUpState(
            status: SignUpStatus.invalid,
            firstName: FirstName.pure(),
            lastName: LastName.pure(),
            email: Email.pure(),
            password: Password.dirty('Password01'),
            passwordConfirmation: Password.pure(),
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits updated passwordConfirmation',
        act: (bloc) => bloc.add(
          const SignUpPasswordConfirmationChanged(
            passwordConfirmation: 'Password01',
          ),
        ),
        build: () {
          return SignUpBloc(authService: mockAuthService);
        },
        expect: () => <SignUpState>[
          SignUpState(
            status: SignUpStatus.invalid,
            firstName: FirstName.pure(),
            lastName: LastName.pure(),
            email: Email.pure(),
            password: Password.pure(),
            passwordConfirmation: Password.dirty('Password01'),
          ),
        ],
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits valid status when '
        'firstName, lastName, email, password and passwordConfirmation '
        'are valid',
        act: (bloc) {
          bloc
            ..add(SignUpFirstNameChanged(firstName: firstName.value!))
            ..add(SignUpLastNameChanged(lastName: lastName.value!))
            ..add(SignUpEmailChanged(email: email.value!))
            ..add(SignUpPasswordChanged(password: password.value!))
            ..add(
              SignUpPasswordConfirmationChanged(
                passwordConfirmation: passwordConfirmation.value!,
              ),
            );
        },
        build: () {
          return SignUpBloc(authService: mockAuthService);
        },
        expect: () => <SignUpState>[
          SignUpState(
            status: SignUpStatus.invalid,
            firstName: firstName,
            lastName: LastName.pure(),
            email: Email.pure(),
            password: Password.pure(),
            passwordConfirmation: Password.pure(),
          ),
          SignUpState(
            status: SignUpStatus.invalid,
            firstName: firstName,
            lastName: lastName,
            email: Email.pure(),
            password: Password.pure(),
            passwordConfirmation: Password.pure(),
          ),
          SignUpState(
            status: SignUpStatus.invalid,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: Password.pure(),
            passwordConfirmation: Password.pure(),
          ),
          SignUpState(
            status: SignUpStatus.invalid,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            passwordConfirmation: Password.pure(),
          ),
          SignUpState(
            status: SignUpStatus.valid,
            firstName: firstName,
            lastName: lastName,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
        ],
      );
    },
  );
}
