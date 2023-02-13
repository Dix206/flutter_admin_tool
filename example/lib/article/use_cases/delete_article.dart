import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<Unit>> deleteArticle(String articleId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      documentId: articleId,
    );
    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to delete article. Please try again");
  }
}
