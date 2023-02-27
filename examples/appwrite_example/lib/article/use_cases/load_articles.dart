import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/constants.dart';
import 'package:flat/flat.dart';

Future<FlatResult<FlatOffsetObjectValueList>> loadArticles({
  required int page,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final databaseList = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      queries: [
        Query.limit(itemsToLoad),
        Query.offset((page - 1) * itemsToLoad),
        if (searchQuery != null) Query.search("title", searchQuery),
        if (sortOptions?.ascending == true) Query.orderAsc(sortOptions!.attributeId),
        if (sortOptions?.ascending == false) Query.orderDesc(sortOptions!.attributeId),
      ],
    );

    final jwt = await account.createJWT();

    final articles = databaseList.documents.map((document) => Article.fromJson(document.data));

    final List<FlatObjectValue> flatObjectValues = [];

    for (final article in articles) {
      final authorDocument = article.authorId == null
          ? null
          : await databases.getDocument(
              databaseId: databaseId,
              collectionId: authorCollectionId,
              documentId: article.authorId!,
            );

      flatObjectValues.add(
        article.toFlatObjectValue(
          authHeaders: {"x-appwrite-jwt": jwt.jwt},
          author: authorDocument == null ? null : Author.fromJson(authorDocument.data),
        ),
      );
    }

    return FlatResult.success(
      FlatOffsetObjectValueList(
        flatObjectValues: flatObjectValues,
        overallPageCount: (databaseList.total / itemsToLoad).ceil(),
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load articles. Please try again");
  }
}
