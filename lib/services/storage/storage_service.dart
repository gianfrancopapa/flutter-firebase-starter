import 'dart:io';

abstract class StorageService {
  Future<void>? uploadFile(File file, String storagePath);

  Future<String?> downloadFile(String storagePath, String localPath);

  Future<String?> downloadURL(String storagePath);
}
