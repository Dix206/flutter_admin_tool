import 'package:flat/flat.dart';

Future<FlatResult<FlatObjectValue>> loadBlogById(String blogId) async {
  try {
    // final document = await databases.getDocument(
    //   databaseId: databaseId,
    //   collectionId: blogCollectionId,
    //   documentId: blogId,
    // );

    // final blog = Blog.fromJson(document.data);
    // final jwt = await account.createJWT();

    return FlatResult.success(
      const FlatObjectValue(
        id: "",
        values: [],
      ),
      // blog.toFlatObjectValue(
      //   {"x-appwrite-jwt": jwt.jwt},
      // ),
    );
  } catch (exception) {
    return FlatResult.error("Failed to load blog with ID $blogId.");
  }
}
