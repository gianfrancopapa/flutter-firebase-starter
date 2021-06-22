import 'package:firebasestarter/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

User mapFirebaseUser(Auth.User user) {
  if (user == null) {
    return null;
  }
  var splittedName = ['Name ', 'LastName'];
  if (user.displayName != null) {
    splittedName = user.displayName.split(' ');
  }
  final map = <String, dynamic>{
    'id': user.uid ?? '',
    'firstName': splittedName.first ?? '',
    'lastName': splittedName.last ?? '',
    'email': user.email ?? '',
    'emailVerified': user.emailVerified ?? false,
    'imageUrl': user.photoURL ?? '',
    'isAnonymous': user.isAnonymous,
    'age': 0,
    'phoneNumber': '',
    'address': '',
  };
  return User.fromJson(map);
}
