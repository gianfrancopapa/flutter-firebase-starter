// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/edit_profile/edit_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditProfileEvent', () {
    group('EditProfileInfoUpdated', () {
      test('supports value comparison', () {
        expect(EditProfileInfoUpdated(), equals(EditProfileInfoUpdated()));
      });
    });

    group('EditProfileFirstNameChanged', () {
      const firstName = 'firstName';

      test('throwsAssertionError when firstName is null', () {
        expect(
          () => EditProfileFirstNameChanged(firstName: null),
          throwsAssertionError,
        );
      });

      test('supports value comparison', () {
        expect(
          EditProfileFirstNameChanged(firstName: firstName),
          equals(
            EditProfileFirstNameChanged(firstName: firstName),
          ),
        );
      });
    });

    group('EditProfileLastNameChanged', () {
      const lastName = 'lastName';

      test('throwsAssertionError when lastName is null', () {
        expect(
          () => EditProfileLastNameChanged(lastName: null),
          throwsAssertionError,
        );
      });

      test('supports value comparison', () {
        expect(
          EditProfileLastNameChanged(lastName: lastName),
          equals(
            EditProfileLastNameChanged(lastName: lastName),
          ),
        );
      });
    });

    group('EditProfilePhotoUpdated', () {
      test('throwsAssertionError when lastName is null', () {
        expect(
          () => EditProfilePhotoUpdated(method: null),
          throwsAssertionError,
        );
      });

      test('supports value comparison', () {
        expect(
          EditProfilePhotoUpdated(method: PhotoUploadMethod.camera),
          equals(
            EditProfilePhotoUpdated(method: PhotoUploadMethod.camera),
          ),
        );
      });
    });

    group('EditProfileUserRequested', () {
      test('supports value comparison', () {
        expect(EditProfileUserRequested(), equals(EditProfileUserRequested()));
      });
    });
  });
}
