// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/models/user.dart';
import 'package:firebasestarter/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserState', () {
    test('supports value comparison', () {
      expect(
        UserState(status: UserStatus.initial),
        equals(
          UserState(status: UserStatus.initial),
        ),
      );
    });

    group('copyWith', () {
      test('returns same object when no properties passed', () {
        expect(
          UserState(status: UserStatus.initial).copyWith(),
          equals(
            UserState(status: UserStatus.initial),
          ),
        );
      });

      test('returns object with updated status when passed', () {
        expect(
          UserState(status: UserStatus.initial)
              .copyWith(status: UserStatus.loading),
          equals(
            UserState(status: UserStatus.loading),
          ),
        );
      });

      test('returns object with updated user when passed', () {
        expect(
          UserState(status: UserStatus.initial).copyWith(
            user: User(id: '1'),
          ),
          equals(
            UserState(
              status: UserStatus.initial,
              user: User(id: '1'),
            ),
          ),
        );
      });
    });
  });
}
