import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<Unit>> deleteBlog(String blogId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      documentId: blogId,
    );
    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to delete blog. Please try again");
  }
}
