import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<Unit>> uploadBlogFile({
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

    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to upload file. Please try again");
  }
}

Future<CmsResult<Unit>> deleteBlogFile({
  required String fileId,
}) async {
  try {
    await storage.deleteFile(
      bucketId: "blog",
      fileId: fileId,
    );

    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to delete file. Please try again");
  }
}
