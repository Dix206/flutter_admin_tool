import 'package:flat/flat.dart';

Future<FlatResult<Unit>> deleteBlog(String blogId) async {
  try {
    // await databases.deleteDocument(
    //   databaseId: databaseId,
    //   collectionId: blogCollectionId,
    //   documentId: blogId,
    // );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to delete blog. Please try again");
  }
}
