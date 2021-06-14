import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_event.dart';
import 'package:firebasestarter/bloc/edit_profile/edit_profile_state.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import '../../unit/auth/mocks/auth_mocks.dart';
import './mocks/edit_profile_mocks.dart';
import './mocks/user_mocks.dart';
import 'package:mockito/mockito.dart';

const TEST_FIRST_NAME = 'TestFirstName';
const TEST_LAST_NAME = 'TestLastName';
const TEST_ID = 'id';
const TEST_URL = 'url';
const TEST_ERROR = 'error';

void main() {
  User user;
  MockFirebaseAuthService auth;
  UserBloc userBloc;
  MockStorageService storageService;
  MockImageService imageService;
  MockEditProfileFormBloc editProfileFormBloc;
  final sameAsUsersImagePickedFile = PickedFile(Assets.somnioLogo);
  final randomPickedFile = PickedFile(Assets.somnioGreyLogoSvg);

  group('Edit profile bloc /', () {
    setUp(() {
      auth = MockFirebaseAuthService();
      userBloc = UserBloc(auth);
      storageService = MockStorageService();
      imageService = MockImageService();
      editProfileFormBloc = MockEditProfileFormBloc();
    });

    test('Initial state BLoC', () {
      expect(
          EditProfileBloc(userBloc, auth, storageService, imageService,
                  editProfileFormBloc, sameAsUsersImagePickedFile)
              .state
              .status,
          EditProfileStatus.initial);
    });

    group('Photo uploaded with camera /', () {
      blocTest(
        'success',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(imageService.imgFromCamera())
              .thenAnswer((_) async => sameAsUsersImagePickedFile);
          bloc.add(PhotoWithCameraUploaded());
        },
        expect: () => [
          EditProfileState(
            status: EditProfileStatus.avatarSuccess,
            image: sameAsUsersImagePickedFile.path,
          ),
        ],
      );

      blocTest(
        'failure (null image)',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(imageService.imgFromCamera()).thenAnswer((_) async => null);
          bloc.add(PhotoWithCameraUploaded());
        },
        expect: () => [
          const EditProfileState(
            status: EditProfileStatus.failure,
            errorMessage: 'Error: Insert valid image',
          ),
        ],
      );

      blocTest(
        'failure (exception)',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(imageService.imgFromCamera()).thenThrow(TEST_ERROR);
          bloc.add(PhotoWithCameraUploaded());
        },
        expect: () => [
          const EditProfileState(
            status: EditProfileStatus.failure,
            errorMessage: TEST_ERROR,
          ),
        ],
      );
    });

    group('Photo uploaded with gallery /', () {
      blocTest(
        'success',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(imageService.imgFromGallery())
              .thenAnswer((_) async => sameAsUsersImagePickedFile);
          bloc.add(PhotoWithLibraryUpdated());
        },
        expect: () => [
          EditProfileState(
            status: EditProfileStatus.avatarSuccess,
            image: sameAsUsersImagePickedFile.path,
          ),
        ],
      );

      blocTest(
        'failure (null image)',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(imageService.imgFromGallery()).thenAnswer((_) async => null);
          bloc.add(PhotoWithLibraryUpdated());
        },
        expect: () => [
          const EditProfileState(
            status: EditProfileStatus.failure,
            errorMessage: 'Error: Insert valid image',
          ),
        ],
      );

      blocTest(
        'failure (exception)',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(imageService.imgFromGallery()).thenThrow(TEST_ERROR);
          bloc.add(PhotoWithLibraryUpdated());
        },
        expect: () => [
          const EditProfileState(
            status: EditProfileStatus.failure,
            errorMessage: TEST_ERROR,
          ),
        ],
      );
    });

    group('Profile info updated /', () {
      blocTest(
        'success without changes',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          final user = mockUser();
          when(auth.currentUser()).thenAnswer((_) async => user);
          when(editProfileFormBloc.firstNameVal).thenReturn(TEST_FIRST_NAME);
          when(editProfileFormBloc.lastNameVal).thenReturn(TEST_LAST_NAME);
          bloc.add(ProfileInfoUpdated());
        },
        expect: () => [
          const EditProfileState(status: EditProfileStatus.inProgress),
          const EditProfileState(status: EditProfileStatus.profileSuccess),
        ],
      );

      blocTest(
        'failure',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(auth.currentUser()).thenThrow(TEST_ERROR);
          bloc.add(ProfileInfoUpdated());
        },
        expect: () => [
          const EditProfileState(status: EditProfileStatus.inProgress),
          const EditProfileState(
            status: EditProfileStatus.failure,
            errorMessage: TEST_ERROR,
          ),
        ],
      );

      blocTest(
        'success with changes',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, randomPickedFile),
        act: (bloc) {
          final user = mockUser();

          when(auth.currentUser()).thenAnswer((_) async => user);
          when(editProfileFormBloc.firstNameVal).thenReturn(TEST_FIRST_NAME);
          when(editProfileFormBloc.lastNameVal).thenReturn(TEST_FIRST_NAME);

          final extension = randomPickedFile.path.split('.').last;
          final path = '/users/${user.id}.${extension}';

          when(storageService.uploadFile(File(randomPickedFile.path), path))
              .thenReturn(null);

          when(storageService.downloadURL(path))
              .thenAnswer((_) async => TEST_URL);

          when(auth.changeProfile(photoURL: TEST_URL))
              .thenAnswer((realInvocation) => null);

          when(auth.changeProfile(
                  firstName: editProfileFormBloc.firstNameVal,
                  lastName: editProfileFormBloc.lastNameVal))
              .thenAnswer((realInvocation) => null);

          bloc.add(ProfileInfoUpdated());
        },
        expect: () => [
          const EditProfileState(status: EditProfileStatus.inProgress),
          const EditProfileState(status: EditProfileStatus.profileSuccess),
          const EditProfileState(
            status: EditProfileStatus.avatarSuccess,
            image: Assets.somnioLogo,
          ),
        ],
      );
    });

    group('Current user loaded /', () {
      setUp(() {
        user = mockUser();
        editProfileFormBloc = MockEditProfileFormBloc();
      });

      blocTest(
        'success',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(auth.currentUser()).thenAnswer((_) async => user);
          when(editProfileFormBloc.onFirstNameChanged)
              .thenReturn((element) => null);
          when(editProfileFormBloc.onLastNameChanged)
              .thenReturn((element) => null);

          bloc.add(const CurrentUserLoaded());
        },
        expect: () => [
          const EditProfileState(status: EditProfileStatus.inProgress),
          EditProfileState(
            status: EditProfileStatus.currentUser,
            user: user,
          ),
          EditProfileState(
            status: EditProfileStatus.avatarSuccess,
            image: user.imageUrl,
          ),
        ],
      );

      blocTest(
        'failure',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, editProfileFormBloc, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(auth.currentUser()).thenThrow(Exception());
          bloc.add(const CurrentUserLoaded());
        },
        expect: () => [
          const EditProfileState(status: EditProfileStatus.inProgress),
          const EditProfileState(
            status: EditProfileStatus.failure,
            errorMessage: 'Error: Something went wrong',
          ),
        ],
      );
    });
  });

  tearDown(() {
    userBloc?.close();
  });
}

MockUser mockUser() {
  final user = MockUser();
  when(user.firstName).thenReturn(TEST_FIRST_NAME);
  when(user.lastName).thenReturn(TEST_LAST_NAME);
  when(user.imageUrl).thenReturn(Assets.somnioLogo);
  when(user.id).thenReturn(TEST_ID);
  return user;
}
