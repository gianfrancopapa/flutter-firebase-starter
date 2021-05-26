import 'package:firebasestarter/bloc/user/user_bloc.dart';
import 'package:firebasestarter/bloc/user/user_event.dart';
import 'package:firebasestarter/bloc/user/user_state.dart';
import 'package:flutter_test/flutter_test.dart';
import '../auth/mocks/auth_mocks.dart';
import 'mocks/user_mocks.dart';
import 'package:mockito/mockito.dart';

void main() {
  final auth = MockFirebaseAuthService();
  final userBloc = UserBloc(auth);
  final user = MockUser();
  group('User bloc', () {
    test('Map event to state', () {
      when(auth.currentUser()).thenAnswer((realInvocation) async => user);

      expectLater(
        userBloc.stream,
        emitsInOrder(
          [
            const UserLoadInProgress(),
            UserLoadSuccess(user),
          ],
        ),
      );

      userBloc.add(const UserLoaded());
    });
  });

  tearDown(() {
    userBloc?.close();
  });
}
