import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<Unit>> deleteArticle(String articleId) async {
  try {
    await databases.deleteDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      documentId: articleId,
    );
    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to delete article. Please try again");
  }
}
