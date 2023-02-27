import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_example/blog/blog.dart';
import 'package:firebase_example/blog/use_cases/blog_file_service.dart';
import 'package:firebase_example/constants.dart';
import 'package:flat/flat.dart';
import 'package:uuid/uuid.dart';

Future<FlatResult<Unit>> updateBlog(FlatObjectValue flatObjectValue) async {
  try {
    final snapshot = await FirebaseFirestore.instance.collection(blogCollectionId).doc(flatObjectValue.id).get();

    final blog = Blog.fromJson(snapshot.data()!);

    return _updateBlogFromExistingBlog(
      blog: blog,
      flatObjectValue: flatObjectValue,
    );
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
        onError: (error) => FlatResult.error(error),
        onSuccess: (_) async {
          final newBlog = Blog.fromFlatObjectValue(
            flatObjectValue: flatObjectValue,
            id: flatObjectValue.id!,
            fileId: fileId,
          );

          await FirebaseFirestore.instance.collection(blogCollectionId).doc(newBlog.id).set(newBlog.toJson());
          return FlatResult.success(const Unit());
        },
      );
    } else if (file?.wasDeleted == true && blog.fileId != null) {
      final result = await deleteBlogFile(
        fileId: blog.fileId!,
      );

      return result.fold(
        onError: (error) => FlatResult.error(error),
        onSuccess: (url) async {
          final newBlog = Blog.fromFlatObjectValue(
            flatObjectValue: flatObjectValue,
            id: flatObjectValue.id!,
            fileId: null,
          );

          await FirebaseFirestore.instance.collection(blogCollectionId).doc(newBlog.id).set(newBlog.toJson());
          return FlatResult.success(const Unit());
        },
      );
    }

    final newBlog = Blog.fromFlatObjectValue(
      flatObjectValue: flatObjectValue,
      id: flatObjectValue.id!,
      fileId: blog.fileId,
    );

    await FirebaseFirestore.instance.collection(blogCollectionId).doc(newBlog.id).set(newBlog.toJson());
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to update article. Please try again");
  }
}
