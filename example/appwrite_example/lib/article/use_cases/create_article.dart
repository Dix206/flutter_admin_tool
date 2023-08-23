import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/article/use_cases/article_image_service.dart';
import 'package:example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';
import 'package:uuid/uuid.dart';

Future<FlatResult<Unit>> createArticle(FlatObjectValue flatObjectValue) async {
  try {
    final id = const Uuid().v4();
    final imageData = flatObjectValue.getAttributeValueByAttributeId<FlatFileValue?>('image');

    if (imageData?.data != null) {
      final imageId = const Uuid().v4();
      final result = await uploadArticleImage(
        data: imageData!.data!,
        imageId: imageId,
      );

      return result.fold(
          onError: (error) => FlatResult.error(error),
          onSuccess: (url) async {
            final article = Article.fromFlatObjectValue(
              flatObjectValue: flatObjectValue,
              id: id,
              imageId: imageId,
            );

            await databases.createDocument(
              databaseId: databaseId,
              collectionId: articleCollectionId,
              data: article.toJson(),
              documentId: article.id,
            );
            return FlatResult.success(const Unit());
          });
    }

    final article = Article.fromFlatObjectValue(
      flatObjectValue: flatObjectValue,
      id: id,
      imageId: null,
    );

    await databases.createDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      data: article.toJson(),
      documentId: article.id,
    );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to create article. Please try again");
  }
}
