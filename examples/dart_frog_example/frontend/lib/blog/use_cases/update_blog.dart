import 'package:flat/flat.dart';
import 'package:frontend/blog/blog.dart';

Future<FlatResult<Unit>> updateBlog(FlatObjectValue flatObjectValue) async {
  try {
    // final document = await databases.getDocument(
    //   databaseId: databaseId,
    //   collectionId: blogCollectionId,
    //   documentId: flatObjectValue.id!,
    // );

    // final blog = Blog.fromJson(document.data);

    // return _updateBlogFromExistingBlog(
    //   blog: blog,
    //   flatObjectValue: flatObjectValue,
    // );

    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to create blog. Please try again");
  }
}

Future<FlatResult<Unit>> _updateBlogFromExistingBlog({
  required FlatObjectValue flatObjectValue,
  required Blog blog,
}) async {
  try {
    final file = flatObjectValue.getAttributeValueByAttributeId<FlatFileValue?>('file');

    // if (file?.data != null) {
    //   final fileId = const Uuid().v4();

    //   if (blog.fileId != null) {
    //     await deleteBlogFile(fileId: blog.fileId!);
    //   }

    //   final result = await uploadBlogFile(
    //     data: file!.data!,
    //     fileId: fileId,
    //   );

    //   return result.fold(
    //     onError: (error) => FlatResult.error(error),
    //     onSuccess: (_) async {
    //       final newBlog = Blog.fromFlatObjectValue(
    //         flatObjectValue: flatObjectValue,
    //         id: flatObjectValue.id!,
    //         fileId: fileId,
    //       );

    //       await databases.updateDocument(
    //         databaseId: databaseId,
    //         collectionId: blogCollectionId,
    //         data: newBlog.toJson(),
    //         documentId: newBlog.id,
    //       );
    //       return FlatResult.success(const Unit());
    //     },
    //   );
    // } else if (file?.wasDeleted == true && blog.fileId != null) {
    //   final result = await deleteBlogFile(
    //     fileId: blog.fileId!,
    //   );

    //   return result.fold(
    //     onError: (error) => FlatResult.error(error),
    //     onSuccess: (url) async {
    //       final newBlog = Blog.fromFlatObjectValue(
    //         flatObjectValue: flatObjectValue,
    //         id: flatObjectValue.id!,
    //         fileId: null,
    //       );

    //       await databases.updateDocument(
    //         databaseId: databaseId,
    //         collectionId: blogCollectionId,
    //         data: newBlog.toJson(),
    //         documentId: newBlog.id,
    //       );
    //       return FlatResult.success(const Unit());
    //     },
    //   );
    // }

    // final newBlog = Blog.fromFlatObjectValue(
    //   flatObjectValue: flatObjectValue,
    //   id: flatObjectValue.id!,
    //   fileId: blog.fileId,
    // );

    // await databases.updateDocument(
    //   databaseId: databaseId,
    //   collectionId: blogCollectionId,
    //   data: newBlog.toJson(),
    //   documentId: newBlog.id,
    // );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to update article. Please try again");
  }
}
