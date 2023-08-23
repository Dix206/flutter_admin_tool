import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> uploadBlogFile({
  required String fileId,
  required Uint8List data,
}) async {
  try {
    await FirebaseStorage.instance.ref("blog/$fileId").putData(data);

    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to upload file. Please try again");
  }
}

Future<FlatResult<Unit>> deleteBlogFile({
  required String fileId,
}) async {
  try {
    await FirebaseStorage.instance.ref("blog/$fileId").delete();

    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete file. Please try again");
  }
}
