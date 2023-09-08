import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/blog/blog.dart';
import 'package:firebase_example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<FlatCurserObjectValueList>> loadBlogs({
  required String? lastLoadedObjectId,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final query = FirebaseFirestore.instance.collection(blogCollectionId);
    final sortedQuery = sortOptions == null
        ? query.orderBy("id", descending: true)
        : query.orderBy(sortOptions.attributeId,
            descending: !sortOptions.ascending);
    final filteredQuery = searchQuery == null
        ? sortedQuery
        : sortedQuery.where("title", isGreaterThan: searchQuery);
    final paginationQuery = lastLoadedObjectId != null
        ? filteredQuery.startAfter([lastLoadedObjectId])
        : filteredQuery;
    final documentSnapshots = await paginationQuery.limit(itemsToLoad).get();

    return FlatResult.success(
      FlatCurserObjectValueList(
        flatObjectValues: documentSnapshots.docs
            .map((document) => Blog.fromJson(document.data()))
            .map(
              (blog) => blog.toFlatObjectValue(),
            )
            .toList(),
        hasMoreItems: documentSnapshots.docs.length == itemsToLoad,
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load blogs. Please try again");
  }
}
