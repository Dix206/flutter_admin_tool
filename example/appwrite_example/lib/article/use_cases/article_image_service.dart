import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> uploadArticleImage({
  required String imageId,
  required Uint8List data,
}) async {
  try {
    await storage.createFile(
      bucketId: "articles",
      fileId: imageId,
      file: InputFile.fromBytes(
        bytes: data,
        filename: imageId,
      ),
    );

    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to upload image. Please try again");
  }
}

Future<FlatResult<Unit>> deleteArticleImage({
  required String imageId,
}) async {
  try {
    await storage.deleteFile(
      bucketId: "articles",
      fileId: imageId,
    );

    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete image. Please try again");
  }
}
