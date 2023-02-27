import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/blog/blog.dart';
import 'package:example/constants.dart';
import 'package:flat/flat.dart';

Future<FlatResult<FlatOffsetObjectValueList>> loadBlogs({
  required int page,
  required String? searchQuery,
  required FlatObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final databaseList = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      queries: [
        Query.limit(itemsToLoad),
        Query.offset((page - 1) * itemsToLoad),
        if (searchQuery != null) Query.search("title", searchQuery),
        if (sortOptions?.ascending == true) Query.orderAsc(sortOptions!.attributeId),
        if (sortOptions?.ascending == false) Query.orderDesc(sortOptions!.attributeId),
      ],
    );

    final jwt = await account.createJWT();

    return FlatResult.success(
      FlatOffsetObjectValueList(
        flatObjectValues: databaseList.documents
            .map((document) => Blog.fromJson(document.data))
            .map(
              (blog) => blog.toFlatObjectValue(
                {"x-appwrite-jwt": jwt.jwt},
              ),
            )
            .toList(),
        overallPageCount: (databaseList.total / itemsToLoad).ceil(),
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load blogs. Please try again");
  }
}
