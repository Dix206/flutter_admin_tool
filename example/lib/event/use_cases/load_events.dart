import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/constants.dart';
import 'package:example/event/event.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<CmsObjectValueList>> loadEvents({
  required int page,
  required String? searchQuery,
  required CmsObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final databaseList = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: eventCollectionId,
      queries: [
        Query.limit(itemsToLoad),
        Query.offset((page - 1) * itemsToLoad),
        if (searchQuery != null) Query.search("title", searchQuery),
        if (sortOptions?.ascending == true) Query.orderAsc(sortOptions!.attributId),
        if (sortOptions?.ascending == false) Query.orderDesc(sortOptions!.attributId),
      ],
    );

    return Result.success(
      CmsObjectValueList(
        cmsObjectValues: databaseList.documents
            .map((document) => Event.fromJson(document.data))
            .map((event) => event.toCmsObjectValue())
            .toList(),
        overallPageCount: (databaseList.total / itemsToLoad).ceil(),
      ),
    );
  } catch (exception) {
    return Result.error("Failed to load events. Please try again");
  }
}
