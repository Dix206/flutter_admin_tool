import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<Unit>> deleteArticle(String articleId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      documentId: articleId,
    );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete article. Please try again");
  }
}
