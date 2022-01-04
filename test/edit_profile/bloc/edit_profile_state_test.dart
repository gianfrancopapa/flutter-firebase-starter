// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/edit_profile/edit_profile.dart';
import 'package:firebasestarter/forms/forms.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditProfileState', () {
    test('supports value comparison', () {
      expect(
        EditProfileState(status: EditProfileStatus.initial),
        equals(
          EditProfileState(status: EditProfileStatus.initial),
        ),
      );
    });

    group('copyWith', () {
      test('returns same object when no properties are passed', () {
        expect(
          EditProfileState(status: EditProfileStatus.initial).copyWith(),
          equals(
            EditProfileState(status: EditProfileStatus.initial),
          ),
        );
      });

      test('returns object with updated status when passed', () {
        expect(
          EditProfileState(status: EditProfileStatus.initial)
              .copyWith(status: EditProfileStatus.loading),
          equals(
            EditProfileState(status: EditProfileStatus.loading),
          ),
        );
      });

      test('returns object with updated firstName when passed', () {
        expect(
          EditProfileState(status: EditProfileStatus.initial).copyWith(
            firstName: FirstName.dirty('firstName'),
          ),
          equals(
            EditProfileState(
              status: EditProfileStatus.initial,
              firstName: FirstName.dirty('firstName'),
            ),
          ),
        );
      });

      test('returns object with updated lastName when passed', () {
        expect(
          EditProfileState(status: EditProfileStatus.initial).copyWith(
            lastName: LastName.dirty('lastName'),
          ),
          equals(
            EditProfileState(
              status: EditProfileStatus.initial,
              lastName: LastName.dirty('lastName'),
            ),
          ),
        );
      });

      test('returns object with updated imageURL when passed', () {
        expect(
          EditProfileState(status: EditProfileStatus.initial)
              .copyWith(imageURL: 'https://fake-image.com'),
          equals(
            EditProfileState(
              status: EditProfileStatus.initial,
              imageURL: 'https://fake-image.com',
            ),
          ),
        );
      });

      test('returns object with updated user when passed', () {
        expect(
          EditProfileState(status: EditProfileStatus.initial)
              .copyWith(user: User(id: '1')),
          equals(
            EditProfileState(
              status: EditProfileStatus.initial,
              user: User(id: '1'),
            ),
          ),
        );
      });
    });
  });
}
