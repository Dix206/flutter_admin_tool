import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<Unit>> uploadImage({
    required String articleId,
    required Uint8List data,
  }) async {
    try {
      await storage.createFile(
        bucketId: "articles",
        fileId: articleId,
        file: InputFile(
          bytes: data,
          filename: articleId,
        ),
      );

      return Result.success(const Unit());
    } catch (exception) {
      return Result.error("Failed to upload media. Please try again");
    }
  }