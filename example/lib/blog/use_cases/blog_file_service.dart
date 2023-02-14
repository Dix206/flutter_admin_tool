import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<Unit>> uploadBlogFile({
  required String fileId,
  required Uint8List data,
}) async {
  try {
    await storage.createFile(
      bucketId: "blog",
      fileId: fileId,
      file: InputFile(
        bytes: data,
        filename: fileId,
      ),
    );

    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to upload media. Please try again");
  }
}

Future<Result<Unit>> deleteBlogFile({
  required String fileId,
}) async {
  try {
    await storage.deleteFile(
      bucketId: "blog",
      fileId: fileId,
    );

    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to delete media. Please try again");
  }
}
