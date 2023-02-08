import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_object_sort_options.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

class ArticlesList {
  final List<Article> articles;
  final bool hasMoreItems;

  ArticlesList({
    required this.articles,
    required this.hasMoreItems,
  });
}

Future<Result<CmsObjectValueList>> loadArticles({
  required String? lastLoadedCmsObjectId,
  required String? searchQuery,
  required CmsObjectSortOptions sortOptions,
}) async {
  try {
    final databaseList = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      queries: [
        Query.limit(3),
        if (lastLoadedCmsObjectId != null) Query.cursorAfter(lastLoadedCmsObjectId),
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
        hasMoreItems: 3 == databaseList.documents.length,
      ),
    );
  } catch (exception) {
    return Result.error("Failed to load articles. Please try again");
  }
}
