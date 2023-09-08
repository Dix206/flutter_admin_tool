import 'package:example/appwrite/client.dart';
import 'package:example/article/article.dart';
import 'package:example/article/use_cases/article_image_service.dart';
import 'package:example/constants.dart';
import 'package:flutter_admin_tool/flat.dart';
import 'package:uuid/uuid.dart';

Future<FlatResult<Unit>> updateArticle(FlatObjectValue flatObjectValue) async {
  try {
    final document = await databases.getDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      documentId: flatObjectValue.id!,
    );

    final article = Article.fromJson(document.data);

    return _updateArticleFromExistingArticle(
      article: article,
      flatObjectValue: flatObjectValue,
    );
  } catch (exception) {
    return FlatResult.error("Failed to update article. Please try again");
  }
}

Future<FlatResult<Unit>> _updateArticleFromExistingArticle({
  required FlatObjectValue flatObjectValue,
  required Article article,
}) async {
  try {
    final imageData =
        flatObjectValue.getAttributeValueByAttributeId<FlatFileValue?>('image');

    if (imageData?.data != null) {
      final imageId = const Uuid().v4();

      if (article.imageId != null) {
        await deleteArticleImage(imageId: article.imageId!);
      }

      final result = await uploadArticleImage(
        data: imageData!.data!,
        imageId: imageId,
      );

      return result.fold(
        onError: (error) => FlatResult.error(error),
        onSuccess: (url) async {
          final newArticle = Article.fromFlatObjectValue(
            flatObjectValue: flatObjectValue,
            id: flatObjectValue.id!,
            imageId: imageId,
          );

          await databases.updateDocument(
            databaseId: databaseId,
            collectionId: articleCollectionId,
            data: newArticle.toJson(),
            documentId: newArticle.id,
          );
          return FlatResult.success(const Unit());
        },
      );
    } else if (imageData?.wasDeleted == true && article.imageId != null) {
      final result = await deleteArticleImage(
        imageId: article.imageId!,
      );

      return result.fold(
        onError: (error) => FlatResult.error(error),
        onSuccess: (url) async {
          final newArticle = Article.fromFlatObjectValue(
            flatObjectValue: flatObjectValue,
            id: flatObjectValue.id!,
            imageId: null,
          );

          await databases.updateDocument(
            databaseId: databaseId,
            collectionId: articleCollectionId,
            data: newArticle.toJson(),
            documentId: newArticle.id,
          );
          return FlatResult.success(const Unit());
        },
      );
    }

    final newArticle = Article.fromFlatObjectValue(
      flatObjectValue: flatObjectValue,
      id: flatObjectValue.id!,
      imageId: article.imageId,
    );

    await databases.updateDocument(
      databaseId: databaseId,
      collectionId: articleCollectionId,
      data: newArticle.toJson(),
      documentId: newArticle.id,
    );
    return FlatResult.success(const Unit());
  } catch (exception) {
    return FlatResult.error("Failed to update article. Please try again");
  }
}
