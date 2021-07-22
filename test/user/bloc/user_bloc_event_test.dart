// ignore_for_file: prefer_const_constructors
import 'package:firebasestarter/user/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserBlocEvent', () {
    group('UserLoaded', () {
      test('supports value comparison', () {
        expect(UserLoaded(), equals(UserLoaded()));
      });
    });
  });
}
