import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:flutter_cms/data_types/result.dart';

final mediaAppwriteService = MediaAppwriteService(storage);

class MediaAppwriteService {
  final Storage _storage;

  MediaAppwriteService(
    this._storage,
  );

  Future<Result<Uint8List>> downloadMedia({
    required String folderName,
    required String mediaName,
  }) async {
    try {
      final bytes = await _storage.getFileDownload(
        bucketId: folderName,
        fileId: mediaName,
      );

      return Result.success(bytes);
    } catch (exception) {
      return Result.error("Failed to download media. Please try again");
    }
  }

  Future<Result<Unit>> deleteMedia({
    required String folderName,
    required String mediaName,
  }) async {
    try {
      await _storage.deleteFile(
        bucketId: folderName,
        fileId: mediaName,
      );

      return Result.success(const Unit());
    } catch (exception) {
      return Result.error("Failed to delete media. Please try again");
    }
  }
}
