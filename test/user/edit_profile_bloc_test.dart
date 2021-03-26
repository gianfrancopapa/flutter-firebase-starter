import 'package:firebasestarter/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../auth/mocks/auth_mocks.dart';
import 'mocks/user_mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  final auth = MockFirebaseAuthService();
  final userBloc = UserBloc();
  final editProfileBloc = EditProfileBloc(userBloc, auth);
  final user = MockUser();

  group('Edit profile bloc', () {
    group('Map event to state', () {
      test('Photo uploaded with camera', () {});

      test('Photo uploaded with library', () {});

      test('Profile info updated', () {});

      test('Current user loaded', () {});
    });
  });

  tearDown(() {
    userBloc?.close();
    editProfileBloc?.close();
  });
}
