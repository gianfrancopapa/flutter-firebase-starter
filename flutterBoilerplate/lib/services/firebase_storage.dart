import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutterBoilerplate/services/storage_interface.dart';

class FirebaseStorageService implements IStorage {
  final _firebaseStorage = FirebaseStorage.instanceFor(
      bucket: 'gs://flutter-boilerplate-609cc.appspot.com');

  @override
  Future<void> uploadFile(File file, String storagePath) async {
    try {
      final storageRef = _firebaseStorage.ref(storagePath);
      return await storageRef.putFile(file);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<String> downloadFile(String storagePath, String localPath) async {
    final downloadToFile = File(localPath);

    try {
      await _firebaseStorage.ref(storagePath).writeToFile(downloadToFile);
      return downloadToFile.path;
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<String> downloadURL(String storagePath) async {
    try {
      final url = await _firebaseStorage.ref(storagePath).getDownloadURL();
      return url;
    } catch (e) {
      throw e;
    }
  }
}