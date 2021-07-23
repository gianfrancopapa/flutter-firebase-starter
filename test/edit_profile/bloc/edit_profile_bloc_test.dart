import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/edit_profile/edit_profile.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/auth/auth.dart';
import 'package:firebasestarter/services/image_picker/image_picker.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockStorageService extends Mock implements StorageService {}

class MockImageService extends Mock implements ImageService {}

class MockEditProfileBloc extends MockBloc<EditProfileEvent, EditProfileState>
    implements EditProfileBloc {}

class MockEditProfileEvent extends Fake implements EditProfileEvent {}

class MockEditProfileState extends Fake implements EditProfileState {}

class MockUser extends Mock implements User {}

class MockPickedFile extends Mock implements PickedFile {}

void main() {
  group('EditProfileBloc', () {
    const firstName = 'firstName';
    const lastName = 'lastName';
    const imageUrl = 'https://mock-image.com';

    AuthService mockAuthService;
    StorageService mockStorageService;
    ImageService mockImageService;

    EditProfileBloc mockEditProfileBloc;

    User mockUser;

    PickedFile mockPickedFile;

    setUp(() {
      registerFallbackValue<EditProfileEvent>(MockEditProfileEvent());
      registerFallbackValue<EditProfileState>(MockEditProfileState());

      mockAuthService = MockAuthService();
      mockStorageService = MockStorageService();
      mockImageService = MockImageService();

      mockEditProfileBloc = MockEditProfileBloc();

      when(() => mockEditProfileBloc.state).thenReturn(
        const EditProfileState(status: EditProfileStatus.initial),
      );

      mockUser = MockUser();

      when(() => mockUser.firstName).thenReturn(firstName);
      when(() => mockUser.lastName).thenReturn(lastName);
      when(() => mockUser.imageUrl).thenReturn(imageUrl);

      mockPickedFile = MockPickedFile();

      when(() => mockPickedFile.path).thenReturn(imageUrl);

      EquatableConfig.stringify = true;
    });

    test('has valid initial state', () {
      expect(
        mockEditProfileBloc.state,
        equals(const EditProfileState(status: EditProfileStatus.initial)),
      );
    });

    group('EditProfileUserRequested', () {
      blocTest<EditProfileBloc, EditProfileState>(
        'calls authService.currentUser',
        act: (bloc) => bloc.add(const EditProfileUserRequested()),
        build: () {
          when(() => mockAuthService.currentUser())
              .thenAnswer((_) async => mockUser);

          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        verify: (_) {
          verify(() => mockAuthService.currentUser()).called(1);
        },
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'emits [loading, success] when authService.currentUser succeeds',
        act: (bloc) => bloc.add(const EditProfileUserRequested()),
        build: () {
          when(() => mockAuthService.currentUser())
              .thenAnswer((_) async => mockUser);

          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.loading,
            firstName: FirstName.pure(),
            lastName: LastName.pure(),
          ),
          EditProfileState(
            status: EditProfileStatus.valid,
            firstName: FirstName.dirty(firstName),
            lastName: LastName.dirty(lastName),
            imageURL: imageUrl,
            user: mockUser,
          ),
        ],
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'emits [loading, failure] when authService.currentUser throws',
        act: (bloc) => bloc.add(const EditProfileUserRequested()),
        build: () {
          when(() => mockAuthService.currentUser()).thenThrow(Exception());

          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.loading,
            firstName: FirstName.pure(),
            lastName: LastName.pure(),
          ),
          EditProfileState(
            status: EditProfileStatus.failure,
            firstName: FirstName.pure(),
            lastName: LastName.pure(),
          ),
        ],
      );
    });

    group('EditProfileFirstNameChanged', () {
      blocTest<EditProfileBloc, EditProfileState>(
        'emits updated firstName and invalid status',
        act: (bloc) => bloc.add(const EditProfileFirstNameChanged(firstName)),
        build: () {
          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.invalid,
            firstName: FirstName.dirty(firstName),
            lastName: LastName.pure(),
          ),
        ],
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'emits updated firstName and valid status',
        act: (bloc) => bloc.add(const EditProfileFirstNameChanged(firstName)),
        seed: () => EditProfileState(
          status: EditProfileStatus.initial,
          lastName: LastName.dirty(lastName),
          imageURL: imageUrl,
        ),
        build: () {
          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.valid,
            firstName: FirstName.dirty(firstName),
            lastName: LastName.dirty(lastName),
            imageURL: imageUrl,
          ),
        ],
      );
    });

    group('EditProfileLastNameChanged', () {
      blocTest<EditProfileBloc, EditProfileState>(
        'emits updated lastName and invalid status',
        act: (bloc) => bloc.add(const EditProfileLastNameChanged(lastName)),
        build: () {
          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.invalid,
            firstName: FirstName.pure(),
            lastName: LastName.dirty(lastName),
          ),
        ],
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'emits updated lastName and valid status',
        act: (bloc) => bloc.add(const EditProfileLastNameChanged(lastName)),
        seed: () => EditProfileState(
          status: EditProfileStatus.initial,
          firstName: FirstName.dirty(firstName),
          imageURL: imageUrl,
        ),
        build: () {
          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.valid,
            firstName: FirstName.dirty(firstName),
            lastName: LastName.dirty(lastName),
            imageURL: imageUrl,
          ),
        ],
      );
    });

    group('EditProfilePhotoUpdated', () {
      blocTest<EditProfileBloc, EditProfileState>(
        'emits updated imageURL and invalid status',
        act: (bloc) => bloc.add(
          const EditProfilePhotoUpdated(method: PhotoUploadMethod.CAMERA),
        ),
        build: () {
          when(() => mockImageService.imgFromCamera())
              .thenAnswer((_) async => mockPickedFile);

          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.invalid,
            imageURL: imageUrl,
            firstName: FirstName.pure(),
            lastName: LastName.pure(),
          ),
        ],
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'emits updated imageURL and valid status',
        act: (bloc) => bloc.add(
          const EditProfilePhotoUpdated(method: PhotoUploadMethod.CAMERA),
        ),
        seed: () => EditProfileState(
          status: EditProfileStatus.initial,
          firstName: FirstName.dirty(firstName),
          lastName: LastName.dirty(lastName),
        ),
        build: () {
          when(() => mockImageService.imgFromCamera())
              .thenAnswer((_) async => mockPickedFile);

          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.valid,
            firstName: FirstName.dirty(firstName),
            lastName: LastName.dirty(lastName),
            imageURL: imageUrl,
          ),
        ],
      );
    });

    group('EditProfileInfoUpdated', () {
      const userId = '1';
      const updatedFirstName = 'updatedFirstName';
      const updatedLastName = 'updatedLastName';
      const imageUrl = 'https://updated-image.com';
      const path = '/users/1.com';

      const oldName = 'oldName';
      const oldLastName = 'oldLastName';
      const oldImageUrl = 'https://old-image.com';

      User mockOldUser;

      setUp(() {
        mockOldUser = MockUser();

        when(() => mockOldUser.id).thenReturn(userId);
        when(() => mockOldUser.firstName).thenReturn(oldName);
        when(() => mockOldUser.lastName).thenReturn(oldLastName);
        when(() => mockOldUser.imageUrl).thenReturn(oldImageUrl);

        when(() => mockUser.id).thenReturn(userId);
        when(() => mockUser.firstName).thenReturn(updatedFirstName);
        when(() => mockUser.lastName).thenReturn(updatedLastName);
        when(() => mockUser.imageUrl).thenReturn(imageUrl);

        when(() => mockAuthService.currentUser())
            .thenAnswer((_) async => mockUser);

        when(
          () => mockStorageService.uploadFile(File(imageUrl), path),
        ).thenAnswer((_) async => null);

        when(() => mockStorageService.downloadURL(path))
            .thenAnswer((_) async => imageUrl);
      });

      blocTest<EditProfileBloc, EditProfileState>(
        'calls storageService.uploadFile, authService.changeProfile '
        'when image and displayName are different than previous',
        seed: () => EditProfileState(
          status: EditProfileStatus.valid,
          firstName: FirstName.dirty(updatedFirstName),
          lastName: LastName.dirty(updatedLastName),
          imageURL: imageUrl,
          user: mockOldUser,
        ),
        act: (bloc) => bloc.add(const EditProfileInfoUpdated()),
        build: () {
          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        verify: (_) {
          verify(() => mockStorageService.downloadURL(path)).called(1);
          verify(
            () => mockAuthService.changeProfile(
              firstName: updatedFirstName,
              lastName: updatedLastName,
              photoURL: imageUrl,
            ),
          ).called(1);
          verify(() => mockAuthService.currentUser()).called(1);
        },
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'calls only authService.changeProfile when '
        'displayName is different and image remains the same',
        seed: () => EditProfileState(
          status: EditProfileStatus.valid,
          firstName: FirstName.dirty(updatedFirstName),
          lastName: LastName.dirty(updatedLastName),
          imageURL: oldImageUrl,
          user: mockOldUser,
        ),
        act: (bloc) => bloc.add(const EditProfileInfoUpdated()),
        build: () {
          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        verify: (_) {
          verifyNever(
              () => mockStorageService.uploadFile(File(imageUrl), path));
          verifyNever(() => mockStorageService.downloadURL(path));

          verify(
            () => mockAuthService.changeProfile(
              firstName: updatedFirstName,
              lastName: updatedLastName,
            ),
          ).called(1);
          verify(() => mockAuthService.currentUser()).called(1);
        },
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'emits [loading, success] when authService.updateProfile succeeds',
        seed: () => EditProfileState(
          status: EditProfileStatus.valid,
          firstName: FirstName.dirty(updatedFirstName),
          lastName: LastName.dirty(updatedLastName),
          imageURL: imageUrl,
          user: mockOldUser,
        ),
        act: (bloc) => bloc.add(const EditProfileInfoUpdated()),
        build: () {
          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.loading,
            firstName: FirstName.dirty(updatedFirstName),
            lastName: LastName.dirty(updatedLastName),
            imageURL: imageUrl,
            user: mockOldUser,
          ),
          EditProfileState(
            status: EditProfileStatus.success,
            firstName: FirstName.dirty(updatedFirstName),
            lastName: LastName.dirty(updatedLastName),
            imageURL: imageUrl,
            user: mockUser,
          ),
        ],
      );

      blocTest<EditProfileBloc, EditProfileState>(
        'emits [loading, failure] when authService.updateProfile throws',
        seed: () => EditProfileState(
          status: EditProfileStatus.valid,
          firstName: FirstName.dirty(updatedFirstName),
          lastName: LastName.dirty(updatedLastName),
          imageURL: imageUrl,
          user: mockOldUser,
        ),
        act: (bloc) => bloc.add(const EditProfileInfoUpdated()),
        build: () {
          when(
            () => mockAuthService.changeProfile(
              firstName: updatedFirstName,
              lastName: updatedLastName,
              photoURL: imageUrl,
            ),
          ).thenThrow(Exception());

          return EditProfileBloc(
            authService: mockAuthService,
            storageService: mockStorageService,
            imageService: mockImageService,
          );
        },
        expect: () => <EditProfileState>[
          EditProfileState(
            status: EditProfileStatus.loading,
            firstName: FirstName.dirty(updatedFirstName),
            lastName: LastName.dirty(updatedLastName),
            imageURL: imageUrl,
            user: mockOldUser,
          ),
          EditProfileState(
            status: EditProfileStatus.failure,
            firstName: FirstName.dirty(updatedFirstName),
            lastName: LastName.dirty(updatedLastName),
            imageURL: imageUrl,
            user: mockOldUser,
          ),
        ],
      );
    });
  });
}
