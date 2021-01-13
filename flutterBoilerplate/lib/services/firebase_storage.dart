import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/services/firebase_auth.dart';

class FirebaseStorageService {
  final _firebaseStorage = FirebaseStorage.instanceFor(
      bucket: 'gs://flutter-boilerplate-609cc.appspot.com');

  Future<void> uploadFile(File file, String storagePath) async {
    try {
      final storageRef = _firebaseStorage.ref(storagePath);
      return await storageRef.putFile(file);
    } catch (e) {
      throw e;
    }
  }

  Future<String> downloadFile(String storagePath, String localPath) async {
    final downloadToFile = File(localPath);

    try {
      await _firebaseStorage.ref(storagePath).writeToFile(downloadToFile);
      return downloadToFile.path;
    } catch (e) {
      throw e;
    }
  }

  Future<String> downloadURL(String storagePath) async {
    try {
      final url = await _firebaseStorage.ref(storagePath).getDownloadURL();
      return url;
    } catch (e) {
      throw e;
    }
  }
}
