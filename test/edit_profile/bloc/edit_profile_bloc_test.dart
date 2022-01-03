// ignore_for_file: avoid_returning_null_for_void

import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/edit_profile/edit_profile.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/services/image_picker/image_picker.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:auth/auth.dart';

class MockAuthService extends Mock implements AuthService {}

class MockStorageService extends Mock implements StorageService {}

class MockImageService extends Mock implements ImageService {}

class MockEditProfileBloc extends MockBloc<EditProfileEvent, EditProfileState>
    implements EditProfileBloc {}

class MockEditProfileEvent extends Fake implements EditProfileEvent {}

class MockEditProfileState extends Fake implements EditProfileState {}

class MockUser extends Mock implements User {}

class MockUserEntity extends Mock implements UserEntity {}

class MockPickedFile extends Mock implements XFile {}

void main() {
  group('EditProfileBloc', () {
    const firstName = 'firstName';
    const lastName = 'lastName';
    const imageUrl = 'https://mock-image.com';

    late AuthService mockAuthService;
    late StorageService mockStorageService;
    late ImageService mockImageService;

    late EditProfileBloc mockEditProfileBloc;

    UserEntity? mockUserEntity;
    late User mockUser;

    XFile? mockPickedFile;

    setUp(() {
      mockAuthService = MockAuthService();
      mockStorageService = MockStorageService();
      mockImageService = MockImageService();

      mockEditProfileBloc = MockEditProfileBloc();

      when(() => mockEditProfileBloc.state).thenReturn(
        const EditProfileState(status: EditProfileStatus.initial),
      );

      mockUser = MockUser();
      mockUserEntity = MockUserEntity();

      when(() => mockUser.firstName).thenReturn(firstName);
      when(() => mockUser.lastName).thenReturn(lastName);
      when(() => mockUser.imageUrl).thenReturn(imageUrl);

      when(() => mockUserEntity!.firstName).thenReturn(firstName);
      when(() => mockUserEntity!.lastName).thenReturn(lastName);
      when(() => mockUserEntity!.imageUrl).thenReturn(imageUrl);

      mockPickedFile = MockPickedFile();

      when(() => mockPickedFile!.path).thenReturn(imageUrl);

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
              .thenAnswer((_) async => mockUserEntity);

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
              .thenAnswer((_) async => mockUserEntity);

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
            user: User.fromEntity(mockUserEntity!),
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
        act: (bloc) =>
            bloc.add(const EditProfileFirstNameChanged(firstName: firstName)),
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
        act: (bloc) =>
            bloc.add(const EditProfileFirstNameChanged(firstName: firstName)),
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
        act: (bloc) =>
            bloc.add(const EditProfileLastNameChanged(lastName: lastName)),
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
        act: (bloc) =>
            bloc.add(const EditProfileLastNameChanged(lastName: lastName)),
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
          const EditProfilePhotoUpdated(method: PhotoUploadMethod.camera),
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
          const EditProfilePhotoUpdated(method: PhotoUploadMethod.camera),
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

      User? mockOldUser;
      UserEntity? _mockUserEntity;

      setUp(() {
        mockOldUser = MockUser();
        _mockUserEntity = MockUserEntity();

        when(() => mockOldUser!.id).thenReturn(userId);
        when(() => mockOldUser!.firstName).thenReturn(oldName);
        when(() => mockOldUser!.lastName).thenReturn(oldLastName);
        when(() => mockOldUser!.imageUrl).thenReturn(oldImageUrl);

        when(() => _mockUserEntity!.id).thenReturn(userId);
        when(() => _mockUserEntity!.firstName).thenReturn(updatedFirstName);
        when(() => _mockUserEntity!.lastName).thenReturn(updatedLastName);
        when(() => _mockUserEntity!.imageUrl).thenReturn(imageUrl);

        when(() => mockUser.id).thenReturn(userId);
        when(() => mockUser.firstName).thenReturn(updatedFirstName);
        when(() => mockUser.lastName).thenReturn(updatedLastName);
        when(() => mockUser.imageUrl).thenReturn(imageUrl);

        when(() => mockAuthService.currentUser())
            .thenAnswer((_) async => _mockUserEntity);

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
            user: User.fromEntity(_mockUserEntity!),
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
