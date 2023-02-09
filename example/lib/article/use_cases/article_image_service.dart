import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<Unit>> uploadArticleImage({
  required String imageId,
  required Uint8List data,
}) async {
  try {
    await storage.createFile(
      bucketId: "articles",
      fileId: imageId,
      file: InputFile(
        bytes: data,
        filename: imageId,
      ),
    );

    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to upload media. Please try again");
  }
}

Future<Result<Unit>> deleteArticleImage({
  required String imageId,
}) async {
  try {
    await storage.deleteFile(
      bucketId: "articles",
      fileId: imageId,
    );

    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to delete media. Please try again");
  }
}
