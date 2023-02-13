import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<Unit>> deleteBlog(String blogId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      documentId: blogId,
    );
    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to delete blog. Please try again");
  }
}
