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
import '../accountCreation/mocks/account_creation_bloc_mocks.dart';
import './mocks/edit_profile_mocks.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

import 'mocks/user_mocks.dart';

const TEST_FIRST_NAME = 'testName';
const TEST_LAST_NAME = 'testLastName';
const TEST_ID = '1';
const TEST_URL = 'assets/somnio_logo.png';
const TEST_ERROR = 'error';

void main() {
  User user;
  Auth.User firebaseUser;
  MockFirebaseAuthService auth;
  UserBloc userBloc;
  MockStorageService storageService;
  MockImageService imageService;
  final sameAsUsersImagePickedFile = PickedFile(Assets.somnioLogo);
  final randomPickedFile = PickedFile(Assets.somnioGreyLogoSvg);

  group('Edit profile bloc /', () {
    setUp(() {
      auth = MockFirebaseAuthService();
      userBloc = UserBloc(auth);
      storageService = MockStorageService();
      imageService = MockImageService();
      final map = <String, dynamic>{
        'id': '1',
        'firstName': 'testName',
        'lastName': 'testLastName',
        'email': 'testEmail',
        'emailVerified': false,
        'imageUrl': 'assets/somnio_logo.png',
        'isAnonymous': false,
        'age': 0,
        'phoneNumber': '',
        'address': '',
      };
      user = User.fromJson(map);
      firebaseUser = MockFirebaseUser();
      when(firebaseUser.displayName).thenReturn('testName testLastName');
      when(firebaseUser.uid).thenReturn('1');
      when(firebaseUser.email).thenReturn('testEmail');
      when(firebaseUser.photoURL).thenReturn('assets/somnio_logo.png');
      when(firebaseUser.isAnonymous).thenReturn(false);
    });

    test('Initial state BLoC', () {
      expect(
          EditProfileBloc(userBloc, auth, storageService, imageService,
                  sameAsUsersImagePickedFile)
              .state
              .status,
          EditProfileStatus.initial);
    });

    group('Photo uploaded with camera /', () {
      blocTest(
        'success',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, sameAsUsersImagePickedFile),
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
            imageService, sameAsUsersImagePickedFile),
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
            imageService, sameAsUsersImagePickedFile),
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
            imageService, sameAsUsersImagePickedFile),
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
            imageService, sameAsUsersImagePickedFile),
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
            imageService, sameAsUsersImagePickedFile),
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
            imageService, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(auth.currentUser()).thenAnswer((_) async => firebaseUser);
          bloc.add(ProfileInfoUpdated(
              firstName: TEST_FIRST_NAME, lastName: TEST_LAST_NAME));
        },
        expect: () => [
          const EditProfileState(
            status: EditProfileStatus.inProgress,
          ),
          const EditProfileState(
            status: EditProfileStatus.profileSuccess,
          ),
        ],
      );

      blocTest(
        'failure',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, sameAsUsersImagePickedFile),
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
        build: () => EditProfileBloc(
            userBloc, auth, storageService, imageService, randomPickedFile),
        act: (bloc) {
          when(auth.currentUser()).thenAnswer((_) async => firebaseUser);

          final extension = randomPickedFile.path.split('.').last;
          final path = '/users/${user.id}.${extension}';

          when(storageService.uploadFile(File(randomPickedFile.path), path))
              .thenReturn(null);

          when(storageService.downloadURL(path))
              .thenAnswer((_) async => TEST_URL);

          when(auth.changeProfile(photoURL: TEST_URL))
              .thenAnswer((realInvocation) => null);

          when(auth.changeProfile(
                  firstName: TEST_FIRST_NAME, lastName: TEST_LAST_NAME))
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
      blocTest(
        'success',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, sameAsUsersImagePickedFile),
        act: (bloc) {
          when(auth.currentUser()).thenAnswer((_) async => firebaseUser);

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
          )
        ],
      );

      blocTest(
        'failure',
        build: () => EditProfileBloc(userBloc, auth, storageService,
            imageService, sameAsUsersImagePickedFile),
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
