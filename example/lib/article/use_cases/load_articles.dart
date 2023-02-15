import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<CmsObjectValueList>> loadArticles({
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

    final articles = databaseList.documents.map((document) => Article.fromJson(document.data));

    final List<CmsObjectValue> cmsObjectValues = [];

    for (final article in articles) {
      final authorDocument = article.authorId == null
          ? null
          : await databases.getDocument(
              databaseId: databaseId,
              collectionId: authorCollectionId,
              documentId: article.authorId!,
            );

      cmsObjectValues.add(
        article.toCmsObjectValue(
          authHeaders: {"x-appwrite-jwt": jwt.jwt},
          author: authorDocument == null ? null : Author.fromJson(authorDocument.data),
        ),
      );
    }

    return CmsResult.success(
      CmsObjectValueList(
        cmsObjectValues: cmsObjectValues,
        overallPageCount: (databaseList.total / itemsToLoad).ceil(),
      ),
    );
  } catch (exception) {
    return CmsResult.error("Failed to load articles. Please try again");
  }
}
