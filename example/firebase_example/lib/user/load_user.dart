import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/user/app_user_dto.dart';
import 'package:firebase_example/user/user_flat_object.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<FlatCurserObjectValueList>> loadUser({
  required String? lastLoadedObjectId,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 20;

    final query = FirebaseFirestore.instance.collection(userFirebaseCollectionId);
    final sortedQuery = sortOptions == null
        ? query.orderBy("name", descending: true)
        : query.orderBy(sortOptions.attributeId, descending: !sortOptions.ascending);
    final filteredQuery = searchQuery == null ? sortedQuery : sortedQuery.where("name", isGreaterThan: searchQuery);
    final paginationQuery = lastLoadedObjectId != null ? filteredQuery.startAfter([lastLoadedObjectId]) : filteredQuery;
    final documentSnapshots = await paginationQuery.limit(itemsToLoad).get();

    return FlatResult.success(
      FlatCurserObjectValueList(
        flatObjectValues: documentSnapshots.docs
            .map((document) => AppUserDto.fromJson(document.data()))
            .map((user) => user.toFlatObjectValue())
            .toList(),
        hasMoreItems: documentSnapshots.docs.length == itemsToLoad,
      ),
    );
  } catch (exception) {
    return FlatResult.error("Es ist ein Fehler aufgetreten. Bitte probiere es erneut.");
  }
}
