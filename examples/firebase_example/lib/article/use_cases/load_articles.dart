import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/article/article.dart';
import 'package:firebase_example/constants.dart';
import 'package:flat/flat.dart';

Future<FlatResult<FlatObjectValueList>> loadArticles({
  required int page,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final query = FirebaseFirestore.instance.collection(articleCollectionId);
    final sortedQuery =
        sortOptions == null ? query : query.orderBy(sortOptions.attributeId, descending: !sortOptions.ascending);
    final filteredQuery = searchQuery == null ? sortedQuery : sortedQuery.where("title", isGreaterThan: searchQuery);
    final aggregateQuerySnapshot = await filteredQuery.count().get();
    final limetedQuery = filteredQuery.startAfter([page * itemsToLoad]).limit(itemsToLoad);
    final documentSnapshots = await limetedQuery.get();

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
      FlatObjectValueList(
        flatObjectValues: flatObjectValues,
        overallPageCount: (aggregateQuerySnapshot.count / itemsToLoad).ceil(),
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load articles. Please try again");
  }
}
