import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/constants.dart';
import 'package:firebase_example/event/event.dart';
import 'package:flat/flat.dart';

Future<FlatResult<FlatObjectValueList>> loadEvents({
  required int page,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 2;

    final l = (page - 1) * itemsToLoad;

    final query = FirebaseFirestore.instance.collection(eventCollectionId);
    final sortedQuery = sortOptions == null
        ? query.orderBy("id", descending: true)
        : query.orderBy(sortOptions.attributeId, descending: !sortOptions.ascending);
    // final filteredQuery = searchQuery == null ? sortedQuery : sortedQuery.where("title", isGreaterThan: searchQuery);
    final aggregateQuerySnapshot = await sortedQuery.count().get();
    final limetedQuery = sortedQuery.startAfter(["6srFF2TJbYd45PM64w2Z"]).limit(itemsToLoad);
    // final limetedQuery = sortedQuery.startAfter(["69ab021b-a8f4-4fe1-ba3a-b22c8feb489f"]).limit(itemsToLoad);
    final documentSnapshots = await limetedQuery.get();
// query.startAfter(values)
    final k = 0;

    return FlatResult.success(
      FlatObjectValueList(
        flatObjectValues: documentSnapshots.docs
            .map((document) => Event.fromJson(document.data()))
            .map((event) => event.toFlatObjectValue())
            .toList(),
        overallPageCount: (aggregateQuerySnapshot.count / itemsToLoad).ceil(),
      ),
    );
  } catch (exception) {
    final ll = exception;
    final k = 0;
    return FlatResult.error("Failed to load events. Please try again");
  }
}
