import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<CmsObjectValueList>> loadArticles({
  required int page,
  required String? searchQuery,
  required CmsObjectSortOptions? sortOptions,
}) async {
  try {
    const itemsToLoad = 10;

    final databaseList = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      queries: [
        Query.limit(itemsToLoad),
        Query.offset((page - 1) * itemsToLoad),
        if (searchQuery != null) Query.search("title", searchQuery),
        if (sortOptions?.ascending == true) Query.orderAsc(sortOptions!.attributId),
        if (sortOptions?.ascending == false) Query.orderDesc(sortOptions!.attributId),
      ],
    );

    final jwt = await account.createJWT();

    return Result.success(
      CmsObjectValueList(
        cmsObjectValues: databaseList.documents
            .map((document) => Article.fromJson(document.data))
            .map(
              (article) => article.toCmsObjectValue(
                {"x-appwrite-jwt": jwt.jwt},
              ),
            )
            .toList(),
        overallPageCount: (databaseList.total / itemsToLoad).ceil(),
      ),
    );
  } catch (exception) {
    return Result.error("Failed to load articles. Please try again");
  }
}
