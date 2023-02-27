import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/blog/blog.dart';
import 'package:firebase_example/constants.dart';
import 'package:flat/flat.dart';

Future<FlatResult<FlatObjectValueList>> loadBlogs({
  required int page,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final query = FirebaseFirestore.instance.collection(blogCollectionId);
    final sortedQuery = sortOptions == null
        ? query
        : query.orderBy(sortOptions.attributeId, descending: !sortOptions.ascending);
    final filteredQuery = searchQuery == null ? sortedQuery : sortedQuery.where("title", isGreaterThan: searchQuery);
    final aggregateQuerySnapshot = await filteredQuery.count().get();
    final limetedQuery = filteredQuery.startAfter([page * itemsToLoad]) .limit(itemsToLoad);
    final documentSnapshots = await limetedQuery.get();

    return FlatResult.success(
      FlatObjectValueList(
        flatObjectValues: documentSnapshots.docs
            .map((document) => Blog.fromJson(document.data()))
            .map(
              (blog) => blog.toFlatObjectValue(
              ),
            )
            .toList(),
        overallPageCount: (aggregateQuerySnapshot.count / itemsToLoad).ceil(),
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load blogs. Please try again");
  }
}
