// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/app/app.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEvent', () {
    group('AppIsFirstTimeLaunched', () {
      test('supports value comparison', () {
        expect(AppIsFirstTimeLaunched(), equals(AppIsFirstTimeLaunched()));
      });
    });

    group('AppUserChanged', () {
      test('supports value comparison', () {
        expect(
          AppUserChanged(user: User.empty),
          equals(
            AppUserChanged(user: User.empty),
          ),
        );
      });
    });

    group('AppLogoutRequsted', () {
      test('supports value comparison', () {
        expect(AppLogoutRequsted(), equals(AppLogoutRequsted()));
      });
    });
  });
}
