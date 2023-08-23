import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/article/article.dart';
import 'package:firebase_example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<FlatCurserObjectValueList>> loadArticles({
  required String? lastLoadedObjectId,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final query = FirebaseFirestore.instance.collection(articleCollectionId);
    final sortedQuery =
        sortOptions == null ? query : query.orderBy(sortOptions.attributeId, descending: !sortOptions.ascending);
    final filteredQuery = searchQuery == null ? sortedQuery : sortedQuery.where("title", isGreaterThan: searchQuery);
    final paginationQuery = lastLoadedObjectId != null ? filteredQuery.startAfter([lastLoadedObjectId]) : filteredQuery;
    final documentSnapshots = await paginationQuery.get();

    final articles = documentSnapshots.docs.map((document) => Article.fromJson(document.data()));

    final List<FlatObjectValue> flatObjectValues = [];

    for (final article in articles) {
      final authorDocument = article.authorId == null
          ? null
          : await FirebaseFirestore.instance.collection(authorCollectionId).doc(article.authorId!).get();

      flatObjectValues.add(
        article.toFlatObjectValue(
          author: authorDocument == null ? null : Author.fromJson(authorDocument.data()!),
        ),
      );
    }

    return FlatResult.success(
      FlatCurserObjectValueList(
        flatObjectValues: flatObjectValues,
        hasMoreItems: documentSnapshots.docs.length == itemsToLoad,
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load articles. Please try again");
  }
}
