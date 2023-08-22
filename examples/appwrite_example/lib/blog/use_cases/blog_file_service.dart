import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flat/flat.dart';

Future<FlatResult<Unit>> uploadBlogFile({
  required String fileId,
  required Uint8List data,
}) async {
  try {
    await storage.createFile(
      bucketId: "blog",
      fileId: fileId,
      file: InputFile.fromBytes(
        bytes: data,
        filename: fileId,
      ),
    );

    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to upload file. Please try again");
  }
}

Future<FlatResult<Unit>> deleteBlogFile({
  required String fileId,
}) async {
  try {
    await storage.deleteFile(
      bucketId: "blog",
      fileId: fileId,
    );

    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete file. Please try again");
  }
}
