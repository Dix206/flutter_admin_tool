import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> uploadArticleImage({
  required String imageId,
  required Uint8List data,
}) async {
  try {
    await FirebaseStorage.instance.ref("articles/$imageId").putData(data);

    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to upload image. Please try again");
  }
}

Future<FlatResult<Unit>> deleteArticleImage({
  required String imageId,
}) async {
  try {
    await FirebaseStorage.instance.ref("articles/$imageId").delete();

    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete image. Please try again");
  }
}
