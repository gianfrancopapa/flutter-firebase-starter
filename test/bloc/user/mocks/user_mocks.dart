import 'package:firebasestarter/models/user.dart';
import 'package:mockito/mockito.dart';
import 'package:somnio_firebase_authentication/src/firebase_auth_service.dart';

// ignore: must_be_immutable
class MockUser extends Mock implements User {}

class MockFirebaseAuthService extends Mock implements FirebaseAuthService {}
