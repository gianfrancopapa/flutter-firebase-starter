import 'package:firebasestarter/models/user.dart' as Starter;
import 'package:mockito/mockito.dart';
import 'package:somnio_firebase_authentication/somnio_firebase_authentication.dart';

// ignore: must_be_immutable
class MockUser extends Mock implements Starter.User {}

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}
