import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<CmsObjectValue>> loadArticleById(String articleId) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      documentId: articleId,
    );

    final article = Article.fromJson(document.data);
    final jwt = await account.createJWT();

    return Result.success(
      article.toCmsObjectValue(
        {"x-appwrite-jwt": jwt.jwt},
      ),
    );
  } catch (exception) {
    return Result.error("Failed to load article with ID $articleId.");
  }
}
