import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final _firebaseStorage = FirebaseStorage.instanceFor(
      bucket: 'gs://flutter-boilerplate-609cc.appspot.com');

  Future<void> uploadFile(File file, String cloudPath) async {
    try {
      final storageRef = _firebaseStorage.ref().child(cloudPath);
      return await storageRef.putFile(file);
    } catch (e) {
      throw e;
    }
  }

  Future<String> downloadFile(String cloudPath) async {
    try {
      final storageRef = _firebaseStorage.ref().child(cloudPath);
      final fileURL = await storageRef.getDownloadURL();
      return fileURL;
    } catch (e) {
      throw e;
    }
  }
}
