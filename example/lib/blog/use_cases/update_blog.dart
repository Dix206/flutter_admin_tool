import 'package:example/appwrite/client.dart';
import 'package:example/blog/blog.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/result.dart';

Future<Result<Unit>> updateBlog(CmsObjectValue cmsObjectValue) async {
  try {
    final blog = Blog.fromCmsObjectValue(
      cmsObjectValue: cmsObjectValue,
    );

    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      data: blog.toJson(),
      documentId: blog.id,
    );
    return Result.success(const Unit());
  } catch (exception) {
    return Result.error("Failed to create blog. Please try again");
  }
}
