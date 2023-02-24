import 'package:example/appwrite/client.dart';
import 'package:example/blog/blog.dart';
import 'package:example/blog/use_cases/blog_file_service.dart';
import 'package:example/constants.dart';
import 'package:flutter_cms/data_types/cms_file_value.dart';
import 'package:flutter_cms/data_types/cms_object_value.dart';
import 'package:flutter_cms/data_types/cms_result.dart';
import 'package:uuid/uuid.dart';

Future<CmsResult<Unit>> updateBlog(CmsObjectValue cmsObjectValue) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      documentId: cmsObjectValue.id!,
    );

    final blog = Blog.fromJson(document.data);

    return _updateBlogFromExistingBlog(
      blog: blog,
      cmsObjectValue: cmsObjectValue,
    );
  } catch (exception) {
    return CmsResult.error("Failed to create blog. Please try again");
  }
}

Future<CmsResult<Unit>> _updateBlogFromExistingBlog({
  required CmsObjectValue cmsObjectValue,
  required Blog blog,
}) async {
  try {
    final file = cmsObjectValue.getAttributeValueByAttributeId<CmsFileValue?>('file');

    if (file?.data != null) {
      final fileId = const Uuid().v4();

      if (blog.fileId != null) {
        await deleteBlogFile(fileId: blog.fileId!);
      }

      final result = await uploadBlogFile(
        data: file!.data!,
        fileId: fileId,
      );

      return result.fold(
        onError: (error) => CmsResult.error(error),
        onSuccess: (_) async {
          final newBlog = Blog.fromCmsObjectValue(
            cmsObjectValue: cmsObjectValue,
            id: cmsObjectValue.id!,
            fileId: fileId,
          );

          await databases.updateDocument(
            databaseId: databaseId,
            collectionId: blogCollectionId,
            data: newBlog.toJson(),
            documentId: newBlog.id,
          );
          return CmsResult.success(const Unit());
        },
      );
    } else if (file?.wasDeleted == true && blog.fileId != null) {
      final result = await deleteBlogFile(
        fileId: blog.fileId!,
      );

      return result.fold(
        onError: (error) => CmsResult.error(error),
        onSuccess: (url) async {
          final newBlog = Blog.fromCmsObjectValue(
            cmsObjectValue: cmsObjectValue,
            id: cmsObjectValue.id!,
            fileId: null,
          );

          await databases.updateDocument(
            databaseId: databaseId,
            collectionId: blogCollectionId,
            data: newBlog.toJson(),
            documentId: newBlog.id,
          );
          return CmsResult.success(const Unit());
        },
      );
    }

    final newBlog = Blog.fromCmsObjectValue(
      cmsObjectValue: cmsObjectValue,
      id: cmsObjectValue.id!,
      fileId: blog.fileId,
    );

    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: blogCollectionId,
      data: newBlog.toJson(),
      documentId: newBlog.id,
    );
    return CmsResult.success(const Unit());
  } catch (exception) {
    return CmsResult.error("Failed to update article. Please try again");
  }
}
