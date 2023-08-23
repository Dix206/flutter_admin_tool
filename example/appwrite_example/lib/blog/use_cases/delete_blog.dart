import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> deleteBlog(String blogId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      documentId: blogId,
    );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete blog. Please try again");
  }
}
