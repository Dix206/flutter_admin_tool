import 'package:flat/flat.dart';

Future<FlatResult<FlatObjectValue>> loadArticleById(String articleId) async {
  try {
    // final document = await databases.getDocument(
    //   databaseId: databaseId,
    //   collectionId: articleCollectionId,
    //   documentId: articleId,
    // );

    // final article = Article.fromJson(document.data);

    // final authorDocument = article.authorId == null
    //     ? null
    //     : await databases.getDocument(
    //         databaseId: databaseId,
    //         collectionId: authorCollectionId,
    //         documentId: article.authorId!,
    //       );

    // final jwt = await account.createJWT();

    return FlatResult.success(
      const FlatObjectValue(
        id: "",
        values: [],
      ),
      // article.toFlatObjectValue(
      //   authHeaders: {"x-appwrite-jwt": jwt.jwt},
      //   author: authorDocument == null ? null : Author.fromJson(authorDocument.data),
      // ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load article with ID $articleId.");
  }
}
