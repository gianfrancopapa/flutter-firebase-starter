// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppState', () {
    test('supports value comparison', () {
      expect(
        AppState(status: AppStatus.authenticated),
        equals(AppState(status: AppStatus.authenticated)),
      );
    });

    group('copyWith', () {
      test('returns same object when nothing is passed', () {
        expect(
          AppState(status: AppStatus.authenticated).copyWith(),
          equals(AppState(status: AppStatus.authenticated)),
        );
      });

      test('returns object with updated status when passed', () {
        expect(
          AppState(status: AppStatus.authenticated).copyWith(
            status: AppStatus.unauthenticated,
          ),
          equals(AppState(status: AppStatus.unauthenticated)),
        );
      });

      test('returns object with updated user when passed', () {
        expect(
          AppState(status: AppStatus.authenticated).copyWith(
            user: User.empty,
          ),
          equals(
            AppState(
              status: AppStatus.authenticated,
              user: User.empty,
            ),
          ),
        );
      });
    });
  });
}
