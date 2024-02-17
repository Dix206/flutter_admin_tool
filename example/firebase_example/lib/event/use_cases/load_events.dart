import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/constants.dart';
import 'package:firebase_example/event/event.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<FlatCurserObjectValueList>> loadEvents({
  required String? lastLoadedObjectId,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final query = FirebaseFirestore.instance.collection(eventCollectionId);
    final sortedQuery = sortOptions == null
        ? query.orderBy("id", descending: true)
        : query.orderBy(sortOptions.attributeId, descending: !sortOptions.ascending);
    final filteredQuery = searchQuery == null ? sortedQuery : sortedQuery.where("title", isGreaterThan: searchQuery);
    final paginationQuery = lastLoadedObjectId != null ? filteredQuery.startAfter([lastLoadedObjectId]) : filteredQuery;
    final documentSnapshots = await paginationQuery.limit(itemsToLoad).get();

    return FlatResult.success(
      FlatCurserObjectValueList(
        flatObjectValues: documentSnapshots.docs
            .map((document) => Event.fromJson(document.data()))
            .map((event) => event.toFlatObjectValue())
            .toList(),
        hasMoreItems: documentSnapshots.docs.length == itemsToLoad,
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load events. Please try again");
  }
}
