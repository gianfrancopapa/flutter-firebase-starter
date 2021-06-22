import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
import 'package:firebasestarter/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

import '../accountCreation/mocks/account_creation_bloc_mocks.dart';
import 'mocks/user_mocks.dart';

void main() {
  final auth = MockFirebaseAuthService();
  User user;
  Auth.User firebaseUser;

  setUp(() {
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

  group('User bloc /', () {
    blocTest(
      'Map UserLoaded to state',
      build: () => UserBloc(auth),
      act: (bloc) {
        when(auth.currentUser()).thenAnswer((_) async => firebaseUser);
        bloc.add(const UserLoaded());
      },
      expect: () => [
        const UserState(status: UserStatus.inProgress),
        UserState(status: UserStatus.success, user: user),
      ],
    );
  });
}
