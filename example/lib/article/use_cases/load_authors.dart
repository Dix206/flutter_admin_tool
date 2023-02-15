import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_result.dart';

Future<CmsResult<List<Author>>> loadAuthors(String searchQuery) async {
  try {
    final databaseList = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: authorCollectionId,
      queries: [
        Query.limit(5),
        Query.search("name", searchQuery),
      ],
    );
    return CmsResult.success(
      databaseList.documents.map((document) => Author.fromJson(document.data)).toList(),
    );
  } catch (exception) {
    return CmsResult.error("Failed to load authors. Please try again");
  }
}