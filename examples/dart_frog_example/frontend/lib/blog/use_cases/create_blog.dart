import 'package:flat/flat.dart';
import 'package:uuid/uuid.dart';

Future<FlatResult<Unit>> createBlog(FlatObjectValue flatObjectValue) async {
  try {
    final id = const Uuid().v4();

    final file = flatObjectValue.getAttributeValueByAttributeId<FlatFileValue?>('file');

    // if (file?.data != null) {
    //   final fileId = const Uuid().v4();
    //   final result = await uploadBlogFile(
    //     data: file!.data!,
    //     fileId: fileId,
    //   );

    //   return result.fold(
    //       onError: (error) => FlatResult.error(error),
    //       onSuccess: (url) async {
    //         final blog = Blog.fromFlatObjectValue(
    //           flatObjectValue: flatObjectValue,
    //           id: id,
    //           fileId: fileId,
    //         );

    //         await databases.createDocument(
    //           databaseId: databaseId,
    //           collectionId: blogCollectionId,
    //           data: blog.toJson(),
    //           documentId: blog.id,
    //         );
    //         return FlatResult.success(const Unit());
    //       });
    // }

    // final blog = Blog.fromFlatObjectValue(
    //   flatObjectValue: flatObjectValue,
    //   id: id,
    //   fileId: null,
    // );

    // await databases.createDocument(
    //   databaseId: databaseId,
    //   collectionId: blogCollectionId,
    //   data: blog.toJson(),
    //   documentId: blog.id,
    // );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to create blog. Please try again");
  }
}
