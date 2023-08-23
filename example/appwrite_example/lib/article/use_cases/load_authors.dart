import 'package:appwrite/appwrite.dart';
import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';

Future<FlatResult<List<Author>>> loadAuthors(String searchQuery) async {
  try {
    final databaseList = await databases.listDocuments(
      databaseId: databaseId,
      collectionId: authorCollectionId,
      queries: [
        Query.limit(5),
        Query.search("name", searchQuery),
      ],
    );
    return FlatResult.success(
      databaseList.documents.map((document) => Author.fromJson(document.data)).toList(),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load authors. Please try again");
  }
}
