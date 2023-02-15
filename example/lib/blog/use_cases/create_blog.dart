import 'package:example/appwrite/client.dart';
import 'package:example/blog/blog.dart';
import 'package:example/blog/use_cases/blog_file_service.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_file_value.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';
import 'package:uuid/uuid.dart';

Future<CmsResult<Unit>> createBlog(CmsObjectValue cmsObjectValue) async {
  try {
    final id = const Uuid().v4();

    final file = cmsObjectValue.getAttributValueByAttributId<CmsFileValue?>('file');

    if (file?.data != null) {
      final fileId = const Uuid().v4();
      final result = await uploadBlogFile(
        data: file!.data!,
        fileId: fileId,
      );

      return result.fold(
          onError: (error) => CmsResult.error(error),
          onSuccess: (url) async {
            final blog = Blog.fromCmsObjectValue(
              cmsObjectValue: cmsObjectValue,
              id: id,
              fileId: fileId,
            );

            await databases.createDocument(
              databaseId: databaseId,
              collectionId: blogCollectionId,
              data: blog.toJson(),
              documentId: blog.id,
            );
            return CmsResult.success(const Unit());
          });
    }

    final blog = Blog.fromCmsObjectValue(
      cmsObjectValue: cmsObjectValue,
      id: id,
      fileId: null,
    );

    await databases.createDocument(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      data: blog.toJson(),
      documentId: blog.id,
    );
    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to create blog. Please try again");
  }
}
