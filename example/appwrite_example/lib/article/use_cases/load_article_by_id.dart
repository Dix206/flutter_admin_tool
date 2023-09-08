import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<FlatObjectValue>> loadArticleById(String articleId) async {
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

    return FlatResult.success(
      article.toFlatObjectValue(
        authHeaders: {"x-appwrite-jwt": jwt.jwt},
        author: authorDocument == null
            ? null
            : Author.fromJson(authorDocument.data),
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load article with ID $articleId.");
  }
}
