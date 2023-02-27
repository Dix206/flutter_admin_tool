import 'package:example/appwrite/client.dart';
import 'package:example/blog/blog.dart';
import 'package:example/constants.dart';
import 'package:flat/flat.dart';

Future<FlatResult<FlatObjectValue>> loadBlogById(String blogId) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      documentId: blogId,
    );

    final blog = Blog.fromJson(document.data);
    final jwt = await account.createJWT();

    return FlatResult.success(
      blog.toFlatObjectValue(
        {"x-appwrite-jwt": jwt.jwt},
      ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load blog with ID $blogId.");
  }
}
