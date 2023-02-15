import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/blog/blog.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<CmsObjectValueList>> loadBlogs({
  required int page,
  required String? searchQuery,
  required CmsObjectSortOptions? sortOptions,
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
        if (sortOptions?.ascending == true) Query.orderAsc(sortOptions!.attributId),
        if (sortOptions?.ascending == false) Query.orderDesc(sortOptions!.attributId),
      ],
    );

    final jwt = await account.createJWT();

    return CmsResult.success(
      CmsObjectValueList(
        cmsObjectValues: databaseList.documents
            .map((document) => Blog.fromJson(document.data))
            .map(
              (blog) => blog.toCmsObjectValue(
                {"x-appwrite-jwt": jwt.jwt},
              ),
            )
            .toList(),
        overallPageCount: (databaseList.total / itemsToLoad).ceil(),
      ),
    );
  } catch (exception) {
    return CmsResult.error("Failed to load blogs. Please try again");
  }
}
