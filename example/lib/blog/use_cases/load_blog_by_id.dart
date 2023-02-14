import 'package:example/appwrite/client.dart';
import 'package:example/blog/blog.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<CmsObjectValue>> loadBlogById(String blogId) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      documentId: blogId,
    );

    final blog = Blog.fromJson(document.data);
    final jwt = await account.createJWT();

    return Result.success(
      blog.toCmsObjectValue(
        {"x-appwrite-jwt": jwt.jwt},
      ),
    );
  } catch (exception) {
    return Result.error("Failed to load blog with ID $blogId.");
  }
}
