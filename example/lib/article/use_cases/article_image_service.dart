import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<Unit>> uploadArticleImage({
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

    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to upload image. Please try again");
  }
}

Future<CmsResult<Unit>> deleteArticleImage({
  required String imageId,
}) async {
  try {
    await storage.deleteFile(
      bucketId: "articles",
      fileId: imageId,
    );

    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to delete image. Please try again");
  }
}
