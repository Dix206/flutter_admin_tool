import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<CmsObjectValue>> loadArticleById(String articleId) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      documentId: articleId,
    );

    final article = Article.fromJson(document.data);

    final authorDocument = article.authorId == null
        ? null
        : await databases.getDocument(
            databaseId: databaseId,
            collectionId: authorCollectionId,
            documentId: article.authorId!,
          );

    final jwt = await account.createJWT();

    return CmsResult.success(
      article.toCmsObjectValue(
        authHeaders: {"x-appwrite-jwt": jwt.jwt},
        author: authorDocument == null ? null : Author.fromJson(authorDocument.data),
      ),
    );
  } catch (exception) {
    return CmsResult.error("Failed to load article with ID $articleId.");
  }
}
