import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:firebasestarter/edit_profile/edit_profile.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/test_bench.dart';

class MockEditProfileBloc extends MockBloc<EditProfileEvent, EditProfileState>
    implements EditProfileBloc {}

class MockEditProfileState extends Fake implements EditProfileState {}

class MockEditProfileEvent extends Fake implements EditProfileEvent {}

class MockUserBloc extends MockBloc<UserEvent, UserState> implements UserBloc {}

class MockUserState extends Fake implements UserState {}

class MockUserEvent extends Fake implements UserEvent {}

class MockUser extends Mock implements User {}

void main() {
  group('EditProfileScreen', () {
    const firstName = 'firstName';
    const lastName = 'lastName';
    const imageUrl = 'https://mock-url.com';

    late EditProfileBloc mockEditProfileBloc;
    UserBloc? mockUserBloc;

    User mockUser;

    setUp(() {
      mockUser = MockUser();

      when(() => mockUser.firstName).thenReturn(firstName);
      when(() => mockUser.lastName).thenReturn(lastName);
      when(() => mockUser.imageUrl).thenReturn(imageUrl);

      mockEditProfileBloc = MockEditProfileBloc();
      mockUserBloc = MockUserBloc();

      when(() => mockEditProfileBloc.state).thenReturn(
        EditProfileState(
          status: EditProfileStatus.initial,
          firstName: FirstName.pure(),
          lastName: LastName.pure(),
          user: mockUser,
        ),
      );

      when(() => mockUserBloc!.state).thenReturn(
        UserState(
          status: UserStatus.success,
          user: mockUser,
        ),
      );

      EquatableConfig.stringify = true;
    });

    test('is a route', () {
      expect(EditProfileScreen.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockEditProfileBloc,
          child: const EditProfileScreen(),
        ),
        userBloc: mockUserBloc,
      );

      expect(
        find.byKey(const Key('editProfileScreen_profileImage')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key('editProfileScreen_editProfileForm_firstNameTextField'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key('editProfileScreen_editProfileForm_lastNameTextField'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const Key('updateProfileScreen_editProfileForm_button'),
        ),
        findsOneWidget,
      );
    });

    testWidgets('adds EditProfileFirstNameChanged', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockEditProfileBloc,
          child: const EditProfileScreen(),
        ),
        userBloc: mockUserBloc,
      );

      final firstNameInputFinder = find.byKey(
        const Key('editProfileScreen_editProfileForm_firstNameTextField'),
      );

      await tester.enterText(firstNameInputFinder, 'myFirstName');

      verify(
        () => mockEditProfileBloc
            .add(const EditProfileFirstNameChanged(firstName: 'myFirstName')),
      ).called(1);
    });

    testWidgets('adds EditProfileLastNameChanged', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: mockEditProfileBloc,
          child: const EditProfileScreen(),
        ),
        userBloc: mockUserBloc,
      );

      final lastNameInputFinder = find.byKey(
        const Key('editProfileScreen_editProfileForm_lastNameTextField'),
      );

      await tester.enterText(lastNameInputFinder, 'myLastName');

      verify(
        () => mockEditProfileBloc
            .add(const EditProfileLastNameChanged(lastName: 'myLastName')),
      ).called(1);
    });

    testWidgets(
      'adds EditProfileInfoUpdated when status is valid',
      (tester) async {
        when(() => mockEditProfileBloc.state).thenReturn(
          mockEditProfileBloc.state.copyWith(status: EditProfileStatus.valid),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: mockEditProfileBloc,
            child: const EditProfileScreen(),
          ),
          userBloc: mockUserBloc,
        );

        final editButtonInputFinder = find.byKey(
          const Key('updateProfileScreen_editProfileForm_button'),
        );

        await tester.tap(editButtonInputFinder);

        verify(
          () => mockEditProfileBloc.add(const EditProfileInfoUpdated()),
        ).called(1);
      },
    );

    testWidgets(
      'does not add EditProfileInfoUpdated when status is not valid',
      (tester) async {
        when(() => mockEditProfileBloc.state).thenReturn(
          mockEditProfileBloc.state.copyWith(status: EditProfileStatus.invalid),
        );

        await tester.pumpApp(
          BlocProvider.value(
            value: mockEditProfileBloc,
            child: const EditProfileScreen(),
          ),
          userBloc: mockUserBloc,
        );

        final editButtonFinder = find.byKey(
          const Key('updateProfileScreen_editProfileForm_button'),
        );

        await tester.tap(editButtonFinder);

        verifyNever(
          () => mockEditProfileBloc.add(const EditProfileInfoUpdated()),
        );
      },
    );

    testWidgets(
      'adds EditProfilePhotoUpdated with [PhotoUploadMethod.CAMERA]',
      (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: mockEditProfileBloc,
            child: const EditProfileScreen(),
          ),
          userBloc: mockUserBloc,
        );

        final editImageIconFinder =
            find.byKey(const Key('profileImage_editImageIcon'));

        await tester.tap(editImageIconFinder);

        //wait until ModalBottomSheet is shown
        await tester.pumpAndSettle();

        final openCameraButtonFinder = find.byKey(
          const Key('editProfileScreen_profileImage_openCameraButton'),
        );

        await tester.tap(openCameraButtonFinder);

        //wait until ModalBottomSheet is dismissed
        await tester.pumpAndSettle();

        verify(
          () => mockEditProfileBloc.add(
            const EditProfilePhotoUpdated(method: PhotoUploadMethod.camera),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'adds EditProfilePhotoUpdated with [PhotoUploadMethod.GALLERY]',
      (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: mockEditProfileBloc,
            child: const EditProfileScreen(),
          ),
          userBloc: mockUserBloc,
        );

        final editImageIconFinder =
            find.byKey(const Key('profileImage_editImageIcon'));

        await tester.tap(editImageIconFinder);

        //wait until ModalBottomSheet is shown
        await tester.pumpAndSettle();

        final openCameraButtonFinder = find.byKey(
          const Key('editProfileScreen_profileImage_openGalleryButton'),
        );

        await tester.tap(openCameraButtonFinder);

        //wait until ModalBottomSheet is dismissed
        await tester.pumpAndSettle();

        verify(
          () => mockEditProfileBloc.add(
            const EditProfilePhotoUpdated(method: PhotoUploadMethod.gallery),
          ),
        ).called(1);
      },
    );
  });
}
